import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/design/design.dart';
import '../../core/utils/identifiants.dart';
import '../../core/validation/validateurs.dart';
import '../../core/widgets/choix_cartes.dart';
import '../../core/widgets/composants.dart';
import '../../core/widgets/formulaires.dart';
import '../../data/providers.dart';
import '../../domain/entities/entities.dart';

/// Ajout ou modification d'un artisan du carnet.
/// Retourne l'identifiant de l'artisan enregistré (utile pour une
/// intervention en cours de saisie).
class EditionArtisanPage extends ConsumerWidget {
  const EditionArtisanPage({super.key, this.artisanId});
  final String? artisanId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = artisanId;
    if (id == null) return const _Formulaire(existant: null);
    return switch (ref.watch(artisanProvider(id))) {
      AsyncData(:final value) => _Formulaire(existant: value),
      _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
    };
  }
}

class _Formulaire extends ConsumerStatefulWidget {
  const _Formulaire({required this.existant});
  final Artisan? existant;

  @override
  ConsumerState<_Formulaire> createState() => _FormulaireState();
}

class _FormulaireState extends ConsumerState<_Formulaire> {
  final _cle = GlobalKey<FormState>();
  late final Artisan? _a = widget.existant;
  late final _nom = TextEditingController(text: _a?.nom);
  late final _entreprise = TextEditingController(text: _a?.entreprise);
  late final _telephone = TextEditingController(text: _a?.telephone);
  late final _email = TextEditingController(text: _a?.email);
  late final _notes = TextEditingController(text: _a?.notes);
  late MetierArtisan? _metier = _a?.metier;
  bool _enCours = false;

  @override
  void dispose() {
    for (final c in [_nom, _entreprise, _telephone, _email, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  static String? _texte(TextEditingController c) =>
      c.text.trim().isEmpty ? null : c.text.trim();

  Future<void> _enregistrer() async {
    if (!validerEtMontrerErreur(_cle)) return;
    setState(() => _enCours = true);
    final maintenant = DateTime.now();
    final artisan = Artisan(
      id: _a?.id ?? Identifiants.nouveau(),
      nom: _nom.text.trim(),
      entreprise: _texte(_entreprise),
      metier: _metier!,
      telephone: Validateurs.normaliserTelephone(_telephone.text),
      email: _texte(_email),
      notes: _texte(_notes),
      creeLe: _a?.creeLe ?? maintenant,
      modifieLe: maintenant,
    );
    final navigateur = Navigator.of(context);
    await ref.read(artisanRepositoryProvider).enregistrer(artisan);
    navigateur.pop(artisan.id);
  }

  Future<void> _supprimer() async {
    final ok = await confirmerSuppression(
      context,
      titre: 'Retirer cet artisan du carnet ?',
      message:
          'Ses interventions passées sont conservées dans l\'historique des '
          'biens.',
      action: 'Retirer',
    );
    if (!ok || !mounted) return;
    final navigateur = Navigator.of(context);
    await ref.read(artisanRepositoryProvider).supprimer(_a!.id);
    navigateur.pop();
  }

  @override
  Widget build(BuildContext context) => PageFormulaire(
    cle: _cle,
    surtitre: 'Carnet d\'artisans',
    titre: _a == null ? 'Nouvel artisan' : 'Artisan',
    libelleAction: 'Enregistrer',
    onEnregistrer: _enregistrer,
    enCours: _enCours,
    onSupprimer: _a == null ? null : _supprimer,
    descriptionSupprimer: 'Retirer l\'artisan',
    champs: [
      ChampTexte(
        controleur: _nom,
        libelle: 'Nom',
        majuscules: TextCapitalization.words,
        validator: (v) =>
            Validateurs.obligatoire(v, message: 'Indiquez le nom.'),
      ),
      ChampTexte(
        controleur: _entreprise,
        libelle: 'Entreprise (facultatif)',
        majuscules: TextCapitalization.words,
      ),
      const SizedBox(height: AppSpacing.bloc),
      const TitreSection('Métier'),
      ChampChoix<MetierArtisan>(
        options: MetierArtisan.values,
        valeurInitiale: _metier,
        libelle: (m) => m.libelle,
        icone: AppIcons.metier,
        messageObligatoire: 'Choisissez le métier.',
        onChanged: (m) => setState(() => _metier = m),
      ),
      const SizedBox(height: AppSpacing.sectionLarge),
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
      ChampTexte(
        controleur: _notes,
        libelle: 'Notes (facultatif)',
        aide: 'Exemple : intervient le samedi, devis gratuit',
        majuscules: TextCapitalization.sentences,
        lignes: 3,
      ),
    ],
  );
}
