import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/design/design.dart';
import '../../core/validation/validateurs.dart';
import '../../core/widgets/composants.dart';
import '../../core/widgets/formulaires.dart';
import '../../data/providers.dart';
import '../../domain/entities/entities.dart';

/// Modification du profil du bailleur (expéditeur des courriers).
class EditionProfilPage extends ConsumerWidget {
  const EditionProfilPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      switch (ref.watch(bailleurFluxProvider)) {
        AsyncData(value: final b?) => _Formulaire(bailleur: b),
        _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
      };
}

class _Formulaire extends ConsumerStatefulWidget {
  const _Formulaire({required this.bailleur});
  final Bailleur bailleur;

  @override
  ConsumerState<_Formulaire> createState() => _FormulaireState();
}

class _FormulaireState extends ConsumerState<_Formulaire> {
  final _cle = GlobalKey<FormState>();
  late final _prenom = TextEditingController(text: widget.bailleur.prenom);
  late final _nom = TextEditingController(text: widget.bailleur.nom);
  late final _rue = TextEditingController(text: widget.bailleur.rue);
  late final _codePostal = TextEditingController(
    text: widget.bailleur.codePostal,
  );
  late final _ville = TextEditingController(text: widget.bailleur.ville);
  late final _telephone = TextEditingController(
    text: widget.bailleur.telephone,
  );
  late final _email = TextEditingController(text: widget.bailleur.email);
  bool _enCours = false;

  @override
  void dispose() {
    for (final c in [
      _prenom,
      _nom,
      _rue,
      _codePostal,
      _ville,
      _telephone,
      _email,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _enregistrer() async {
    if (!validerEtMontrerErreur(_cle)) return;
    setState(() => _enCours = true);
    final navigateur = Navigator.of(context);
    await ref
        .read(bailleurRepositoryProvider)
        .enregistrer(
          widget.bailleur.copyWith(
            prenom: _prenom.text.trim(),
            nom: _nom.text.trim(),
            rue: _rue.text.trim(),
            codePostal: _codePostal.text.trim(),
            ville: _ville.text.trim(),
            telephone: Validateurs.normaliserTelephone(_telephone.text) ?? '',
            email: _email.text.trim(),
            modifieLe: DateTime.now(),
          ),
        );
    navigateur.pop();
  }

  @override
  Widget build(BuildContext context) => PageFormulaire(
    cle: _cle,
    surtitre: 'Réglages',
    titre: 'Mon profil',
    libelleAction: 'Enregistrer',
    onEnregistrer: _enregistrer,
    enCours: _enCours,
    champs: [
      const Note(
        icone: AppIcons.courrier,
        texte:
            'Ces informations apparaissent comme expéditeur sur les '
            'courriers préparés par l\'application. Elles restent sur votre '
            'téléphone.',
      ),
      const SizedBox(height: AppSpacing.sectionLarge),
      ChampTexte(
        controleur: _prenom,
        libelle: 'Prénom',
        majuscules: TextCapitalization.words,
        autofill: const [AutofillHints.givenName],
        validator: (v) =>
            Validateurs.obligatoire(v, message: 'Indiquez votre prénom.'),
      ),
      ChampTexte(
        controleur: _nom,
        libelle: 'Nom',
        majuscules: TextCapitalization.words,
        autofill: const [AutofillHints.familyName],
        validator: (v) =>
            Validateurs.obligatoire(v, message: 'Indiquez votre nom.'),
      ),
      const SizedBox(height: AppSpacing.bloc),
      const TitreSection('Adresse postale'),
      ChampTexte(
        controleur: _rue,
        libelle: 'Numéro et rue',
        majuscules: TextCapitalization.sentences,
        autofill: const [AutofillHints.streetAddressLine1],
        validator: (v) =>
            Validateurs.obligatoire(v, message: 'Indiquez votre adresse.'),
      ),
      ChampTexte(
        controleur: _codePostal,
        libelle: 'Code postal',
        clavier: TextInputType.number,
        autofill: const [AutofillHints.postalCode],
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
        autofill: const [AutofillHints.addressCity],
        validator: (v) =>
            Validateurs.obligatoire(v, message: 'Indiquez votre ville.'),
      ),
      const SizedBox(height: AppSpacing.bloc),
      const TitreSection('Pour vous joindre'),
      ChampTexte(
        controleur: _telephone,
        libelle: 'Téléphone (facultatif)',
        aide: 'Exemple : 06 12 34 56 78',
        clavier: TextInputType.phone,
        autofill: const [AutofillHints.telephoneNumber],
        validator: Validateurs.telephone,
      ),
      ChampTexte(
        controleur: _email,
        libelle: 'Email (facultatif)',
        clavier: TextInputType.emailAddress,
        autofill: const [AutofillHints.email],
        validator: Validateurs.email,
      ),
    ],
  );
}
