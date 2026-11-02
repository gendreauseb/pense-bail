import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/design/design.dart';
import '../../../app/etat_app.dart';
import '../../../app/routes.dart';
import '../../../core/format/formats.dart';
import '../../../core/services/contact.dart';
import '../../../core/widgets/composants.dart';
import '../../../core/widgets/listes.dart';
import '../../../data/providers.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/services/calculateur_bail.dart';
import '../../premium/premium_page.dart';

class OngletBail extends ConsumerWidget {
  const OngletBail({super.key, required this.bien});
  final Bien bien;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bail = ref.watch(bailActifFluxProvider(bien.id));
    return switch (bail) {
      AsyncData(value: final b?) => _AvecBail(
        bien: bien,
        bail: b,
        verrouille: ref.watch(bienVerrouilleProvider(bien.id)),
      ),
      AsyncData() => _SansBail(
        bien: bien,
        verrouille: ref.watch(bienVerrouilleProvider(bien.id)),
      ),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}

/// État vide : invitation à renseigner le bail.
class _SansBail extends StatelessWidget {
  const _SansBail({required this.bien, required this.verrouille});
  final Bien bien;
  final bool verrouille;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      if (verrouille)
        const EtatVide(
          icone: AppIcons.bail,
          texte: 'Aucun bail renseigné pour ce bien.',
        )
      else ...[
        const Note(
          icone: AppIcons.bail,
          texte:
              'Renseignez le bail pour activer les rappels : révision du '
              'loyer, fin du bail, date limite pour donner congé.',
        ),
        const SizedBox(height: AppSpacing.bloc),
        FilledButton(
          onPressed: () => context.push(Routes.bail(bien.id)),
          child: const Text('Ajouter les informations du bail'),
        ),
      ],
    ],
  );
}

class _AvecBail extends ConsumerWidget {
  const _AvecBail({
    required this.bien,
    required this.bail,
    required this.verrouille,
  });
  final Bien bien;
  final Bail bail;

  /// Lecture seule : ni ajout de locataire ni modification du bail.
  final bool verrouille;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aujourdhui = ref.watch(aujourdhuiProvider);
    final locataires =
        ref.watch(locatairesFluxProvider(bail.id)).value ?? const [];
    final regle = bail.regle;
    final duree = bail.dureeEffectiveMois;
    final fin = CalculateurBail.finPeriodeEnCours(bail, aujourdhui);
    final depot = bail.depotGarantieCentimes;
    final dateRevision = bail.dateRevision;
    final trimestre = bail.irlTrimestre;
    final revisions =
        ref.watch(historiqueRevisionsFluxProvider(bien.id)).value ?? const [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EnTeteSection(
          titre: locataires.length > 1 ? 'Locataires' : 'Locataire',
        ),
        if (locataires.isNotEmpty) ...[
          CarteListe(
            enfants: [
              for (final l in locataires)
                _LigneLocataire(
                  bienId: bien.id,
                  locataire: l,
                  modifiable: !verrouille,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.bloc),
        ],
        if (!verrouille)
          BoutonPointille(
            libelle: locataires.isEmpty
                ? 'Ajouter le locataire'
                : 'Ajouter un colocataire',
            onPressed: () => context.push(Routes.locataire(bien.id)),
          )
        else if (locataires.isEmpty)
          const EtatVide(
            icone: AppIcons.locataire,
            texte: 'Aucun locataire renseigné.',
          ),
        const SizedBox(height: AppSpacing.sectionLarge),
        if (verrouille)
          const EnTeteSection(titre: 'Bail')
        else
          EnTeteSection(
            titre: 'Bail',
            action: 'Modifier',
            onAction: () => context.push(Routes.bail(bien.id)),
          ),
        CarteListe(
          enfants: [
            LigneInfo(libelle: 'Type de bail', valeur: bail.typeBail.libelle),
            LigneInfo(
              libelle: 'Début du bail',
              valeur: Formats.date(bail.dateDebut),
            ),
            LigneInfo(
              libelle: 'Durée',
              valeur: duree == null
                  ? 'Non renseignée'
                  : '$duree mois${bail.dureeMois == null ? ' (durée légale)' : ''}',
            ),
            if (fin != null)
              LigneInfo(
                libelle: regle.reconductionTacite
                    ? 'Fin de la période en cours'
                    : 'Fin du bail',
                valeur: Formats.date(fin),
              ),
            LigneInfo(
              libelle: 'Dépôt de garantie',
              valeur: depot == null ? 'Non renseigné' : Formats.montant(depot),
            ),
          ],
        ),
        if (regle.noteUtilisateur case final note?) ...[
          const SizedBox(height: AppSpacing.bloc),
          Note(icone: AppIcons.attention, texte: 'À vérifier : $note'),
        ],
        if (regle.revisionIrlAutorisee) ...[
          const SizedBox(height: AppSpacing.sectionLarge),
          const EnTeteSection(titre: 'Révision du loyer'),
          CarteListe(
            enfants: [
              LigneInfo(
                libelle: 'Prévue au bail',
                valeur: switch (bail.clauseRevision) {
                  true => 'Oui',
                  false => 'Non',
                  null => 'À vérifier',
                },
              ),
              if (bail.revisionPrevue) ...[
                LigneInfo(
                  libelle: 'Date de révision',
                  valeur: dateRevision == null
                      ? 'Date anniversaire (${_jourMois(bail.dateDebut)})'
                      : 'Chaque ${_jourMois(dateRevision)}',
                ),
                LigneInfo(
                  libelle: 'IRL de référence',
                  valeur: bail.irlReferenceComplet
                      ? '${Formats.trimestre(trimestre!, bail.irlAnnee)} : '
                            '${Formats.decimal(bail.irlValeur!)}'
                      : 'À renseigner',
                ),
              ],
            ],
          ),
          if (bail.clauseRevision == false) ...[
            const SizedBox(height: AppSpacing.bloc),
            const Note(
              texte:
                  'Sans clause de révision, le loyer ne peut pas être révisé '
                  'en cours de bail : Pense-Bail ne vous le rappelle pas.',
            ),
          ] else if (!bail.irlReferenceComplet && !verrouille) ...[
            const SizedBox(height: AppSpacing.bloc),
            BanniereInformation(
              texte:
                  'Indiquez l\'IRL de référence de votre bail pour calculer '
                  'la révision.',
              action: 'Compléter',
              onAction: () => context.push(Routes.bail(bien.id)),
            ),
          ],
        ],
        if (revisions.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sectionLarge),
          const EnTeteSection(titre: 'Révisions passées'),
          CarteListe(
            enfants: [for (final r in revisions) _LigneRevision(revision: r)],
          ),
        ],
      ],
    );
  }

  static String _jourMois(DateTime d) {
    final mois = Formats.nomMois(d.month);
    return '${d.day == 1 ? '1er' : d.day} $mois';
  }
}

class _LigneLocataire extends StatelessWidget {
  const _LigneLocataire({
    required this.bienId,
    required this.locataire,
    required this.modifiable,
  });
  final String bienId;
  final Locataire locataire;

  /// Faux en lecture seule : la ligne n'ouvre pas le formulaire (appeler et
  /// écrire restent possibles).
  final bool modifiable;

  @override
  Widget build(BuildContext context) {
    final t = context.textes;
    final telephone = locataire.telephone;
    final email = locataire.email;
    final coordonnees = [?telephone, ?email].join('\n');

    final onTap = modifiable
        ? () => context.push(
            Routes.avec(Routes.locataire(bienId), {'locataire': locataire.id}),
          )
        : null;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.ligne,
          AppSpacing.ligne,
          AppSpacing.xs,
          AppSpacing.ligne,
        ),
        child: Row(
          children: [
            Expanded(
              // Appeler et écrire restent accessibles séparément.
              child: SemantiqueLigne(
                libelle: [
                  locataire.nomComplet,
                  if (coordonnees.isEmpty) 'coordonnées à compléter',
                  ?telephone,
                  ?email,
                ].join(', '),
                onTap: onTap,
                child: Row(
                  children: [
                    const TuileIcone(icone: AppIcons.locataire),
                    const SizedBox(width: AppSpacing.bloc),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(locataire.nomComplet, style: t.rowTitle),
                          Text(
                            coordonnees.isEmpty
                                ? 'Coordonnées à compléter'
                                : coordonnees,
                            style: t.secondary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (telephone != null)
              IconButton(
                icon: const Icon(AppIcons.appeler),
                tooltip: 'Appeler ${locataire.nomComplet}',
                color: context.couleurs.primary,
                onPressed: () => Contact.appeler(context, telephone),
              ),
            if (email != null)
              IconButton(
                icon: const Icon(AppIcons.ecrire),
                tooltip: 'Écrire à ${locataire.nomComplet}',
                color: context.couleurs.primary,
                onPressed: () => Contact.ecrire(context, email),
              ),
          ],
        ),
      ),
    );
  }
}

/// Révision passée : date, ancien et nouveau loyer ; ouvre le courrier.
/// En version gratuite, seuls les courriers déjà produits s'ouvrent ; les
/// autres mènent à la présentation de Premium.
class _LigneRevision extends ConsumerWidget {
  const _LigneRevision({required this.revision});
  final RevisionLoyer revision;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.textes;
    final r = revision;
    final courrier =
        r.courrierInclus ||
        ref.watch(
          fonctionnaliteDisponibleProvider(Fonctionnalite.courrierRevision),
        );
    final titre = 'Révision du ${Formats.date(r.dateEffet)}';
    final detail =
        '${Formats.montant(r.ancienLoyerCentimes)} → '
        '${Formats.parMois(r.nouveauLoyerCentimes)}';
    return Semantics(
      container: true,
      button: true,
      label:
          '$titre, loyer passé de ${Formats.montant(r.ancienLoyerCentimes)} '
          'à ${Formats.parMois(r.nouveauLoyerCentimes)}. '
          '${courrier ? 'Voir le courrier' : 'Courrier inclus dans Pense-Bail Premium'}',
      excludeSemantics: true,
      child: InkWell(
        onTap: courrier
            ? () => context.push(Routes.courrierRevision(r.id))
            : () => ouvrirPremium(context),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.ligne),
          child: Row(
            children: [
              const TuileIcone(icone: AppIcons.historique),
              const SizedBox(width: AppSpacing.bloc),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titre, style: t.rowTitle),
                    Text(detail, style: t.secondary),
                  ],
                ),
              ),
              Icon(
                courrier ? AppIcons.document : AppIcons.verrou,
                color: context.couleurs.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
