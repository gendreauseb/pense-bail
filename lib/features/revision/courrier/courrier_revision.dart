import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pw;

import '../../../core/config/regles_legales.dart';
import '../../../core/format/formats.dart';
import '../../../core/pdf/nom_fichier.dart';
import '../../../core/pdf/style_pdf.dart';
import '../../../domain/entities/entities.dart';

/// Texte du courrier de révision de loyer, indépendant de sa mise en page.
class CourrierRevision {
  const CourrierRevision({
    required this.expediteur,
    required this.destinataire,
    required this.lieuEtDate,
    required this.objet,
    required this.logement,
    required this.salutation,
    required this.introduction,
    required this.calcul,
    required this.application,
    required this.nouveauLoyer,
    required this.conclusion,
    required this.signataire,
  });

  /// Lignes d'adresse du bailleur.
  final List<String> expediteur;

  /// Noms des locataires puis adresse du logement.
  final List<String> destinataire;
  final String lieuEtDate;
  final String objet;
  final String logement;
  final String salutation;
  final List<String> introduction;

  /// Détail du calcul (libellé, valeur). La dernière ligne est le calcul.
  final List<(String, String)> calcul;
  final String application;

  /// Nouveau loyer (libellé, valeur). La dernière ligne est le total.
  final List<(String, String)> nouveauLoyer;
  final List<String> conclusion;
  final String signataire;

  factory CourrierRevision.depuis({
    required Bailleur bailleur,
    required List<Locataire> locataires,
    required Bien bien,
    required Bail bail,
    required RevisionLoyer revision,
  }) {
    final dateCourrier = revision.creeLe;
    final ancien = Formats.montantComplet(revision.ancienLoyerCentimes);
    final nouveau = Formats.montantComplet(revision.nouveauLoyerCentimes);
    final ancienIrl = Formats.decimal(revision.ancienIrlValeur);
    final nouvelIrl = Formats.decimal(revision.nouvelIrlValeur);
    final charges = bien.chargesCentimes;
    const politesse = 'Madame, Monsieur';

    return CourrierRevision(
      expediteur: [
        bailleur.nomComplet,
        ...bailleur.lignesAdresse,
        if (bailleur.telephone.isNotEmpty) 'Tél. ${bailleur.telephone}',
        if (bailleur.email.isNotEmpty) bailleur.email,
      ],
      destinataire: [
        if (locataires.isEmpty) 'Au locataire',
        for (final l in locataires) l.nomComplet,
        ...bien.lignesAdresse,
      ],
      lieuEtDate: 'À ${bailleur.ville}, le ${Formats.dateLongue(dateCourrier)}',
      objet: 'Révision annuelle du loyer',
      logement: bien.adresseComplete,
      salutation: '$politesse,',
      introduction: [
        'Conformément à la clause de révision de votre bail et '
            '${ReglesLegales.referenceLegaleRevision(bail.typeBail)}, je '
            'vous informe de la révision annuelle du loyer du logement que '
            'vous occupez, selon l\'indice de référence des loyers (IRL) '
            'publié par l\'INSEE.',
        'Le trimestre de référence prévu au bail est le '
            '${Formats.trimestre(revision.nouvelIrlTrimestre)}. Le loyer '
            'hors charges évolue comme l\'indice sur un an :',
      ],
      calcul: [
        ('Loyer actuel hors charges', ancien),
        (
          'IRL du ${Formats.trimestre(revision.ancienIrlTrimestre, revision.ancienIrlAnnee)}',
          ancienIrl,
        ),
        (
          'IRL du ${Formats.trimestre(revision.nouvelIrlTrimestre, revision.nouvelIrlAnnee)}',
          nouvelIrl,
        ),
        ('Calcul', '$ancien × $nouvelIrl / $ancienIrl = $nouveau'),
      ],
      application: revision.demandeeEnRetard
          ? 'La révision n\'étant pas rétroactive, votre nouveau loyer '
                's\'applique à compter de la date du présent courrier, soit '
                'le ${Formats.dateLongue(revision.dateEffet)} :'
          : 'Votre nouveau loyer s\'applique à compter du '
                '${Formats.dateLongue(revision.dateEffet)}, date de révision '
                'prévue au bail :',
      nouveauLoyer: [
        ('Nouveau loyer hors charges', nouveau),
        if (charges > 0)
          ('Charges (inchangées)', Formats.montantComplet(charges)),
        (
          'Nouveau total mensuel',
          Formats.montantComplet(revision.nouveauLoyerCentimes + charges),
        ),
      ],
      conclusion: [
        'Je vous remercie d\'en tenir compte pour vos prochains règlements '
            'et reste à votre disposition pour toute question.',
        'Je vous prie d\'agréer, $politesse, l\'expression de mes '
            'salutations distinguées.',
      ],
      signataire: bailleur.nomComplet,
    );
  }

  /// Nom de fichier proposé : « revision-loyer-2026-studio-gambetta.pdf ».
  static String nomFichier(Bien bien, RevisionLoyer revision) =>
      nomFichierPdf(['revision-loyer', '${revision.dateEffet.year}', bien.nom]);

  Future<Uint8List> genererPdf() async {
    final style = await StylePdf.charger();
    final document = pw.Document(
      title: '$objet, $logement',
      author: signataire,
      creator: 'Pense-Bail',
    );

    document.addPage(
      pw.MultiPage(
        pageFormat: StylePdf.format,
        margin: StylePdf.marges,
        theme: style.theme,
        build: (_) => [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              for (final (i, ligne) in expediteur.indexed)
                pw.Text(ligne, style: i == 0 ? style.styleGras : null),
            ],
          ),
          pw.SizedBox(height: StylePdf.espaceSection),
          pw.Row(
            children: [
              pw.Spacer(),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    for (final (i, ligne) in destinataire.indexed)
                      pw.Text(
                        ligne,
                        style: i < destinataire.length - 2
                            ? style.styleGras
                            : null,
                      ),
                    pw.SizedBox(height: StylePdf.espaceSection),
                    pw.Text(lieuEtDate),
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: StylePdf.espaceSection),
          pw.Text(objet, style: style.styleTitre),
          pw.SizedBox(height: StylePdf.interligne),
          pw.Text('Logement : $logement', style: style.styleLegende),
          pw.SizedBox(height: StylePdf.espaceSection),
          style.paragraphe(salutation),
          for (final p in introduction) style.paragraphe(p),
          style.tableau(calcul),
          style.paragraphe(application),
          style.tableau(nouveauLoyer, accent: true),
          for (final p in conclusion) style.paragraphe(p),
          pw.SizedBox(height: StylePdf.espaceSection),
          pw.Row(
            children: [
              pw.Spacer(),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(signataire, style: style.styleGras),
                    pw.SizedBox(height: StylePdf.interligne),
                    pw.Text('Signature', style: style.styleLegende),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
    return document.save();
  }
}
