import 'package:flutter/material.dart';

import '../../core/widgets/page_a_venir.dart';

class ParametresPage extends StatelessWidget {
  const ParametresPage({super.key});

  @override
  Widget build(BuildContext context) => const PageAVenir(
    titre: 'Paramètres',
    icone: Icons.settings,
    etape: 'étape 6',
  );
}
