// Verrous de la version gratuite : bandeau explicatif, mention « Lecture
// seule » et exécution d'une écriture qui peut être refusée.

import 'package:flutter/material.dart';

import '../../app/design/design.dart';
import '../../domain/entities/entities.dart';
import '../../domain/services/acces_biens.dart';
import 'composants.dart';

/// Bandeau de verrou : cadenas, une phrase qui dit ce que débloque Premium,
/// et le lien vers la présentation de Premium. L'information passe par le
/// texte et l'icône, jamais par la couleur seule.
class BandeauVerrou extends StatelessWidget {
  const BandeauVerrou({
    super.key,
    required this.texte,
    required this.onDecouvrir,
  });

  final String texte;
  final VoidCallback onDecouvrir;

  @override
  Widget build(BuildContext context) {
    final t = context.textes;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.ligne,
          AppSpacing.ligne,
          AppSpacing.ligne,
          AppSpacing.xs,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TuileIcone(icone: AppIcons.verrou),
            const SizedBox(width: AppSpacing.bloc),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    container: true,
                    label: 'Verrouillé. $texte',
                    excludeSemantics: true,
                    child: Text(
                      texte,
                      style: t.body.copyWith(color: context.couleurs.textMuted),
                    ),
                  ),
                  TextButton(
                    onPressed: onDecouvrir,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(
                        AppSizes.zoneTactile,
                        AppSizes.zoneTactile,
                      ),
                    ),
                    child: const Text('Découvrir Pense-Bail Premium'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Écran réservé à Premium, atteint par un lien direct : titre, bandeau de
/// verrou et retour.
class PageVerrouillee extends StatelessWidget {
  const PageVerrouillee({
    super.key,
    required this.titre,
    required this.texte,
    required this.onDecouvrir,
  });

  final String titre;
  final String texte;
  final VoidCallback onDecouvrir;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: const Icon(AppIcons.retour),
        tooltip: 'Retour',
        onPressed: () => Navigator.of(context).pop(),
      ),
    ),
    body: ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.ecran,
        AppSpacing.s,
        AppSpacing.ecran,
        AppSpacing.ecran + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        Semantics(
          header: true,
          child: Text(titre, style: context.textes.headline),
        ),
        const SizedBox(height: AppSpacing.section),
        BandeauVerrou(texte: texte, onDecouvrir: onDecouvrir),
      ],
    ),
  );
}

/// Mention d'un bien qu'on ne modifie pas (cadenas et texte) : « Lecture
/// seule » (version gratuite), « Vendu » ou « Plus en location ».
class MentionLectureSeule extends StatelessWidget {
  const MentionLectureSeule({super.key, this.libelle = lectureSeule});

  static const lectureSeule = 'Lecture seule';

  final String libelle;

  /// Mention de [bien], ou `null` s'il est modifiable.
  static String? pour(Bien bien, {required bool verrouille}) => bien.vendu
      ? 'Vendu'
      : bien.retire
      ? 'Plus en location'
      : verrouille
      ? lectureSeule
      : null;

  @override
  Widget build(BuildContext context) {
    final c = context.couleurs;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(AppIcons.verrou, size: AppSizes.iconePetite, color: c.textMuted),
        const SizedBox(width: AppSpacing.xxs),
        Flexible(
          child: Text(
            libelle,
            style: context.textes.caption.copyWith(color: c.textMuted),
          ),
        ),
      ],
    );
  }
}

/// Exécute une écriture que les droits peuvent refuser. En cas de refus,
/// affiche le message et retourne `false`.
Future<bool> executerSiAutorise(
  BuildContext context,
  Future<void> Function() ecriture,
) async {
  final messager = ScaffoldMessenger.of(context);
  try {
    await ecriture();
    return true;
  } on AccesRefuse catch (refus) {
    messager.showSnackBar(SnackBar(content: Text(refus.message)));
    return false;
  }
}
