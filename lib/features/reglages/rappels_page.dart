import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/design/design.dart';
import '../../core/config/config_app.dart';
import '../../core/widgets/composants.dart';
import '../../core/widgets/listes.dart';
import '../../data/providers.dart';
import '../../domain/entities/entities.dart';
import '../echeances/textes_echeances.dart';

/// Les notifications sont-elles autorisées sur le téléphone ?
final notificationsAutoriseesProvider = FutureProvider.autoDispose<bool>(
  (ref) => ref.watch(serviceNotificationsProvider).sontAutorisees(),
);

/// Réglages des rappels : délais par défaut et types notifiés. Chaque
/// changement est enregistré immédiatement.
class RappelsPage extends ConsumerWidget {
  const RappelsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.textes;
    final preferences = ref.watch(preferencesRappelsProvider).value;
    final autorisees = ref.watch(notificationsAutoriseesProvider).value;
    final gestion = ref.read(gestionPreferencesRappelsProvider);

    Future<void> enregistrer(PreferencesRappels p) => gestion.enregistrer(p);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(AppIcons.retour),
          tooltip: 'Retour',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: preferences == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.ecran,
                AppSpacing.s,
                AppSpacing.ecran,
                AppSpacing.ecran,
              ),
              children: [
                Text('RÉGLAGES', style: t.overline),
                const SizedBox(height: AppSpacing.xs),
                Semantics(
                  header: true,
                  child: Text('Rappels', style: t.headline),
                ),
                const SizedBox(height: AppSpacing.sectionLarge),
                if (autorisees == false) ...[
                  const Note(
                    icone: AppIcons.notificationsCoupees,
                    texte:
                        'Les notifications sont bloquées sur ce téléphone : '
                        'vous ne recevrez aucun rappel. Si rien ne s\'affiche '
                        'en touchant le bouton, autorisez-les dans les '
                        'réglages du téléphone.',
                  ),
                  const SizedBox(height: AppSpacing.bloc),
                  OutlinedButton(
                    onPressed: () async {
                      await ref
                          .read(serviceNotificationsProvider)
                          .demanderAutorisation();
                      ref.invalidate(notificationsAutoriseesProvider);
                    },
                    child: const Text('Autoriser les notifications'),
                  ),
                  const SizedBox(height: AppSpacing.sectionLarge),
                ],
                const TitreSection('Rappels des nouvelles échéances'),
                Text(
                  'Délais proposés par défaut pour chaque nouvelle échéance. '
                  'Vous pouvez toujours les changer échéance par échéance. '
                  'Les rappels arrivent vers ${ConfigApp.heureRappel} h.',
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
                        active: preferences.delaisParDefaut.contains(jours),
                        onTap: () {
                          final delais = {...preferences.delaisParDefaut};
                          if (!delais.remove(jours)) delais.add(jours);
                          enregistrer(
                            preferences.copyWith(
                              delaisParDefaut: delais.toList()
                                ..sort((a, b) => b.compareTo(a)),
                            ),
                          );
                        },
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () => _appliquerPartout(
                      context,
                      ref,
                      preferences.delaisParDefaut,
                    ),
                    child: const Text('Appliquer à toutes les échéances'),
                  ),
                ),
                const SizedBox(height: AppSpacing.sectionLarge),
                const TitreSection('Me prévenir pour'),
                Text(
                  'Les échéances désactivées restent affichées dans '
                  'l\'application, sans notification.',
                  style: t.secondary,
                ),
                const SizedBox(height: AppSpacing.bloc),
                CarteListe(
                  enfants: [
                    for (final type in TypeEcheance.values)
                      SwitchListTile(
                        title: Text(type.libelle, style: t.rowTitle),
                        value: preferences.notifie(type),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.ligne,
                        ),
                        onChanged: (actif) {
                          final types = {...preferences.typesDesactives};
                          actif ? types.remove(type) : types.add(type);
                          enregistrer(
                            preferences.copyWith(typesDesactives: types),
                          );
                        },
                      ),
                  ],
                ),
              ],
            ),
    );
  }

  Future<void> _appliquerPartout(
    BuildContext context,
    WidgetRef ref,
    List<int> delais,
  ) async {
    final texteDelais = delais.isEmpty
        ? 'aucun rappel'
        : delais.map(texteDelaiRappel).join(', ').toLowerCase();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Appliquer à toutes les échéances ?'),
        content: Text(
          'Les rappels de toutes les échéances à venir seront remplacés par : '
          '$texteDelais. Les réglages faits échéance par échéance seront '
          'perdus.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remplacer les rappels'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final messager = ScaffoldMessenger.of(context);
    final nombre = await ref
        .read(gestionPreferencesRappelsProvider)
        .appliquerAuxEcheancesAFaire(delais);
    messager.showSnackBar(
      SnackBar(
        content: Text(
          nombre > 1
              ? 'Rappels mis à jour pour $nombre échéances.'
              : 'Rappels mis à jour.',
        ),
      ),
    );
  }
}
