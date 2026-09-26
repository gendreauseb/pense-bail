import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/design/design.dart';
import '../../../app/etat_app.dart';
import '../../../core/format/formats.dart';
import '../../../core/utils/dates.dart';
import '../../../core/utils/identifiants.dart';
import '../../../core/widgets/choix_cartes.dart';
import '../../../core/widgets/composants.dart';
import '../../../core/widgets/formulaires.dart';
import '../../../data/providers.dart';
import '../../../domain/entities/entities.dart';

/// Catégories proposées dans le journal. Les loyers se suivent avec les
/// cases « Loyer reçu » ; les interventions viennent de l'onglet Artisans.
const _categories = [
  CategorieMouvement.travaux,
  CategorieMouvement.taxeFonciere,
  CategorieMouvement.assurance,
  CategorieMouvement.copropriete,
  CategorieMouvement.credit,
  CategorieMouvement.fraisGestion,
  CategorieMouvement.autreDepense,
  CategorieMouvement.autreRecette,
];

/// Ajout ou modification d'une ligne du journal (dépense ou recette).
class EditionMouvementPage extends ConsumerWidget {
  const EditionMouvementPage({
    super.key,
    required this.bienId,
    this.mouvementId,
  });

  final String bienId;
  final String? mouvementId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = mouvementId;
    if (id == null) return _Formulaire(bienId: bienId, existant: null);
    return switch (ref.watch(mouvementsBienFluxProvider(bienId))) {
      AsyncData(:final value) => _Formulaire(
        bienId: bienId,
        existant: value.where((m) => m.id == id).firstOrNull,
      ),
      _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
    };
  }
}

class _Formulaire extends ConsumerStatefulWidget {
  const _Formulaire({required this.bienId, required this.existant});
  final String bienId;
  final MouvementFinancier? existant;

  @override
  ConsumerState<_Formulaire> createState() => _FormulaireState();
}

class _FormulaireState extends ConsumerState<_Formulaire> {
  final _cle = GlobalKey<FormState>();
  late final _montant = TextEditingController(
    text: ChampMontant.texte(widget.existant?.montantCentimes),
  );
  late final _note = TextEditingController(text: widget.existant?.note);
  late DateTime? _date = widget.existant?.date ?? ref.read(aujourdhuiProvider);
  late CategorieMouvement? _categorie = widget.existant?.categorie;
  bool _enCours = false;

  /// Dépense créée depuis une intervention : se modifie dans l'intervention.
  bool get _lieeIntervention => widget.existant?.interventionId != null;

  @override
  void dispose() {
    _montant.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _enregistrer() async {
    if (!validerEtMontrerErreur(_cle)) return;
    setState(() => _enCours = true);
    final maintenant = DateTime.now();
    final note = _note.text.trim();
    final existant = widget.existant;
    final mouvement = existant == null
        ? MouvementFinancier(
            id: Identifiants.nouveau(),
            bienId: widget.bienId,
            date: _date!,
            montantCentimes: Formats.parseMontant(_montant.text)!,
            categorie: _categorie!,
            note: note.isEmpty ? null : note,
            creeLe: maintenant,
            modifieLe: maintenant,
          )
        : existant.copyWith(
            date: _date,
            montantCentimes: Formats.parseMontant(_montant.text),
            categorie: _categorie,
            note: note.isEmpty ? null : note,
          );
    final navigateur = Navigator.of(context);
    await ref.read(financeRepositoryProvider).enregistrerMouvement(mouvement);
    navigateur.pop();
  }

  Future<void> _supprimer() async {
    final ok = await confirmerSuppression(
      context,
      titre: 'Supprimer cette ligne ?',
      message: 'Elle disparaîtra du journal et du bilan.',
    );
    if (!ok || !mounted) return;
    final navigateur = Navigator.of(context);
    await ref
        .read(financeRepositoryProvider)
        .supprimerMouvement(widget.existant!.id);
    navigateur.pop();
  }

  @override
  Widget build(BuildContext context) {
    final aujourdhui = ref.watch(aujourdhuiProvider);
    if (_lieeIntervention) {
      return Scaffold(
        appBar: AppBar(),
        body: const Padding(
          padding: EdgeInsets.all(AppSpacing.ecran),
          child: Note(
            texte:
                'Cette dépense vient d\'une intervention d\'artisan : '
                'modifiez-la depuis l\'onglet Artisans du bien.',
          ),
        ),
      );
    }
    return PageFormulaire(
      cle: _cle,
      surtitre: 'Journal',
      titre: widget.existant == null ? 'Nouvelle ligne' : 'Modifier la ligne',
      libelleAction: 'Enregistrer',
      onEnregistrer: _enregistrer,
      enCours: _enCours,
      onSupprimer: widget.existant == null ? null : _supprimer,
      descriptionSupprimer: 'Supprimer la ligne',
      champs: [
        const TitreSection('Catégorie'),
        ChampChoix<CategorieMouvement>(
          options: _categories,
          valeurInitiale: _categorie,
          libelle: (c) => c.libelle,
          icone: (c) => c.sens == SensMouvement.recette
              ? AppIcons.recette
              : AppIcons.depense,
          messageObligatoire: 'Choisissez une catégorie.',
          onChanged: (c) => setState(() => _categorie = c),
        ),
        const SizedBox(height: AppSpacing.sectionLarge),
        ChampMontant(
          controleur: _montant,
          libelle: 'Montant',
          obligatoire: true,
        ),
        ChampDate(
          libelle: 'Date',
          date: _date,
          premiere: DateTime(2000),
          derniere: Dates.ajouterMois(aujourdhui, 12),
          onChanged: (d) => setState(() => _date = d),
        ),
        ChampTexte(
          controleur: _note,
          libelle: 'Note (facultatif)',
          majuscules: TextCapitalization.sentences,
          lignes: 2,
        ),
      ],
    );
  }
}
