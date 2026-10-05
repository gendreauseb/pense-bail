import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/design/design.dart';
import '../../app/routes.dart';
import '../../core/widgets/composants.dart';
import '../../core/widgets/listes.dart';
import '../../data/providers.dart';
import '../../domain/entities/entities.dart';
import '../echeances/textes_echeances.dart';
import '../premium/premium_page.dart';
import 'actions_donnees.dart';

/// Onglet « Réglages » : profil, rappels, biens, données, mentions légales.
class ReglagesPage extends ConsumerWidget {
  const ReglagesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.textes;
    final bailleur = ref.watch(bailleurFluxProvider).value;
    final biens = ref.watch(biensFluxProvider).value ?? const <Bien>[];
    final preferences = ref.watch(preferencesRappelsProvider).value;
    final estBeta = ref.watch(estBetaProvider);

    Widget section(String titre, List<Widget> contenu) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sectionLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(titre.toUpperCase(), style: t.overline),
          const SizedBox(height: AppSpacing.s),
          ...contenu,
        ],
      ),
    );

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.ecran,
            AppSpacing.section,
            AppSpacing.ecran,
            AppSpacing.tresGrand + AppSizes.boutonCentralSurelevation,
          ),
          children: [
            Semantics(header: true, child: Text('Réglages', style: t.headline)),
            const SizedBox(height: AppSpacing.section),
            if (estBeta)
              section('Mode bêta', [
                Text(
                  "Réservé aux testeurs. Passez d'une version à l'autre pour "
                  'voir les différences : aucun achat, aucune donnée '
                  'supprimée.',
                  style: t.secondary,
                ),
                const SizedBox(height: AppSpacing.bloc),
                CarteListe(
                  enfants: [
                    const _InterrupteurPremium(),
                    LigneNavigation(
                      icone: AppIcons.verrou,
                      titre: "Simuler la fin de l'abonnement",
                      sousTitre:
                          'Repasse en version gratuite et affiche le message '
                          'prévu pour les abonnés',
                      onTap: () async {
                        final routeur = GoRouter.of(context);
                        await ref
                            .read(droitsBetaProvider)
                            .simulerFinAbonnement();
                        routeur.go(Routes.accueil);
                      },
                    ),
                  ],
                ),
              ]),
            section('Profil', [
              CarteListe(
                enfants: [
                  LigneNavigation(
                    icone: AppIcons.personne,
                    titre: bailleur?.nomComplet ?? 'Mon profil',
                    sousTitre: bailleur?.adresseComplete,
                    onTap: () => context.push(Routes.profil),
                  ),
                ],
              ),
            ]),
            section('Rappels', [
              CarteListe(
                enfants: [
                  LigneNavigation(
                    icone: AppIcons.rappel,
                    titre: 'Rappels et notifications',
                    sousTitre: preferences == null
                        ? null
                        : _resumeRappels(preferences),
                    onTap: () => context.push(Routes.reglagesRappels),
                  ),
                ],
              ),
            ]),
            section('Mes biens', [
              if (biens.isNotEmpty) ...[
                CarteListe(
                  enfants: [
                    for (final bien in biens)
                      LigneNavigation(
                        icone: AppIcons.typeLogement(bien.typeLogement),
                        titre: bien.nom,
                        sousTitre: ref.watch(bienVerrouilleProvider(bien.id))
                            ? '${bien.typeLocation.libelle}, lecture seule'
                            : bien.typeLocation.libelle,
                        onTap: () => context.push(Routes.ficheBien(bien.id)),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s),
                Text(
                  'Pour modifier ou supprimer un bien, ouvrez sa fiche.',
                  style: t.caption,
                ),
                const SizedBox(height: AppSpacing.bloc),
              ],
              BoutonPointille(
                libelle: 'Ajouter un bien',
                onPressed: () => ouvrirAjoutBien(context, ref),
              ),
            ]),
            section('Mes données', [
              CarteListe(
                enfants: [
                  LigneNavigation(
                    icone: AppIcons.enregistrer,
                    titre: 'Sauvegarder mes données',
                    sousTitre:
                        'Un fichier à garder en lieu sûr, pour changer de '
                        'téléphone ou en cas de perte',
                    onTap: () => sauvegarderDonnees(context, ref),
                  ),
                  LigneNavigation(
                    icone: AppIcons.actualiser,
                    titre: 'Restaurer une sauvegarde',
                    sousTitre: 'Remplace les données actuelles',
                    onTap: () => restaurerDonnees(context, ref),
                  ),
                  LigneNavigation(
                    icone: AppIcons.supprimer,
                    titre: 'Tout effacer',
                    sousTitre: 'Supprime toutes les données de ce téléphone',
                    onTap: () => effacerDonnees(context, ref),
                  ),
                ],
              ),
            ]),
            section('À propos', [
              CarteListe(
                enfants: [
                  LigneNavigation(
                    icone: AppIcons.confidentialite,
                    titre: 'Mentions légales et confidentialité',
                    sousTitre: 'Vos données restent sur votre téléphone',
                    onTap: () => context.push(Routes.mentionsLegales),
                  ),
                ],
              ),
            ]),
          ],
        ),
      ),
    );
  }

  /// « 30 j, 7 j et 1 j avant » (+ « 2 types sans notification »).
  static String _resumeRappels(PreferencesRappels p) {
    final delais = p.delaisParDefaut;
    final texte = delais.isEmpty
        ? 'Aucun rappel par défaut'
        : delais.length == 1
        ? texteDelaiRappel(delais.single)
        : '${delais.take(delais.length - 1).map((j) => j == 0 ? 'le jour même' : '$j j').join(', ')} '
              'et ${texteDelaiRappel(delais.last).toLowerCase()}';
    final coupes = p.typesDesactives.length;
    return coupes == 0
        ? texte
        : '$texte. $coupes type${coupes > 1 ? 's' : ''} sans notification';
  }
}

/// Bascule gratuit / Premium de la version bêta.
class _InterrupteurPremium extends ConsumerWidget {
  const _InterrupteurPremium();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.textes;
    final droits = ref.watch(droitsProvider).value;
    final premium = droits?.estPremium ?? false;
    return SwitchListTile(
      title: Text('Pense-Bail Premium', style: t.rowTitle),
      subtitle: Text(
        premium
            ? 'Activé : toutes les fonctionnalités'
            : 'Désactivé : version gratuite',
        style: t.secondary,
      ),
      value: premium,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.ligne),
      onChanged: droits == null
          ? null
          : (actif) => ref.read(droitsBetaProvider).definirPremium(actif),
    );
  }
}
