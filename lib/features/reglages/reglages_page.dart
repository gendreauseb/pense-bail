import 'package:flutter/material.dart';

import '../../app/design/design.dart';
import '../../core/widgets/page_a_venir.dart';

class ReglagesPage extends StatelessWidget {
  const ReglagesPage({super.key});

  @override
  Widget build(BuildContext context) => const PageAVenir(
    titre: 'Réglages',
    icone: AppIcons.reglages,
    etape: 'étape 6',
  );
}
