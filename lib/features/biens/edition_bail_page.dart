import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/design/design.dart';
import '../../app/etat_app.dart';
import '../../core/config/config_app.dart';
import '../../core/config/regles_legales.dart';
import '../../core/format/formats.dart';
import '../../core/utils/dates.dart';
import '../../core/utils/identifiants.dart';
import '../../core/validation/validateurs.dart';
import '../../core/widgets/choix_cartes.dart';
import '../../core/widgets/choix_trimestre.dart';
import '../../core/widgets/composants.dart';
import '../../core/widgets/formulaires.dart';
import '../../data/providers.dart';
import '../../domain/entities/entities.dart';

/// Informations du bail d'un bien (création ou modification). Les échéances
/// calculées depuis le bail sont recalculées à l'enregistrement.
class EditionBailPage extends ConsumerWidget {
  const EditionBailPage({super.key, required this.bienId});
  final String bienId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bien = ref.watch(bienFluxProvider(bienId));
    final bail = ref.watch(bailActifFluxProvider(bienId));
    return switch ((bien, bail)) {
      (AsyncData(value: final b?), AsyncData(value: final bail)) => _Formulaire(
        bien: b,
        existant: bail,
      ),
      (AsyncError(), _) || (_, AsyncError()) || (AsyncData(), _) => Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Ce bien n\'existe plus.')),
      ),
      _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
    };
  }
}

class _Formulaire extends ConsumerStatefulWidget {
  const _Formulaire({required this.bien, required this.existant});
  final Bien bien;
  final Bail? existant;

  @override
  ConsumerState<_Formulaire> createState() => _FormulaireState();
}

class _FormulaireState extends ConsumerState<_Formulaire> {
  final _formulaire = GlobalKey<FormState>();
  late final Bail? _b = widget.existant;

  late TypeBail? _type = _b?.typeBail;
  late DateTime? _debut = _b?.dateDebut;
  late DateTime? _dateRevision = _b?.dateRevision;
  late int? _irlTrimestre = _b?.irlTrimestre;

  late final _duree = TextEditingController(
    text: _b?.dureeMois?.toString() ?? '',
  );
  late final _depot = TextEditingController(
    text: ChampMontant.texte(_b?.depotGarantieCentimes),
  );
  late final _irlAnnee = TextEditingController(
    text: _b?.irlAnnee?.toString() ?? '',
  );
  late final _irlValeur = TextEditingController(
    text: _b?.irlValeur == null ? '' : Formats.decimal(_b!.irlValeur!),
  );
  bool _enCours = false;

  @override
  void dispose() {
    for (final c in [_duree, _depot, _irlAnnee, _irlValeur]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _enregistrer() async {
    if (!validerEtMontrerErreur(_formulaire)) return;
    setState(() => _enCours = true);
    final maintenant = DateTime.now();
    final revision = _type!.revision;
    final bail = Bail(
      id: _b?.id ?? Identifiants.nouveau(),
      bienId: widget.bien.id,
      typeBail: _type!,
      dateDebut: _debut!,
      dureeMois: int.tryParse(_duree.text.trim()),
      depotGarantieCentimes: _depot.text.trim().isEmpty
          ? null
          : Formats.parseMontant(_depot.text),
      dateRevision: revision ? _dateRevision : null,
      irlTrimestre: revision ? _irlTrimestre : null,
      irlAnnee: revision ? int.tryParse(_irlAnnee.text.trim()) : null,
      irlValeur: revision ? Formats.parseDecimal(_irlValeur.text) : null,
      actif: true,
      creeLe: _b?.creeLe ?? maintenant,
      modifieLe: maintenant,
    );
    final navigateur = Navigator.of(context);
    final messager = ScaffoldMessenger.of(context);
    await ref
        .read(gestionBiensProvider)
        .enregistrerBail(
          bien: widget.bien,
          bail: bail,
          aujourdhui: ref.read(aujourdhuiProvider),
        );
    navigateur.pop();
    messager.showSnackBar(
      const SnackBar(
        content: Text('Bail enregistré. Les échéances ont été mises à jour.'),
      ),
    );
  }

  /// IRL : les trois champs ensemble, ou aucun.
  bool get _irlCommence =>
      _irlTrimestre != null ||
      _irlAnnee.text.trim().isNotEmpty ||
      _irlValeur.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final t = context.textes;
    final aujourdhui = ref.watch(aujourdhuiProvider);
    final type = _type;
    final regle = type?.regle;
    final loyer = widget.bien.loyerHcCentimes;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(AppIcons.retour),
          tooltip: 'Retour',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Form(
        key: _formulaire,
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
              Text(widget.bien.nom.toUpperCase(), style: t.overline),
              const SizedBox(height: AppSpacing.xs),
              Semantics(
                header: true,
                child: Text('Le bail', style: t.headline),
              ),
              const SizedBox(height: AppSpacing.sectionLarge),
              const TitreSection('Type de bail'),
              ChampChoix<TypeBail>(
                options: TypeBail.values,
                valeurInitiale: _type,
                libelle: (x) => x.libelle,
                icone: AppIcons.typeBail,
                messageObligatoire: 'Choisissez le type de bail.',
                onChanged: (x) => setState(() => _type = x),
              ),
              const SizedBox(height: AppSpacing.sectionLarge),
              const TitreSection('Dates et durée'),
              ChampDate(
                libelle: 'Date de début du bail',
                date: _debut,
                premiere: DateTime(1970),
                derniere: Dates.ajouterMois(
                  aujourdhui,
                  ConfigApp.debutBailMaxMoisDansLeFutur,
                ),
                messageObligatoire: 'Indiquez la date de début du bail.',
                onChanged: (d) => setState(() => _debut = d),
              ),
              ChampTexte(
                controleur: _duree,
                libelle: 'Durée du bail',
                suffixe: 'mois',
                clavier: TextInputType.number,
                formats: [FilteringTextInputFormatter.digitsOnly],
                aide: regle == null ? null : _aideDuree(regle),
                validator: (v) => _validerDuree(v, regle),
              ),
              ChampMontant(
                controleur: _depot,
                libelle: 'Dépôt de garantie',
                aide: regle == null ? null : _aideDepot(regle, loyer),
                validationSupplementaire: (c) =>
                    regle == null ? null : _validerDepot(c, regle, loyer),
              ),
              if (type != null && type.revision) ...[
                const SizedBox(height: AppSpacing.bloc),
                const TitreSection('Révision du loyer'),
                ChampDate(
                  libelle: 'Date de révision prévue au bail (facultatif)',
                  date: _dateRevision,
                  obligatoire: false,
                  premiere: DateTime(1970),
                  derniere: Dates.ajouterMois(aujourdhui, 24),
                  aide:
                      'Si le bail ne précise rien, c\'est la date anniversaire '
                      'du bail.',
                  onChanged: (d) => setState(() => _dateRevision = d),
                ),
                const SizedBox(height: AppSpacing.s),
                const Note(
                  texte:
                      'L\'IRL de référence figure dans la clause de révision '
                      'de votre bail : un trimestre (par exemple « 2e '
                      'trimestre 2025 ») et une valeur. Recopiez-les '
                      'exactement, ils servent au calcul de la révision.',
                ),
                const SizedBox(height: AppSpacing.bloc),
                Text('Trimestre de référence', style: t.rowTitle),
                const SizedBox(height: AppSpacing.s),
                ChoixTrimestre(
                  valeur: _irlTrimestre,
                  onChanged: (x) => setState(() => _irlTrimestre = x),
                ),
                const SizedBox(height: AppSpacing.bloc),
                ChampTexte(
                  controleur: _irlAnnee,
                  libelle: 'Année du trimestre',
                  clavier: TextInputType.number,
                  formats: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  onChanged: (_) => setState(() {}),
                  validator: (v) => _validerAnnee(v, aujourdhui),
                ),
                ChampTexte(
                  controleur: _irlValeur,
                  libelle: 'Valeur de l\'IRL de référence',
                  aide: 'Format : 123,45',
                  clavier: const TextInputType.numberWithOptions(decimal: true),
                  formats: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9,.]')),
                  ],
                  onChanged: (_) => setState(() {}),
                  validator: _validerValeur,
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: BarreActionFixe(
        libelle: 'Enregistrer le bail',
        onPressed: _enregistrer,
        enCours: _enCours,
      ),
    );
  }

  static String _aideDuree(RegleBail r) {
    final duree = r.dureeMois;
    if (duree != null) {
      final ans = duree % 12 == 0
          ? ' (${duree ~/ 12} an${duree >= 24 ? 's' : ''})'
          : '';
      return 'Laissez vide pour la durée légale : $duree mois$ans.';
    }
    final min = r.dureeMinMois;
    final max = r.dureeMaxMois;
    if (min != null && max != null) return 'Entre $min et $max mois.';
    if (max != null) return '$max mois au maximum.';
    return 'Durée prévue au contrat.';
  }

  static String? _validerDuree(String? v, RegleBail? r) {
    final texte = v?.trim() ?? '';
    if (r == null) return null;
    if (texte.isEmpty) {
      return r.dureeMois == null ? 'Indiquez la durée prévue au bail.' : null;
    }
    final mois = int.tryParse(texte);
    if (mois == null || mois <= 0) return 'Durée incorrecte.';
    final min = r.dureeMinMois;
    final max = r.dureeMaxMois;
    if (min != null && mois < min) return '$min mois au minimum.';
    if (max != null && mois > max) return '$max mois au maximum.';
    return null;
  }

  static String? _aideDepot(RegleBail r, int loyer) =>
      switch (r.depotGarantieMaxMois) {
        null => null,
        0 => 'Interdit pour ce type de bail.',
        final m =>
          'Maximum légal : ${Formats.montant(loyer * m)} ($m mois de loyer '
              'hors charges).',
      };

  static String? _validerDepot(int centimes, RegleBail r, int loyer) {
    final max = r.depotGarantieMaxMois;
    if (max == null) return null;
    if (max == 0 && centimes > 0) {
      return 'Le dépôt de garantie est interdit pour ce type de bail.';
    }
    if (centimes > loyer * max) {
      return 'Au-delà du maximum légal (${Formats.montant(loyer * max)}).';
    }
    return null;
  }

  String? _validerAnnee(String? v, DateTime aujourdhui) {
    final texte = v?.trim() ?? '';
    if (texte.isEmpty) {
      return _irlCommence ? 'Indiquez l\'année du trimestre.' : null;
    }
    final annee = int.tryParse(texte);
    if (annee == null || annee < 1998 || annee > aujourdhui.year) {
      return 'Année incorrecte.';
    }
    return null;
  }

  String? _validerValeur(String? v) {
    final texte = v?.trim() ?? '';
    if (texte.isEmpty) {
      return _irlCommence ? 'Indiquez la valeur de l\'IRL.' : null;
    }
    if (Validateurs.indiceIrl(texte) case final erreur?) return erreur;
    if (_irlTrimestre == null) return 'Choisissez aussi le trimestre.';
    return null;
  }
}

extension on TypeBail {
  RegleBail get regle => ReglesLegales.bail(this);
  bool get revision => regle.revisionIrlAutorisee;
}
