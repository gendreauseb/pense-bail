import 'dart:io';

import 'package:bailleur_app/app/etat_app.dart';
import 'package:bailleur_app/core/config/cles_reglages.dart';
import 'package:bailleur_app/data/local/database.dart';
import 'package:bailleur_app/data/providers.dart';
import 'package:bailleur_app/data/repositories/drift_repositories.dart';
import 'package:bailleur_app/domain/entities/entities.dart';
import 'package:bailleur_app/features/onboarding/brouillon_onboarding.dart';
import 'package:bailleur_app/features/onboarding/onboarding_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/base_memoire.dart';
import 'brouillon_onboarding_test.dart' show bienComplet;

void main() {
  late AppDatabase db;

  setUp(() => db = baseDeTest());
  tearDown(() => db.close());

  Future<(ProviderContainer, OnboardingController)> demarrer() async {
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        dossierDocumentsProvider.overrideWithValue(Directory.systemTemp),
        onboardingTermineAuDemarrageProvider.overrideWithValue(false),
      ],
    );
    container.listen(onboardingControllerProvider, (_, _) {});
    await container.read(onboardingControllerProvider.future);
    return (container, container.read(onboardingControllerProvider.notifier));
  }

  BrouillonOnboarding etat(ProviderContainer c) =>
      c.read(onboardingControllerProvider).requireValue;

  /// Laisse passer les écritures en base lancées sans attendre.
  Future<void> patienter() =>
      Future<void>.delayed(const Duration(milliseconds: 50));

  test('parcours complet des étapes, avec 2 biens', () async {
    final (c, ctrl) = await demarrer();
    addTearDown(c.dispose);

    expect(etat(c).etape, EtapeOnboarding.bienvenue);
    ctrl.suivant();
    expect(etat(c).etape, EtapeOnboarding.identite);
    ctrl.suivant();
    expect(etat(c).etape, EtapeOnboarding.nombreBiens);
    ctrl.definirNombreBiens(2);
    ctrl.suivant();
    expect(etat(c).etape, EtapeOnboarding.bien);
    expect(etat(c).biens, hasLength(2));
    ctrl.suivant();
    expect(etat(c).etape, EtapeOnboarding.photoBien);
    ctrl.suivant();
    expect((etat(c).etape, etat(c).indexBien), (EtapeOnboarding.bien, 1));
    ctrl.suivant();
    ctrl.suivant();
    expect(etat(c).etape, EtapeOnboarding.recapitulatif);

    // Retour arrière depuis le récapitulatif : photo du dernier bien.
    ctrl.precedent();
    expect((etat(c).etape, etat(c).indexBien), (EtapeOnboarding.photoBien, 1));
    ctrl.precedent();
    ctrl.precedent();
    expect((etat(c).etape, etat(c).indexBien), (EtapeOnboarding.photoBien, 0));
  });

  test('modification depuis le récapitulatif : retour direct', () async {
    final (c, ctrl) = await demarrer();
    addTearDown(c.dispose);
    for (var i = 0; i < 5; i++) {
      ctrl.suivant();
    }
    expect(etat(c).etape, EtapeOnboarding.recapitulatif);

    ctrl.modifierIdentite();
    ctrl.suivant();
    expect(etat(c).etape, EtapeOnboarding.recapitulatif);

    ctrl.modifierBien(0);
    expect(etat(c).etape, EtapeOnboarding.bien);
    ctrl.suivant(); // photo
    ctrl.suivant();
    expect(etat(c).etape, EtapeOnboarding.recapitulatif);
    expect(etat(c).depuisRecapitulatif, isFalse);
  });

  test('la progression est reprise après fermeture de l\'app', () async {
    final (c1, ctrl) = await demarrer();
    ctrl.suivant();
    ctrl.majIdentite(const BrouillonIdentite(prenom: 'Marie'));
    ctrl.suivant(); // sauvegarde immédiate au changement d'étape
    await patienter();
    c1.dispose();

    final (c2, _) = await demarrer();
    addTearDown(c2.dispose);
    expect(etat(c2).etape, EtapeOnboarding.nombreBiens);
    expect(etat(c2).identite.prenom, 'Marie');
  });

  test(
    'terminer : données enregistrées et onboarding marqué terminé',
    () async {
      final (c, ctrl) = await demarrer();
      addTearDown(c.dispose);
      ctrl.suivant();
      ctrl.majIdentite(
        const BrouillonIdentite(
          prenom: 'Marie',
          nom: 'Durand',
          rue: '1 place de la Mairie',
          codePostal: '69001',
          ville: 'Lyon',
          telephone: '0612345678',
        ),
      );
      ctrl.suivant();
      ctrl.suivant(); // 1 bien
      final id = etat(c).bienCourant.id;
      ctrl.majBienCourant(bienComplet(id: id));
      ctrl.suivant();
      ctrl.suivant();
      expect(etat(c).etape, EtapeOnboarding.recapitulatif);

      await ctrl.terminer();
      await patienter();

      expect(c.read(onboardingTermineProvider), isTrue);
      final bailleur = await DriftBailleurRepository(db).obtenir();
      expect(bailleur!.telephone, '06 12 34 56 78');
      final biens = await DriftBienRepository(db).tous();
      expect(biens.single.nom, 'Studio Gambetta');
      expect(biens.single.typeLocation, TypeLocation.longueDuree);
      expect(await DriftBailRepository(db).bailActif(id), isNotNull);
      expect(
        await DriftReglagesRepository(
          db,
        ).lire(ClesReglages.brouillonOnboarding),
        isNull,
        reason: 'le brouillon ne doit pas être réécrit après la fin',
      );
    },
  );

  test('terminer refuse un bien incomplet', () async {
    final (c, ctrl) = await demarrer();
    addTearDown(c.dispose);
    for (var i = 0; i < 5; i++) {
      ctrl.suivant();
    }
    await expectLater(ctrl.terminer(), throwsStateError);
    expect(c.read(onboardingTermineProvider), isFalse);
  });
}
