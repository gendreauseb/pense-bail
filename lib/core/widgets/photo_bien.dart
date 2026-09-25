import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/enums.dart';
import 'icones.dart';

/// Photo d'un bien, ou illustration par défaut selon le type de logement.
class PhotoBien extends ConsumerWidget {
  const PhotoBien({
    super.key,
    required this.chemin,
    required this.typeLogement,
    this.rayon = 16,
    this.tailleIcone = 56,
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
      borderRadius: BorderRadius.circular(rayon),
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

class IllustrationBien extends StatelessWidget {
  const IllustrationBien({
    super.key,
    required this.typeLogement,
    this.tailleIcone = 56,
  });

  final TypeLogement? typeLogement;
  final double tailleIcone;

  @override
  Widget build(BuildContext context) {
    final schema = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [schema.primaryContainer, schema.secondaryContainer],
        ),
      ),
      child: Center(
        child: Icon(
          typeLogement?.icone ?? Icons.home_work_outlined,
          size: tailleIcone,
          color: schema.onPrimaryContainer.withValues(alpha: 0.7),
          semanticLabel: typeLogement == null
              ? 'Illustration'
              : 'Illustration : ${typeLogement!.libelle}',
        ),
      ),
    );
  }
}
