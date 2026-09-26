import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../app/design/app_colors.dart';

/// Polices, couleurs et tailles des documents PDF (courriers, exports).
///
/// Mêmes polices que l'application (embarquées, sans réseau). Un document
/// imprimé reste toujours en palette claire.
class StylePdf {
  const StylePdf._({
    required this.texte,
    required this.gras,
    required this.titre,
  });

  final pw.Font texte;
  final pw.Font gras;
  final pw.Font titre;

  static Future<StylePdf>? _chargement;

  /// Chargé une seule fois, puis réutilisé.
  static Future<StylePdf> charger() => _chargement ??= _charger();

  static Future<StylePdf> _charger() async {
    Future<pw.Font> police(String fichier) async =>
        pw.Font.ttf(await rootBundle.load('assets/fonts/$fichier'));
    return StylePdf._(
      texte: await police('Manrope-Regular.ttf'),
      gras: await police('Manrope-Bold.ttf'),
      titre: await police('Fraunces-SemiBold.ttf'),
    );
  }

  static const format = PdfPageFormat.a4;

  /// Marges d'une lettre (2 cm), un peu plus en bas pour la signature.
  static const marges = pw.EdgeInsets.fromLTRB(
    2 * PdfPageFormat.cm,
    2 * PdfPageFormat.cm,
    2 * PdfPageFormat.cm,
    2.5 * PdfPageFormat.cm,
  );

  // Tailles en points (1 pt = 1/72 de pouce).
  static const tailleTexte = 10.5;
  static const tailleTitre = 15.0;
  static const tailleLegende = 8.5;
  static const interligne = 3.0;
  static const espaceParagraphe = 10.0;
  static const espaceSection = 22.0;
  static const rayon = 6.0;
  static const epaisseurBordure = 0.8;

  static PdfColor _pdf(Color c) => PdfColor.fromInt(c.toARGB32());

  static final couleurTexte = _pdf(AppColors.clair.textPrimary);
  static final couleurSecondaire = _pdf(AppColors.clair.textSecondary);
  static final couleurAccent = _pdf(AppColors.clair.primary);
  static final couleurFondAccent = _pdf(AppColors.clair.primarySoft);
  static final couleurBordure = _pdf(AppColors.clair.border);

  pw.ThemeData get theme =>
      pw.ThemeData.withFont(base: texte, bold: gras).copyWith(
        defaultTextStyle: pw.TextStyle(
          font: texte,
          fontBold: gras,
          fontSize: tailleTexte,
          lineSpacing: interligne,
          color: couleurTexte,
        ),
      );

  pw.TextStyle get styleTitre =>
      pw.TextStyle(font: titre, fontSize: tailleTitre, color: couleurAccent);

  pw.TextStyle get styleGras => pw.TextStyle(font: gras, fontBold: gras);

  pw.TextStyle get styleLegende =>
      pw.TextStyle(fontSize: tailleLegende, color: couleurSecondaire);

  pw.Widget paragraphe(String texte) => pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: espaceParagraphe),
    child: pw.Text(texte, textAlign: pw.TextAlign.justify),
  );

  /// Tableau libellé / valeur. [accent] : fond coloré au lieu d'une bordure.
  /// La dernière ligne (total) est en gras.
  pw.Widget tableau(List<(String, String)> lignes, {bool accent = false}) =>
      pw.Container(
        margin: const pw.EdgeInsets.only(bottom: espaceParagraphe),
        padding: const pw.EdgeInsets.all(espaceParagraphe),
        decoration: pw.BoxDecoration(
          color: accent ? couleurFondAccent : null,
          border: accent
              ? null
              : pw.Border.all(color: couleurBordure, width: epaisseurBordure),
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(rayon)),
        ),
        child: pw.Column(
          children: [
            for (final (i, (libelle, valeur)) in lignes.indexed)
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 2),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(child: pw.Text(libelle)),
                    pw.SizedBox(width: espaceParagraphe),
                    pw.Text(
                      valeur,
                      style: i == lignes.length - 1 ? styleGras : null,
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
}
