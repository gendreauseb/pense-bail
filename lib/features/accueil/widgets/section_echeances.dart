import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/design/design.dart';
import '../../../app/etat_app.dart';
import '../../../app/routes.dart';
import '../../../core/config/config_app.dart';
import '../../../core/widgets/composants.dart';
import '../../../core/widgets/listes.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/services/tableau_de_bord.dart';
import '../../echeances/detail_echeance.dart';
import '../accueil_providers.dart';

/// « Prochaines échéances » : filtres par bien + liste chronologique.
class SectionEcheances extends ConsumerStatefulWidget {
  const SectionEcheances({super.key, required this.donnees});
  final DonneesAccueil donnees;

  @override
  ConsumerState<SectionEcheances> createState() => _SectionEcheancesState();
}

class _SectionEcheancesState extends ConsumerState<SectionEcheances> {
  bool _toutAfficher = false;

  @override
  Widget build(BuildContext context) {
    final donnees = widget.donnees;
    final filtre = ref.watch(filtreBienProvider);
    final aujourdhui = ref.watch(aujourdhuiProvider);
    final echeances = TableauDeBord.filtrer(donnees.echeances, filtre);
    final visibles = _toutAfficher
        ? echeances
        : echeances.take(ConfigApp.echeancesAccueil).toList();
    final masquees = echeances.length - visibles.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const TitreSection('Prochaines échéances'),
        if (donnees.biens.length > 1) ...[
          _Filtres(biens: donnees.biens, filtre: filtre),
          const SizedBox(height: AppSpacing.bloc),
        ],
        if (echeances.isEmpty)
          const EtatVide(
            icone: AppIcons.echeance,
            texte: 'Aucune échéance à venir.',
          )
        else
          CarteListe(
            enfants: [
              for (final e in visibles)
                LigneEcheance(
                  echeance: e,
                  sousTitre: nomBienEcheance(e, donnees.biens),
                  aujourdhui: aujourdhui,
                  onTap: () => ouvrirDetailEcheance(context, e),
                  onCalculer: _actionDirecte(context, e),
                ),
            ],
          ),
        if (masquees > 0 ||
            _toutAfficher && echeances.length > ConfigApp.echeancesAccueil)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => setState(() => _toutAfficher = !_toutAfficher),
              child: Text(
                _toutAfficher
                    ? 'Afficher moins'
                    : 'Afficher ${masquees > 1 ? 'les $masquees autres' : 'l\'autre'}',
              ),
            ),
          ),
      ],
    );
  }

  /// Révision de loyer : bouton « Calculer » à la place de la pastille.
  VoidCallback? _actionDirecte(BuildContext context, Echeance e) {
    final bienId = e.bienId;
    if (e.type != TypeEcheance.revisionLoyer || bienId == null) return null;
    return () => context.push(Routes.revision(bienId));
  }
}

class _Filtres extends ConsumerWidget {
  const _Filtres({required this.biens, required this.filtre});
  final List<Bien> biens;
  final String? filtre;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(filtreBienProvider.notifier);
    // Défilement horizontal, en débordant jusqu'aux bords de l'écran.
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          PuceFiltre(
            libelle: 'Tous',
            active: filtre == null,
            onTap: () => notifier.choisir(null),
          ),
          for (final bien in biens) ...[
            const SizedBox(width: AppSpacing.s),
            PuceFiltre(
              libelle: bien.nom,
              active: filtre == bien.id,
              onTap: () => notifier.choisir(bien.id),
            ),
          ],
        ],
      ),
    );
  }
}

/// Bannières « Complétez… » (données manquantes uniquement).
class BannieresInvitations extends StatelessWidget {
  const BannieresInvitations({super.key, required this.invitations});
  final List<Invitation> invitations;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (final (i, invitation) in invitations.indexed) ...[
        if (i > 0) const SizedBox(height: AppSpacing.s),
        BanniereInformation(
          texte: switch (invitation.type) {
            TypeInvitation.irlManquant =>
              'Indiquez l\'IRL de référence de ${invitation.bien.nom} pour '
                  'calculer sa révision.',
            TypeInvitation.bailManquant =>
              'Complétez ${invitation.bien.nom} pour activer vos rappels.',
          },
          action: 'Compléter',
          onAction: () => context.push(Routes.ficheBien(invitation.bien.id)),
        ),
      ],
    ],
  );
}
