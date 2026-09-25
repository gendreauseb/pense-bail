import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/design/design.dart';
import '../../../app/etat_app.dart';
import '../../../core/config/config_app.dart';
import '../../../core/widgets/composants.dart';
import '../../../core/widgets/listes.dart';
import '../../../data/providers.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/services/proximite.dart';
import '../../echeances/detail_echeance.dart';
import '../accueil_providers.dart';

/// Bouton cloche de l'en-tête, avec le nombre d'échéances urgentes.
class BoutonNotifications extends ConsumerWidget {
  const BoutonNotifications({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.couleurs;
    final urgentes = ref.watch(nombreUrgentesProvider);
    return IconButton(
      tooltip: urgentes == 0
          ? 'Notifications'
          : 'Notifications, $urgentes ${urgentes > 1 ? 'échéances urgentes' : 'échéance urgente'}',
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        // Au-dessus de la barre de navigation et du bouton « + ».
        useRootNavigator: true,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => const _PanneauNotifications(),
      ),
      style: IconButton.styleFrom(
        backgroundColor: c.surface,
        side: BorderSide(color: c.border),
      ),
      icon: Badge(
        isLabelVisible: urgentes > 0,
        backgroundColor: c.notification,
        textColor: c.onPrimary,
        label: Text('$urgentes'),
        child: const Icon(AppIcons.notifications),
      ),
    );
  }
}

class _PanneauNotifications extends ConsumerWidget {
  const _PanneauNotifications();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.textes;
    final c = context.couleurs;
    final aujourdhui = ref.watch(aujourdhuiProvider);
    final autorisees = ref.watch(notificationsAutoriseesProvider).value;
    final biens = ref.watch(biensFluxProvider).value ?? const <Bien>[];
    final urgentes = [
      for (final e in ref.watch(echeancesAFaireFluxProvider).value ?? const [])
        if (Proximite.depuisDate(e.date, aujourdhui: aujourdhui) ==
            Proximite.urgent)
          e,
    ];

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
          const TitreSection('Notifications'),
          if (autorisees == false)
            BanniereInformation(
              texte: 'Les rappels sont désactivés sur ce téléphone.',
              action: 'Activer',
              onAction: () => _activer(context, ref),
            )
          else if (autorisees == true)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  AppIcons.rappel,
                  size: AppSizes.iconePetite,
                  color: c.primary,
                ),
                const SizedBox(width: AppSpacing.blocSerre),
                Expanded(
                  child: Text(
                    'Rappels activés : une notification arrive à '
                    '${ConfigApp.heureRappel} h, aux dates choisies pour '
                    'chaque échéance.',
                    style: t.secondary,
                  ),
                ),
              ],
            ),
          const SizedBox(height: AppSpacing.section),
          Text('À TRAITER DANS LES 7 JOURS', style: t.overline),
          const SizedBox(height: AppSpacing.s),
          if (urgentes.isEmpty)
            const EtatVide(
              icone: AppIcons.selectionne,
              texte: 'Rien d\'urgent pour le moment.',
            )
          else
            CarteListe(
              enfants: [
                for (final e in urgentes)
                  LigneEcheance(
                    echeance: e,
                    sousTitre: nomBienEcheance(e, biens),
                    aujourdhui: aujourdhui,
                    onTap: () {
                      // Le contexte du panneau disparaît à sa fermeture :
                      // on ouvre le détail depuis celui du navigateur.
                      final navigateur = Navigator.of(context);
                      navigateur.pop();
                      ouvrirDetailEcheance(navigateur.context, e);
                    },
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _activer(BuildContext context, WidgetRef ref) async {
    final messager = ScaffoldMessenger.of(context);
    final accordee = await ref
        .read(serviceNotificationsProvider)
        .demanderAutorisation();
    ref.invalidate(notificationsAutoriseesProvider);
    if (!accordee) {
      messager.showSnackBar(
        const SnackBar(
          content: Text(
            'Autorisez les notifications de Pense-Bail dans les réglages '
            'de votre téléphone.',
          ),
        ),
      );
    }
  }
}
