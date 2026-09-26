import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/design/design.dart';
import '../../app/etat_app.dart';
import '../../app/routes.dart';
import '../../core/config/config_app.dart';
import '../../core/config/regles_legales.dart';
import '../../core/format/formats.dart';
import '../../core/utils/dates.dart';
import '../../core/utils/identifiants.dart';
import '../../core/validation/validateurs.dart';
import '../../core/widgets/choix_cartes.dart';
import '../../core/widgets/composants.dart';
import '../../core/widgets/formulaires.dart';
import '../../core/widgets/listes.dart';
import '../../data/providers.dart';
import '../../domain/entities/entities.dart';

/// Création d'un bien, ou modification de ses informations.
class EditionBienPage extends ConsumerWidget {
  const EditionBienPage({super.key, this.bienId});

  /// `null` : nouveau bien.
  final String? bienId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = bienId;
    if (id == null) return const _Formulaire(existant: null);
    return switch (ref.watch(bienFluxProvider(id))) {
      AsyncData(value: final bien?) => _Formulaire(existant: bien),
      AsyncData() || AsyncError() => const _Introuvable(),
      _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
    };
  }
}

class _Introuvable extends StatelessWidget {
  const _Introuvable();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: Padding(
      padding: const EdgeInsets.all(AppSpacing.ecran),
      child: Text('Ce bien n\'existe plus.', style: context.textes.body),
    ),
  );
}

class _Formulaire extends ConsumerStatefulWidget {
  const _Formulaire({required this.existant});
  final Bien? existant;

  @override
  ConsumerState<_Formulaire> createState() => _FormulaireState();
}

class _FormulaireState extends ConsumerState<_Formulaire> {
  final _formulaire = GlobalKey<FormState>();
  late final Bien? _b = widget.existant;

  late final _nom = TextEditingController(text: _b?.nom);
  late final _loyer = TextEditingController(
    text: ChampMontant.texte(_b?.loyerHcCentimes),
  );
  late final _charges = TextEditingController(
    text: ChampMontant.texte(_b?.chargesCentimes),
  );
  late final _rue = TextEditingController(text: _b?.rue);
  late final _codePostal = TextEditingController(text: _b?.codePostal);
  late final _ville = TextEditingController(text: _b?.ville);
  late final _surface = TextEditingController(
    text: _b?.surfaceM2 == null ? '' : Formats.decimal(_b!.surfaceM2!),
  );
  late final _lots = TextEditingController(
    text: _b?.nombreLots?.toString() ?? '',
  );

  late TypeLogement? _typeLogement = _b?.typeLogement;
  late TypeLocation? _typeLocation = _b?.typeLocation;
  late ClasseDpe? _dpe = _b?.classeDpe;
  late DateTime? _dateDpe = _b?.dateDpe;

  // Création en longue durée : bail (comme à l'onboarding).
  TypeBail? _typeBail;
  DateTime? _debutBail;
  bool _enCours = false;

  bool get _creation => widget.existant == null;

  @override
  void dispose() {
    for (final c in [
      _nom,
      _loyer,
      _charges,
      _rue,
      _codePostal,
      _ville,
      _surface,
      _lots,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _enregistrer() async {
    if (!validerEtMontrerErreur(_formulaire)) return;
    setState(() => _enCours = true);
    final maintenant = DateTime.now();
    final aujourdhui = ref.read(aujourdhuiProvider);
    final gestion = ref.read(gestionBiensProvider);
    final surface = Formats.parseDecimal(_surface.text);
    final lots = int.tryParse(_lots.text.trim());
    final chargesCentimes = _charges.text.trim().isEmpty
        ? 0
        : Formats.parseMontant(_charges.text)!;

    final existant = widget.existant;
    final bien = existant == null
        ? Bien(
            id: Identifiants.nouveau(),
            nom: _nom.text.trim(),
            typeLogement: _typeLogement!,
            typeLocation: _typeLocation!,
            rue: _rue.text.trim(),
            codePostal: _codePostal.text.trim(),
            ville: _ville.text.trim(),
            loyerHcCentimes: Formats.parseMontant(_loyer.text)!,
            chargesCentimes: chargesCentimes,
            surfaceM2: surface,
            classeDpe: _dpe,
            dateDpe: _dateDpe,
            nombreLots: _typeLogement == TypeLogement.immeuble ? lots : null,
            ordre: (ref.read(biensFluxProvider).value ?? const []).length,
            creeLe: maintenant,
            modifieLe: maintenant,
          )
        : existant.copyWith(
            nom: _nom.text.trim(),
            typeLogement: _typeLogement,
            typeLocation: _typeLocation,
            rue: _rue.text.trim(),
            codePostal: _codePostal.text.trim(),
            ville: _ville.text.trim(),
            loyerHcCentimes: Formats.parseMontant(_loyer.text),
            chargesCentimes: chargesCentimes,
            surfaceM2: surface,
            classeDpe: _dpe,
            dateDpe: _dateDpe,
            nombreLots: _typeLogement == TypeLogement.immeuble ? lots : null,
          );

    final routeur = GoRouter.of(context);
    final messager = ScaffoldMessenger.of(context);
    if (existant == null) {
      final avecBail = bien.typeLocation == TypeLocation.longueDuree;
      await gestion.creer(
        bien: bien,
        bail: avecBail
            ? Bail(
                id: Identifiants.nouveau(),
                bienId: bien.id,
                typeBail: _typeBail!,
                dateDebut: _debutBail!,
                actif: true,
                creeLe: maintenant,
                modifieLe: maintenant,
              )
            : null,
        aujourdhui: aujourdhui,
      );
      routeur.pushReplacement(Routes.ficheBien(bien.id));
      messager.showSnackBar(
        SnackBar(content: Text('« ${bien.nom} » a été ajouté.')),
      );
    } else {
      await gestion.modifier(bien: bien, aujourdhui: aujourdhui);
      routeur.pop();
      messager.showSnackBar(
        const SnackBar(content: Text('Modifications enregistrées.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.textes;
    final aujourdhui = ref.watch(aujourdhuiProvider);
    final longueDuree = _typeLocation == TypeLocation.longueDuree;
    final dpeGel = ReglesLegales.classesDpeSansRevision.contains(_dpe);

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
              Semantics(
                header: true,
                child: Text(
                  _creation ? 'Nouveau bien' : 'Informations du bien',
                  style: t.headline,
                ),
              ),
              const SizedBox(height: AppSpacing.sectionLarge),
              ChampTexte(
                controleur: _nom,
                libelle: 'Nom du bien',
                aide: 'Le nom affiché partout. Exemple : Studio Gambetta',
                majuscules: TextCapitalization.sentences,
                validator: (v) => Validateurs.obligatoire(
                  v,
                  message: 'Donnez un nom à ce bien.',
                ),
              ),
              const SizedBox(height: AppSpacing.bloc),
              const TitreSection('Type de logement'),
              ChampChoix<TypeLogement>(
                options: TypeLogement.values,
                valeurInitiale: _typeLogement,
                libelle: (x) => x.libelle,
                icone: AppIcons.typeLogement,
                messageObligatoire: 'Choisissez le type de logement.',
                onChanged: (x) => setState(() => _typeLogement = x),
              ),
              const SizedBox(height: AppSpacing.sectionLarge),
              const TitreSection('Type de location'),
              ChampChoix<TypeLocation>(
                options: TypeLocation.values,
                valeurInitiale: _typeLocation,
                libelle: (x) => x.libelle,
                icone: AppIcons.typeLocation,
                precision: (x) => x.precision,
                colonnesMax: 1,
                messageObligatoire: 'Choisissez le type de location.',
                onChanged: (x) => setState(() => _typeLocation = x),
              ),
              if (_creation)
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  alignment: Alignment.topCenter,
                  child: longueDuree
                      ? Padding(
                          padding: const EdgeInsets.only(
                            top: AppSpacing.section,
                          ),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.carte),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const TitreSection('Type de bail'),
                                  ChampChoix<TypeBail>(
                                    options: TypeBail.longueDuree,
                                    valeurInitiale: _typeBail,
                                    libelle: (x) => x.libelle,
                                    icone: AppIcons.typeBail,
                                    messageObligatoire:
                                        'Choisissez le type de bail.',
                                    onChanged: (x) =>
                                        setState(() => _typeBail = x),
                                  ),
                                  const SizedBox(height: AppSpacing.section),
                                  ChampDate(
                                    libelle: 'Date de début du bail',
                                    date: _debutBail,
                                    premiere: DateTime(1970),
                                    derniere: Dates.ajouterMois(
                                      aujourdhui,
                                      ConfigApp.debutBailMaxMoisDansLeFutur,
                                    ),
                                    messageObligatoire:
                                        'Indiquez la date de début du bail.',
                                    aide:
                                        'Pour activer vos premiers rappels '
                                        'automatiquement.',
                                    onChanged: (d) =>
                                        setState(() => _debutBail = d),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(width: double.infinity),
                ),
              const SizedBox(height: AppSpacing.sectionLarge),
              const TitreSection('Loyer'),
              ChampMontant(
                controleur: _loyer,
                libelle: 'Loyer mensuel hors charges',
                obligatoire: true,
              ),
              ChampMontant(
                controleur: _charges,
                libelle: 'Charges mensuelles',
                aide: 'Laissez vide s\'il n\'y a pas de charges.',
              ),
              const SizedBox(height: AppSpacing.bloc),
              const TitreSection('Adresse du bien'),
              ChampTexte(
                controleur: _rue,
                libelle: 'Numéro et rue',
                majuscules: TextCapitalization.sentences,
                validator: (v) =>
                    Validateurs.obligatoire(v, message: 'Indiquez l\'adresse.'),
              ),
              ChampTexte(
                controleur: _codePostal,
                libelle: 'Code postal',
                clavier: TextInputType.number,
                formats: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(5),
                ],
                validator: Validateurs.codePostal,
              ),
              ChampTexte(
                controleur: _ville,
                libelle: 'Ville',
                majuscules: TextCapitalization.words,
                validator: (v) =>
                    Validateurs.obligatoire(v, message: 'Indiquez la ville.'),
              ),
              const SizedBox(height: AppSpacing.bloc),
              const TitreSection('Informations complémentaires'),
              Text(
                'Facultatives, à compléter quand vous voulez.',
                style: t.secondary,
              ),
              const SizedBox(height: AppSpacing.bloc),
              ChampTexte(
                controleur: _surface,
                libelle: 'Surface habitable',
                suffixe: 'm²',
                clavier: const TextInputType.numberWithOptions(decimal: true),
                formats: [FilteringTextInputFormatter.allow(RegExp('[0-9,.]'))],
                validator: (v) =>
                    (v != null &&
                        v.trim().isNotEmpty &&
                        Formats.parseDecimal(v) == null)
                    ? 'Surface incorrecte (exemple : 32,5).'
                    : null,
              ),
              if (_typeLogement == TypeLogement.immeuble)
                ChampTexte(
                  controleur: _lots,
                  libelle: 'Nombre de lots',
                  clavier: TextInputType.number,
                  formats: [FilteringTextInputFormatter.digitsOnly],
                ),
              const SizedBox(height: AppSpacing.s),
              Text('Classe énergie (DPE)', style: t.rowTitle),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                'Indiquée sur le diagnostic de performance énergétique.',
                style: t.secondary,
              ),
              const SizedBox(height: AppSpacing.s),
              Wrap(
                spacing: AppSpacing.s,
                runSpacing: AppSpacing.s,
                children: [
                  for (final classe in ClasseDpe.values)
                    PuceFiltre(
                      libelle: classe.libelle,
                      active: _dpe == classe,
                      onTap: () =>
                          setState(() => _dpe = _dpe == classe ? null : classe),
                    ),
                ],
              ),
              if (dpeGel) ...[
                const SizedBox(height: AppSpacing.bloc),
                const Note(
                  icone: AppIcons.energie,
                  texte:
                      'Logement classé F ou G : la loi interdit d\'augmenter '
                      'son loyer, la révision n\'est pas possible.',
                ),
              ],
              const SizedBox(height: AppSpacing.bloc),
              ChampDate(
                libelle: 'Date du DPE',
                date: _dateDpe,
                obligatoire: false,
                premiere: DateTime(2006),
                derniere: aujourdhui,
                onChanged: (d) => setState(() => _dateDpe = d),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BarreActionFixe(
        libelle: _creation
            ? 'Ajouter ce bien'
            : 'Enregistrer les modifications',
        onPressed: _enregistrer,
        enCours: _enCours,
      ),
    );
  }
}
