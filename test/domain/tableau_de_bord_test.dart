import 'package:bailleur_app/domain/entities/entities.dart';
import 'package:bailleur_app/domain/services/tableau_de_bord.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fabriques.dart';

Echeance _echeance(String id, String? bienId, DateTime date) => Echeance(
  id: id,
  bienId: bienId,
  type: TypeEcheance.taxeFonciere,
  titre: 'Taxe foncière',
  date: date,
  statut: StatutEcheance.aFaire,
  automatique: false,
  creeLe: date,
  modifieLe: date,
);

void main() {
  final studio = unBien(id: 'studio', loyerHcCentimes: 65000);
  final gite = unBien(
    id: 'gite',
    nom: 'Gîte',
    typeLocation: TypeLocation.courteDuree,
    loyerHcCentimes: 90000,
  );

  test('synthèse : nombre de biens, loyers et charges', () {
    final s = TableauDeBord.synthese([studio, gite]);
    expect(s.nombreBiens, 2);
    expect(s.loyersCentimes, 155000);
    expect(s.chargesCentimes, 10000); // 50 € chacun (fabrique)
  });

  group('invitations à compléter', () {
    test('longue durée sans IRL de référence', () {
      final bail = unBail(bienId: 'studio', debut: DateTime(2024, 1, 1));
      final invitations = TableauDeBord.invitations([studio], [bail]);
      expect(invitations.single.type, TypeInvitation.irlManquant);
    });

    test('longue durée complète : aucune invitation', () {
      final bail = unBail(
        bienId: 'studio',
        debut: DateTime(2024, 1, 1),
      ).copyWith(irlTrimestre: 2, irlAnnee: 2025, irlValeur: 100.0);
      expect(TableauDeBord.invitations([studio], [bail]), isEmpty);
    });

    test('autre type sans bail : bail manquant', () {
      final invitations = TableauDeBord.invitations([gite], const []);
      expect(invitations.single.type, TypeInvitation.bailManquant);
      expect(invitations.single.bien.id, 'gite');
    });
  });

  test('prochaine échéance par bien et filtre', () {
    final liste = [
      _echeance('commune', null, DateTime(2026, 10, 1)),
      _echeance('s1', 'studio', DateTime(2026, 10, 15)),
      _echeance('g1', 'gite', DateTime(2026, 11, 1)),
      _echeance('s2', 'studio', DateTime(2027, 1, 1)),
    ];
    final prochaines = TableauDeBord.prochaineParBien(liste);
    expect(prochaines['studio']!.id, 's1');
    expect(prochaines['gite']!.id, 'g1');

    expect(TableauDeBord.filtrer(liste, null), hasLength(4));
    expect(TableauDeBord.filtrer(liste, 'studio').map((e) => e.id), [
      's1',
      's2',
    ]);
  });
}
