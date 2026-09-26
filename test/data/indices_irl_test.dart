import 'dart:io';

import 'package:bailleur_app/core/config/cles_reglages.dart';
import 'package:bailleur_app/data/irl/lecteur_indices.dart';
import 'package:bailleur_app/data/irl/service_indices_irl.dart';
import 'package:bailleur_app/data/local/database.dart';
import 'package:bailleur_app/data/repositories/drift_repositories.dart';
import 'package:bailleur_app/domain/entities/entities.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../helpers/base_memoire.dart';

/// Extrait d'une réponse SDMX de l'INSEE (valeurs réelles du T2).
const _sdmx = '''
<?xml version='1.0' encoding='UTF-8'?><message:StructureSpecificData><message:DataSet>
<Series IDBANK="001515333" FREQ="T" TITLE_FR="Indice de référence des loyers (IRL)" LAST_UPDATE="2026-07-10" DECIMALS="2">
<Obs TIME_PERIOD="2026-Q2" OBS_VALUE="148.37" OBS_STATUS="A" OBS_QUAL="DEF" OBS_TYPE="A" DATE_JO="2026-07-12"/>
<Obs TIME_PERIOD="2025-Q2" OBS_VALUE="146.68" OBS_STATUS="A" OBS_QUAL="DEF" OBS_TYPE="A" DATE_JO="2025-07-13"/>
<Obs TIME_PERIOD="2003-Q1" OBS_VALUE="106.17" OBS_STATUS="A" OBS_QUAL="DEF" OBS_TYPE="A"/>
</Series></message:DataSet></message:StructureSpecificData>
''';

const _jsonEmbarque = '''
{
  "source": "INSEE",
  "miseAJour": "2025-07-13",
  "indices": [
    { "annee": 2025, "trimestre": 2, "valeur": 146.68, "datePublicationJo": "2025-07-13" }
  ]
}
''';

void main() {
  group('LecteurIndices', () {
    test("réponse SDMX de l'INSEE", () {
      final indices = LecteurIndices.depuisSdmxInsee(_sdmx);
      expect(indices, hasLength(3));
      expect(indices.first.annee, 2026);
      expect(indices.first.trimestre, 2);
      expect(indices.first.valeur, 148.37);
      expect(indices.first.datePublication, DateTime(2026, 7, 12));
      expect(indices.last.datePublication, isNull);
    });

    test('autre série refusée', () {
      expect(
        () => LecteurIndices.depuisSdmxInsee(
          _sdmx.replaceAll('001515333', '000000001'),
        ),
        throwsA(isA<FormatIndicesInvalide>()),
      );
    });

    test("valeur illisible : rien n'est importé", () {
      expect(
        () =>
            LecteurIndices.depuisSdmxInsee(_sdmx.replaceAll('148.37', 'NaN?')),
        throwsA(isA<FormatIndicesInvalide>()),
      );
    });

    test("table embarquée de l'application lisible et cohérente", () {
      final table = LecteurIndices.depuisJson(
        File('assets/irl/irl.json').readAsStringSync(),
      );
      expect(table.indices, isNotEmpty);
      final cles = {for (final i in table.indices) (i.annee, i.trimestre)};
      expect(cles, hasLength(table.indices.length), reason: 'sans doublon');
      final t2 = table.indices.firstWhere(
        (i) => i.annee == 2026 && i.trimestre == 2,
      );
      expect(t2.valeur, 148.37);
    });
  });

  group('ServiceIndicesIrl', () {
    late AppDatabase db;
    late DriftIndiceIrlRepository indices;
    late DriftReglagesRepository reglages;
    var appels = 0;

    ServiceIndicesIrl service(http.Client client) => ServiceIndicesIrl(
      indices: indices,
      reglages: reglages,
      lireTableEmbarquee: () async {
        appels++;
        return _jsonEmbarque;
      },
      client: client,
      horloge: () => DateTime(2026, 9, 26),
    );

    final inseeOk = MockClient((_) async => http.Response(_sdmx, 200));

    setUp(() {
      db = baseDeTest();
      indices = DriftIndiceIrlRepository(db);
      reglages = DriftReglagesRepository(db);
      appels = 0;
    });
    tearDown(() => db.close());

    test('table embarquée importée une seule fois par version', () async {
      await service(inseeOk).importerTableEmbarquee();
      expect(await indices.tous(), hasLength(1));
      expect(await reglages.lire(ClesReglages.irlTableEmbarquee), '2025-07-13');
      // Un indice supprimé entre-temps n'est pas réimporté (même version).
      await db.delete(db.indicesIrl).go();
      await service(inseeOk).importerTableEmbarquee();
      expect(await indices.tous(), isEmpty);
    });

    test('mise à jour INSEE : nouveaux indices et date enregistrés', () async {
      final s = service(inseeOk);
      expect(await s.miseAJourConseillee(), isTrue);
      expect(await s.mettreAJour(), 2);
      expect(await indices.tous(), hasLength(3));
      expect(await s.derniereMiseAJour(), DateTime(2026, 9, 26));
      expect(await s.miseAJourConseillee(), isFalse);
      expect(appels, 1);
    });

    test('INSEE indisponible : message clair, rien de modifié', () async {
      final s = service(MockClient((_) async => http.Response('', 503)));
      await expectLater(
        s.mettreAJour(),
        throwsA(
          isA<MiseAJourIrlImpossible>().having(
            (e) => e.message,
            'message',
            contains('erreur 503'),
          ),
        ),
      );
      expect(await s.derniereMiseAJour(), isNull);
    });

    test('pas de réseau', () async {
      final s = service(
        MockClient((_) async => throw http.ClientException('hors ligne')),
      );
      await expectLater(
        s.mettreAJour(),
        throwsA(
          isA<MiseAJourIrlImpossible>().having(
            (e) => e.message,
            'message',
            contains('connexion'),
          ),
        ),
      );
    });

    test('saisie manuelle : ne remplace jamais une valeur INSEE', () async {
      final s = service(inseeOk);
      await s.importerTableEmbarquee();
      await s.saisir(annee: 2025, trimestre: 2, valeur: 150);
      expect(
        (await indices.trouver(annee: 2025, trimestre: 2))!.valeur,
        146.68,
      );

      await s.saisir(annee: 2026, trimestre: 2, valeur: 148.3);
      expect(
        (await indices.trouver(annee: 2026, trimestre: 2))!.source,
        SourceIndice.manuel,
      );
      // La valeur officielle remplace ensuite la saisie.
      await s.mettreAJour();
      final t2 = (await indices.trouver(annee: 2026, trimestre: 2))!;
      expect((t2.valeur, t2.source), (148.37, SourceIndice.insee));
    });
  });
}
