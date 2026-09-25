import 'package:bailleur_app/domain/entities/entities.dart';
import 'package:bailleur_app/domain/services/generateur_echeances.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fabriques.dart';

void main() {
  final aujourdhui = DateTime(2026, 9, 25);

  Map<TypeEcheance, DateTime> parType(List<EcheancePrevue> liste) => {
    for (final e in liste) e.type: e.date,
  };

  test('longue durée, bail vide : 4 échéances automatiques', () {
    final prevues = GenerateurEcheances.depuisBail(
      bien: unBien(),
      bail: unBail(debut: DateTime(2023, 9, 1)),
      aujourdhui: aujourdhui,
    );
    expect(parType(prevues), {
      TypeEcheance.revisionLoyer: DateTime(2027, 9, 1),
      TypeEcheance.finBail: DateTime(2029, 8, 31),
      TypeEcheance.dateLimiteConge: DateTime(2029, 2, 28),
      TypeEcheance.regularisationCharges: DateTime(2027, 9, 1),
    });
    expect(prevues.every((e) => e.automatique && e.bienId == 'bien-1'), isTrue);
    expect(
      prevues.firstWhere((e) => e.type == TypeEcheance.finBail).intervalleMois,
      36,
    );
  });

  test("moyenne durée : pas d'échéance de révision", () {
    final prevues = GenerateurEcheances.depuisBail(
      bien: unBien(typeLocation: TypeLocation.moyenneDuree),
      bail: unBail(typeBail: TypeBail.meuble, debut: DateTime(2026, 3, 15)),
      aujourdhui: aujourdhui,
    );
    expect(parType(prevues).containsKey(TypeEcheance.revisionLoyer), isFalse);
  });

  test('échéances génériques', () {
    final bien = GenerateurEcheances.generiquesBien(
      bien: unBien(),
      aujourdhui: aujourdhui,
    );
    expect(parType(bien), {TypeEcheance.taxeFonciere: DateTime(2026, 10, 15)});
    expect(bien.single.automatique, isFalse);

    final globales = GenerateurEcheances.globales(aujourdhui: aujourdhui);
    expect(globales.single.bienId, isNull);
    expect(globales.single.date, DateTime(2027, 5, 20));
  });

  test('conversion en échéance à faire', () {
    final e = GenerateurEcheances.globales(
      aujourdhui: aujourdhui,
    ).single.versEcheance(id: 'x', maintenant: aujourdhui);
    expect(e.statut, StatutEcheance.aFaire);
    expect(e.titre, TypeEcheance.declarationRevenus.libelle);
  });
}
