import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/design/design.dart';
import '../../../core/validation/validateurs.dart';
import '../brouillon_onboarding.dart';
import '../onboarding_controller.dart';
import '../widgets/gabarit_etape.dart';

class EtapeIdentite extends ConsumerStatefulWidget {
  const EtapeIdentite({super.key, required this.brouillon});
  final BrouillonOnboarding brouillon;

  @override
  ConsumerState<EtapeIdentite> createState() => _EtapeIdentiteState();
}

class _EtapeIdentiteState extends ConsumerState<EtapeIdentite> {
  final _formulaire = GlobalKey<FormState>();
  late final _prenom = TextEditingController(text: _initial.prenom);
  late final _nom = TextEditingController(text: _initial.nom);
  late final _rue = TextEditingController(text: _initial.rue);
  late final _complement = TextEditingController(
    text: _initial.complementAdresse,
  );
  late final _codePostal = TextEditingController(text: _initial.codePostal);
  late final _ville = TextEditingController(text: _initial.ville);
  late final _telephone = TextEditingController(text: _initial.telephone);
  late final _email = TextEditingController(text: _initial.email);

  BrouillonIdentite get _initial => widget.brouillon.identite;
  OnboardingController get _controleur =>
      ref.read(onboardingControllerProvider.notifier);

  @override
  void dispose() {
    for (final c in [
      _prenom,
      _nom,
      _rue,
      _complement,
      _codePostal,
      _ville,
      _telephone,
      _email,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _enregistrer() => _controleur.majIdentite(
    BrouillonIdentite(
      prenom: _prenom.text,
      nom: _nom.text,
      rue: _rue.text,
      complementAdresse: _complement.text,
      codePostal: _codePostal.text,
      ville: _ville.text,
      telephone: _telephone.text,
      email: _email.text,
    ),
  );

  void _continuer() {
    if (!validerEtMontrerErreur(_formulaire)) return;
    _enregistrer();
    _controleur.suivant();
  }

  Widget _champ(
    TextEditingController controleur,
    String libelle, {
    String? Function(String?)? validator,
    TextInputType? clavier,
    TextCapitalization majuscules = TextCapitalization.none,
    Iterable<String>? autofill,
    List<TextInputFormatter>? formats,
    String? aide,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.bloc),
    child: TextFormField(
      controller: controleur,
      decoration: InputDecoration(labelText: libelle, helperText: aide),
      validator: validator,
      keyboardType: clavier,
      textCapitalization: majuscules,
      autofillHints: autofill,
      inputFormatters: formats,
      textInputAction: TextInputAction.next,
      autovalidateMode: AutovalidateMode.onUserInteractionIfError,
      onChanged: (_) => _enregistrer(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return GabaritEtape(
      titre: 'Vos coordonnées',
      sousTitre: 'Pour commencer, présentez-vous.',
      onRetour: _controleur.precedent,
      libelleAction: 'Continuer',
      onAction: _continuer,
      contenu: Form(
        key: _formulaire,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Note(
                icone: AppIcons.courrier,
                texte:
                    'Ces informations apparaîtront comme expéditeur sur les '
                    'courriers préparés par l\'application (révision de '
                    'loyer…). Elles restent sur votre téléphone.',
              ),
              const SizedBox(height: AppSpacing.sectionLarge),
              _champ(
                _prenom,
                'Prénom',
                validator: (v) => Validateurs.obligatoire(
                  v,
                  message: 'Indiquez votre prénom.',
                ),
                majuscules: TextCapitalization.words,
                autofill: const [AutofillHints.givenName],
              ),
              _champ(
                _nom,
                'Nom',
                validator: (v) =>
                    Validateurs.obligatoire(v, message: 'Indiquez votre nom.'),
                majuscules: TextCapitalization.words,
                autofill: const [AutofillHints.familyName],
              ),
              const SizedBox(height: AppSpacing.bloc),
              const TitreSection('Adresse postale'),
              _champ(
                _rue,
                'Numéro et rue',
                validator: (v) => Validateurs.obligatoire(
                  v,
                  message: 'Indiquez votre adresse.',
                ),
                majuscules: TextCapitalization.sentences,
                autofill: const [AutofillHints.streetAddressLine1],
              ),
              _champ(
                _complement,
                "Complément d'adresse (facultatif)",
                aide: 'Bâtiment, résidence, étage, appartement…',
                majuscules: TextCapitalization.sentences,
                autofill: const [AutofillHints.streetAddressLine2],
              ),
              _champ(
                _codePostal,
                'Code postal',
                validator: Validateurs.codePostal,
                clavier: TextInputType.number,
                autofill: const [AutofillHints.postalCode],
                formats: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(5),
                ],
              ),
              _champ(
                _ville,
                'Ville',
                validator: (v) => Validateurs.obligatoire(
                  v,
                  message: 'Indiquez votre ville.',
                ),
                majuscules: TextCapitalization.words,
                autofill: const [AutofillHints.addressCity],
              ),
              const SizedBox(height: AppSpacing.bloc),
              const TitreSection('Pour vous joindre'),
              _champ(
                _telephone,
                'Téléphone (facultatif)',
                validator: Validateurs.telephone,
                clavier: TextInputType.phone,
                autofill: const [AutofillHints.telephoneNumber],
                aide: 'Exemple : 06 12 34 56 78',
              ),
              _champ(
                _email,
                'Email (facultatif)',
                validator: Validateurs.email,
                clavier: TextInputType.emailAddress,
                autofill: const [AutofillHints.email],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
