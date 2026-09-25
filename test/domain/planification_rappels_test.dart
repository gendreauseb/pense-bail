import 'package:bailleur_app/domain/entities/entities.dart';
import 'package:bailleur_app/domain/services/planification_rappels.dart';
import 'package:flutter_test/flutter_test.dart';

Echeance _echeance(
  String id,
  DateTime date, {
  String? bienId = 'b1',
  StatutEcheance statut = StatutEcheance.aFaire,
}) => Echeance(
  id: id,
  bienId: bienId,
  type: TypeEcheance.revisionLoyer,
  titre: 'Révision du loyer',
  date: date,
  statut: statut,
  automatique: true,
  creeLe: date,
  modifieLe: date,
);

void main() {
  // 25/09/2026 à 10 h.
  final maintenant = DateTime(2026, 9, 25, 10);

  test('rappels à 9 h, J-30 / J-7 / J-1, textes clairs', () {
    final plan = PlanificationRappels.planifier(
      echeances: [_echeance('e1', DateTime(2026, 12, 1))],
      rappels: const [
        Rappel(id: 1, echeanceId: 'e1', joursAvant: 30),
        Rappel(id: 2, echeanceId: 'e1', joursAvant: 7),
        Rappel(id: 3, echeanceId: 'e1', joursAvant: 1),
      ],
      nomsBiens: const {'b1': 'Studio Gambetta'},
      maintenant: maintenant,
    );

    expect(plan.map((r) => r.quand), [
      DateTime(2026, 11, 1, 9),
      DateTime(2026, 11, 24, 9),
      DateTime(2026, 11, 30, 9),
    ]);
    expect(plan.first.titre, 'Dans 30 jours : Révision du loyer');
    expect(plan.last.titre, 'Demain : Révision du loyer');
    expect(plan.first.corps, 'Studio Gambetta, le 01/12/2026');
    expect(plan.first.id, 1);
    expect(plan.first.echeanceId, 'e1');
  });

  test('ignore les rappels passés (y compris aujourd\'hui après 9 h)', () {
    final plan = PlanificationRappels.planifier(
      echeances: [_echeance('e1', DateTime(2026, 9, 26))],
      rappels: const [
        Rappel(id: 1, echeanceId: 'e1', joursAvant: 7), // 19/09 : passé
        Rappel(id: 2, echeanceId: 'e1', joursAvant: 1), // 25/09 9 h : passé
        Rappel(id: 3, echeanceId: 'e1', joursAvant: 0), // 26/09 9 h
      ],
      nomsBiens: const {},
      maintenant: maintenant,
    );
    expect(plan.single.id, 3);
    expect(plan.single.titre, 'Aujourd\'hui : Révision du loyer');
  });

  test('échéance commune et échéance faite', () {
    final plan = PlanificationRappels.planifier(
      echeances: [
        _echeance('commune', DateTime(2027, 5, 20), bienId: null),
        _echeance('faite', DateTime(2027, 5, 20), statut: StatutEcheance.faite),
      ],
      rappels: const [
        Rappel(id: 1, echeanceId: 'commune', joursAvant: 7),
        Rappel(id: 2, echeanceId: 'faite', joursAvant: 7),
        Rappel(id: 3, echeanceId: 'supprimee', joursAvant: 7),
      ],
      nomsBiens: const {},
      maintenant: maintenant,
    );
    expect(plan.single.corps, 'Tous vos biens, le 20/05/2027');
  });

  test('limite iOS : seulement les plus proches', () {
    final echeances = [
      for (var i = 0; i < 100; i++)
        _echeance('e$i', DateTime(2027, 1, 1).add(Duration(days: i))),
    ];
    final plan = PlanificationRappels.planifier(
      echeances: echeances,
      rappels: [
        for (var i = 0; i < 100; i++)
          Rappel(id: i, echeanceId: 'e$i', joursAvant: 1),
      ],
      nomsBiens: const {},
      maintenant: maintenant,
      maximum: 60,
    );
    expect(plan, hasLength(60));
    expect(plan.first.id, 0);
    expect(plan.last.id, 59);
  });
}
