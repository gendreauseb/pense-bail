import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/design/design.dart';
import '../../data/providers.dart';
import '../../domain/enums.dart';

/// Photo d'un bien (recadrée, jamais déformée), ou illustration par défaut.
class PhotoBien extends ConsumerWidget {
  const PhotoBien({
    super.key,
    required this.chemin,
    required this.typeLogement,
    this.rayon = AppRadius.carte,
    this.tailleIcone = AppSizes.pictogramme,
  });

  /// Chemin relatif (voir PhotoService). `null` : illustration.
  final String? chemin;
  final TypeLogement? typeLogement;
  final double rayon;
  final double tailleIcone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final illustration = IllustrationBien(
      typeLogement: typeLogement,
      tailleIcone: tailleIcone,
    );
    final chemin = this.chemin;
    return ClipRRect(
      borderRadius: AppRadius.arrondi(rayon),
      child: chemin == null
          ? illustration
          : Image.file(
              ref.watch(photoServiceProvider).fichier(chemin),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              semanticLabel: 'Photo du bien',
              errorBuilder: (_, _, _) => illustration,
            ),
    );
  }
}

/// Grand pictogramme au trait centré sur un fond coloré (UI.md §5) :
/// maison sur fond sable, les autres types sur fond bleu canard pâle.
class IllustrationBien extends StatelessWidget {
  const IllustrationBien({
    super.key,
    required this.typeLogement,
    this.tailleIcone = AppSizes.pictogramme,
  });

  final TypeLogement? typeLogement;
  final double tailleIcone;

  @override
  Widget build(BuildContext context) {
    final c = context.couleurs;
    final maison = typeLogement == TypeLogement.maison;
    final type = typeLogement;
    return ColoredBox(
      color: maison ? c.sand : c.primarySoft,
      child: SizedBox.expand(
        child: Center(
          child: Icon(
            type == null ? AppIcons.biens : AppIcons.typeLogement(type),
            size: tailleIcone,
            color: maison ? c.sandIcon : c.primary,
            semanticLabel: type == null
                ? 'Illustration'
                : 'Illustration : ${type.libelle}',
          ),
        ),
      ),
    );
  }
}
