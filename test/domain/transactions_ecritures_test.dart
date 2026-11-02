import 'package:pense_bail/data/local/database.dart';
import 'package:pense_bail/data/repositories/drift_repositories.dart';
import 'package:pense_bail/domain/entities/entities.dart';
import 'package:pense_bail/domain/repositories/repositories.dart';
import 'package:pense_bail/domain/usecases/gestion_artisans.dart';
import 'package:pense_bail/domain/usecases/gestion_biens.dart';
import 'package:pense_bail/domain/usecases/gestion_finances.dart';
import 'package:pense_bail/domain/usecases/verrou_biens.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/base_memoire.dart';
import '../helpers/fabriques.dart';

/// Indique si une transaction est en cours.
class _TransactionsEspion implements Transactions {
  _TransactionsEspion(this._reelles);
  final Transactions _reelles;
  bool enCours = false;

  @override
  Future<T> executer<T>(Future<T> Function() operations) =>
      _reelles.executer(() async {
        enCours = true;
        try {
          return await operations();
        } finally {
          enCours = false;
        }
      });
}

/// Le contrôle des droits et l'écriture se font dans la même transaction
/// (audit A5-06) : rien ne peut changer entre les deux.
void main() {
  late AppDatabase db;
  late _TransactionsEspion transactions;
  late List<bool> controles;
  final t = DateTime(2026, 9, 25);

  setUp(() async {
    db = baseDeTest();
    transactions = _TransactionsEspion(DriftTransactions(db));
    controles = [];
    await DriftBienRepository(db).enregistrer(unBien());
    await DriftBailRepository(db).enregistrer(unBail(debut: DateTime(2023)));
  });
  tearDown(() => db.close());

  /// Chaque lecture des droits note si elle a lieu dans une transaction.
  Future<Droits> droits() async {
    controles.add(transactions.enCours);
    return Droits.premium;
  }

  VerrouBiens verrou() =>
      VerrouBiens(biens: DriftBienRepository(db), droits: droits);

  Future<void> verifier(Future<void> Function() ecriture) async {
    controles.clear();
    await ecriture();
    expect(controles, isNotEmpty);
    expect(controles, everyElement(isTrue));
  }

  test('rentabilité', () async {
    final finances = GestionFinances(
      transactions: transactions,
      biens: DriftBienRepository(db),
      finances: DriftFinanceRepository(db),
      verrou: verrou(),
    );
    final mouvement = MouvementFinancier(
      id: 'm1',
      bienId: 'bien-1',
      date: t,
      montantCentimes: 1000,
      categorie: CategorieMouvement.travaux,
      creeLe: t,
      modifieLe: t,
    );
    await verifier(() => finances.enregistrerInvestissement(unBien()));
    await verifier(() => finances.enregistrerMouvement(mouvement));
    await verifier(() => finances.supprimerMouvement(mouvement));
    await verifier(
      () => finances.definirEncaissement(
        const EncaissementLoyer(
          bienId: 'bien-1',
          annee: 2026,
          mois: 9,
          recu: true,
        ),
      ),
    );
  });

  test('artisans et interventions', () async {
    final artisans = GestionArtisans(
      transactions: transactions,
      artisans: DriftArtisanRepository(db),
      verrou: verrou(),
    );
    final intervention = Intervention(
      id: 'i1',
      bienId: 'bien-1',
      date: t,
      description: 'Réparation',
      creeLe: t,
      modifieLe: t,
    );
    await verifier(
      () => artisans.enregistrer(
        Artisan(
          id: 'a1',
          nom: 'Dupont',
          metier: MetierArtisan.plombier,
          creeLe: t,
          modifieLe: t,
        ),
      ),
    );
    await verifier(() => artisans.enregistrerIntervention(intervention));
    await verifier(() => artisans.supprimerIntervention(intervention));
    await verifier(() => artisans.supprimer('a1'));
  });

  test('locataires', () async {
    final gestion = GestionBiens(
      transactions: transactions,
      biens: DriftBienRepository(db),
      baux: DriftBailRepository(db),
      echeances: DriftEcheanceRepository(db),
      droits: droits,
    );
    await verifier(
      () => gestion.enregistrerLocataire(
        bienId: 'bien-1',
        locataire: Locataire(
          id: 'l1',
          bailId: 'bail-1',
          prenom: 'Paul',
          nom: 'Martin',
          creeLe: t,
          modifieLe: t,
        ),
      ),
    );
    await verifier(
      () => gestion.supprimerLocataire(bienId: 'bien-1', locataireId: 'l1'),
    );
  });
}
