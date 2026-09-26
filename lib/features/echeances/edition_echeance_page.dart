import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/design/design.dart';
import '../../app/etat_app.dart';
import '../../core/config/config_app.dart';
import '../../core/format/formats.dart';
import '../../core/utils/dates.dart';
import '../../core/utils/identifiants.dart';
import '../../core/validation/validateurs.dart';
import '../../core/widgets/choix_cartes.dart';
import '../../core/widgets/composants.dart';
import '../../core/widgets/listes.dart';
import '../../data/providers.dart';
import '../../domain/entities/entities.dart';
import 'textes_echeances.dart';

/// Valeurs proposées pour une nouvelle échéance (depuis la fiche d'un bien :
/// assurance, chaudière, diagnostic…). Toutes restent modifiables.
class Preremplissage {
  const Preremplissage({
    this.bienId,
    this.type = TypeEcheance.personnalisee,
    this.titre,
    this.date,
    this.intervalleMois,
    this.notes,
    this.typeDiagnostic,
  });

  final String? bienId;
  final TypeEcheance type;
  final String? titre;
  final DateTime? date;
  final int? intervalleMois;
  final String? notes;
  final TypeDiagnostic? typeDiagnostic;

  /// Paramètres d'URL (voir Routes.nouvelleEcheance).
  Map<String, String?> versParametres() => {
    'bien': bienId,
    'type': type.name,
    'titre': titre,
    'date': date?.toIso8601String(),
    'intervalle': intervalleMois?.toString(),
    'notes': notes,
    'diagnostic': typeDiagnostic?.name,
  };

  factory Preremplissage.depuisParametres(Map<String, String> p) {
    T? parNom<T extends Enum>(List<T> valeurs, String? nom) {
      for (final v in valeurs) {
        if (v.name == nom) return v;
      }
      return null;
    }

    return Preremplissage(
      bienId: p['bien'],
      type:
          parNom(TypeEcheance.values, p['type']) ?? TypeEcheance.personnalisee,
      titre: p['titre'],
      date: p['date'] == null ? null : DateTime.tryParse(p['date']!),
      intervalleMois: int.tryParse(p['intervalle'] ?? ''),
      notes: p['notes'],
      typeDiagnostic: parNom(TypeDiagnostic.values, p['diagnostic']),
    );
  }
}

/// Création (via le bouton « + » ou la fiche d'un bien) ou modification
/// d'une échéance.
class EditionEcheancePage extends ConsumerWidget {
  const EditionEcheancePage({
    super.key,
    this.echeanceId,
    this.preremplissage = const Preremplissage(),
  });

  /// `null` : nouvelle échéance.
  final String? echeanceId;
  final Preremplissage preremplissage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = echeanceId;
    if (id == null) {
      return _Formulaire(
        existante: null,
        rappels: null,
        preremplissage: preremplissage,
      );
    }

    final echeance = ref.watch(echeanceProvider(id));
    final rappels = ref.watch(rappelsEcheanceProvider(id));
    return switch ((echeance, rappels)) {
      (AsyncData(value: final e?), AsyncData(value: final r)) => _Formulaire(
        existante: e,
        rappels: [for (final x in r) x.joursAvant],
        preremplissage: const Preremplissage(),
      ),
      (AsyncData(value: null), _) => const _Introuvable(),
      (AsyncError(), _) || (_, AsyncError()) => const _Introuvable(),
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
      child: Text('Cette échéance n\'existe plus.', style: context.textes.body),
    ),
  );
}

/// Récurrences proposées (en mois). 0 : une seule fois.
const _recurrences = {
  0: 'Une seule fois',
  1: 'Chaque mois',
  3: 'Chaque trimestre',
  12: 'Chaque année',
};

/// Bien « commun » (échéance valable pour tous les biens).
const _tousLesBiens = '';

class _Formulaire extends ConsumerStatefulWidget {
  const _Formulaire({
    required this.existante,
    required this.rappels,
    required this.preremplissage,
  });

  final Echeance? existante;
  final List<int>? rappels;
  final Preremplissage preremplissage;

  @override
  ConsumerState<_Formulaire> createState() => _FormulaireState();
}

class _FormulaireState extends ConsumerState<_Formulaire> {
  final _formulaire = GlobalKey<FormState>();
  late final _titre = TextEditingController(
    text: widget.existante?.titre ?? widget.preremplissage.titre,
  );
  late final _notes = TextEditingController(
    text: widget.existante?.notes ?? widget.preremplissage.notes,
  );
  late final _dateTexte = TextEditingController(
    text: _date == null ? '' : Formats.date(_date!),
  );

  late DateTime? _date = widget.existante?.date ?? widget.preremplissage.date;
  late int _recurrence =
      widget.existante?.intervalleMois ??
      widget.preremplissage.intervalleMois ??
      0;
  late String _bienId =
      widget.existante?.bienId ?? widget.preremplissage.bienId ?? _tousLesBiens;
  late final Set<int> _rappels = {
    ...(widget.rappels ??
        ref.read(preferencesRappelsProvider).value?.delaisParDefaut ??
        ConfigApp.rappelsParDefautJours),
  };
  bool _enCours = false;

  bool get _creation => widget.existante == null;

  @override
  void dispose() {
    _titre.dispose();
    _notes.dispose();
    _dateTexte.dispose();
    super.dispose();
  }

  Future<void> _choisirDate() async {
    final aujourdhui = ref.read(aujourdhuiProvider);
    final date = await showDatePicker(
      context: context,
      helpText: 'Date de l\'échéance',
      initialDate: _date ?? aujourdhui,
      firstDate: Dates.ajouterMois(aujourdhui, -12),
      lastDate: Dates.ajouterMois(aujourdhui, 120),
      confirmText: 'Choisir cette date',
      cancelText: 'Annuler',
      fieldLabelText: 'Date (JJ/MM/AAAA)',
      errorFormatText: 'Format attendu : JJ/MM/AAAA',
      errorInvalidText: 'Date hors des limites possibles',
    );
    if (date == null) return;
    setState(() {
      _date = Dates.jour(date);
      _dateTexte.text = Formats.date(_date!);
    });
  }

  Future<void> _enregistrer() async {
    if (!validerEtMontrerErreur(_formulaire)) return;
    setState(() => _enCours = true);
    final maintenant = DateTime.now();
    final notes = _notes.text.trim().isEmpty ? null : _notes.text.trim();
    final intervalle = _recurrence == 0 ? null : _recurrence;
    final existante = widget.existante;

    final echeance = existante == null
        ? Echeance(
            id: Identifiants.nouveau(),
            bienId: _bienId == _tousLesBiens ? null : _bienId,
            type: widget.preremplissage.type,
            typeDiagnostic: widget.preremplissage.typeDiagnostic,
            titre: _titre.text.trim(),
            date: _date!,
            statut: StatutEcheance.aFaire,
            notes: notes,
            intervalleMois: intervalle,
            automatique: false,
            creeLe: maintenant,
            modifieLe: maintenant,
          )
        : existante.copyWith(
            titre: _titre.text.trim(),
            date: _date,
            // Nouvelle date choisie : ce n'est plus un report.
            dateInitiale: _date == existante.date
                ? existante.dateInitiale
                : null,
            notes: notes,
            intervalleMois: intervalle,
          );

    final messager = ScaffoldMessenger.of(context);
    final navigateur = Navigator.of(context);
    await ref
        .read(gestionEcheancesProvider)
        .enregistrer(echeance, _rappels.toList());
    navigateur.pop();
    messager.showSnackBar(
      SnackBar(
        content: Text(
          _creation ? 'Échéance ajoutée.' : 'Modifications enregistrées.',
        ),
      ),
    );
  }

  Future<void> _supprimer() async {
    final existante = widget.existante!;
    final confirme = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer cette échéance ?'),
        content: Text(
          existante.automatique
              ? '« ${existante.titre} » a été calculée depuis le bail : elle '
                    'sera recréée si vous modifiez les informations du bail.'
              : '« ${existante.titre} » et ses rappels seront supprimés.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: context.couleurs.erreur,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirme != true || !mounted) return;
    final messager = ScaffoldMessenger.of(context);
    final navigateur = Navigator.of(context);
    await ref.read(gestionEcheancesProvider).supprimer(existante.id);
    navigateur.pop();
    messager.showSnackBar(const SnackBar(content: Text('Échéance supprimée.')));
  }

  @override
  Widget build(BuildContext context) {
    final t = context.textes;
    final biens = ref.watch(biensFluxProvider).value ?? const <Bien>[];
    final recurrences = {
      ..._recurrences,
      if (!_recurrences.containsKey(_recurrence))
        _recurrence: _libelleRecurrence(_recurrence),
    };

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(AppIcons.retour),
          tooltip: 'Retour',
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (!_creation)
            IconButton(
              icon: const Icon(AppIcons.supprimer),
              tooltip: 'Supprimer l\'échéance',
              onPressed: _enCours ? null : _supprimer,
            ),
        ],
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
                  _creation ? 'Nouvelle échéance' : 'Modifier l\'échéance',
                  style: t.headline,
                ),
              ),
              const SizedBox(height: AppSpacing.sectionLarge),
              TextFormField(
                controller: _titre,
                decoration: const InputDecoration(
                  labelText: 'Intitulé',
                  helperText: 'Exemple : Contrôle de la VMC',
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (v) => Validateurs.obligatoire(
                  v,
                  message: 'Donnez un intitulé à cette échéance.',
                ),
              ),
              const SizedBox(height: AppSpacing.bloc),
              TextFormField(
                controller: _dateTexte,
                readOnly: true,
                onTap: _choisirDate,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  hintText: 'JJ/MM/AAAA',
                  suffixIcon: Icon(AppIcons.calendrier),
                ),
                validator: (_) =>
                    _date == null ? 'Choisissez la date de l\'échéance.' : null,
              ),
              if (_creation && biens.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sectionLarge),
                const TitreSection('Bien concerné'),
                ChampChoix<String>(
                  options: [_tousLesBiens, for (final b in biens) b.id],
                  valeurInitiale: _bienId,
                  libelle: (id) => id == _tousLesBiens
                      ? 'Tous mes biens'
                      : biens.firstWhere((b) => b.id == id).nom,
                  onChanged: (id) => setState(() => _bienId = id),
                ),
              ],
              const SizedBox(height: AppSpacing.sectionLarge),
              const TitreSection('Répétition'),
              ChampChoix<int>(
                options: recurrences.keys.toList(),
                valeurInitiale: _recurrence,
                libelle: (m) => recurrences[m]!,
                onChanged: (m) => setState(() => _recurrence = m),
              ),
              const SizedBox(height: AppSpacing.sectionLarge),
              const TitreSection('Me prévenir'),
              Text(
                'Une notification est envoyée à ${ConfigApp.heureRappel} h '
                'les jours choisis.',
                style: t.secondary,
              ),
              const SizedBox(height: AppSpacing.bloc),
              Wrap(
                spacing: AppSpacing.s,
                runSpacing: AppSpacing.s,
                children: [
                  for (final jours in ConfigApp.rappelsProposesJours)
                    PuceFiltre(
                      libelle: texteDelaiRappel(jours),
                      active: _rappels.contains(jours),
                      onTap: () => setState(
                        () => _rappels.contains(jours)
                            ? _rappels.remove(jours)
                            : _rappels.add(jours),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sectionLarge),
              TextFormField(
                controller: _notes,
                decoration: const InputDecoration(
                  labelText: 'Notes (facultatif)',
                  alignLabelWithHint: true,
                ),
                textCapitalization: TextCapitalization.sentences,
                minLines: 3,
                maxLines: 6,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BarreActionFixe(
        libelle: _creation
            ? 'Ajouter l\'échéance'
            : 'Enregistrer les modifications',
        onPressed: _enregistrer,
        enCours: _enCours,
      ),
    );
  }

  static String _libelleRecurrence(int mois) =>
      mois % 12 == 0 ? 'Tous les ${mois ~/ 12} ans' : 'Tous les $mois mois';
}
