import 'package:pense_bail/domain/entities/entities.dart';
import 'package:pense_bail/domain/services/calculateur_diagnostic.dart';
import 'package:flutter_test/flutter_test.dart';

// Validité des diagnostics pour une location (audit A2-09).

void main() {
  final realise = DateTime(2024, 3, 15);

  DateTime? expiration(TypeDiagnostic type) =>
      CalculateurDiagnostic.expiration(type, realise);

  test('DPE : 10 ans', () {
    expect(expiration(TypeDiagnostic.dpe), DateTime(2034, 3, 15));
  });

  test('électricité, gaz et plomb : 6 ans', () {
    expect(expiration(TypeDiagnostic.electricite), DateTime(2030, 3, 15));
    expect(expiration(TypeDiagnostic.gaz), DateTime(2030, 3, 15));
    expect(expiration(TypeDiagnostic.plomb), DateTime(2030, 3, 15));
  });

  test('état des risques : 6 mois', () {
    expect(expiration(TypeDiagnostic.erp), DateTime(2024, 9, 15));
  });

  test("amiante : pas d'expiration dans le cas général", () {
    expect(expiration(TypeDiagnostic.amiante), isNull);
  });

  test('réalisé un 31 : dernier jour du mois quand il est plus court', () {
    expect(
      CalculateurDiagnostic.expiration(
        TypeDiagnostic.erp,
        DateTime(2024, 8, 31),
      ),
      DateTime(2025, 2, 28),
    );
  });
}
