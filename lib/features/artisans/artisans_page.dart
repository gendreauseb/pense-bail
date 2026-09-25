import 'package:flutter/material.dart';

import '../../app/design/design.dart';
import '../../core/widgets/page_a_venir.dart';

class ArtisansPage extends StatelessWidget {
  const ArtisansPage({super.key});

  @override
  Widget build(BuildContext context) => const PageAVenir(
    titre: 'Artisans',
    icone: AppIcons.artisans,
    etape: 'étape 4',
  );
}
