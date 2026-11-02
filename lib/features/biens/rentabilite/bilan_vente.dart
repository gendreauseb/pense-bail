import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/design/design.dart';
import '../../../app/routes.dart';
import '../../../core/format/formats.dart';
import '../../../core/widgets/composants.dart';
import '../../../core/widgets/listes.dart';
import '../../../data/providers.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/services/rentabilite.dart';

/// Bilan de la vente (Premium) : plus-value brute, puis loyers encaissés et
/// dépenses saisies depuis l'ajout du bien (decisions.md).
class BilanVenteCarte extends ConsumerWidget {
  const BilanVenteCarte({super.key, required this.bien});
  final Bien bien;

  static String _signe(int centimes) => centimes == 0
      ? Formats.montant(0)
      : '${centimes < 0 ? '−' : '+'}${Formats.montant(centimes.abs())}';

  static String _moins(int centimes) => '−${Formats.montant(centimes)}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.textes;
    final bilan = Rentabilite.bilanVente(
      bien: bien,
      encaissements:
          ref.watch(encaissementsBienFluxProvider(bien.id)).value ?? const [],
      mouvements:
          ref.watch(mouvementsBienFluxProvider(bien.id)).value ?? const [],
      revisions:
          ref.watch(historiqueRevisionsFluxProvider(bien.id)).value ?? const [],
    );
    final modifier = OutlinedButton.icon(
      onPressed: () => context.push(Routes.vente(bien.id)),
      icon: const Icon(AppIcons.modifier),
      label: const Text('Modifier la vente'),
    );

    if (bilan == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TitreSection('Bilan de la vente'),
          Note(
            texte: bien.prixVenteCentimes == null
                ? 'Indiquez le prix de vente pour voir le bilan de la vente.'
                : "Le prix d'achat n'a pas été renseigné. Pour le saisir, "
                      'annulez la vente le temps de compléter les chiffres '
                      'de rentabilité, puis déclarez-la de nouveau.',
          ),
          const SizedBox(height: AppSpacing.bloc),
          modifier,
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const TitreSection('Bilan de la vente'),
        CarteListe(
          enfants: [
            LigneInfo(
              libelle: 'Prix de vente',
              valeur: Formats.montant(bilan.prixVente),
            ),
            if (bilan.fraisVente > 0)
              LigneInfo(
                libelle: 'Frais de vente',
                valeur: _moins(bilan.fraisVente),
              ),
            LigneInfo(
              libelle: 'Achat et frais de notaire',
              valeur: _moins(bilan.coutAchat),
            ),
            if (bilan.travauxInitiaux > 0)
              LigneInfo(
                libelle: 'Travaux avant la première location',
                valeur: _moins(bilan.travauxInitiaux),
              ),
            LigneInfo(
              libelle: 'Plus-value brute',
              valeur: _signe(bilan.plusValueBrute),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.bloc),
        CarteListe(
          enfants: [
            LigneInfo(
              libelle: 'Loyers encaissés',
              valeur: _signe(bilan.loyersEncaisses),
            ),
            if (bilan.autresRecettes > 0)
              LigneInfo(
                libelle: 'Autres recettes',
                valeur: _signe(bilan.autresRecettes),
              ),
            if (bilan.travauxJournal > 0)
              LigneInfo(
                libelle: "Travaux depuis l'achat",
                valeur: _moins(bilan.travauxJournal),
              ),
            if (bilan.autresDepenses > 0)
              LigneInfo(
                libelle: 'Autres dépenses (hors crédit)',
                valeur: _moins(bilan.autresDepenses),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.bloc),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.carte),
            child: Semantics(
              container: true,
              label: 'Bilan de la vente : ${_signe(bilan.resultat)}',
              excludeSemantics: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bilan de la vente', style: t.secondary),
                  Text(_signe(bilan.resultat), style: t.figure),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.bloc),
        const Note(
          texte:
              "Hors impôt sur la plus-value et hors crédit. Seul ce que vous "
              'avez saisi est compté : cases « Loyer reçu » et journal, pas '
              'les charges estimées de la fiche.',
        ),
        const SizedBox(height: AppSpacing.bloc),
        modifier,
      ],
    );
  }
}
