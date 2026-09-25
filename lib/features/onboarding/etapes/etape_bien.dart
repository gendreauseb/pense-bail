import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/design/design.dart';
import '../../../core/config/config_app.dart';
import '../../../core/format/formats.dart';
import '../../../core/utils/dates.dart';
import '../../../core/validation/validateurs.dart';
import '../../../core/widgets/choix_cartes.dart';
import '../../../domain/entities/entities.dart';
import '../brouillon_onboarding.dart';
import '../onboarding_controller.dart';
import '../onboarding_page.dart';
import '../widgets/gabarit_etape.dart';

class EtapeBien extends ConsumerStatefulWidget {
  const EtapeBien({super.key, required this.brouillon});
  final BrouillonOnboarding brouillon;

  @override
  ConsumerState<EtapeBien> createState() => _EtapeBienState();
}

class _EtapeBienState extends ConsumerState<EtapeBien> {
  final _formulaire = GlobalKey<FormState>();
  late final _nom = TextEditingController(text: _bien.nom);
  late final _loyer = TextEditingController(text: _bien.loyer);
  late final _charges = TextEditingController(text: _bien.charges);
  late final _rue = TextEditingController(text: _bien.rue);
  late final _codePostal = TextEditingController(text: _bien.codePostal);
  late final _ville = TextEditingController(text: _bien.ville);
  late final _dateDebut = TextEditingController(
    text: _texteDate(_bien.dateDebutBail),
  );

  BrouillonBien get _bien => widget.brouillon.bienCourant;
  OnboardingController get _controleur =>
      ref.read(onboardingControllerProvider.notifier);

  static String _texteDate(DateTime? d) => d == null ? '' : Formats.date(d);

  DateTime get _dateMax => Dates.ajouterMois(
    Dates.aujourdhui(),
    ConfigApp.debutBailMaxMoisDansLeFutur,
  );

  @override
  void dispose() {
    for (final c in [
      _nom,
      _loyer,
      _charges,
      _rue,
      _codePostal,
      _ville,
      _dateDebut,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  /// Met à jour le brouillon avec les champs texte et les choix donnés.
  void _enregistrer({
    TypeLogement? typeLogement,
    TypeLocation? typeLocation,
    TypeBail? typeBail,
    DateTime? dateDebutBail,
  }) => _controleur.majBienCourant(
    _bien.copyWith(
      nom: _nom.text,
      loyer: _loyer.text,
      charges: _charges.text,
      rue: _rue.text,
      codePostal: _codePostal.text,
      ville: _ville.text,
      typeLogement: typeLogement,
      typeLocation: typeLocation,
      typeBail: typeBail,
      dateDebutBail: dateDebutBail,
    ),
  );

  Future<void> _choisirDate() async {
    final max = _dateMax;
    final actuelle = _bien.dateDebutBail;
    final date = await showDatePicker(
      context: context,
      helpText: 'Date de début du bail',
      initialDate: actuelle == null || actuelle.isAfter(max)
          ? Dates.aujourdhui()
          : actuelle,
      firstDate: DateTime(1970),
      lastDate: max,
      fieldLabelText: 'Date (JJ/MM/AAAA)',
      errorFormatText: 'Format attendu : JJ/MM/AAAA',
      errorInvalidText: 'Date trop éloignée dans le futur',
      // Jamais « OK » seul (UI.md §8).
      confirmText: 'Choisir cette date',
      cancelText: 'Annuler',
    );
    if (date == null) return;
    _dateDebut.text = _texteDate(date);
    _enregistrer(dateDebutBail: Dates.jour(date));
  }

  void _continuer() {
    if (!validerEtMontrerErreur(_formulaire)) return;
    _enregistrer();
    _controleur.suivant();
  }

  @override
  Widget build(BuildContext context) {
    final bien = _bien;
    return GabaritEtape(
      entete: ProgressionBien(brouillon: widget.brouillon),
      titre: 'Décrivez votre bien',
      onRetour: _controleur.precedent,
      libelleAction: 'Continuer',
      onAction: _continuer,
      contenu: Form(
        key: _formulaire,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _texte(
              _nom,
              'Nom du bien',
              aide:
                  'Le nom affiché partout dans l\'application. '
                  'Exemple : Studio Gambetta',
              validator: (v) => Validateurs.obligatoire(
                v,
                message: 'Donnez un nom à ce bien.',
              ),
              majuscules: TextCapitalization.sentences,
            ),
            const SizedBox(height: AppSpacing.bloc),
            const TitreSection('Type de logement'),
            ChampChoix<TypeLogement>(
              options: TypeLogement.values,
              valeurInitiale: bien.typeLogement,
              libelle: (t) => t.libelle,
              icone: AppIcons.typeLogement,
              messageObligatoire: 'Choisissez le type de logement.',
              onChanged: (t) => _enregistrer(typeLogement: t),
            ),
            const SizedBox(height: AppSpacing.sectionLarge),
            const TitreSection('Type de location'),
            ChampChoix<TypeLocation>(
              options: TypeLocation.values,
              valeurInitiale: bien.typeLocation,
              libelle: (t) => t.libelle,
              icone: AppIcons.typeLocation,
              precision: (t) => t.precision,
              messageObligatoire: 'Choisissez le type de location.',
              colonnesMax: 1,
              onChanged: (t) => _enregistrer(typeLocation: t),
            ),
            // Champs du bail : uniquement en longue durée, avec une apparition
            // fluide. Les valeurs restent dans le brouillon si on change de type.
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: bien.estLongueDuree
                  ? _BlocBail(
                      bien: bien,
                      dateDebut: _dateDebut,
                      dateMax: _dateMax,
                      onTypeBail: (t) => _enregistrer(typeBail: t),
                      onChoisirDate: _choisirDate,
                    )
                  : const SizedBox(width: double.infinity),
            ),
            const SizedBox(height: AppSpacing.sectionLarge),
            const TitreSection('Loyer'),
            _texte(
              _loyer,
              'Loyer mensuel hors charges',
              suffixe: '€',
              clavier: const TextInputType.numberWithOptions(decimal: true),
              formats: [_formatMontant],
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Indiquez le loyer.';
                return Formats.parseMontant(v) == null
                    ? 'Montant incorrect (exemple : 650 ou 650,50).'
                    : null;
              },
            ),
            _texte(
              _charges,
              'Charges mensuelles',
              suffixe: '€',
              aide: 'Laissez vide s\'il n\'y a pas de charges.',
              clavier: const TextInputType.numberWithOptions(decimal: true),
              formats: [_formatMontant],
              validator: (v) =>
                  (v != null &&
                      v.trim().isNotEmpty &&
                      Formats.parseMontant(v) == null)
                  ? 'Montant incorrect (exemple : 50 ou 49,90).'
                  : null,
            ),
            const SizedBox(height: AppSpacing.bloc),
            const TitreSection('Adresse du bien'),
            _texte(
              _rue,
              'Numéro et rue',
              validator: (v) =>
                  Validateurs.obligatoire(v, message: 'Indiquez l\'adresse.'),
              majuscules: TextCapitalization.sentences,
            ),
            _texte(
              _codePostal,
              'Code postal',
              validator: Validateurs.codePostal,
              clavier: TextInputType.number,
              formats: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(5),
              ],
            ),
            _texte(
              _ville,
              'Ville',
              validator: (v) =>
                  Validateurs.obligatoire(v, message: 'Indiquez la ville.'),
              majuscules: TextCapitalization.words,
            ),
          ],
        ),
      ),
    );
  }

  static final _formatMontant = FilteringTextInputFormatter.allow(
    RegExp(r'[0-9,.\s]'),
  );

  Widget _texte(
    TextEditingController controleur,
    String libelle, {
    String? aide,
    String? suffixe,
    String? Function(String?)? validator,
    TextInputType? clavier,
    TextCapitalization majuscules = TextCapitalization.none,
    List<TextInputFormatter>? formats,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.bloc),
    child: TextFormField(
      controller: controleur,
      decoration: InputDecoration(
        labelText: libelle,
        helperText: aide,
        suffixText: suffixe,
      ),
      validator: validator,
      keyboardType: clavier,
      textCapitalization: majuscules,
      inputFormatters: formats,
      textInputAction: TextInputAction.next,
      autovalidateMode: AutovalidateMode.onUserInteractionIfError,
      onChanged: (_) => _enregistrer(),
    ),
  );
}

class _BlocBail extends StatelessWidget {
  const _BlocBail({
    required this.bien,
    required this.dateDebut,
    required this.dateMax,
    required this.onTypeBail,
    required this.onChoisirDate,
  });

  final BrouillonBien bien;
  final TextEditingController dateDebut;
  final DateTime dateMax;
  final ValueChanged<TypeBail> onTypeBail;
  final VoidCallback onChoisirDate;

  @override
  Widget build(BuildContext context) {
    final t = context.textes;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.section),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.carte),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const TitreSection('Type de bail'),
              ChampChoix<TypeBail>(
                options: TypeBail.longueDuree,
                valeurInitiale: bien.typeBail,
                libelle: (t) => t.libelle,
                icone: AppIcons.typeBail,
                messageObligatoire: 'Choisissez le type de bail.',
                onChanged: onTypeBail,
              ),
              const SizedBox(height: AppSpacing.section),
              TextFormField(
                controller: dateDebut,
                readOnly: true,
                onTap: onChoisirDate,
                decoration: const InputDecoration(
                  labelText: 'Date de début du bail',
                  hintText: 'JJ/MM/AAAA',
                  suffixIcon: Icon(AppIcons.calendrier),
                ),
                validator: (_) {
                  final date = bien.dateDebutBail;
                  if (date == null) return 'Indiquez la date de début du bail.';
                  if (date.isAfter(dateMax)) {
                    return 'La date ne peut pas dépasser le ${Formats.date(dateMax)}.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.bloc),
              // Explication en ligne (pas de carte dans la carte).
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    AppIcons.rappel,
                    size: AppSizes.iconePetite,
                    color: context.couleurs.primary,
                  ),
                  const SizedBox(width: AppSpacing.blocSerre),
                  Expanded(
                    child: Text(
                      'Pour activer vos premiers rappels automatiquement : '
                      'révision du loyer, fin du bail et date limite pour '
                      'donner congé.',
                      style: t.secondary.copyWith(
                        color: context.couleurs.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
