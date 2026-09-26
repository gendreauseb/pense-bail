import 'dart:convert';
import 'dart:io';

import 'package:bailleur_app/data/local/database.dart';
import 'package:bailleur_app/data/repositories/drift_repositories.dart';
import 'package:bailleur_app/data/sauvegarde/service_sauvegarde.dart';
import 'package:bailleur_app/domain/entities/entities.dart';
import 'package:bailleur_app/domain/usecases/gestion_biens.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/base_memoire.dart';
import '../helpers/fabriques.dart';

void main() {
  late AppDatabase db;
  late Directory documents;
  late ServiceSauvegarde service;

  setUp(() async {
    db = baseDeTest();
    documents = await Directory.systemTemp.createTemp('pense_bail_test');
    service = ServiceSauvegarde(
      db: db,
      documents: documents,
      horloge: () => DateTime(2026, 9, 26, 10),
    );
  });
  tearDown(() async {
    await db.close();
    await documents.delete(recursive: true);
  });

  /// Un bien avec photo, bail, échéances et rappels, un locataire, un
  /// artisan, un réglage.
  Future<void> remplir() async {
    final photo = File('${documents.path}/photos/abc.jpg');
    await photo.create(recursive: true);
    await photo.writeAsBytes([1, 2, 3, 4]);
    final bien = Bien(
      id: 'bien-1',
      nom: 'Studio Gambetta',
      typeLogement: TypeLogement.appartement,
      typeLocation: TypeLocation.longueDuree,
      rue: '12 rue Gambetta',
      codePostal: '75020',
      ville: 'Paris',
      loyerHcCentimes: 65000,
      chargesCentimes: 5000,
      photoChemin: 'photos/abc.jpg',
      classeDpe: ClasseDpe.d,
      ordre: 0,
      creeLe: DateTime(2026),
      modifieLe: DateTime(2026),
    );
    await GestionBiens(
      transactions: DriftTransactions(db),
      biens: DriftBienRepository(db),
      baux: DriftBailRepository(db),
      echeances: DriftEcheanceRepository(db),
    ).creer(
      bien: bien,
      bail: unBail(debut: DateTime(2023, 9, 1)),
      aujourdhui: DateTime(2026, 9, 25),
    );
    await DriftBailRepository(db).enregistrerLocataire(
      Locataire(
        id: 'l1',
        bailId: 'bail-1',
        prenom: 'Paul',
        nom: 'Martin',
        email: 'paul@exemple.fr',
        creeLe: DateTime(2026),
        modifieLe: DateTime(2026),
      ),
    );
    await DriftArtisanRepository(db).enregistrer(
      Artisan(
        id: 'a1',
        nom: 'Dupont Plomberie',
        metier: MetierArtisan.plombier,
        creeLe: DateTime(2026),
        modifieLe: DateTime(2026),
      ),
    );
    await DriftReglagesRepository(db).ecrire('onboarding.termine', 'true');
  }

  Future<Map<String, Object?>> tables() async {
    final json =
        jsonDecode(utf8.decode(await service.exporter()))
            as Map<String, Object?>;
    return json['tables']! as Map<String, Object?>;
  }

  test('sauvegarde, effacement puis restauration à l\'identique', () async {
    await remplir();
    final avant = await tables();
    final fichier = await service.exporter();

    await service.effacerTout();
    expect(await DriftBienRepository(db).tous(), isEmpty);
    expect(await DriftEcheanceRepository(db).tousLesRappels(), isEmpty);
    expect(Directory('${documents.path}/photos').existsSync(), isFalse);

    final sauvegarde = service.lire(fichier);
    expect(sauvegarde.nombreBiens, 1);
    expect(sauvegarde.creeLe, DateTime(2026, 9, 26, 10));
    await service.restaurer(sauvegarde);

    expect(await tables(), avant);
    expect(File('${documents.path}/photos/abc.jpg').readAsBytesSync(), [
      1,
      2,
      3,
      4,
    ]);
    final bien = (await DriftBienRepository(db).parId('bien-1'))!;
    expect((bien.nom, bien.classeDpe), ('Studio Gambetta', ClasseDpe.d));
    expect(service.nomFichier(), 'pense-bail-sauvegarde-2026-09-26.json');
  });

  test('restaurer remplace les données présentes', () async {
    await remplir();
    final fichier = await service.exporter();
    await DriftBienRepository(
      db,
    ).enregistrer(unBien(id: 'autre', nom: 'Autre bien'));
    await service.restaurer(service.lire(fichier));
    expect((await DriftBienRepository(db).tous()).map((b) => b.id), ['bien-1']);
  });

  group('fichiers refusés', () {
    Map<String, Object?> valide() => {
      'application': 'Pense-Bail',
      'format': 1,
      'schema': 2,
      'creeLe': '2026-09-26T10:00:00.000',
      'tables': <String, Object?>{},
      'photos': <String, Object?>{},
    };

    void refuse(Object? contenu, String message) => expect(
      () => service.lire(utf8.encode(jsonEncode(contenu))),
      throwsA(
        isA<SauvegardeInvalide>().having(
          (e) => e.message,
          'message',
          contains(message),
        ),
      ),
    );

    test('autre fichier', () {
      refuse({'nom': 'x'}, "n'est pas une sauvegarde");
      expect(
        () => service.lire(utf8.encode('pas du json')),
        throwsA(isA<SauvegardeInvalide>()),
      );
    });

    test('version plus récente', () {
      refuse({...valide(), 'schema': 99}, 'version plus récente');
    });

    test('table ou colonne inconnue', () {
      refuse({
        ...valide(),
        'tables': {'pirate': <Object?>[]},
      }, 'Contenu inattendu');
      refuse({
        ...valide(),
        'tables': {
          'biens': [
            {'id': 'x', 'colonne_pirate': 1},
          ],
        },
      }, 'Contenu inattendu');
    });

    test('chemin de photo hors du dossier des photos', () {
      refuse({
        ...valide(),
        'photos': {'../../etc/passwd': 'AAAA'},
      }, 'Photo inattendue');
    });
  });
}
