import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/design/design.dart';
import '../../app/etat_app.dart';
import '../../core/config/cles_reglages.dart';
import '../../core/format/formats.dart';
import '../../core/widgets/composants.dart';
import '../../data/providers.dart';
import '../echeances/detail_echeance.dart';
import '../revision/choix_bien_revision.dart';
import 'accueil_providers.dart';
import 'widgets/carte_synthese.dart';
import 'widgets/cartes_biens.dart';
import 'widgets/panneau_notifications.dart';
import 'widgets/section_echeances.dart';

/// Tableau de bord : « Qu'est-ce que je dois faire bientôt ? »
class AccueilPage extends ConsumerStatefulWidget {
  const AccueilPage({super.key});

  @override
  ConsumerState<AccueilPage> createState() => _AccueilPageState();
}

class _AccueilPageState extends ConsumerState<AccueilPage> {
  late final AppLifecycleListener _cycleDeVie;

  @override
  void initState() {
    super.initState();
    // Nouvelle journée au retour dans l'app : statuts recalculés.
    _cycleDeVie = AppLifecycleListener(
      onResume: () => ref.read(aujourdhuiProvider.notifier).actualiser(),
    );
    // Échéance à ouvrir (toucher d'une notification), y compris au lancement.
    ref.listenManual(echeanceAOuvrirProvider, (_, id) {
      if (id != null) _ouvrirDepuisNotification(id);
    }, fireImmediately: true);
    WidgetsBinding.instance.addPostFrameCallback((_) => _demanderRappels());
  }

  @override
  void dispose() {
    _cycleDeVie.dispose();
    super.dispose();
  }

  /// Demande l'autorisation des notifications une seule fois, à la première
  /// arrivée sur le tableau de bord (les rappels viennent d'être créés).
  Future<void> _demanderRappels() async {
    final reglages = ref.read(reglagesRepositoryProvider);
    if (await reglages.lire(ClesReglages.notificationsDemandees) != null) {
      return;
    }
    await reglages.ecrire(ClesReglages.notificationsDemandees, 'true');
    await ref.read(serviceNotificationsProvider).demanderAutorisation();
    ref.invalidate(notificationsAutoriseesProvider);
  }

  Future<void> _ouvrirDepuisNotification(String id) async {
    ref.read(echeanceAOuvrirProvider.notifier).effacer();
    final echeance = await ref.read(echeanceRepositoryProvider).parId(id);
    if (echeance == null || !mounted) return;
    await ouvrirDetailEcheance(context, echeance);
  }

  @override
  Widget build(BuildContext context) {
    final donnees = ref.watch(donneesAccueilProvider);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: switch (donnees) {
          AsyncData(:final value) => _Contenu(donnees: value),
          AsyncError(:final error) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.ecran),
              child: Text(
                'Impossible d\'afficher le tableau de bord.\n$error',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

class _Contenu extends ConsumerWidget {
  const _Contenu({required this.donnees});
  final DonneesAccueil donnees;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.textes;
    final aujourdhui = ref.watch(aujourdhuiProvider);
    final salutation = donnees.prenom.isEmpty
        ? 'Bonjour'
        : 'Bonjour ${donnees.prenom}';

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.ecran,
        AppSpacing.section,
        AppSpacing.ecran,
        // Place pour le bouton « + » qui dépasse de la barre.
        AppSpacing.tresGrand + AppSizes.boutonCentralSurelevation,
      ),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Formats.jourComplet(aujourdhui),
                    style: t.label.copyWith(
                      color: context.couleurs.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Semantics(
                    header: true,
                    child: Text(salutation, style: t.headline),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.bloc),
            const BoutonNotifications(),
          ],
        ),
        const SizedBox(height: AppSpacing.section),
        CarteSynthese(synthese: donnees.synthese),
        const SizedBox(height: AppSpacing.bloc),
        CarteAction(
          icone: AppIcons.calcul,
          titre: 'Réviser un loyer',
          sousTitre: 'Calculez le nouveau loyer selon l\'IRL',
          onTap: () => ouvrirChoixBienRevision(context),
        ),
        const SizedBox(height: AppSpacing.sectionLarge),
        SectionEcheances(donnees: donnees),
        if (donnees.invitations.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.bloc),
          BannieresInvitations(invitations: donnees.invitations),
        ],
        const SizedBox(height: AppSpacing.sectionLarge),
        const TitreSection('Mes biens'),
        CartesBiens(
          biens: donnees.biens,
          prochaineParBien: donnees.prochaineParBien,
        ),
      ],
    );
  }
}
