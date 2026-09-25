import 'package:flutter/material.dart';

import '../../app/design/design.dart';
import '../../core/widgets/page_a_venir.dart';

/// Fiche détaillée d'un bien (étape 4).
class FicheBienPage extends StatelessWidget {
  const FicheBienPage({super.key, required this.bienId});
  final String bienId;

  @override
  Widget build(BuildContext context) => const PageAVenir(
    titre: 'Fiche du bien',
    icone: AppIcons.biens,
    etape: 'étape 4',
    avecRetour: true,
  );
}
