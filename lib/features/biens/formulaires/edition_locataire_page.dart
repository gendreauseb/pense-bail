import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/design/design.dart';
import '../../../core/utils/identifiants.dart';
import '../../../core/validation/validateurs.dart';
import '../../../core/widgets/composants.dart';
import '../../../core/widgets/formulaires.dart';
import '../../../data/providers.dart';
import '../../../domain/entities/entities.dart';

/// Ajout ou modification d'un locataire du bail actif.
class EditionLocatairePage extends ConsumerWidget {
  const EditionLocatairePage({
    super.key,
    required this.bienId,
    this.locataireId,
  });

  final String bienId;
  final String? locataireId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bail = ref.watch(bailActifFluxProvider(bienId));
    return switch (bail) {
      AsyncData(value: final b?) => _Chargement(
        bail: b,
        locataireId: locataireId,
      ),
      AsyncData() => Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('Renseignez d\'abord les informations du bail.'),
        ),
      ),
      _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
    };
  }
}

class _Chargement extends ConsumerWidget {
  const _Chargement({required this.bail, required this.locataireId});
  final Bail bail;
  final String? locataireId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = locataireId;
    if (id == null) return _Formulaire(bail: bail, existant: null);
    final locataires = ref.watch(locatairesFluxProvider(bail.id));
    return switch (locataires) {
      AsyncData(:final value) => _Formulaire(
        bail: bail,
        existant: value.where((l) => l.id == id).firstOrNull,
      ),
      _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
    };
  }
}

class _Formulaire extends ConsumerStatefulWidget {
  const _Formulaire({required this.bail, required this.existant});
  final Bail bail;
  final Locataire? existant;

  @override
  ConsumerState<_Formulaire> createState() => _FormulaireState();
}

class _FormulaireState extends ConsumerState<_Formulaire> {
  final _cle = GlobalKey<FormState>();
  late final _prenom = TextEditingController(text: widget.existant?.prenom);
  late final _nom = TextEditingController(text: widget.existant?.nom);
  late final _telephone = TextEditingController(
    text: widget.existant?.telephone,
  );
  late final _email = TextEditingController(text: widget.existant?.email);
  bool _enCours = false;

  @override
  void dispose() {
    for (final c in [_prenom, _nom, _telephone, _email]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _enregistrer() async {
    if (!validerEtMontrerErreur(_cle)) return;
    setState(() => _enCours = true);
    final maintenant = DateTime.now();
    final telephone = Validateurs.normaliserTelephone(_telephone.text);
    final email = _email.text.trim();
    final locataire = Locataire(
      id: widget.existant?.id ?? Identifiants.nouveau(),
      bailId: widget.bail.id,
      prenom: _prenom.text.trim(),
      nom: _nom.text.trim(),
      telephone: telephone,
      email: email.isEmpty ? null : email,
      creeLe: widget.existant?.creeLe ?? maintenant,
      modifieLe: maintenant,
    );
    final navigateur = Navigator.of(context);
    await ref.read(bailRepositoryProvider).enregistrerLocataire(locataire);
    navigateur.pop();
  }

  Future<void> _supprimer() async {
    final l = widget.existant!;
    final ok = await confirmerSuppression(
      context,
      titre: 'Retirer ce locataire ?',
      message: '${l.nomComplet} ne figurera plus sur ce bail.',
      action: 'Retirer',
    );
    if (!ok || !mounted) return;
    final navigateur = Navigator.of(context);
    await ref.read(bailRepositoryProvider).supprimerLocataire(l.id);
    navigateur.pop();
  }

  @override
  Widget build(BuildContext context) => PageFormulaire(
    cle: _cle,
    surtitre: 'Bail et locataire',
    titre: widget.existant == null ? 'Nouveau locataire' : 'Locataire',
    libelleAction: 'Enregistrer',
    onEnregistrer: _enregistrer,
    enCours: _enCours,
    onSupprimer: widget.existant == null ? null : _supprimer,
    descriptionSupprimer: 'Retirer le locataire',
    champs: [
      ChampTexte(
        controleur: _prenom,
        libelle: 'Prénom',
        majuscules: TextCapitalization.words,
      ),
      ChampTexte(
        controleur: _nom,
        libelle: 'Nom',
        majuscules: TextCapitalization.words,
        validator: (v) =>
            Validateurs.obligatoire(v, message: 'Indiquez le nom.'),
      ),
      ChampTexte(
        controleur: _telephone,
        libelle: 'Téléphone (facultatif)',
        aide: 'Exemple : 06 12 34 56 78',
        clavier: TextInputType.phone,
        validator: Validateurs.telephone,
      ),
      ChampTexte(
        controleur: _email,
        libelle: 'Email (facultatif)',
        clavier: TextInputType.emailAddress,
        validator: Validateurs.email,
      ),
      const SizedBox(height: AppSpacing.s),
      const Note(
        texte:
            'Ces coordonnées servent à appeler ou écrire à votre locataire, '
            'et figurent sur les courriers. Elles restent sur votre '
            'téléphone.',
      ),
    ],
  );
}
