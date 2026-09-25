import 'package:flutter/material.dart';

import '../../core/widgets/page_a_venir.dart';

class BiensPage extends StatelessWidget {
  const BiensPage({super.key});

  @override
  Widget build(BuildContext context) => const PageAVenir(
    titre: 'Mes biens',
    icone: Icons.apartment,
    etape: 'étape 4',
  );
}
