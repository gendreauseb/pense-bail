import 'dart:convert';

import 'package:bailleur_app/domain/entities/entities.dart';
import 'package:bailleur_app/features/onboarding/brouillon_onboarding.dart';
import 'package:flutter_test/flutter_test.dart';

BrouillonBien bienComplet({
  String id = 'b1',
  TypeLocation typeLocation = TypeLocation.longueDuree,
}) => BrouillonBien(
  id: id,
  nom: 'Studio Gambetta',
  typeLogement: TypeLogement.appartement,
  typeLocation: typeLocation,
  typeBail: TypeBail.meuble,
  dateDebutBail: DateTime(2024, 3, 1),
  loyer: '650,50',
  charges: '',
  rue: '12 rue Gambetta',
  codePostal: '75020',
  ville: 'Paris',
);

void main() {
  final maintenant = DateTime(2026, 9, 25);

  test('aller-retour JSON sans perte', () {
    final brouillon = BrouillonOnboarding(
      etape: EtapeOnboarding.photoBien,
      indexBien: 1,
      nombreBiens: 2,
      identite: const BrouillonIdentite(prenom: 'Marie', email: 'm@x.fr'),
      biens: [
        bienComplet(),
        const BrouillonBien(id: 'b2', nom: 'Maison'),
      ],
      depuisRecapitulatif: true,
    );

    final relu = BrouillonOnboarding.fromJson(
      jsonDecode(jsonEncode(brouillon.toJson())) as Map<String, dynamic>,
    );

    expect(relu.etape, EtapeOnboarding.photoBien);
    expect(relu.indexBien, 1);
    expect(relu.nombreBiens, 2);
    expect(relu.identite.prenom, 'Marie');
    expect(relu.depuisRecapitulatif, isTrue);
    expect(relu.biens.first.typeBail, TypeBail.meuble);
    expect(relu.biens.first.dateDebutBail, DateTime(2024, 3, 1));
    expect(relu.biens.first.loyer, '650,50');
    expect(relu.biens.last.typeLogement, isNull);
  });

  test('brouillon incohérent : reprise au choix du nombre de biens', () {
    final relu = BrouillonOnboarding.fromJson({
      'etape': 'bien',
      'indexBien': 3,
      'nombreBiens': 2,
      'biens': [],
    });
    expect(relu.etape, EtapeOnboarding.nombreBiens);
  });

  test('montants : charges vides = 0', () {
    final b = bienComplet();
    expect(b.loyerCentimes, 65050);
    expect(b.chargesCentimes, 0);
    expect(b.estComplet, isTrue);
    expect(b.copyWith(loyer: 'abc').estComplet, isFalse);
  });

  test('longue durée : bail obligatoire et créé', () {
    final b = bienComplet();
    final bail = b.versBail(id: 'bail', maintenant: maintenant)!;
    expect(bail.bienId, 'b1');
    expect(bail.typeBail, TypeBail.meuble);
    expect(bail.dateDebut, DateTime(2024, 3, 1));

    final sansDate = BrouillonBien(
      id: 'x',
      nom: 'X',
      typeLogement: TypeLogement.maison,
      typeLocation: TypeLocation.longueDuree,
      loyer: '500',
      rue: 'r',
      codePostal: '69001',
      ville: 'Lyon',
    );
    expect(sansDate.estComplet, isFalse);
  });

  test('autre type : infos de bail conservées mais pas enregistrées', () {
    final b = bienComplet(typeLocation: TypeLocation.courteDuree);
    expect(b.typeBail, TypeBail.meuble); // gardé en mémoire
    expect(b.estComplet, isTrue);
    expect(b.versBail(id: 'bail', maintenant: maintenant), isNull);
    expect(b.versBien(ordre: 0, maintenant: maintenant).loyerHcCentimes, 65050);
  });

  test('biens retenus selon le nombre choisi', () {
    final brouillon = BrouillonOnboarding(
      nombreBiens: 1,
      biens: [
        bienComplet(),
        bienComplet(id: 'b2'),
      ],
    );
    expect(brouillon.biensRetenus.map((b) => b.id), ['b1']);
  });
}
