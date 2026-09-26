import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/design/design.dart';
import '../../app/etat_app.dart';
import '../../app/routes.dart';
import '../../core/config/regles_legales.dart';
import '../../core/format/formats.dart';
import '../../core/widgets/choix_trimestre.dart';
import '../../core/widgets/composants.dart';
import '../../core/widgets/formulaires.dart';
import '../../core/widgets/listes.dart';
import '../../data/irl/service_indices_irl.dart';
import '../../data/providers.dart';
import '../../domain/entities/entities.dart';
import '../../domain/services/calculateur_revision.dart';
import 'indices/sheets_indices.dart';

/// Outil de révision de loyer : vos données, indices IRL, résultat.
class RevisionPage extends ConsumerWidget {
  const RevisionPage({super.key, required this.bienId});
  final String bienId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bien = ref.watch(bienFluxProvider(bienId));
    final bail = ref.watch(bailActifFluxProvider(bienId));
    final historique = ref.watch(historiqueRevisionsFluxProvider(bienId));
    final indices = ref.watch(indicesIrlFluxProvider);

    if (indices case AsyncError(:final error)) {
      return _Message(texte: 'Les indices IRL sont illisibles ($error).');
    }
    final b = bien.value;
    if (!bien.hasValue ||
        !bail.hasValue ||
        !historique.hasValue ||
        !indices.hasValue) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (b == null) return const _Message(texte: 'Ce bien n\'existe plus.');

    final bailActif = bail.value;
    final blocages = CalculateurRevision.blocages(b, bailActif);
    if (bailActif == null || blocages.isNotEmpty) {
      return _RevisionImpossible(bien: b, blocages: blocages);
    }

    final revisionsDuBail = historique.value!.where(
      (r) => r.bailId == bailActif.id,
    );
    final derniereDateEffet = revisionsDuBail.isEmpty
        ? null
        : revisionsDuBail
              .map((r) => r.dateEffet)
              .reduce((a, b) => a.isAfter(b) ? a : b);
    final cycle = CalculateurRevision.cycle(
      bailActif,
      aujourdhui: ref.watch(aujourdhuiProvider),
      derniereDateEffet: derniereDateEffet,
    );
    if (cycle == null) {
      return _RevisionImpossible(
        bien: b,
        blocages: const [BlocageRevision.bailSansRevision],
      );
    }
    return _Assistant(
      bien: b,
      bail: bailActif,
      derniereDateEffet: derniereDateEffet,
      table: indices.value!,
    );
  }
}

// ---------------------------------------------------------------------------
// Assistant en trois étapes
// ---------------------------------------------------------------------------

enum _Etape {
  donnees('Vos données'),
  indices('Indices IRL'),
  resultat('Résultat');

  const _Etape(this.libelle);
  final String libelle;
}

class _Assistant extends ConsumerStatefulWidget {
  const _Assistant({
    required this.bien,
    required this.bail,
    required this.derniereDateEffet,
    required this.table,
  });

  final Bien bien;
  final Bail bail;
  final DateTime? derniereDateEffet;
  final List<IndiceIrl> table;

  @override
  ConsumerState<_Assistant> createState() => _AssistantState();
}

class _AssistantState extends ConsumerState<_Assistant> {
  final _cle = GlobalKey<FormState>();
  var _etape = _Etape.donnees;
  late final _loyer = TextEditingController(
    text: ChampMontant.texte(widget.bien.loyerHcCentimes),
  );

  /// Trimestre prévu au bail ou, à défaut, celui du dernier IRL publié à la
  /// signature.
  late final bool _trimestreSuggere = widget.bail.irlTrimestre == null;
  late int _trimestre =
      widget.bail.irlTrimestre ??
      CalculateurRevision.dernierTrimestrePublie(
        widget.bail.dateDebut,
      ).trimestre;

  /// Année du nouvel indice choisie par l'utilisateur (sinon calculée).
  int? _anneeChoisie;

  /// Date prévue que l'utilisateur dit avoir déjà révisée hors de
  /// l'application : on passe à la révision suivante.
  DateTime? _dejaRevisee;

  CycleRevision get _cycle {
    final derniere = widget.derniereDateEffet;
    final deja = _dejaRevisee;
    return CalculateurRevision.cycle(
      widget.bail,
      aujourdhui: ref.watch(aujourdhuiProvider),
      derniereDateEffet:
          derniere == null || (deja != null && deja.isAfter(derniere))
          ? deja
          : derniere,
    )!;
  }

  bool _miseAJourEnCours = false;
  String? _erreurMiseAJour;
  bool _enCours = false;

  @override
  void initState() {
    super.initState();
    // Nouveaux indices publiés depuis la dernière visite ? (discret)
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final service = ref.read(serviceIndicesIrlProvider);
      if (await service.miseAJourConseillee()) {
        await _mettreAJour(silencieux: true);
      }
    });
  }

  @override
  void dispose() {
    _loyer.dispose();
    super.dispose();
  }

  int get _annee =>
      _anneeChoisie ??
      CalculateurRevision.anneeDernierIndice(
        trimestre: _trimestre,
        date: _cycle.datePrevue,
      );

  IndicesRevision get _indices => CalculateurRevision.indices(
    trimestre: _trimestre,
    annee: _annee,
    table: widget.table,
  );

  Future<void> _mettreAJour({bool silencieux = false}) async {
    if (_miseAJourEnCours) return;
    setState(() {
      _miseAJourEnCours = true;
      _erreurMiseAJour = null;
    });
    String? erreur;
    try {
      await ref.read(serviceIndicesIrlProvider).mettreAJour();
      ref.invalidate(derniereMiseAJourIrlProvider);
    } on MiseAJourIrlImpossible catch (e) {
      erreur = e.message;
    }
    if (!mounted) return;
    setState(() {
      _miseAJourEnCours = false;
      if (!silencieux) _erreurMiseAJour = erreur;
    });
  }

  /// Résultat figé pendant l'enregistrement : les données du bien changent
  /// (nouveau loyer, révision suivante) avant l'ouverture du courrier.
  ResultatRevision? _resultatConfirme;

  ResultatRevision? get _resultat {
    if (_resultatConfirme case final r?) return r;
    final indices = _indices;
    final ancien = indices.ancien;
    final nouveau = indices.nouveau;
    final loyer = Formats.parseMontant(_loyer.text);
    if (ancien == null || nouveau == null || loyer == null) return null;
    return CalculateurRevision.calculer(
      cycle: _cycle,
      ancien: ancien,
      nouveau: nouveau,
      loyerActuelCentimes: loyer,
      chargesCentimes: widget.bien.chargesCentimes,
    );
  }

  void _continuer() {
    switch (_etape) {
      case _Etape.donnees:
        if (!validerEtMontrerErreur(_cle)) return;
        setState(() => _etape = _Etape.indices);
      case _Etape.indices:
        setState(() => _etape = _Etape.resultat);
      case _Etape.resultat:
        _confirmer();
    }
  }

  Future<void> _confirmer() async {
    final resultat = _resultat;
    if (resultat == null) return;
    setState(() {
      _enCours = true;
      _resultatConfirme = resultat;
    });
    final routeur = GoRouter.of(context);
    final messager = ScaffoldMessenger.of(context);
    final revision = await ref
        .read(reviserLoyerProvider)
        .confirmer(bien: widget.bien, bail: widget.bail, resultat: resultat);
    routeur.pushReplacement(Routes.courrierRevision(revision.id));
    messager.showSnackBar(
      SnackBar(
        content: Text(
          'Révision enregistrée : le loyer passe à '
          '${Formats.parMois(revision.nouveauLoyerCentimes)}.',
        ),
      ),
    );
  }

  void _retour() {
    if (_etape == _Etape.donnees) {
      Navigator.of(context).pop();
    } else {
      setState(() => _etape = _Etape.values[_etape.index - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.textes;
    final indices = _indices;
    final resultat = _resultat;
    final nouvelAttendu = CalculateurRevision.publicationEstimee(
      trimestre: _trimestre,
      annee: _annee,
    );
    final nouvelPasEncorePublie =
        indices.nouveau == null &&
        nouvelAttendu.isAfter(ref.watch(aujourdhuiProvider));

    final (libelleAction, peutContinuer, legende) = switch (_etape) {
      _Etape.donnees => ('Continuer', true, null),
      _Etape.indices => ('Calculer le nouveau loyer', indices.complets, null),
      _Etape.resultat => (
        'Confirmer la révision',
        resultat != null,
        resultat == null
            ? null
            : 'Le loyer du bien passera à '
                  '${Formats.parMois(resultat.nouveauLoyerCentimes)}, puis '
                  'le courrier sera prêt à envoyer.',
      ),
    };

    return PopScope(
      canPop: _etape == _Etape.donnees,
      onPopInvokedWithResult: (aPoppe, _) {
        if (!aPoppe) _retour();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(AppIcons.retour),
            tooltip: _etape == _Etape.donnees ? 'Retour' : 'Étape précédente',
            onPressed: _enCours ? null : _retour,
          ),
        ),
        body: Form(
          key: _cle,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.ecran,
              AppSpacing.s,
              AppSpacing.ecran,
              AppSpacing.ecran,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('RÉVISION DU LOYER', style: t.overline),
                const SizedBox(height: AppSpacing.xs),
                Semantics(
                  header: true,
                  child: Text(widget.bien.nom, style: t.headline),
                ),
                const SizedBox(height: AppSpacing.bloc),
                _Progression(etape: _etape),
                const SizedBox(height: AppSpacing.sectionLarge),
                ...switch (_etape) {
                  _Etape.donnees => _donnees(context),
                  _Etape.indices => _etapeIndices(
                    context,
                    indices,
                    nouvelPasEncorePublie: nouvelPasEncorePublie,
                    nouvelAttendu: nouvelAttendu,
                  ),
                  _Etape.resultat => _etapeResultat(context, resultat!),
                },
              ],
            ),
          ),
        ),
        bottomNavigationBar: BarreActionFixe(
          libelle: libelleAction,
          onPressed: peutContinuer ? _continuer : null,
          enCours: _enCours,
          legende: legende,
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Étape 1 : vos données
  // -------------------------------------------------------------------------

  List<Widget> _donnees(BuildContext context) {
    final t = context.textes;
    final cycle = _cycle;
    return [
      CarteListe(
        enfants: [
          LigneInfo(
            libelle: 'Date de révision prévue',
            valeur: Formats.date(cycle.datePrevue),
          ),
          LigneInfo(
            libelle: 'Nouveau loyer applicable',
            valeur: cycle.enRetard
                ? 'Dès votre courrier'
                : 'Le ${Formats.date(cycle.dateEffet)}',
          ),
        ],
      ),
      const SizedBox(height: AppSpacing.bloc),
      Note(
        icone: cycle.enRetard ? AppIcons.attention : AppIcons.calendrier,
        texte: cycle.enRetard
            ? 'La date prévue au bail est passée. Vous pouvez encore '
                  'demander la révision jusqu\'au '
                  '${Formats.date(cycle.dateLimiteDemande)}. Elle '
                  's\'appliquera à partir de la date de votre courrier, '
                  'sans effet rétroactif.'
            : 'La révision a lieu une fois par an, à la date prévue au '
                  'bail. Elle n\'est pas rétroactive : envoyez votre courrier '
                  'avant le ${Formats.date(cycle.datePrevue)}.',
      ),
      if (cycle.enRetard)
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () => setState(() {
              _dejaRevisee = cycle.datePrevue;
              _anneeChoisie = null;
            }),
            child: Text(
              "J'ai déjà révisé le loyer au ${Formats.date(cycle.datePrevue)}",
            ),
          ),
        ),
      const SizedBox(height: AppSpacing.sectionLarge),
      ChampMontant(
        controleur: _loyer,
        libelle: 'Loyer actuel hors charges',
        obligatoire: true,
        aide: 'La révision porte uniquement sur le loyer hors charges.',
        validationSupplementaire: (c) =>
            c <= 0 ? 'Le loyer doit être supérieur à 0.' : null,
      ),
      const SizedBox(height: AppSpacing.bloc),
      Text('Trimestre de référence de l\'IRL', style: t.rowTitle),
      const SizedBox(height: AppSpacing.xs),
      Text(
        _trimestreSuggere
            ? '${ReglesLegales.trimestreParDefautExplication} Nous avons '
                  'présélectionné le ${Formats.trimestre(_trimestre)} : '
                  'vérifiez la clause de révision de votre bail.'
            : 'Indiqué dans la clause de révision de votre bail.',
        style: t.secondary,
      ),
      const SizedBox(height: AppSpacing.s),
      ChoixTrimestre(
        valeur: _trimestre,
        effacable: false,
        onChanged: (x) => setState(() {
          _trimestre = x!;
          _anneeChoisie = null;
        }),
      ),
    ];
  }

  // -------------------------------------------------------------------------
  // Étape 2 : indices
  // -------------------------------------------------------------------------

  List<Widget> _etapeIndices(
    BuildContext context,
    IndicesRevision indices, {
    required bool nouvelPasEncorePublie,
    required DateTime nouvelAttendu,
  }) {
    final t = context.textes;
    final bail = widget.bail;
    final ancien = indices.ancien;
    final anneeBail = bail.irlAnnee;
    final valeurBail = bail.irlValeur;
    final anneesPerdues =
        anneeBail != null &&
        bail.irlTrimestre == _trimestre &&
        anneeBail < indices.anneeAncien;
    final ecartAvecBail =
        ancien != null &&
        valeurBail != null &&
        anneeBail == ancien.annee &&
        bail.irlTrimestre == ancien.trimestre &&
        (valeurBail - ancien.valeur).abs() >= 0.005;
    final manquant = indices.nouveau == null
        ? (trimestre: _trimestre, annee: indices.annee)
        : indices.ancien == null
        ? (trimestre: _trimestre, annee: indices.anneeAncien)
        : null;
    final derniereVerification = ref.watch(derniereMiseAJourIrlProvider).value;

    String valeur(IndiceIrl? i) => switch (i) {
      null => 'Manquant',
      IndiceIrl(source: SourceIndice.manuel) =>
        '${Formats.decimal(i.valeur)} (saisi)',
      _ => Formats.decimal(i.valeur),
    };

    return [
      Text(
        'Le calcul compare l\'IRL du '
        '${Formats.trimestre(_trimestre, indices.annee)} à celui du même '
        'trimestre un an plus tôt, publiés par l\'INSEE.',
        style: t.body,
      ),
      const SizedBox(height: AppSpacing.bloc),
      CarteListe(
        enfants: [
          LigneInfo(
            libelle:
                'Ancien indice, ${Formats.trimestre(_trimestre, indices.anneeAncien)}',
            valeur: valeur(indices.ancien),
          ),
          LigneInfo(
            libelle:
                'Nouvel indice, ${Formats.trimestre(_trimestre, indices.annee)}',
            valeur: valeur(indices.nouveau),
          ),
        ],
      ),
      const SizedBox(height: AppSpacing.bloc),
      if (nouvelPasEncorePublie)
        Note(
          icone: AppIcons.calendrier,
          texte:
              'L\'INSEE publiera l\'IRL du '
              '${Formats.trimestre(_trimestre, indices.annee)} vers le '
              '${Formats.date(nouvelAttendu)}. Revenez après cette date pour '
              'calculer la révision.',
        )
      else if (manquant != null) ...[
        BanniereInformation(
          texte:
              'L\'IRL du ${Formats.trimestre(manquant.trimestre, manquant.annee)} '
              'manque dans l\'application.',
          action: _miseAJourEnCours ? 'Recherche…' : 'Mettre à jour',
          onAction: _miseAJourEnCours ? () {} : _mettreAJour,
        ),
        if (_erreurMiseAJour case final erreur?) ...[
          const SizedBox(height: AppSpacing.s),
          Text(erreur, style: t.secondary),
        ],
        const SizedBox(height: AppSpacing.xs),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () => ouvrirSaisieIndice(
              context,
              trimestre: manquant.trimestre,
              annee: manquant.annee,
            ),
            child: const Text('Saisir l\'indice vous-même'),
          ),
        ),
      ],
      if (anneesPerdues) ...[
        const SizedBox(height: AppSpacing.bloc),
        Note(
          texte:
              'Le loyer n\'a pas été révisé depuis l\'indice de $anneeBail. '
              'Les révisions des années passées sont perdues : le calcul '
              'part de l\'indice de ${indices.anneeAncien}, comme le prévoit '
              'la loi.',
        ),
      ],
      if (ecartAvecBail) ...[
        const SizedBox(height: AppSpacing.bloc),
        Note(
          icone: AppIcons.attention,
          texte:
              'L\'indice indiqué dans votre bail '
              '(${Formats.decimal(valeurBail)}) diffère de la valeur publiée '
              'par l\'INSEE. Le calcul utilise la valeur officielle.',
        ),
      ],
      const SizedBox(height: AppSpacing.bloc),
      Wrap(
        spacing: AppSpacing.s,
        children: [
          TextButton.icon(
            onPressed: () => ouvrirChoixAnnee(
              context,
              trimestre: _trimestre,
              table: widget.table,
              anneeParDefaut: CalculateurRevision.anneeDernierIndice(
                trimestre: _trimestre,
                date: _cycle.datePrevue,
              ),
              anneeActuelle: indices.annee,
              onChoisie: (a) => setState(() => _anneeChoisie = a),
            ),
            icon: const Icon(AppIcons.calendrier),
            label: const Text('Utiliser un autre indice'),
          ),
          TextButton.icon(
            onPressed: _miseAJourEnCours ? null : _mettreAJour,
            icon: const Icon(AppIcons.actualiser),
            label: Text(
              _miseAJourEnCours ? 'Mise à jour…' : 'Mettre à jour les indices',
            ),
          ),
        ],
      ),
      Text(
        [
          'Source : INSEE, indice de référence des loyers.',
          if (derniereVerification != null)
            'Dernière vérification le ${Formats.date(derniereVerification)}.',
        ].join(' '),
        style: t.caption,
      ),
    ];
  }

  // -------------------------------------------------------------------------
  // Étape 3 : résultat
  // -------------------------------------------------------------------------

  List<Widget> _etapeResultat(BuildContext context, ResultatRevision r) {
    final t = context.textes;
    final locataires =
        ref.watch(locatairesFluxProvider(widget.bail.id)).value ?? const [];
    String signe(int centimes) =>
        '${centimes < 0 ? '−' : '+'}${Formats.montant(centimes.abs())}';

    return [
      Semantics(
        container: true,
        label:
            'Nouveau loyer hors charges : '
            '${Formats.parMois(r.nouveauLoyerCentimes)}',
        excludeSemantics: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nouveau loyer hors charges', style: t.secondary),
            Text(Formats.parMois(r.nouveauLoyerCentimes), style: t.headline),
          ],
        ),
      ),
      const SizedBox(height: AppSpacing.bloc),
      CarteListe(
        enfants: [
          LigneInfo(
            libelle: 'Loyer actuel hors charges',
            valeur: Formats.montant(r.ancienLoyerCentimes),
          ),
          LigneInfo(
            libelle: 'Évolution par mois',
            valeur: signe(r.augmentationMensuelleCentimes),
          ),
          LigneInfo(
            libelle: 'Évolution par an',
            valeur: signe(r.augmentationAnnuelleCentimes),
          ),
          LigneInfo(
            libelle: 'Charges (inchangées)',
            valeur: Formats.montant(r.chargesCentimes),
          ),
          LigneInfo(
            libelle: 'Nouveau total mensuel',
            valeur: Formats.montant(r.nouveauTotalCentimes),
          ),
          LigneInfo(
            libelle: 'À partir du',
            valeur: Formats.date(r.cycle.dateEffet),
          ),
        ],
      ),
      if (r.baisse) ...[
        const SizedBox(height: AppSpacing.bloc),
        const Note(
          texte:
              'L\'indice a baissé : ce calcul diminue le loyer. La révision '
              'est à votre initiative, vous n\'êtes pas obligé de la faire.',
        ),
      ],
      const SizedBox(height: AppSpacing.sectionLarge),
      const EnTeteSection(titre: 'Détail du calcul'),
      CarteListe(
        enfants: [
          LigneInfo(
            libelle:
                'IRL du ${Formats.trimestre(r.ancien.trimestre, r.ancien.annee)}',
            valeur: Formats.decimal(r.ancien.valeur),
          ),
          LigneInfo(
            libelle:
                'IRL du ${Formats.trimestre(r.nouveau.trimestre, r.nouveau.annee)}',
            valeur: Formats.decimal(r.nouveau.valeur),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.ligne),
            child: Text(
              '${Formats.montantComplet(r.ancienLoyerCentimes)} × '
              '${Formats.decimal(r.nouveau.valeur)} / '
              '${Formats.decimal(r.ancien.valeur)} = '
              '${Formats.montantComplet(r.nouveauLoyerCentimes)}',
              style: t.rowTitle,
            ),
          ),
        ],
      ),
      const SizedBox(height: AppSpacing.xs),
      Text(
        'Nouveau loyer = loyer actuel × nouvel IRL / ancien IRL, arrondi au '
        'centime.',
        style: t.caption,
      ),
      if (locataires.isEmpty) ...[
        const SizedBox(height: AppSpacing.sectionLarge),
        BanniereInformation(
          texte: 'Ajoutez le locataire pour qu\'il figure sur le courrier.',
          action: 'Ajouter',
          onAction: () => context.push(Routes.locataire(widget.bien.id)),
        ),
      ],
      const SizedBox(height: AppSpacing.sectionLarge),
      Text(
        'Outil d\'aide, ne remplace pas un conseil juridique.',
        style: t.caption,
        textAlign: TextAlign.center,
      ),
    ];
  }
}

/// Barre de progression : 3 segments et le nom de l'étape.
class _Progression extends StatelessWidget {
  const _Progression({required this.etape});
  final _Etape etape;

  @override
  Widget build(BuildContext context) {
    final c = context.couleurs;
    final numero = etape.index + 1;
    final total = _Etape.values.length;
    return Semantics(
      container: true,
      label: 'Étape $numero sur $total : ${etape.libelle}',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (final e in _Etape.values) ...[
                if (e.index > 0) const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Container(
                    height: AppSizes.progressionEtapes,
                    decoration: BoxDecoration(
                      color: e.index <= etape.index ? c.primary : c.border,
                      borderRadius: BorderRadius.circular(AppRadius.complet),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            'Étape $numero sur $total : ${etape.libelle}',
            style: context.textes.caption,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Révision impossible
// ---------------------------------------------------------------------------

class _RevisionImpossible extends StatelessWidget {
  const _RevisionImpossible({required this.bien, required this.blocages});
  final Bien bien;
  final List<BlocageRevision> blocages;

  @override
  Widget build(BuildContext context) {
    final t = context.textes;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(AppIcons.retour),
          tooltip: 'Retour',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.ecran,
          AppSpacing.s,
          AppSpacing.ecran,
          AppSpacing.ecran,
        ),
        children: [
          Text('RÉVISION DU LOYER', style: t.overline),
          const SizedBox(height: AppSpacing.xs),
          Semantics(header: true, child: Text(bien.nom, style: t.headline)),
          const SizedBox(height: AppSpacing.sectionLarge),
          for (final b in blocages) ...[
            Note(
              icone: b == BlocageRevision.dpeGel
                  ? AppIcons.attention
                  : AppIcons.information,
              texte: b.message,
            ),
            const SizedBox(height: AppSpacing.bloc),
          ],
          if (blocages.contains(BlocageRevision.dpeGel)) ...[
            Text(
              'Si un nouveau DPE classe désormais le logement de A à E, '
              'mettez à jour la classe énergétique du bien.',
              style: t.secondary,
            ),
            const SizedBox(height: AppSpacing.bloc),
            OutlinedButton(
              onPressed: () => context.push(Routes.modifierBien(bien.id)),
              child: const Text('Modifier le bien'),
            ),
          ],
          if (blocages.contains(BlocageRevision.pasDeBail))
            FilledButton(
              onPressed: () => context.push(Routes.bail(bien.id)),
              child: const Text('Ajouter les informations du bail'),
            ),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.texte});
  final String texte;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: Padding(
      padding: AppSpacing.paddingEcran,
      child: Center(child: Text(texte, textAlign: TextAlign.center)),
    ),
  );
}
