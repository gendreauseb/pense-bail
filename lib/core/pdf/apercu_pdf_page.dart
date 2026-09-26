import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../app/design/design.dart';
import '../widgets/composants.dart';
import 'style_pdf.dart';

/// Aperçu d'un document PDF avec les actions : partager (email,
/// messagerie...), imprimer, enregistrer sur le téléphone.
class ApercuPdfPage extends StatefulWidget {
  const ApercuPdfPage({
    super.key,
    required this.surtitre,
    required this.titre,
    required this.nomFichier,
    required this.generer,
    this.sujet,
    this.enTete,
    this.legende,
  });

  final String surtitre;
  final String titre;

  /// Nom proposé à l'enregistrement et au partage (avec « .pdf »).
  final String nomFichier;
  final Future<Uint8List> Function() generer;

  /// Objet de l'email en cas de partage par email.
  final String? sujet;

  /// Contenu affiché au-dessus de l'aperçu (conseil...).
  final Widget? enTete;
  final String? legende;

  @override
  State<ApercuPdfPage> createState() => _ApercuPdfPageState();
}

class _ApercuPdfPageState extends State<ApercuPdfPage> {
  late final Future<Uint8List> _document = widget.generer();
  bool _enCours = false;

  Future<void> _action(Future<void> Function(Uint8List pdf) action) async {
    setState(() => _enCours = true);
    try {
      await action(await _document);
    } on Exception {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('L\'action n\'a pas pu aboutir. Réessayez.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _enCours = false);
    }
  }

  Future<void> _partager() => _action(
    (pdf) => Printing.sharePdf(
      bytes: pdf,
      filename: widget.nomFichier,
      subject: widget.sujet,
    ),
  );

  Future<void> _imprimer() => _action(
    (pdf) => Printing.layoutPdf(
      name: widget.nomFichier,
      format: StylePdf.format,
      onLayout: (_) async => pdf,
    ),
  );

  Future<void> _enregistrer() => _action((pdf) async {
    final messager = ScaffoldMessenger.of(context);
    final fichier = await FilePicker.saveFile(
      dialogTitle: 'Enregistrer le document',
      fileName: widget.nomFichier,
      bytes: pdf,
      mimeType: 'application/pdf',
      type: FileType.custom,
      allowedExtensions: const ['pdf'],
    );
    if (fichier != null) {
      messager.showSnackBar(
        const SnackBar(content: Text('Document enregistré.')),
      );
    }
  });

  @override
  Widget build(BuildContext context) {
    final t = context.textes;
    final c = context.couleurs;
    final enTete = widget.enTete;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(AppIcons.retour),
          tooltip: 'Retour',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.ecran,
              0,
              AppSpacing.ecran,
              AppSpacing.bloc,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.surtitre.toUpperCase(), style: t.overline),
                const SizedBox(height: AppSpacing.xs),
                Semantics(
                  header: true,
                  child: Text(widget.titre, style: t.headline),
                ),
                if (enTete != null) ...[
                  const SizedBox(height: AppSpacing.bloc),
                  enTete,
                ],
              ],
            ),
          ),
          Expanded(
            child: Semantics(
              label: 'Aperçu du document ${widget.titre}',
              child: PdfPreview(
                build: (_) => _document,
                initialPageFormat: StylePdf.format,
                useActions: false,
                canChangePageFormat: false,
                canChangeOrientation: false,
                canDebug: false,
                pdfFileName: widget.nomFichier,
                scrollViewDecoration: BoxDecoration(color: c.background),
                pdfPreviewPageDecoration: BoxDecoration(
                  color: c.surface,
                  border: Border.all(color: c.border),
                ),
                loadingWidget: const CircularProgressIndicator(),
                onError: (context, _) => Padding(
                  padding: AppSpacing.paddingEcran,
                  child: Center(
                    child: Text(
                      'L\'aperçu n\'est pas disponible. Vous pouvez quand '
                      'même partager, imprimer ou enregistrer le document.',
                      textAlign: TextAlign.center,
                      style: t.secondary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BarreActionFixe(
        libelle: 'Partager',
        onPressed: _partager,
        enCours: _enCours,
        legende: widget.legende,
        secondaire: Row(
          children: [
            Expanded(
              child: TextButton.icon(
                onPressed: _enCours ? null : _imprimer,
                icon: const Icon(AppIcons.imprimer),
                label: const Text('Imprimer'),
              ),
            ),
            Expanded(
              child: TextButton.icon(
                onPressed: _enCours ? null : _enregistrer,
                icon: const Icon(AppIcons.enregistrer),
                label: const Text('Enregistrer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
