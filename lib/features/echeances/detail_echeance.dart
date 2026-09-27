import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/design/design.dart';
import '../../app/etat_app.dart';
import '../../app/routes.dart';
import '../../core/format/formats.dart';
import '../../core/utils/dates.dart';
import '../../core/widgets/composants.dart';
import '../../core/widgets/feuille.dart';
import '../../core/widgets/statut_echeance.dart';
import '../../data/providers.dart';
import '../../domain/entities/entities.dart';
import '../../domain/services/proximite.dart';
import 'textes_echeances.dart';

/// Ouvre le détail d'une échéance dans un panneau (UI.md : panneau ivoire,
/// haut arrondi).
Future<void> ouvrirDetailEcheance(BuildContext context, Echeance echeance) =>
    ouvrirFeuille<void>(
      context,
      builder: (_) => _PanneauEcheance(echeance: echeance),
    );

/// Nom affiché du bien d'une échéance (« Tous vos biens » si commune).
String nomBienEcheance(Echeance e, List<Bien> biens) {
  final bienId = e.bienId;
  if (bienId == null) return 'Tous vos biens';
  for (final b in biens) {
    if (b.id == bienId) return b.nom;
  }
  return 'Bien supprimé';
}

class _PanneauEcheance extends ConsumerWidget {
  const _PanneauEcheance({required this.echeance});
  final Echeance echeance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.couleurs;
    final t = context.textes;
    final aujourdhui = ref.watch(aujourdhuiProvider);
    final biens = ref.watch(biensFluxProvider).value ?? const <Bien>[];
    final rappels = ref.watch(rappelsEcheanceProvider(echeance.id)).value;
    final proximite = Proximite.depuisDate(
      echeance.date,
      aujourdhui: aujourdhui,
    );
    final explication = explicationEcheance(echeance.type);
    final recurrence = texteRecurrence(echeance.intervalleMois);
    final texteDesRappels = rappels == null
        ? null
        : texteRappels([for (final r in rappels) r.joursAvant]);
    final dateInitiale = echeance.dateInitiale;
    final notes = echeance.notes;
    final estRevision =
        echeance.type == TypeEcheance.revisionLoyer && echeance.bienId != null;

    Widget info(IconData icone, String texte) => Padding(
      padding: const EdgeInsets.only(top: AppSpacing.s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icone, size: AppSizes.iconePetite, color: c.textSecondary),
          const SizedBox(width: AppSpacing.blocSerre),
          Expanded(child: Text(texte, style: t.body)),
        ],
      ),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.ecran,
        0,
        AppSpacing.ecran,
        AppSpacing.ecran,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            nomBienEcheance(echeance, biens).toUpperCase(),
            style: t.overline,
          ),
          const SizedBox(height: AppSpacing.xs),
          Semantics(
            header: true,
            child: Text(echeance.titre, style: t.headline),
          ),
          const SizedBox(height: AppSpacing.bloc),
          Row(
            children: [
              TuileDate(date: echeance.date, proximite: proximite),
              const SizedBox(width: AppSpacing.bloc),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Formats.dateLongue(echeance.date), style: t.rowTitle),
                    const SizedBox(height: AppSpacing.xxs),
                    PastilleStatut(
                      texte: textePastille(
                        echeance.date,
                        aujourdhui: aujourdhui,
                        dense: false,
                      ),
                      proximite: proximite,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.bloc),
          if (recurrence != null) info(AppIcons.echeance, recurrence),
          if (texteDesRappels != null) info(AppIcons.rappel, texteDesRappels),
          if (dateInitiale != null)
            info(
              AppIcons.calendrier,
              'Reportée (date prévue à l\'origine : '
              '${Formats.date(dateInitiale)})',
            ),
          if (notes != null && notes.trim().isNotEmpty)
            info(AppIcons.document, notes.trim()),
          if (explication != null) ...[
            const SizedBox(height: AppSpacing.section),
            Note(texte: explication),
          ],
          const SizedBox(height: AppSpacing.sectionLarge),
          if (estRevision) ...[
            FilledButton(
              onPressed: () => _calculerRevision(context),
              child: const Text('Calculer la révision'),
            ),
            const SizedBox(height: AppSpacing.blocSerre),
            OutlinedButton(
              onPressed: () => _marquerFaite(context, ref),
              child: const Text('Marquer comme faite'),
            ),
          ] else
            FilledButton(
              onPressed: () => _marquerFaite(context, ref),
              child: const Text('Marquer comme faite'),
            ),
          const SizedBox(height: AppSpacing.blocSerre),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _reporter(context, ref),
                  icon: const Icon(AppIcons.calendrier),
                  label: const Text('Reporter'),
                ),
              ),
              const SizedBox(width: AppSpacing.blocSerre),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _modifier(context),
                  icon: const Icon(AppIcons.modifier),
                  label: const Text('Modifier'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _calculerRevision(BuildContext context) {
    final routeur = GoRouter.of(context);
    Navigator.of(context).pop();
    routeur.push(Routes.revision(echeance.bienId!));
  }

  void _modifier(BuildContext context) {
    final routeur = GoRouter.of(context);
    Navigator.of(context).pop();
    routeur.push(Routes.modifierEcheance(echeance.id));
  }

  Future<void> _marquerFaite(BuildContext context, WidgetRef ref) async {
    final messager = ScaffoldMessenger.of(context);
    final gestion = ref.read(gestionEcheancesProvider);
    Navigator.of(context).pop();

    final suivante = await gestion.marquerFaite(echeance);
    final message = suivante == null
        ? '« ${echeance.titre} » est marquée comme faite.'
        : '« ${echeance.titre} » est faite. Prochaine le '
              '${Formats.date(suivante.date)}.';
    messager.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'Annuler',
          onPressed: () =>
              gestion.annulerFaite(originale: echeance, suivante: suivante),
        ),
      ),
    );
  }

  Future<void> _reporter(BuildContext context, WidgetRef ref) async {
    final messager = ScaffoldMessenger.of(context);
    final navigateur = Navigator.of(context);
    final gestion = ref.read(gestionEcheancesProvider);
    final aujourdhui = ref.read(aujourdhuiProvider);
    final initiale = echeance.date.isBefore(aujourdhui)
        ? aujourdhui
        : echeance.date;

    final date = await showDatePicker(
      context: context,
      helpText: 'Reporter au',
      initialDate: initiale,
      firstDate: aujourdhui,
      lastDate: Dates.ajouterMois(aujourdhui, 60),
      confirmText: 'Reporter à cette date',
      cancelText: 'Annuler',
      fieldLabelText: 'Date (JJ/MM/AAAA)',
      errorFormatText: 'Format attendu : JJ/MM/AAAA',
      errorInvalidText: 'Date hors des limites possibles',
    );
    if (date == null) return;
    navigateur.pop();
    final reportee = await gestion.reporter(echeance, date);
    messager.showSnackBar(
      SnackBar(
        content: Text('Échéance reportée au ${Formats.date(reportee.date)}.'),
      ),
    );
  }
}
