import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/design/design.dart';
import '../../app/routes.dart';
import '../../core/widgets/composants.dart';
import '../../core/widgets/feuille.dart';
import '../../data/providers.dart';
import '../../domain/entities/entities.dart';
import '../../domain/services/acces_biens.dart';

/// Annonce la fin de l'abonnement Premium (affichée une fois, sur
/// l'accueil) : ce qui reste accessible, le bien qui reste actif, et
/// l'assurance que rien n'a été supprimé.
Future<void> ouvrirMessageFinAbonnement(BuildContext context) =>
    ouvrirFeuille<void>(context, builder: (_) => const _MessageFinAbonnement());

/// Textes du message, selon les biens (le bien actif est le plus ancien).
class TextesFinAbonnement {
  TextesFinAbonnement(List<Bien> biens) {
    final actifs = AccesBiens.actifs(biens, Droits.gratuit);
    bienActif = biens.where((b) => actifs.contains(b.id)).firstOrNull?.nom;
    // Les biens vendus ou retirés ne passent pas « en lecture seule » du
    // fait de l'abonnement : ils l'étaient déjà.
    autres = biens.where((b) => b.enLocation).length - actifs.length;
  }

  late final String? bienActif;
  late final int autres;

  String? get texteBienActif => bienActif == null
      ? null
      : '« $bienActif » reste votre bien actif : vous pouvez le modifier '
            'comme avant.';

  String? get texteAutresBiens => switch (autres) {
    0 => null,
    1 =>
      'Votre autre bien reste consultable, en lecture seule. Ses échéances '
          'restent affichées, mais ne sont plus rappelées par une '
          'notification.',
    _ =>
      'Vos $autres autres biens restent consultables, en lecture seule. '
          'Leurs échéances restent affichées, mais ne sont plus rappelées '
          'par une notification.',
  };
}

class _MessageFinAbonnement extends ConsumerWidget {
  const _MessageFinAbonnement();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.textes;
    final textes = TextesFinAbonnement(
      ref.watch(biensFluxProvider).value ?? const [],
    );

    Widget paragraphe(IconData icone, String texte) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.bloc),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icone,
            size: AppSizes.iconePetite,
            color: context.couleurs.textSecondary,
          ),
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
          Semantics(
            header: true,
            child: Text(
              'Votre abonnement Premium a pris fin',
              style: t.headline,
            ),
          ),
          const SizedBox(height: AppSpacing.bloc),
          const Note(
            icone: AppIcons.confidentialite,
            texte:
                "Rien n'a été supprimé : toutes vos données restent sur ce "
                'téléphone.',
          ),
          const SizedBox(height: AppSpacing.section),
          if (textes.texteBienActif case final texte?)
            paragraphe(AppIcons.biens, texte),
          if (textes.texteAutresBiens case final texte?)
            paragraphe(AppIcons.verrou, texte),
          paragraphe(
            AppIcons.echeance,
            "Toujours gratuit : les échéances de votre bien actif et leurs "
            'rappels, le contrôle du DPE (logements F et G) et le calcul de '
            'la révision du loyer.',
          ),
          paragraphe(
            AppIcons.document,
            'Les courriers déjà produits, la rentabilité et le carnet '
            "d'artisans déjà saisis restent consultables.",
          ),
          const SizedBox(height: AppSpacing.s),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Continuer en version gratuite'),
          ),
          const SizedBox(height: AppSpacing.blocSerre),
          TextButton(
            onPressed: () {
              final routeur = GoRouter.of(context);
              Navigator.of(context).pop();
              routeur.push(Routes.premium);
            },
            child: const Text('Découvrir Pense-Bail Premium'),
          ),
        ],
      ),
    );
  }
}
