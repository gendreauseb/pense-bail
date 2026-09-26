import 'package:bailleur_app/domain/entities/entities.dart';
import 'package:bailleur_app/features/biens/rentabilite/recapitulatif_annuel.dart';
import 'package:bailleur_app/features/revision/courrier/courrier_revision.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fabriques.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final e = String.fromCharCode(0xA0);

  final bailleur = Bailleur(
    id: 'moi',
    prenom: 'Marie',
    nom: 'Durand',
    rue: '1 place de la Mairie',
    codePostal: '69001',
    ville: 'Lyon',
    telephone: '06 12 34 56 78',
    email: '',
    creeLe: DateTime(2026),
    modifieLe: DateTime(2026),
  );
  final locataire = Locataire(
    id: 'l1',
    bailId: 'bail-1',
    prenom: 'Paul',
    nom: 'Martin',
    creeLe: DateTime(2026),
    modifieLe: DateTime(2026),
  );

  RevisionLoyer revision({required DateTime dateEffet}) => RevisionLoyer(
    id: 'r1',
    bienId: 'bien-1',
    bailId: 'bail-1',
    datePrevue: DateTime(2026, 9, 1),
    dateEffet: dateEffet,
    ancienLoyerCentimes: 65000,
    nouveauLoyerCentimes: 65749,
    ancienIrlTrimestre: 2,
    ancienIrlAnnee: 2025,
    ancienIrlValeur: 146.68,
    nouvelIrlTrimestre: 2,
    nouvelIrlAnnee: 2026,
    nouvelIrlValeur: 148.37,
    creeLe: DateTime(2026, 8, 10),
  );

  CourrierRevision courrier(RevisionLoyer r) => CourrierRevision.depuis(
    bailleur: bailleur,
    locataires: [locataire],
    bien: unBien(),
    bail: unBail(debut: DateTime(2023, 9, 1)),
    revision: r,
  );

  test("contenu : parties, calcul, nouveau loyer, date d'application", () {
    final c = courrier(revision(dateEffet: DateTime(2026, 9, 1)));
    expect(c.expediteur, [
      'Marie Durand',
      '1 place de la Mairie',
      '69001 Lyon',
      'Tél. 06 12 34 56 78',
    ]);
    expect(c.destinataire, ['Paul Martin', '12 rue Gambetta', '75020 Paris']);
    expect(c.lieuEtDate, 'À Lyon, le 10 août 2026');
    expect(c.introduction.first, contains('article 17-1 de la loi'));
    expect(c.calcul[1], ('IRL du 2e trimestre 2025', '146,68'));
    expect(c.calcul.last.$2, '650,00$e€ × 148,37 / 146,68 = 657,49$e€');
    expect(c.application, contains('1 septembre 2026, date de révision'));
    expect(c.nouveauLoyer, [
      ('Nouveau loyer hors charges', '657,49$e€'),
      ('Charges (inchangées)', '50,00$e€'),
      ('Nouveau total mensuel', '707,49$e€'),
    ]);
  });

  test('demandée en retard : non rétroactive', () {
    final c = courrier(revision(dateEffet: DateTime(2026, 9, 25)));
    expect(c.application, contains("n'étant pas rétroactive"));
    expect(c.application, contains('25 septembre 2026'));
  });

  test('nom de fichier sans accents', () {
    expect(
      CourrierRevision.nomFichier(
        unBien(nom: 'Gîte du Lac'),
        revision(dateEffet: DateTime(2026, 9, 1)),
      ),
      'revision-loyer-2026-gite-du-lac.pdf',
    );
  });

  test('PDF du courrier et du récapitulatif générés', () async {
    final pdf = await courrier(
      revision(dateEffet: DateTime(2026, 9, 1)),
    ).genererPdf();
    expect(String.fromCharCodes(pdf.take(5)), '%PDF-');

    final recap = RecapitulatifAnnuel.depuis(
      bailleur: bailleur,
      bien: unBien(),
      annee: 2026,
      encaissements: [
        for (var m = 1; m <= 3; m++)
          EncaissementLoyer(bienId: 'bien-1', annee: 2026, mois: m, recu: true),
      ],
      mouvements: [
        MouvementFinancier(
          id: 'm1',
          bienId: 'bien-1',
          date: DateTime(2026, 2, 3),
          montantCentimes: 12000,
          categorie: CategorieMouvement.assurance,
          creeLe: DateTime(2026),
          modifieLe: DateTime(2026),
        ),
      ],
      revisions: const [],
      maintenant: DateTime(2026, 9, 26),
    );
    expect(recap.moisRecus, 'janvier, février, mars');
    expect(recap.recettes.first.$2, '1${e}950,00$e€');
    expect(recap.depenses, [
      ('Assurance', '120,00$e€'),
      ('Total des dépenses', '120,00$e€'),
    ]);
    expect(recap.resultat.last.$2, '1${e}830,00$e€');
    final pdfRecap = await recap.genererPdf();
    expect(String.fromCharCodes(pdfRecap.take(5)), '%PDF-');
  });
}
