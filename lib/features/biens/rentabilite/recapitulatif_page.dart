import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/pdf/apercu_pdf_page.dart';
import '../../../data/providers.dart';
import 'recapitulatif_annuel.dart';

/// Export PDF du récapitulatif annuel d'un bien.
class RecapitulatifPage extends ConsumerWidget {
  const RecapitulatifPage({
    super.key,
    required this.bienId,
    required this.annee,
  });

  final String bienId;
  final int annee;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cle = (bienId, annee);
    final bien = ref.watch(bienFluxProvider(bienId)).value;
    final bailleur = ref.watch(bailleurFluxProvider).value;
    final encaissements = ref.watch(encaissementsFluxProvider(cle)).value;
    final mouvements = ref.watch(mouvementsFluxProvider(cle)).value;
    final revisions = ref.watch(historiqueRevisionsFluxProvider(bienId)).value;

    if (bien == null ||
        bailleur == null ||
        encaissements == null ||
        mouvements == null ||
        revisions == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final recapitulatif = RecapitulatifAnnuel.depuis(
      bailleur: bailleur,
      bien: bien,
      annee: annee,
      encaissements: encaissements,
      mouvements: mouvements,
      revisions: revisions,
      maintenant: DateTime.now(),
    );
    return ApercuPdfPage(
      surtitre: bien.nom,
      titre: recapitulatif.titre,
      nomFichier: RecapitulatifAnnuel.nomFichier(bien, annee),
      sujet: '${recapitulatif.titre} : ${bien.nom}',
      generer: recapitulatif.genererPdf,
      legende: 'Aide à la déclaration, ne remplace pas un conseil fiscal.',
    );
  }
}
