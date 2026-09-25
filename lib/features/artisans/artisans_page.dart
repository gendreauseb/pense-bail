import 'package:flutter/material.dart';

import '../../core/widgets/page_a_venir.dart';

class ArtisansPage extends StatelessWidget {
  const ArtisansPage({super.key});

  @override
  Widget build(BuildContext context) => const PageAVenir(
    titre: 'Artisans',
    icone: Icons.handyman,
    etape: 'étape 4',
  );
}
