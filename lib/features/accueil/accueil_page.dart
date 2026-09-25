import 'package:flutter/material.dart';

import '../../core/widgets/page_a_venir.dart';

class AccueilPage extends StatelessWidget {
  const AccueilPage({super.key});

  @override
  Widget build(BuildContext context) => const PageAVenir(
    titre: 'Tableau de bord',
    icone: Icons.home,
    etape: 'étape 3',
  );
}
