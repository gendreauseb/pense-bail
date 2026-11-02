import 'package:pense_bail/domain/entities/entities.dart';
import 'package:pense_bail/domain/services/acces_biens.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fabriques.dart';

void main() {
  final janvier = DateTime(2026, 1, 1);
  final fevrier = DateTime(2026, 2, 1);
  final mars = DateTime(2026, 3, 1);

  group('droits', () {
    test('gratuit : un bien, aucune fonctionnalité Premium', () {
      expect(Droits.gratuit.maxBiensActifs, 1);
      for (final f in Fonctionnalite.values) {
        expect(Droits.gratuit.autorise(f), isFalse, reason: f.name);
      }
    });

    test('Premium : tout est disponible', () {
      expect(Droits.premium.maxBiensActifs, isNull);
      for (final f in Fonctionnalite.values) {
        expect(Droits.premium.autorise(f), isTrue, reason: f.name);
      }
    });
  });

  group('bien actif en gratuit', () {
    test("le plus ancien, même si on l'affiche en dernier", () {
      final biens = [
        unBien(id: 'recent', creeLe: mars, ordre: 0),
        unBien(id: 'ancien', creeLe: janvier, ordre: 2),
        unBien(id: 'moyen', creeLe: fevrier, ordre: 1),
      ];
      expect(AccesBiens.actifs(biens, Droits.gratuit), {'ancien'});
    });

    test('même date de création (onboarding) : le premier saisi', () {
      final biens = [
        unBien(id: 'b', creeLe: janvier, ordre: 1),
        unBien(id: 'a', creeLe: janvier, ordre: 0),
        unBien(id: 'c', creeLe: janvier, ordre: 2),
      ];
      expect(AccesBiens.actifs(biens, Droits.gratuit), {'a'});
    });

    test('même date et même ordre : par identifiant, toujours le même', () {
      final biens = [
        unBien(id: 'z', creeLe: janvier),
        unBien(id: 'm', creeLe: janvier),
      ];
      expect(AccesBiens.actifs(biens, Droits.gratuit), {'m'});
      expect(AccesBiens.actifs(biens.reversed.toList(), Droits.gratuit), {'m'});
    });

    test('le plus ancien supprimé : le suivant devient actif', () {
      final biens = [
        unBien(id: 'ancien', creeLe: janvier),
        unBien(id: 'moyen', creeLe: fevrier),
        unBien(id: 'recent', creeLe: mars),
      ];
      final restants = biens.where((b) => b.id != 'ancien').toList();
      expect(AccesBiens.actifs(restants, Droits.gratuit), {'moyen'});
    });

    test('aucun bien', () {
      expect(AccesBiens.actifs(const [], Droits.gratuit), isEmpty);
    });
  });

  test('Premium : tous les biens sont actifs', () {
    final biens = [
      unBien(id: 'a', creeLe: janvier),
      unBien(id: 'b', creeLe: fevrier),
    ];
    expect(AccesBiens.actifs(biens, Droits.premium), {'a', 'b'});
  });

  test('ajout possible selon la limite', () {
    final un = [unBien(id: 'a')];
    expect(AccesBiens.peutAjouter(const [], Droits.gratuit), isTrue);
    expect(AccesBiens.peutAjouter(un, Droits.gratuit), isFalse);
    expect(AccesBiens.peutAjouter(un, Droits.premium), isTrue);
  });

  test('message de refus', () {
    expect(
      const LimiteBiensAtteinte(1).message,
      "La version gratuite permet de gérer un seul bien. "
      "Pense-Bail Premium permet d'en ajouter d'autres.",
    );
  });
}
