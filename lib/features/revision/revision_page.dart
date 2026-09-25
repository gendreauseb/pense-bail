import 'package:flutter/material.dart';

import '../../app/design/design.dart';
import '../../core/widgets/page_a_venir.dart';

/// Outil de révision de loyer (étape 5).
class RevisionPage extends StatelessWidget {
  const RevisionPage({super.key, required this.bienId});
  final String bienId;

  @override
  Widget build(BuildContext context) => const PageAVenir(
    titre: 'Révision du loyer',
    icone: AppIcons.calcul,
    etape: 'étape 5',
    avecRetour: true,
  );
}
