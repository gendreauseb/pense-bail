import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/design/design.dart';
import '../../../core/pdf/apercu_pdf_page.dart';
import '../../../core/widgets/composants.dart';
import '../../../data/providers.dart';
import 'courrier_revision.dart';

/// Courrier de révision : aperçu, partage, impression, enregistrement.
/// Le courrier est reconstruit à partir de la révision enregistrée ; il
/// reste disponible depuis l'historique de l'onglet Bail.
class CourrierRevisionPage extends ConsumerWidget {
  const CourrierRevisionPage({super.key, required this.revisionId});
  final String revisionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final revision = ref.watch(revisionProvider(revisionId)).value;
    final bien = revision == null
        ? null
        : ref.watch(bienFluxProvider(revision.bienId)).value;
    final bail = revision == null
        ? null
        : ref.watch(bailActifFluxProvider(revision.bienId)).value;
    final locataires = revision == null
        ? null
        : ref.watch(locatairesFluxProvider(revision.bailId)).value;
    final bailleur = ref.watch(bailleurFluxProvider).value;

    if (revision == null ||
        bien == null ||
        bail == null ||
        locataires == null ||
        bailleur == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final courrier = CourrierRevision.depuis(
      bailleur: bailleur,
      locataires: locataires,
      bien: bien,
      bail: bail,
      revision: revision,
    );
    return ApercuPdfPage(
      surtitre: 'Révision du loyer',
      titre: 'Courrier au locataire',
      nomFichier: CourrierRevision.nomFichier(bien, revision),
      sujet: '${courrier.objet} : ${courrier.logement}',
      generer: courrier.genererPdf,
      enTete: const Note(
        icone: AppIcons.courrier,
        texte:
            'Envoyez ce courrier en recommandé avec accusé de réception : '
            'vous garderez la preuve de la date de votre demande.',
      ),
      legende: 'Outil d\'aide, ne remplace pas un conseil juridique.',
    );
  }
}
