import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/design/design.dart';
import '../../app/etat_app.dart';
import '../../app/routes.dart';
import '../../core/format/formats.dart';
import '../../core/utils/dates.dart';
import '../../core/utils/identifiants.dart';
import '../../core/validation/validateurs.dart';
import '../../core/widgets/choix_cartes.dart';
import '../../core/widgets/composants.dart';
import '../../core/widgets/formulaires.dart';
import '../../data/providers.dart';
import '../../domain/entities/entities.dart';

/// Artisan « non enregistré » (intervention sans fiche dans le carnet).
const _sansArtisan = '';

/// Ajout ou modification d'une intervention sur un bien. Son coût crée
/// automatiquement une dépense dans la rentabilité du bien.
class EditionInterventionPage extends ConsumerWidget {
  const EditionInterventionPage({
    super.key,
    required this.bienId,
    this.interventionId,
  });

  final String bienId;
  final String? interventionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = interventionId;
    if (id == null) return _Formulaire(bienId: bienId, existante: null);
    return switch (ref.watch(interventionsFluxProvider(bienId))) {
      AsyncData(:final value) => _Formulaire(
        bienId: bienId,
        existante: value.where((i) => i.id == id).firstOrNull,
      ),
      _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
    };
  }
}

class _Formulaire extends ConsumerStatefulWidget {
  const _Formulaire({required this.bienId, required this.existante});
  final String bienId;
  final Intervention? existante;

  @override
  ConsumerState<_Formulaire> createState() => _FormulaireState();
}

class _FormulaireState extends ConsumerState<_Formulaire> {
  final _cle = GlobalKey<FormState>();
  late final Intervention? _i = widget.existante;
  late final _description = TextEditingController(text: _i?.description);
  late final _cout = TextEditingController(
    text: ChampMontant.texte(_i?.coutCentimes),
  );
  late DateTime? _date = _i?.date ?? ref.read(aujourdhuiProvider);
  late String _artisanId = _i?.artisanId ?? _sansArtisan;

  /// Remonte le formulaire quand un artisan vient d'être ajouté.
  int _version = 0;
  bool _enCours = false;

  @override
  void dispose() {
    _description.dispose();
    _cout.dispose();
    super.dispose();
  }

  Future<void> _nouvelArtisan() async {
    final id = await context.push<String>(Routes.artisan);
    if (id != null && mounted) {
      setState(() {
        _artisanId = id;
        _version++;
      });
    }
  }

  Future<void> _enregistrer() async {
    if (!validerEtMontrerErreur(_cle)) return;
    setState(() => _enCours = true);
    final maintenant = DateTime.now();
    final cout = _cout.text.trim().isEmpty
        ? null
        : Formats.parseMontant(_cout.text);
    final intervention = Intervention(
      id: _i?.id ?? Identifiants.nouveau(),
      bienId: widget.bienId,
      artisanId: _artisanId == _sansArtisan ? null : _artisanId,
      date: _date!,
      description: _description.text.trim(),
      coutCentimes: cout,
      creeLe: _i?.creeLe ?? maintenant,
      modifieLe: maintenant,
    );
    final navigateur = Navigator.of(context);
    await ref
        .read(artisanRepositoryProvider)
        .enregistrerIntervention(intervention);
    navigateur.pop();
  }

  Future<void> _supprimer() async {
    final ok = await confirmerSuppression(
      context,
      titre: 'Supprimer cette intervention ?',
      message: 'La dépense correspondante sera retirée du journal.',
    );
    if (!ok || !mounted) return;
    final navigateur = Navigator.of(context);
    await ref.read(artisanRepositoryProvider).supprimerIntervention(_i!.id);
    navigateur.pop();
  }

  @override
  Widget build(BuildContext context) {
    final aujourdhui = ref.watch(aujourdhuiProvider);
    final artisans = ref.watch(artisansFluxProvider).value ?? const <Artisan>[];
    final options = [_sansArtisan, for (final a in artisans) a.id];
    String libelle(String id) => id == _sansArtisan
        ? 'Non enregistré'
        : artisans.firstWhere((a) => a.id == id).nom;

    return PageFormulaire(
      cle: _cle,
      surtitre: 'Artisans',
      titre: _i == null ? 'Nouvelle intervention' : 'Intervention',
      libelleAction: 'Enregistrer',
      onEnregistrer: _enregistrer,
      enCours: _enCours,
      onSupprimer: _i == null ? null : _supprimer,
      descriptionSupprimer: 'Supprimer l\'intervention',
      champs: [
        ChampTexte(
          controleur: _description,
          libelle: 'Travaux réalisés',
          aide: 'Exemple : réparation de la fuite sous l\'évier',
          majuscules: TextCapitalization.sentences,
          lignes: 2,
          validator: (v) =>
              Validateurs.obligatoire(v, message: 'Décrivez l\'intervention.'),
        ),
        ChampDate(
          libelle: 'Date',
          date: _date,
          premiere: DateTime(2000),
          derniere: Dates.ajouterMois(aujourdhui, 12),
          onChanged: (d) => setState(() => _date = d),
        ),
        ChampMontant(
          controleur: _cout,
          libelle: 'Coût (facultatif)',
          aide: 'Ajouté automatiquement aux dépenses du bien.',
        ),
        const SizedBox(height: AppSpacing.bloc),
        const TitreSection('Artisan'),
        ChampChoix<String>(
          // Recréé quand un artisan vient d'être ajouté au carnet.
          key: ValueKey('$_version-${artisans.length}'),
          options: options,
          valeurInitiale: options.contains(_artisanId)
              ? _artisanId
              : _sansArtisan,
          libelle: libelle,
          colonnesMax: 1,
          precision: (id) => id == _sansArtisan
              ? 'Pas encore dans votre carnet'
              : artisans.firstWhere((a) => a.id == id).metier.libelle,
          onChanged: (id) => setState(() => _artisanId = id),
        ),
        const SizedBox(height: AppSpacing.bloc),
        BoutonPointille(
          libelle: 'Ajouter un artisan au carnet',
          onPressed: _nouvelArtisan,
        ),
      ],
    );
  }
}
