import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pw;

import '../../../core/format/formats.dart';
import '../../../core/pdf/nom_fichier.dart';
import '../../../core/pdf/style_pdf.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/services/rentabilite.dart';

/// Récapitulatif annuel d'un bien, pour préparer la déclaration de revenus.
class RecapitulatifAnnuel {
  const RecapitulatifAnnuel({
    required this.titre,
    required this.bien,
    required this.adresse,
    required this.proprietaire,
    required this.editeLe,
    required this.moisRecus,
    required this.recettes,
    required this.depenses,
    required this.resultat,
    required this.journal,
  });

  final String titre;
  final String bien;
  final String adresse;
  final String proprietaire;
  final String editeLe;

  /// « janvier, février, mars » ou « aucun ».
  final String moisRecus;

  /// (libellé, montant) ; la dernière ligne est le total.
  final List<(String, String)> recettes;
  final List<(String, String)> depenses;
  final List<(String, String)> resultat;

  /// (date, catégorie, détail, montant signé).
  final List<(String, String, String, String)> journal;

  static const avertissement =
      'Document d\'aide à la préparation de votre déclaration de revenus, '
      'établi à partir des informations saisies dans Pense-Bail. Les loyers '
      'sont ceux des mois indiqués comme reçus, au montant en vigueur ce '
      'mois-là : vérifiez-les avec vos relevés bancaires. Toutes les dépenses '
      'ne sont pas déductibles de vos revenus fonciers (par exemple le '
      'remboursement du capital d\'un crédit) : consultez impots.gouv.fr. '
      'Ne remplace pas un conseil fiscal.';

  factory RecapitulatifAnnuel.depuis({
    required Bailleur bailleur,
    required Bien bien,
    required int annee,
    required List<EncaissementLoyer> encaissements,
    required List<MouvementFinancier> mouvements,
    required List<RevisionLoyer> revisions,
    required DateTime maintenant,
  }) {
    final bilan = Rentabilite.bilan(
      bien: bien,
      annee: annee,
      encaissements: encaissements,
      mouvements: mouvements,
      revisions: revisions,
    );
    final totaux = Rentabilite.totauxParCategorie(
      annee: annee,
      mouvements: mouvements,
    );
    final mois = [
      for (final e in encaissements)
        if (e.annee == annee && e.recu) e.mois,
    ]..sort();
    final duJournal = [
      for (final m in mouvements)
        if (m.date.year == annee) m,
    ]..sort((a, b) => a.date.compareTo(b.date));

    return RecapitulatifAnnuel(
      titre: 'Récapitulatif $annee',
      bien: bien.nom,
      adresse: bien.adresseComplete,
      proprietaire: bailleur.nomComplet,
      editeLe: Formats.date(maintenant),
      moisRecus: mois.isEmpty ? 'aucun' : mois.map(Formats.nomMois).join(', '),
      recettes: [
        (
          'Loyers hors charges perçus (${bilan.moisRecus} mois)',
          Formats.montantComplet(bilan.loyersPercus),
        ),
        for (final MapEntry(key: c, value: total) in totaux.entries)
          if (c.sens == SensMouvement.recette)
            (c.libelle, Formats.montantComplet(total)),
        (
          'Total des recettes',
          Formats.montantComplet(bilan.loyersPercus + bilan.autresRecettes),
        ),
      ],
      depenses: [
        for (final MapEntry(key: c, value: total) in totaux.entries)
          if (c.sens == SensMouvement.depense)
            (c.libelle, Formats.montantComplet(total)),
        ('Total des dépenses', Formats.montantComplet(bilan.depenses)),
      ],
      resultat: [
        (
          'Recettes',
          Formats.montantComplet(bilan.loyersPercus + bilan.autresRecettes),
        ),
        ('Dépenses', Formats.montantComplet(bilan.depenses)),
        ('Résultat de l\'année', Formats.montantComplet(bilan.resultat)),
      ],
      journal: [
        for (final m in duJournal)
          (
            Formats.date(m.date),
            m.categorie.libelle,
            m.note ?? '',
            '${m.sens == SensMouvement.depense ? '−' : '+'}'
                '${Formats.montantComplet(m.montantCentimes)}',
          ),
      ],
    );
  }

  static String nomFichier(Bien bien, int annee) =>
      nomFichierPdf(['recapitulatif', '$annee', bien.nom]);

  Future<Uint8List> genererPdf() async {
    final style = await StylePdf.charger();
    final document = pw.Document(
      title: '$titre, $bien',
      author: proprietaire,
      creator: 'Pense-Bail',
    );

    pw.Widget section(String texte) => pw.Padding(
      padding: const pw.EdgeInsets.only(
        top: StylePdf.espaceSection,
        bottom: StylePdf.espaceParagraphe,
      ),
      child: pw.Text(texte, style: style.styleGras),
    );

    document.addPage(
      pw.MultiPage(
        pageFormat: StylePdf.format,
        margin: StylePdf.marges,
        theme: style.theme,
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'Page ${context.pageNumber} sur ${context.pagesCount}',
            style: style.styleLegende,
          ),
        ),
        build: (_) => [
          pw.Text(titre, style: style.styleTitre),
          pw.SizedBox(height: StylePdf.interligne),
          pw.Text(bien, style: style.styleGras),
          pw.Text(adresse),
          pw.SizedBox(height: StylePdf.interligne),
          pw.Text(
            'Propriétaire : $proprietaire. Édité le $editeLe avec Pense-Bail.',
            style: style.styleLegende,
          ),
          section('Recettes'),
          style.tableau(recettes),
          pw.Text(
            'Mois indiqués comme reçus : $moisRecus.',
            style: style.styleLegende,
          ),
          section('Dépenses'),
          if (depenses.length > 1)
            style.tableau(depenses)
          else
            style.paragraphe('Aucune dépense enregistrée.'),
          section('Résultat'),
          style.tableau(resultat, accent: true),
          if (journal.isNotEmpty) ...[
            section('Détail des dépenses et recettes'),
            pw.TableHelper.fromTextArray(
              headers: const ['Date', 'Catégorie', 'Détail', 'Montant'],
              data: [
                for (final (date, categorie, detail, montant) in journal)
                  [date, categorie, detail, montant],
              ],
              headerStyle: style.styleGras,
              headerDecoration: pw.BoxDecoration(
                color: StylePdf.couleurFondAccent,
              ),
              border: pw.TableBorder(
                horizontalInside: pw.BorderSide(
                  color: StylePdf.couleurBordure,
                  width: StylePdf.epaisseurBordure,
                ),
              ),
              cellAlignments: const {3: pw.Alignment.centerRight},
              columnWidths: const {
                0: pw.IntrinsicColumnWidth(),
                1: pw.IntrinsicColumnWidth(),
                2: pw.FlexColumnWidth(),
                3: pw.IntrinsicColumnWidth(),
              },
            ),
          ],
          pw.SizedBox(height: StylePdf.espaceSection),
          pw.Text(avertissement, style: style.styleLegende),
        ],
      ),
    );
    return document.save();
  }
}
