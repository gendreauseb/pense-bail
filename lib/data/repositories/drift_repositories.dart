// Implémentations locales (SQLite / drift) des repositories du domaine.

import 'package:drift/drift.dart';

import '../../core/utils/identifiants.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../local/database.dart';

// ---------------------------------------------------------------------------
// Transactions
// ---------------------------------------------------------------------------

/// Les transactions drift s'appliquent à tous les appels faits à l'intérieur,
/// y compris ceux des autres repositories partageant la même base.
class DriftTransactions implements Transactions {
  DriftTransactions(this._db);
  final AppDatabase _db;

  @override
  Future<T> executer<T>(Future<T> Function() operations) =>
      _db.transaction(operations);
}

// ---------------------------------------------------------------------------
// Bailleur
// ---------------------------------------------------------------------------

class DriftBailleurRepository implements BailleurRepository {
  DriftBailleurRepository(this._db);
  final AppDatabase _db;

  // Un seul bailleur par appareil en V1.
  SimpleSelectStatement<$BailleursTable, Bailleur> get _requete =>
      _db.select(_db.bailleurs)..limit(1);

  @override
  Future<Bailleur?> obtenir() => _requete.getSingleOrNull();

  @override
  Stream<Bailleur?> surveiller() => _requete.watchSingleOrNull();

  @override
  Future<void> enregistrer(Bailleur bailleur) =>
      _db.into(_db.bailleurs).insertOnConflictUpdate(bailleur.toInsertable());
}

// ---------------------------------------------------------------------------
// Biens
// ---------------------------------------------------------------------------

class DriftBienRepository implements BienRepository {
  DriftBienRepository(this._db);
  final AppDatabase _db;

  SimpleSelectStatement<$BiensTable, Bien> get _tous =>
      _db.select(_db.biens)..orderBy([
        (b) => OrderingTerm(expression: b.ordre),
        (b) => OrderingTerm(expression: b.creeLe),
      ]);

  SimpleSelectStatement<$BiensTable, Bien> _parId(String id) =>
      _db.select(_db.biens)..where((b) => b.id.equals(id));

  @override
  Stream<List<Bien>> surveillerTous() => _tous.watch();

  @override
  Future<List<Bien>> tous() => _tous.get();

  @override
  Stream<Bien?> surveiller(String id) => _parId(id).watchSingleOrNull();

  @override
  Future<Bien?> parId(String id) => _parId(id).getSingleOrNull();

  @override
  Future<void> enregistrer(Bien bien) =>
      _db.into(_db.biens).insertOnConflictUpdate(bien.toInsertable());

  @override
  Future<void> supprimer(String id) =>
      (_db.delete(_db.biens)..where((b) => b.id.equals(id))).go();
}

// ---------------------------------------------------------------------------
// Baux et locataires
// ---------------------------------------------------------------------------

class DriftBailRepository implements BailRepository {
  DriftBailRepository(this._db);
  final AppDatabase _db;

  SimpleSelectStatement<$BauxTable, Bail> _actif(String bienId) =>
      _db.select(_db.baux)
        ..where((b) => b.bienId.equals(bienId) & b.actif.equals(true))
        ..limit(1);

  SimpleSelectStatement<$LocatairesTable, Locataire> _locataires(
    String bailId,
  ) => _db.select(_db.locataires)
    ..where((l) => l.bailId.equals(bailId))
    ..orderBy([(l) => OrderingTerm(expression: l.creeLe)]);

  @override
  Future<Bail?> bailActif(String bienId) => _actif(bienId).getSingleOrNull();

  @override
  Stream<Bail?> surveillerBailActif(String bienId) =>
      _actif(bienId).watchSingleOrNull();

  @override
  Stream<List<Bail>> surveillerBauxActifs() =>
      (_db.select(_db.baux)..where((b) => b.actif.equals(true))).watch();

  @override
  Future<void> enregistrer(Bail bail) => _db.transaction(() async {
    if (bail.actif) {
      // Un seul bail actif par bien.
      await (_db.update(_db.baux)..where(
            (b) =>
                b.bienId.equals(bail.bienId) &
                b.actif.equals(true) &
                b.id.equals(bail.id).not(),
          ))
          .write(const BauxCompanion(actif: Value(false)));
    }
    await _db.into(_db.baux).insertOnConflictUpdate(bail.toInsertable());
  });

  @override
  Stream<List<Locataire>> surveillerLocataires(String bailId) =>
      _locataires(bailId).watch();

  @override
  Future<List<Locataire>> locataires(String bailId) =>
      _locataires(bailId).get();

  @override
  Future<void> enregistrerLocataire(Locataire locataire) =>
      _db.into(_db.locataires).insertOnConflictUpdate(locataire.toInsertable());

  @override
  Future<void> supprimerLocataire(String id) =>
      (_db.delete(_db.locataires)..where((l) => l.id.equals(id))).go();
}

// ---------------------------------------------------------------------------
// Échéances et rappels
// ---------------------------------------------------------------------------

class DriftEcheanceRepository implements EcheanceRepository {
  DriftEcheanceRepository(this._db);
  final AppDatabase _db;

  SimpleSelectStatement<$EcheancesTable, Echeance> _aFaire({String? bienId}) =>
      _db.select(_db.echeances)
        ..where((e) {
          final aFaire = e.statut.equalsValue(StatutEcheance.aFaire);
          return bienId == null ? aFaire : aFaire & e.bienId.equals(bienId);
        })
        ..orderBy([(e) => OrderingTerm(expression: e.date)]);

  @override
  Future<List<Echeance>> aFaire() => _aFaire().get();

  @override
  Future<List<Rappel>> tousLesRappels() => _db.select(_db.rappels).get();

  @override
  Stream<List<Echeance>> surveillerAFaire({String? bienId}) =>
      _aFaire(bienId: bienId).watch();

  @override
  Stream<List<Echeance>> surveillerParBien(String bienId) =>
      (_db.select(_db.echeances)
            ..where((e) => e.bienId.equals(bienId))
            ..orderBy([(e) => OrderingTerm(expression: e.date)]))
          .watch();

  @override
  Future<Echeance?> parId(String id) => (_db.select(
    _db.echeances,
  )..where((e) => e.id.equals(id))).getSingleOrNull();

  @override
  Future<void> enregistrer(Echeance echeance) =>
      _db.into(_db.echeances).insertOnConflictUpdate(echeance.toInsertable());

  @override
  Future<void> enregistrerTout(List<Echeance> echeances) => _db.batch(
    (b) => b.insertAllOnConflictUpdate(
      _db.echeances,
      echeances.map((e) => e.toInsertable()).toList(),
    ),
  );

  @override
  Future<void> supprimer(String id) =>
      (_db.delete(_db.echeances)..where((e) => e.id.equals(id))).go();

  @override
  Future<void> remplacerAutomatiques(String bienId, List<Echeance> nouvelles) =>
      _db.transaction(() async {
        await (_db.delete(_db.echeances)..where(
              (e) =>
                  e.bienId.equals(bienId) &
                  e.automatique.equals(true) &
                  e.statut.equalsValue(StatutEcheance.aFaire),
            ))
            .go();
        await enregistrerTout(nouvelles);
      });

  @override
  Future<List<Rappel>> rappels(String echeanceId) =>
      (_db.select(_db.rappels)
            ..where((r) => r.echeanceId.equals(echeanceId))
            ..orderBy([
              (r) => OrderingTerm(
                expression: r.joursAvant,
                mode: OrderingMode.desc,
              ),
            ]))
          .get();

  @override
  Future<List<Rappel>> definirRappels(
    String echeanceId,
    List<int> joursAvant,
  ) => _db.transaction(() async {
    await (_db.delete(
      _db.rappels,
    )..where((r) => r.echeanceId.equals(echeanceId))).go();
    for (final jours in joursAvant.toSet()) {
      await _db
          .into(_db.rappels)
          .insert(
            RappelsCompanion.insert(echeanceId: echeanceId, joursAvant: jours),
          );
    }
    return rappels(echeanceId);
  });
}

// ---------------------------------------------------------------------------
// Artisans et interventions
// ---------------------------------------------------------------------------

class DriftArtisanRepository implements ArtisanRepository {
  DriftArtisanRepository(this._db);
  final AppDatabase _db;

  @override
  Stream<List<Artisan>> surveillerTous() =>
      (_db.select(_db.artisans)..orderBy([
            (a) => OrderingTerm(expression: a.nom.collate(Collate.noCase)),
          ]))
          .watch();

  @override
  Future<Artisan?> parId(String id) => (_db.select(
    _db.artisans,
  )..where((a) => a.id.equals(id))).getSingleOrNull();

  @override
  Future<void> enregistrer(Artisan artisan) =>
      _db.into(_db.artisans).insertOnConflictUpdate(artisan.toInsertable());

  @override
  Future<void> supprimer(String id) =>
      (_db.delete(_db.artisans)..where((a) => a.id.equals(id))).go();

  @override
  Stream<List<Intervention>> surveillerInterventions(String bienId) =>
      (_db.select(_db.interventions)
            ..where((i) => i.bienId.equals(bienId))
            ..orderBy([
              (i) => OrderingTerm(expression: i.date, mode: OrderingMode.desc),
            ]))
          .watch();

  @override
  Future<void> enregistrerIntervention(Intervention intervention) =>
      _db.transaction(() async {
        await _db
            .into(_db.interventions)
            .insertOnConflictUpdate(intervention.toInsertable());

        final existant =
            await (_db.select(_db.mouvementsFinanciers)
                  ..where((m) => m.interventionId.equals(intervention.id)))
                .getSingleOrNull();
        final cout = intervention.coutCentimes ?? 0;

        if (cout <= 0) {
          if (existant != null) {
            await (_db.delete(
              _db.mouvementsFinanciers,
            )..where((m) => m.id.equals(existant.id))).go();
          }
          return;
        }

        final maintenant = DateTime.now();
        final mouvement =
            existant?.copyWith(
              date: intervention.date,
              montantCentimes: cout,
              note: intervention.description,
            ) ??
            MouvementFinancier(
              id: Identifiants.nouveau(),
              bienId: intervention.bienId,
              date: intervention.date,
              montantCentimes: cout,
              categorie: CategorieMouvement.intervention,
              note: intervention.description,
              interventionId: intervention.id,
              creeLe: maintenant,
              modifieLe: maintenant,
            );
        await _db
            .into(_db.mouvementsFinanciers)
            .insertOnConflictUpdate(mouvement.toInsertable());
      });

  @override
  Future<void> supprimerIntervention(String id) =>
      // La dépense liée est supprimée en cascade.
      (_db.delete(_db.interventions)..where((i) => i.id.equals(id))).go();
}

// ---------------------------------------------------------------------------
// Finances
// ---------------------------------------------------------------------------

class DriftFinanceRepository implements FinanceRepository {
  DriftFinanceRepository(this._db);
  final AppDatabase _db;

  SimpleSelectStatement<$MouvementsFinanciersTable, MouvementFinancier>
  _mouvements(String bienId, int? annee) {
    final requete = _db.select(_db.mouvementsFinanciers)
      ..where((m) => m.bienId.equals(bienId))
      ..orderBy([
        (m) => OrderingTerm(expression: m.date, mode: OrderingMode.desc),
      ]);
    if (annee != null) {
      requete.where((m) => m.date.year.equals(annee));
    }
    return requete;
  }

  @override
  Stream<List<MouvementFinancier>> surveillerMouvements(
    String bienId, {
    int? annee,
  }) => _mouvements(bienId, annee).watch();

  @override
  Future<List<MouvementFinancier>> mouvements(String bienId, {int? annee}) =>
      _mouvements(bienId, annee).get();

  @override
  Future<void> enregistrerMouvement(MouvementFinancier mouvement) => _db
      .into(_db.mouvementsFinanciers)
      .insertOnConflictUpdate(mouvement.toInsertable());

  @override
  Future<void> supprimerMouvement(String id) => (_db.delete(
    _db.mouvementsFinanciers,
  )..where((m) => m.id.equals(id))).go();

  @override
  Stream<List<EncaissementLoyer>> surveillerEncaissements(
    String bienId,
    int annee,
  ) =>
      (_db.select(_db.encaissementsLoyers)
            ..where((e) => e.bienId.equals(bienId) & e.annee.equals(annee))
            ..orderBy([(e) => OrderingTerm(expression: e.mois)]))
          .watch();

  @override
  Future<void> definirEncaissement(EncaissementLoyer encaissement) => _db
      .into(_db.encaissementsLoyers)
      .insertOnConflictUpdate(encaissement.toInsertable());
}

// ---------------------------------------------------------------------------
// Révisions de loyer
// ---------------------------------------------------------------------------

class DriftRevisionRepository implements RevisionRepository {
  DriftRevisionRepository(this._db);
  final AppDatabase _db;

  @override
  Stream<List<RevisionLoyer>> surveillerHistorique(String bienId) =>
      (_db.select(_db.revisionsLoyers)
            ..where((r) => r.bienId.equals(bienId))
            ..orderBy([
              (r) => OrderingTerm(
                expression: r.dateEffet,
                mode: OrderingMode.desc,
              ),
            ]))
          .watch();

  @override
  Future<void> enregistrer(RevisionLoyer revision) => _db
      .into(_db.revisionsLoyers)
      .insertOnConflictUpdate(revision.toInsertable());
}

// ---------------------------------------------------------------------------
// Indices IRL
// ---------------------------------------------------------------------------

class DriftIndiceIrlRepository implements IndiceIrlRepository {
  DriftIndiceIrlRepository(this._db);
  final AppDatabase _db;

  @override
  Future<List<IndiceIrl>> tous() =>
      (_db.select(_db.indicesIrl)..orderBy([
            (i) => OrderingTerm(expression: i.annee, mode: OrderingMode.desc),
            (i) =>
                OrderingTerm(expression: i.trimestre, mode: OrderingMode.desc),
          ]))
          .get();

  @override
  Future<IndiceIrl?> trouver({required int annee, required int trimestre}) =>
      (_db.select(_db.indicesIrl)..where(
            (i) => i.annee.equals(annee) & i.trimestre.equals(trimestre),
          ))
          .getSingleOrNull();

  @override
  Future<IndiceIrl?> dernier() async {
    final liste = await tous();
    return liste.isEmpty ? null : liste.first;
  }

  @override
  Future<void> enregistrerTout(List<IndiceIrl> indices) =>
      _db.transaction(() async {
        for (final indice in indices) {
          final existant = await trouver(
            annee: indice.annee,
            trimestre: indice.trimestre,
          );
          final ecraseInsee =
              existant?.source == SourceIndice.insee &&
              indice.source == SourceIndice.manuel;
          if (ecraseInsee) continue;
          await _db
              .into(_db.indicesIrl)
              .insertOnConflictUpdate(indice.toInsertable());
        }
      });
}

// ---------------------------------------------------------------------------
// Réglages clé / valeur
// ---------------------------------------------------------------------------

class DriftReglagesRepository implements ReglagesRepository {
  DriftReglagesRepository(this._db);
  final AppDatabase _db;

  SimpleSelectStatement<$ReglagesTable, ReglageLigne> _cle(String cle) =>
      _db.select(_db.reglages)..where((r) => r.cle.equals(cle));

  @override
  Future<String?> lire(String cle) async =>
      (await _cle(cle).getSingleOrNull())?.valeur;

  @override
  Stream<String?> surveiller(String cle) =>
      _cle(cle).watchSingleOrNull().map((r) => r?.valeur);

  @override
  Future<void> ecrire(String cle, String valeur) => _db
      .into(_db.reglages)
      .insertOnConflictUpdate(
        ReglagesCompanion.insert(cle: cle, valeur: valeur),
      );

  @override
  Future<void> supprimer(String cle) =>
      (_db.delete(_db.reglages)..where((r) => r.cle.equals(cle))).go();
}
