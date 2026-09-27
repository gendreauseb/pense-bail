// Idiome drift : check() référence la colonne elle-même.
// ignore_for_file: recursive_getters

// Schéma SQLite (drift).
//
// Les lignes sont lues directement dans les entités du domaine grâce à
// @UseRowClass : pas de classes intermédiaires à maintenir.
// Identifiants : UUID texte (prêts pour une future synchronisation).
// Montants : entiers en centimes. Énumérations : stockées par leur nom.

import 'package:drift/drift.dart';

import '../../domain/entities/entities.dart';

@UseRowClass(Bailleur, generateInsertable: true)
class Bailleurs extends Table {
  TextColumn get id => text()();
  TextColumn get prenom => text()();
  TextColumn get nom => text()();
  TextColumn get rue => text()();
  // Ajoutée en version 3 du schéma.
  TextColumn get complementAdresse => text().nullable()();
  TextColumn get codePostal => text()();
  TextColumn get ville => text()();
  TextColumn get telephone => text()();
  TextColumn get email => text()();
  DateTimeColumn get creeLe => dateTime()();
  DateTimeColumn get modifieLe => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@UseRowClass(Bien, generateInsertable: true)
class Biens extends Table {
  TextColumn get id => text()();
  TextColumn get nom => text()();
  TextColumn get typeLogement => textEnum<TypeLogement>()();
  TextColumn get typeLocation => textEnum<TypeLocation>()();
  TextColumn get rue => text()();
  // Ajoutée en version 3 du schéma.
  TextColumn get complementAdresse => text().nullable()();
  TextColumn get codePostal => text()();
  TextColumn get ville => text()();
  IntColumn get loyerHcCentimes => integer()();
  IntColumn get chargesCentimes => integer()();
  TextColumn get photoChemin => text().nullable()();
  RealColumn get surfaceM2 => real().nullable()();
  TextColumn get classeDpe => textEnum<ClasseDpe>().nullable()();
  DateTimeColumn get dateDpe => dateTime().nullable()();
  IntColumn get nombreLots => integer().nullable()();
  IntColumn get prixAchatCentimes => integer().nullable()();
  IntColumn get fraisNotaireCentimes => integer().nullable()();
  IntColumn get travauxInitiauxCentimes => integer().nullable()();
  IntColumn get mensualiteCreditCentimes => integer().nullable()();
  IntColumn get taxeFonciereCentimes => integer().nullable()();
  IntColumn get assuranceCentimes => integer().nullable()();
  IntColumn get chargesNonRecuperablesCentimes => integer().nullable()();
  IntColumn get fraisDiversCentimes => integer().nullable()();
  IntColumn get ordre => integer()();
  DateTimeColumn get creeLe => dateTime()();
  DateTimeColumn get modifieLe => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@UseRowClass(Bail, generateInsertable: true)
class Baux extends Table {
  TextColumn get id => text()();
  TextColumn get bienId =>
      text().references(Biens, #id, onDelete: KeyAction.cascade)();
  TextColumn get typeBail => textEnum<TypeBail>()();
  DateTimeColumn get dateDebut => dateTime()();
  IntColumn get dureeMois => integer().nullable()();
  IntColumn get depotGarantieCentimes => integer().nullable()();
  DateTimeColumn get dateRevision => dateTime().nullable()();
  IntColumn get irlTrimestre =>
      integer().nullable().check(irlTrimestre.isBetweenValues(1, 4))();
  IntColumn get irlAnnee => integer().nullable()();
  RealColumn get irlValeur => real().nullable()();
  BoolColumn get actif => boolean()();
  DateTimeColumn get creeLe => dateTime()();
  DateTimeColumn get modifieLe => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@UseRowClass(Locataire, generateInsertable: true)
class Locataires extends Table {
  TextColumn get id => text()();
  TextColumn get bailId =>
      text().references(Baux, #id, onDelete: KeyAction.cascade)();
  TextColumn get prenom => text()();
  TextColumn get nom => text()();
  TextColumn get telephone => text().nullable()();
  TextColumn get email => text().nullable()();
  DateTimeColumn get creeLe => dateTime()();
  DateTimeColumn get modifieLe => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@UseRowClass(Echeance, generateInsertable: true)
class Echeances extends Table {
  TextColumn get id => text()();
  TextColumn get bienId =>
      text().nullable().references(Biens, #id, onDelete: KeyAction.cascade)();
  TextColumn get type => textEnum<TypeEcheance>()();
  TextColumn get titre => text()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get dateInitiale => dateTime().nullable()();
  TextColumn get statut => textEnum<StatutEcheance>()();
  DateTimeColumn get faiteLe => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  IntColumn get intervalleMois => integer().nullable()();
  TextColumn get typeDiagnostic => textEnum<TypeDiagnostic>().nullable()();
  BoolColumn get automatique => boolean()();
  DateTimeColumn get creeLe => dateTime()();
  DateTimeColumn get modifieLe => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// L'identifiant entier sert d'identifiant de notification locale.
@UseRowClass(Rappel)
class Rappels extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get echeanceId =>
      text().references(Echeances, #id, onDelete: KeyAction.cascade)();
  IntColumn get joursAvant => integer()();
}

@UseRowClass(Artisan, generateInsertable: true)
class Artisans extends Table {
  TextColumn get id => text()();
  TextColumn get nom => text()();
  TextColumn get entreprise => text().nullable()();
  TextColumn get metier => textEnum<MetierArtisan>()();
  TextColumn get telephone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get creeLe => dateTime()();
  DateTimeColumn get modifieLe => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@UseRowClass(Intervention, generateInsertable: true)
class Interventions extends Table {
  TextColumn get id => text()();
  TextColumn get bienId =>
      text().references(Biens, #id, onDelete: KeyAction.cascade)();
  TextColumn get artisanId => text().nullable().references(
    Artisans,
    #id,
    onDelete: KeyAction.setNull,
  )();
  DateTimeColumn get date => dateTime()();
  TextColumn get description => text()();
  IntColumn get coutCentimes => integer().nullable()();
  DateTimeColumn get creeLe => dateTime()();
  DateTimeColumn get modifieLe => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@UseRowClass(MouvementFinancier, generateInsertable: true)
class MouvementsFinanciers extends Table {
  TextColumn get id => text()();
  TextColumn get bienId =>
      text().references(Biens, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get date => dateTime()();
  IntColumn get montantCentimes => integer()();
  TextColumn get categorie => textEnum<CategorieMouvement>()();
  TextColumn get note => text().nullable()();
  TextColumn get interventionId => text().nullable().references(
    Interventions,
    #id,
    onDelete: KeyAction.cascade,
  )();
  DateTimeColumn get creeLe => dateTime()();
  DateTimeColumn get modifieLe => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@UseRowClass(EncaissementLoyer, generateInsertable: true)
class EncaissementsLoyers extends Table {
  TextColumn get bienId =>
      text().references(Biens, #id, onDelete: KeyAction.cascade)();
  IntColumn get annee => integer()();
  IntColumn get mois => integer().check(mois.isBetweenValues(1, 12))();
  BoolColumn get recu => boolean()();
  DateTimeColumn get recuLe => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {bienId, annee, mois};
}

@UseRowClass(RevisionLoyer, generateInsertable: true)
class RevisionsLoyers extends Table {
  TextColumn get id => text()();
  TextColumn get bienId =>
      text().references(Biens, #id, onDelete: KeyAction.cascade)();
  TextColumn get bailId =>
      text().references(Baux, #id, onDelete: KeyAction.cascade)();
  // Ajoutée en version 2 du schéma.
  DateTimeColumn get datePrevue => dateTime().nullable()();
  DateTimeColumn get dateEffet => dateTime()();
  IntColumn get ancienLoyerCentimes => integer()();
  IntColumn get nouveauLoyerCentimes => integer()();
  IntColumn get ancienIrlTrimestre => integer()();
  IntColumn get ancienIrlAnnee => integer()();
  RealColumn get ancienIrlValeur => real()();
  IntColumn get nouvelIrlTrimestre => integer()();
  IntColumn get nouvelIrlAnnee => integer()();
  RealColumn get nouvelIrlValeur => real()();
  TextColumn get courrierChemin => text().nullable()();
  DateTimeColumn get creeLe => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@UseRowClass(IndiceIrl, generateInsertable: true)
class IndicesIrl extends Table {
  IntColumn get annee => integer()();
  IntColumn get trimestre => integer().check(trimestre.isBetweenValues(1, 4))();
  RealColumn get valeur => real()();
  DateTimeColumn get datePublication => dateTime().nullable()();
  TextColumn get source => textEnum<SourceIndice>()();

  @override
  Set<Column> get primaryKey => {annee, trimestre};
}

@DataClassName('ReglageLigne')
class Reglages extends Table {
  TextColumn get cle => text()();
  TextColumn get valeur => text()();

  @override
  Set<Column> get primaryKey => {cle};
}
