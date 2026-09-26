// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $BailleursTable extends Bailleurs
    with TableInfo<$BailleursTable, Bailleur> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BailleursTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _prenomMeta = const VerificationMeta('prenom');
  @override
  late final GeneratedColumn<String> prenom = GeneratedColumn<String>(
    'prenom',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nomMeta = const VerificationMeta('nom');
  @override
  late final GeneratedColumn<String> nom = GeneratedColumn<String>(
    'nom',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rueMeta = const VerificationMeta('rue');
  @override
  late final GeneratedColumn<String> rue = GeneratedColumn<String>(
    'rue',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codePostalMeta = const VerificationMeta(
    'codePostal',
  );
  @override
  late final GeneratedColumn<String> codePostal = GeneratedColumn<String>(
    'code_postal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _villeMeta = const VerificationMeta('ville');
  @override
  late final GeneratedColumn<String> ville = GeneratedColumn<String>(
    'ville',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _telephoneMeta = const VerificationMeta(
    'telephone',
  );
  @override
  late final GeneratedColumn<String> telephone = GeneratedColumn<String>(
    'telephone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creeLeMeta = const VerificationMeta('creeLe');
  @override
  late final GeneratedColumn<DateTime> creeLe = GeneratedColumn<DateTime>(
    'cree_le',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifieLeMeta = const VerificationMeta(
    'modifieLe',
  );
  @override
  late final GeneratedColumn<DateTime> modifieLe = GeneratedColumn<DateTime>(
    'modifie_le',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    prenom,
    nom,
    rue,
    codePostal,
    ville,
    telephone,
    email,
    creeLe,
    modifieLe,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bailleurs';
  @override
  VerificationContext validateIntegrity(
    Insertable<Bailleur> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('prenom')) {
      context.handle(
        _prenomMeta,
        prenom.isAcceptableOrUnknown(data['prenom']!, _prenomMeta),
      );
    } else if (isInserting) {
      context.missing(_prenomMeta);
    }
    if (data.containsKey('nom')) {
      context.handle(
        _nomMeta,
        nom.isAcceptableOrUnknown(data['nom']!, _nomMeta),
      );
    } else if (isInserting) {
      context.missing(_nomMeta);
    }
    if (data.containsKey('rue')) {
      context.handle(
        _rueMeta,
        rue.isAcceptableOrUnknown(data['rue']!, _rueMeta),
      );
    } else if (isInserting) {
      context.missing(_rueMeta);
    }
    if (data.containsKey('code_postal')) {
      context.handle(
        _codePostalMeta,
        codePostal.isAcceptableOrUnknown(data['code_postal']!, _codePostalMeta),
      );
    } else if (isInserting) {
      context.missing(_codePostalMeta);
    }
    if (data.containsKey('ville')) {
      context.handle(
        _villeMeta,
        ville.isAcceptableOrUnknown(data['ville']!, _villeMeta),
      );
    } else if (isInserting) {
      context.missing(_villeMeta);
    }
    if (data.containsKey('telephone')) {
      context.handle(
        _telephoneMeta,
        telephone.isAcceptableOrUnknown(data['telephone']!, _telephoneMeta),
      );
    } else if (isInserting) {
      context.missing(_telephoneMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('cree_le')) {
      context.handle(
        _creeLeMeta,
        creeLe.isAcceptableOrUnknown(data['cree_le']!, _creeLeMeta),
      );
    } else if (isInserting) {
      context.missing(_creeLeMeta);
    }
    if (data.containsKey('modifie_le')) {
      context.handle(
        _modifieLeMeta,
        modifieLe.isAcceptableOrUnknown(data['modifie_le']!, _modifieLeMeta),
      );
    } else if (isInserting) {
      context.missing(_modifieLeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Bailleur map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bailleur(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      prenom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prenom'],
      )!,
      nom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nom'],
      )!,
      rue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rue'],
      )!,
      codePostal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code_postal'],
      )!,
      ville: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ville'],
      )!,
      telephone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telephone'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      creeLe: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cree_le'],
      )!,
      modifieLe: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modifie_le'],
      )!,
    );
  }

  @override
  $BailleursTable createAlias(String alias) {
    return $BailleursTable(attachedDatabase, alias);
  }
}

class BailleursCompanion extends UpdateCompanion<Bailleur> {
  final Value<String> id;
  final Value<String> prenom;
  final Value<String> nom;
  final Value<String> rue;
  final Value<String> codePostal;
  final Value<String> ville;
  final Value<String> telephone;
  final Value<String> email;
  final Value<DateTime> creeLe;
  final Value<DateTime> modifieLe;
  final Value<int> rowid;
  const BailleursCompanion({
    this.id = const Value.absent(),
    this.prenom = const Value.absent(),
    this.nom = const Value.absent(),
    this.rue = const Value.absent(),
    this.codePostal = const Value.absent(),
    this.ville = const Value.absent(),
    this.telephone = const Value.absent(),
    this.email = const Value.absent(),
    this.creeLe = const Value.absent(),
    this.modifieLe = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BailleursCompanion.insert({
    required String id,
    required String prenom,
    required String nom,
    required String rue,
    required String codePostal,
    required String ville,
    required String telephone,
    required String email,
    required DateTime creeLe,
    required DateTime modifieLe,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       prenom = Value(prenom),
       nom = Value(nom),
       rue = Value(rue),
       codePostal = Value(codePostal),
       ville = Value(ville),
       telephone = Value(telephone),
       email = Value(email),
       creeLe = Value(creeLe),
       modifieLe = Value(modifieLe);
  static Insertable<Bailleur> custom({
    Expression<String>? id,
    Expression<String>? prenom,
    Expression<String>? nom,
    Expression<String>? rue,
    Expression<String>? codePostal,
    Expression<String>? ville,
    Expression<String>? telephone,
    Expression<String>? email,
    Expression<DateTime>? creeLe,
    Expression<DateTime>? modifieLe,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (prenom != null) 'prenom': prenom,
      if (nom != null) 'nom': nom,
      if (rue != null) 'rue': rue,
      if (codePostal != null) 'code_postal': codePostal,
      if (ville != null) 'ville': ville,
      if (telephone != null) 'telephone': telephone,
      if (email != null) 'email': email,
      if (creeLe != null) 'cree_le': creeLe,
      if (modifieLe != null) 'modifie_le': modifieLe,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BailleursCompanion copyWith({
    Value<String>? id,
    Value<String>? prenom,
    Value<String>? nom,
    Value<String>? rue,
    Value<String>? codePostal,
    Value<String>? ville,
    Value<String>? telephone,
    Value<String>? email,
    Value<DateTime>? creeLe,
    Value<DateTime>? modifieLe,
    Value<int>? rowid,
  }) {
    return BailleursCompanion(
      id: id ?? this.id,
      prenom: prenom ?? this.prenom,
      nom: nom ?? this.nom,
      rue: rue ?? this.rue,
      codePostal: codePostal ?? this.codePostal,
      ville: ville ?? this.ville,
      telephone: telephone ?? this.telephone,
      email: email ?? this.email,
      creeLe: creeLe ?? this.creeLe,
      modifieLe: modifieLe ?? this.modifieLe,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (prenom.present) {
      map['prenom'] = Variable<String>(prenom.value);
    }
    if (nom.present) {
      map['nom'] = Variable<String>(nom.value);
    }
    if (rue.present) {
      map['rue'] = Variable<String>(rue.value);
    }
    if (codePostal.present) {
      map['code_postal'] = Variable<String>(codePostal.value);
    }
    if (ville.present) {
      map['ville'] = Variable<String>(ville.value);
    }
    if (telephone.present) {
      map['telephone'] = Variable<String>(telephone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (creeLe.present) {
      map['cree_le'] = Variable<DateTime>(creeLe.value);
    }
    if (modifieLe.present) {
      map['modifie_le'] = Variable<DateTime>(modifieLe.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BailleursCompanion(')
          ..write('id: $id, ')
          ..write('prenom: $prenom, ')
          ..write('nom: $nom, ')
          ..write('rue: $rue, ')
          ..write('codePostal: $codePostal, ')
          ..write('ville: $ville, ')
          ..write('telephone: $telephone, ')
          ..write('email: $email, ')
          ..write('creeLe: $creeLe, ')
          ..write('modifieLe: $modifieLe, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$BailleurInsertable implements Insertable<Bailleur> {
  Bailleur _object;
  _$BailleurInsertable(this._object);
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return BailleursCompanion(
      id: Value(_object.id),
      prenom: Value(_object.prenom),
      nom: Value(_object.nom),
      rue: Value(_object.rue),
      codePostal: Value(_object.codePostal),
      ville: Value(_object.ville),
      telephone: Value(_object.telephone),
      email: Value(_object.email),
      creeLe: Value(_object.creeLe),
      modifieLe: Value(_object.modifieLe),
    ).toColumns(false);
  }
}

extension BailleurToInsertable on Bailleur {
  _$BailleurInsertable toInsertable() {
    return _$BailleurInsertable(this);
  }
}

class $BiensTable extends Biens with TableInfo<$BiensTable, Bien> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BiensTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nomMeta = const VerificationMeta('nom');
  @override
  late final GeneratedColumn<String> nom = GeneratedColumn<String>(
    'nom',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TypeLogement, String>
  typeLogement = GeneratedColumn<String>(
    'type_logement',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<TypeLogement>($BiensTable.$convertertypeLogement);
  @override
  late final GeneratedColumnWithTypeConverter<TypeLocation, String>
  typeLocation = GeneratedColumn<String>(
    'type_location',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<TypeLocation>($BiensTable.$convertertypeLocation);
  static const VerificationMeta _rueMeta = const VerificationMeta('rue');
  @override
  late final GeneratedColumn<String> rue = GeneratedColumn<String>(
    'rue',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codePostalMeta = const VerificationMeta(
    'codePostal',
  );
  @override
  late final GeneratedColumn<String> codePostal = GeneratedColumn<String>(
    'code_postal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _villeMeta = const VerificationMeta('ville');
  @override
  late final GeneratedColumn<String> ville = GeneratedColumn<String>(
    'ville',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loyerHcCentimesMeta = const VerificationMeta(
    'loyerHcCentimes',
  );
  @override
  late final GeneratedColumn<int> loyerHcCentimes = GeneratedColumn<int>(
    'loyer_hc_centimes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chargesCentimesMeta = const VerificationMeta(
    'chargesCentimes',
  );
  @override
  late final GeneratedColumn<int> chargesCentimes = GeneratedColumn<int>(
    'charges_centimes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoCheminMeta = const VerificationMeta(
    'photoChemin',
  );
  @override
  late final GeneratedColumn<String> photoChemin = GeneratedColumn<String>(
    'photo_chemin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _surfaceM2Meta = const VerificationMeta(
    'surfaceM2',
  );
  @override
  late final GeneratedColumn<double> surfaceM2 = GeneratedColumn<double>(
    'surface_m2',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ClasseDpe?, String> classeDpe =
      GeneratedColumn<String>(
        'classe_dpe',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<ClasseDpe?>($BiensTable.$converterclasseDpen);
  static const VerificationMeta _dateDpeMeta = const VerificationMeta(
    'dateDpe',
  );
  @override
  late final GeneratedColumn<DateTime> dateDpe = GeneratedColumn<DateTime>(
    'date_dpe',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nombreLotsMeta = const VerificationMeta(
    'nombreLots',
  );
  @override
  late final GeneratedColumn<int> nombreLots = GeneratedColumn<int>(
    'nombre_lots',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _prixAchatCentimesMeta = const VerificationMeta(
    'prixAchatCentimes',
  );
  @override
  late final GeneratedColumn<int> prixAchatCentimes = GeneratedColumn<int>(
    'prix_achat_centimes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fraisNotaireCentimesMeta =
      const VerificationMeta('fraisNotaireCentimes');
  @override
  late final GeneratedColumn<int> fraisNotaireCentimes = GeneratedColumn<int>(
    'frais_notaire_centimes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _travauxInitiauxCentimesMeta =
      const VerificationMeta('travauxInitiauxCentimes');
  @override
  late final GeneratedColumn<int> travauxInitiauxCentimes =
      GeneratedColumn<int>(
        'travaux_initiaux_centimes',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _mensualiteCreditCentimesMeta =
      const VerificationMeta('mensualiteCreditCentimes');
  @override
  late final GeneratedColumn<int> mensualiteCreditCentimes =
      GeneratedColumn<int>(
        'mensualite_credit_centimes',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _taxeFonciereCentimesMeta =
      const VerificationMeta('taxeFonciereCentimes');
  @override
  late final GeneratedColumn<int> taxeFonciereCentimes = GeneratedColumn<int>(
    'taxe_fonciere_centimes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _assuranceCentimesMeta = const VerificationMeta(
    'assuranceCentimes',
  );
  @override
  late final GeneratedColumn<int> assuranceCentimes = GeneratedColumn<int>(
    'assurance_centimes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _chargesNonRecuperablesCentimesMeta =
      const VerificationMeta('chargesNonRecuperablesCentimes');
  @override
  late final GeneratedColumn<int> chargesNonRecuperablesCentimes =
      GeneratedColumn<int>(
        'charges_non_recuperables_centimes',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _fraisDiversCentimesMeta =
      const VerificationMeta('fraisDiversCentimes');
  @override
  late final GeneratedColumn<int> fraisDiversCentimes = GeneratedColumn<int>(
    'frais_divers_centimes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ordreMeta = const VerificationMeta('ordre');
  @override
  late final GeneratedColumn<int> ordre = GeneratedColumn<int>(
    'ordre',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creeLeMeta = const VerificationMeta('creeLe');
  @override
  late final GeneratedColumn<DateTime> creeLe = GeneratedColumn<DateTime>(
    'cree_le',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifieLeMeta = const VerificationMeta(
    'modifieLe',
  );
  @override
  late final GeneratedColumn<DateTime> modifieLe = GeneratedColumn<DateTime>(
    'modifie_le',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nom,
    typeLogement,
    typeLocation,
    rue,
    codePostal,
    ville,
    loyerHcCentimes,
    chargesCentimes,
    photoChemin,
    surfaceM2,
    classeDpe,
    dateDpe,
    nombreLots,
    prixAchatCentimes,
    fraisNotaireCentimes,
    travauxInitiauxCentimes,
    mensualiteCreditCentimes,
    taxeFonciereCentimes,
    assuranceCentimes,
    chargesNonRecuperablesCentimes,
    fraisDiversCentimes,
    ordre,
    creeLe,
    modifieLe,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'biens';
  @override
  VerificationContext validateIntegrity(
    Insertable<Bien> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nom')) {
      context.handle(
        _nomMeta,
        nom.isAcceptableOrUnknown(data['nom']!, _nomMeta),
      );
    } else if (isInserting) {
      context.missing(_nomMeta);
    }
    if (data.containsKey('rue')) {
      context.handle(
        _rueMeta,
        rue.isAcceptableOrUnknown(data['rue']!, _rueMeta),
      );
    } else if (isInserting) {
      context.missing(_rueMeta);
    }
    if (data.containsKey('code_postal')) {
      context.handle(
        _codePostalMeta,
        codePostal.isAcceptableOrUnknown(data['code_postal']!, _codePostalMeta),
      );
    } else if (isInserting) {
      context.missing(_codePostalMeta);
    }
    if (data.containsKey('ville')) {
      context.handle(
        _villeMeta,
        ville.isAcceptableOrUnknown(data['ville']!, _villeMeta),
      );
    } else if (isInserting) {
      context.missing(_villeMeta);
    }
    if (data.containsKey('loyer_hc_centimes')) {
      context.handle(
        _loyerHcCentimesMeta,
        loyerHcCentimes.isAcceptableOrUnknown(
          data['loyer_hc_centimes']!,
          _loyerHcCentimesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_loyerHcCentimesMeta);
    }
    if (data.containsKey('charges_centimes')) {
      context.handle(
        _chargesCentimesMeta,
        chargesCentimes.isAcceptableOrUnknown(
          data['charges_centimes']!,
          _chargesCentimesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_chargesCentimesMeta);
    }
    if (data.containsKey('photo_chemin')) {
      context.handle(
        _photoCheminMeta,
        photoChemin.isAcceptableOrUnknown(
          data['photo_chemin']!,
          _photoCheminMeta,
        ),
      );
    }
    if (data.containsKey('surface_m2')) {
      context.handle(
        _surfaceM2Meta,
        surfaceM2.isAcceptableOrUnknown(data['surface_m2']!, _surfaceM2Meta),
      );
    }
    if (data.containsKey('date_dpe')) {
      context.handle(
        _dateDpeMeta,
        dateDpe.isAcceptableOrUnknown(data['date_dpe']!, _dateDpeMeta),
      );
    }
    if (data.containsKey('nombre_lots')) {
      context.handle(
        _nombreLotsMeta,
        nombreLots.isAcceptableOrUnknown(data['nombre_lots']!, _nombreLotsMeta),
      );
    }
    if (data.containsKey('prix_achat_centimes')) {
      context.handle(
        _prixAchatCentimesMeta,
        prixAchatCentimes.isAcceptableOrUnknown(
          data['prix_achat_centimes']!,
          _prixAchatCentimesMeta,
        ),
      );
    }
    if (data.containsKey('frais_notaire_centimes')) {
      context.handle(
        _fraisNotaireCentimesMeta,
        fraisNotaireCentimes.isAcceptableOrUnknown(
          data['frais_notaire_centimes']!,
          _fraisNotaireCentimesMeta,
        ),
      );
    }
    if (data.containsKey('travaux_initiaux_centimes')) {
      context.handle(
        _travauxInitiauxCentimesMeta,
        travauxInitiauxCentimes.isAcceptableOrUnknown(
          data['travaux_initiaux_centimes']!,
          _travauxInitiauxCentimesMeta,
        ),
      );
    }
    if (data.containsKey('mensualite_credit_centimes')) {
      context.handle(
        _mensualiteCreditCentimesMeta,
        mensualiteCreditCentimes.isAcceptableOrUnknown(
          data['mensualite_credit_centimes']!,
          _mensualiteCreditCentimesMeta,
        ),
      );
    }
    if (data.containsKey('taxe_fonciere_centimes')) {
      context.handle(
        _taxeFonciereCentimesMeta,
        taxeFonciereCentimes.isAcceptableOrUnknown(
          data['taxe_fonciere_centimes']!,
          _taxeFonciereCentimesMeta,
        ),
      );
    }
    if (data.containsKey('assurance_centimes')) {
      context.handle(
        _assuranceCentimesMeta,
        assuranceCentimes.isAcceptableOrUnknown(
          data['assurance_centimes']!,
          _assuranceCentimesMeta,
        ),
      );
    }
    if (data.containsKey('charges_non_recuperables_centimes')) {
      context.handle(
        _chargesNonRecuperablesCentimesMeta,
        chargesNonRecuperablesCentimes.isAcceptableOrUnknown(
          data['charges_non_recuperables_centimes']!,
          _chargesNonRecuperablesCentimesMeta,
        ),
      );
    }
    if (data.containsKey('frais_divers_centimes')) {
      context.handle(
        _fraisDiversCentimesMeta,
        fraisDiversCentimes.isAcceptableOrUnknown(
          data['frais_divers_centimes']!,
          _fraisDiversCentimesMeta,
        ),
      );
    }
    if (data.containsKey('ordre')) {
      context.handle(
        _ordreMeta,
        ordre.isAcceptableOrUnknown(data['ordre']!, _ordreMeta),
      );
    } else if (isInserting) {
      context.missing(_ordreMeta);
    }
    if (data.containsKey('cree_le')) {
      context.handle(
        _creeLeMeta,
        creeLe.isAcceptableOrUnknown(data['cree_le']!, _creeLeMeta),
      );
    } else if (isInserting) {
      context.missing(_creeLeMeta);
    }
    if (data.containsKey('modifie_le')) {
      context.handle(
        _modifieLeMeta,
        modifieLe.isAcceptableOrUnknown(data['modifie_le']!, _modifieLeMeta),
      );
    } else if (isInserting) {
      context.missing(_modifieLeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Bien map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bien(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nom'],
      )!,
      typeLogement: $BiensTable.$convertertypeLogement.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type_logement'],
        )!,
      ),
      typeLocation: $BiensTable.$convertertypeLocation.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type_location'],
        )!,
      ),
      rue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rue'],
      )!,
      codePostal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code_postal'],
      )!,
      ville: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ville'],
      )!,
      loyerHcCentimes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}loyer_hc_centimes'],
      )!,
      chargesCentimes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}charges_centimes'],
      )!,
      photoChemin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_chemin'],
      ),
      surfaceM2: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}surface_m2'],
      ),
      classeDpe: $BiensTable.$converterclasseDpen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}classe_dpe'],
        ),
      ),
      dateDpe: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_dpe'],
      ),
      nombreLots: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nombre_lots'],
      ),
      prixAchatCentimes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prix_achat_centimes'],
      ),
      fraisNotaireCentimes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}frais_notaire_centimes'],
      ),
      travauxInitiauxCentimes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}travaux_initiaux_centimes'],
      ),
      mensualiteCreditCentimes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mensualite_credit_centimes'],
      ),
      taxeFonciereCentimes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}taxe_fonciere_centimes'],
      ),
      assuranceCentimes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}assurance_centimes'],
      ),
      chargesNonRecuperablesCentimes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}charges_non_recuperables_centimes'],
      ),
      fraisDiversCentimes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}frais_divers_centimes'],
      ),
      ordre: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ordre'],
      )!,
      creeLe: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cree_le'],
      )!,
      modifieLe: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modifie_le'],
      )!,
    );
  }

  @override
  $BiensTable createAlias(String alias) {
    return $BiensTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TypeLogement, String, String>
  $convertertypeLogement = const EnumNameConverter<TypeLogement>(
    TypeLogement.values,
  );
  static JsonTypeConverter2<TypeLocation, String, String>
  $convertertypeLocation = const EnumNameConverter<TypeLocation>(
    TypeLocation.values,
  );
  static JsonTypeConverter2<ClasseDpe, String, String> $converterclasseDpe =
      const EnumNameConverter<ClasseDpe>(ClasseDpe.values);
  static JsonTypeConverter2<ClasseDpe?, String?, String?> $converterclasseDpen =
      JsonTypeConverter2.asNullable($converterclasseDpe);
}

class BiensCompanion extends UpdateCompanion<Bien> {
  final Value<String> id;
  final Value<String> nom;
  final Value<TypeLogement> typeLogement;
  final Value<TypeLocation> typeLocation;
  final Value<String> rue;
  final Value<String> codePostal;
  final Value<String> ville;
  final Value<int> loyerHcCentimes;
  final Value<int> chargesCentimes;
  final Value<String?> photoChemin;
  final Value<double?> surfaceM2;
  final Value<ClasseDpe?> classeDpe;
  final Value<DateTime?> dateDpe;
  final Value<int?> nombreLots;
  final Value<int?> prixAchatCentimes;
  final Value<int?> fraisNotaireCentimes;
  final Value<int?> travauxInitiauxCentimes;
  final Value<int?> mensualiteCreditCentimes;
  final Value<int?> taxeFonciereCentimes;
  final Value<int?> assuranceCentimes;
  final Value<int?> chargesNonRecuperablesCentimes;
  final Value<int?> fraisDiversCentimes;
  final Value<int> ordre;
  final Value<DateTime> creeLe;
  final Value<DateTime> modifieLe;
  final Value<int> rowid;
  const BiensCompanion({
    this.id = const Value.absent(),
    this.nom = const Value.absent(),
    this.typeLogement = const Value.absent(),
    this.typeLocation = const Value.absent(),
    this.rue = const Value.absent(),
    this.codePostal = const Value.absent(),
    this.ville = const Value.absent(),
    this.loyerHcCentimes = const Value.absent(),
    this.chargesCentimes = const Value.absent(),
    this.photoChemin = const Value.absent(),
    this.surfaceM2 = const Value.absent(),
    this.classeDpe = const Value.absent(),
    this.dateDpe = const Value.absent(),
    this.nombreLots = const Value.absent(),
    this.prixAchatCentimes = const Value.absent(),
    this.fraisNotaireCentimes = const Value.absent(),
    this.travauxInitiauxCentimes = const Value.absent(),
    this.mensualiteCreditCentimes = const Value.absent(),
    this.taxeFonciereCentimes = const Value.absent(),
    this.assuranceCentimes = const Value.absent(),
    this.chargesNonRecuperablesCentimes = const Value.absent(),
    this.fraisDiversCentimes = const Value.absent(),
    this.ordre = const Value.absent(),
    this.creeLe = const Value.absent(),
    this.modifieLe = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BiensCompanion.insert({
    required String id,
    required String nom,
    required TypeLogement typeLogement,
    required TypeLocation typeLocation,
    required String rue,
    required String codePostal,
    required String ville,
    required int loyerHcCentimes,
    required int chargesCentimes,
    this.photoChemin = const Value.absent(),
    this.surfaceM2 = const Value.absent(),
    this.classeDpe = const Value.absent(),
    this.dateDpe = const Value.absent(),
    this.nombreLots = const Value.absent(),
    this.prixAchatCentimes = const Value.absent(),
    this.fraisNotaireCentimes = const Value.absent(),
    this.travauxInitiauxCentimes = const Value.absent(),
    this.mensualiteCreditCentimes = const Value.absent(),
    this.taxeFonciereCentimes = const Value.absent(),
    this.assuranceCentimes = const Value.absent(),
    this.chargesNonRecuperablesCentimes = const Value.absent(),
    this.fraisDiversCentimes = const Value.absent(),
    required int ordre,
    required DateTime creeLe,
    required DateTime modifieLe,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nom = Value(nom),
       typeLogement = Value(typeLogement),
       typeLocation = Value(typeLocation),
       rue = Value(rue),
       codePostal = Value(codePostal),
       ville = Value(ville),
       loyerHcCentimes = Value(loyerHcCentimes),
       chargesCentimes = Value(chargesCentimes),
       ordre = Value(ordre),
       creeLe = Value(creeLe),
       modifieLe = Value(modifieLe);
  static Insertable<Bien> custom({
    Expression<String>? id,
    Expression<String>? nom,
    Expression<String>? typeLogement,
    Expression<String>? typeLocation,
    Expression<String>? rue,
    Expression<String>? codePostal,
    Expression<String>? ville,
    Expression<int>? loyerHcCentimes,
    Expression<int>? chargesCentimes,
    Expression<String>? photoChemin,
    Expression<double>? surfaceM2,
    Expression<String>? classeDpe,
    Expression<DateTime>? dateDpe,
    Expression<int>? nombreLots,
    Expression<int>? prixAchatCentimes,
    Expression<int>? fraisNotaireCentimes,
    Expression<int>? travauxInitiauxCentimes,
    Expression<int>? mensualiteCreditCentimes,
    Expression<int>? taxeFonciereCentimes,
    Expression<int>? assuranceCentimes,
    Expression<int>? chargesNonRecuperablesCentimes,
    Expression<int>? fraisDiversCentimes,
    Expression<int>? ordre,
    Expression<DateTime>? creeLe,
    Expression<DateTime>? modifieLe,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nom != null) 'nom': nom,
      if (typeLogement != null) 'type_logement': typeLogement,
      if (typeLocation != null) 'type_location': typeLocation,
      if (rue != null) 'rue': rue,
      if (codePostal != null) 'code_postal': codePostal,
      if (ville != null) 'ville': ville,
      if (loyerHcCentimes != null) 'loyer_hc_centimes': loyerHcCentimes,
      if (chargesCentimes != null) 'charges_centimes': chargesCentimes,
      if (photoChemin != null) 'photo_chemin': photoChemin,
      if (surfaceM2 != null) 'surface_m2': surfaceM2,
      if (classeDpe != null) 'classe_dpe': classeDpe,
      if (dateDpe != null) 'date_dpe': dateDpe,
      if (nombreLots != null) 'nombre_lots': nombreLots,
      if (prixAchatCentimes != null) 'prix_achat_centimes': prixAchatCentimes,
      if (fraisNotaireCentimes != null)
        'frais_notaire_centimes': fraisNotaireCentimes,
      if (travauxInitiauxCentimes != null)
        'travaux_initiaux_centimes': travauxInitiauxCentimes,
      if (mensualiteCreditCentimes != null)
        'mensualite_credit_centimes': mensualiteCreditCentimes,
      if (taxeFonciereCentimes != null)
        'taxe_fonciere_centimes': taxeFonciereCentimes,
      if (assuranceCentimes != null) 'assurance_centimes': assuranceCentimes,
      if (chargesNonRecuperablesCentimes != null)
        'charges_non_recuperables_centimes': chargesNonRecuperablesCentimes,
      if (fraisDiversCentimes != null)
        'frais_divers_centimes': fraisDiversCentimes,
      if (ordre != null) 'ordre': ordre,
      if (creeLe != null) 'cree_le': creeLe,
      if (modifieLe != null) 'modifie_le': modifieLe,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BiensCompanion copyWith({
    Value<String>? id,
    Value<String>? nom,
    Value<TypeLogement>? typeLogement,
    Value<TypeLocation>? typeLocation,
    Value<String>? rue,
    Value<String>? codePostal,
    Value<String>? ville,
    Value<int>? loyerHcCentimes,
    Value<int>? chargesCentimes,
    Value<String?>? photoChemin,
    Value<double?>? surfaceM2,
    Value<ClasseDpe?>? classeDpe,
    Value<DateTime?>? dateDpe,
    Value<int?>? nombreLots,
    Value<int?>? prixAchatCentimes,
    Value<int?>? fraisNotaireCentimes,
    Value<int?>? travauxInitiauxCentimes,
    Value<int?>? mensualiteCreditCentimes,
    Value<int?>? taxeFonciereCentimes,
    Value<int?>? assuranceCentimes,
    Value<int?>? chargesNonRecuperablesCentimes,
    Value<int?>? fraisDiversCentimes,
    Value<int>? ordre,
    Value<DateTime>? creeLe,
    Value<DateTime>? modifieLe,
    Value<int>? rowid,
  }) {
    return BiensCompanion(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      typeLogement: typeLogement ?? this.typeLogement,
      typeLocation: typeLocation ?? this.typeLocation,
      rue: rue ?? this.rue,
      codePostal: codePostal ?? this.codePostal,
      ville: ville ?? this.ville,
      loyerHcCentimes: loyerHcCentimes ?? this.loyerHcCentimes,
      chargesCentimes: chargesCentimes ?? this.chargesCentimes,
      photoChemin: photoChemin ?? this.photoChemin,
      surfaceM2: surfaceM2 ?? this.surfaceM2,
      classeDpe: classeDpe ?? this.classeDpe,
      dateDpe: dateDpe ?? this.dateDpe,
      nombreLots: nombreLots ?? this.nombreLots,
      prixAchatCentimes: prixAchatCentimes ?? this.prixAchatCentimes,
      fraisNotaireCentimes: fraisNotaireCentimes ?? this.fraisNotaireCentimes,
      travauxInitiauxCentimes:
          travauxInitiauxCentimes ?? this.travauxInitiauxCentimes,
      mensualiteCreditCentimes:
          mensualiteCreditCentimes ?? this.mensualiteCreditCentimes,
      taxeFonciereCentimes: taxeFonciereCentimes ?? this.taxeFonciereCentimes,
      assuranceCentimes: assuranceCentimes ?? this.assuranceCentimes,
      chargesNonRecuperablesCentimes:
          chargesNonRecuperablesCentimes ?? this.chargesNonRecuperablesCentimes,
      fraisDiversCentimes: fraisDiversCentimes ?? this.fraisDiversCentimes,
      ordre: ordre ?? this.ordre,
      creeLe: creeLe ?? this.creeLe,
      modifieLe: modifieLe ?? this.modifieLe,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nom.present) {
      map['nom'] = Variable<String>(nom.value);
    }
    if (typeLogement.present) {
      map['type_logement'] = Variable<String>(
        $BiensTable.$convertertypeLogement.toSql(typeLogement.value),
      );
    }
    if (typeLocation.present) {
      map['type_location'] = Variable<String>(
        $BiensTable.$convertertypeLocation.toSql(typeLocation.value),
      );
    }
    if (rue.present) {
      map['rue'] = Variable<String>(rue.value);
    }
    if (codePostal.present) {
      map['code_postal'] = Variable<String>(codePostal.value);
    }
    if (ville.present) {
      map['ville'] = Variable<String>(ville.value);
    }
    if (loyerHcCentimes.present) {
      map['loyer_hc_centimes'] = Variable<int>(loyerHcCentimes.value);
    }
    if (chargesCentimes.present) {
      map['charges_centimes'] = Variable<int>(chargesCentimes.value);
    }
    if (photoChemin.present) {
      map['photo_chemin'] = Variable<String>(photoChemin.value);
    }
    if (surfaceM2.present) {
      map['surface_m2'] = Variable<double>(surfaceM2.value);
    }
    if (classeDpe.present) {
      map['classe_dpe'] = Variable<String>(
        $BiensTable.$converterclasseDpen.toSql(classeDpe.value),
      );
    }
    if (dateDpe.present) {
      map['date_dpe'] = Variable<DateTime>(dateDpe.value);
    }
    if (nombreLots.present) {
      map['nombre_lots'] = Variable<int>(nombreLots.value);
    }
    if (prixAchatCentimes.present) {
      map['prix_achat_centimes'] = Variable<int>(prixAchatCentimes.value);
    }
    if (fraisNotaireCentimes.present) {
      map['frais_notaire_centimes'] = Variable<int>(fraisNotaireCentimes.value);
    }
    if (travauxInitiauxCentimes.present) {
      map['travaux_initiaux_centimes'] = Variable<int>(
        travauxInitiauxCentimes.value,
      );
    }
    if (mensualiteCreditCentimes.present) {
      map['mensualite_credit_centimes'] = Variable<int>(
        mensualiteCreditCentimes.value,
      );
    }
    if (taxeFonciereCentimes.present) {
      map['taxe_fonciere_centimes'] = Variable<int>(taxeFonciereCentimes.value);
    }
    if (assuranceCentimes.present) {
      map['assurance_centimes'] = Variable<int>(assuranceCentimes.value);
    }
    if (chargesNonRecuperablesCentimes.present) {
      map['charges_non_recuperables_centimes'] = Variable<int>(
        chargesNonRecuperablesCentimes.value,
      );
    }
    if (fraisDiversCentimes.present) {
      map['frais_divers_centimes'] = Variable<int>(fraisDiversCentimes.value);
    }
    if (ordre.present) {
      map['ordre'] = Variable<int>(ordre.value);
    }
    if (creeLe.present) {
      map['cree_le'] = Variable<DateTime>(creeLe.value);
    }
    if (modifieLe.present) {
      map['modifie_le'] = Variable<DateTime>(modifieLe.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BiensCompanion(')
          ..write('id: $id, ')
          ..write('nom: $nom, ')
          ..write('typeLogement: $typeLogement, ')
          ..write('typeLocation: $typeLocation, ')
          ..write('rue: $rue, ')
          ..write('codePostal: $codePostal, ')
          ..write('ville: $ville, ')
          ..write('loyerHcCentimes: $loyerHcCentimes, ')
          ..write('chargesCentimes: $chargesCentimes, ')
          ..write('photoChemin: $photoChemin, ')
          ..write('surfaceM2: $surfaceM2, ')
          ..write('classeDpe: $classeDpe, ')
          ..write('dateDpe: $dateDpe, ')
          ..write('nombreLots: $nombreLots, ')
          ..write('prixAchatCentimes: $prixAchatCentimes, ')
          ..write('fraisNotaireCentimes: $fraisNotaireCentimes, ')
          ..write('travauxInitiauxCentimes: $travauxInitiauxCentimes, ')
          ..write('mensualiteCreditCentimes: $mensualiteCreditCentimes, ')
          ..write('taxeFonciereCentimes: $taxeFonciereCentimes, ')
          ..write('assuranceCentimes: $assuranceCentimes, ')
          ..write(
            'chargesNonRecuperablesCentimes: $chargesNonRecuperablesCentimes, ',
          )
          ..write('fraisDiversCentimes: $fraisDiversCentimes, ')
          ..write('ordre: $ordre, ')
          ..write('creeLe: $creeLe, ')
          ..write('modifieLe: $modifieLe, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$BienInsertable implements Insertable<Bien> {
  Bien _object;
  _$BienInsertable(this._object);
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return BiensCompanion(
      id: Value(_object.id),
      nom: Value(_object.nom),
      typeLogement: Value(_object.typeLogement),
      typeLocation: Value(_object.typeLocation),
      rue: Value(_object.rue),
      codePostal: Value(_object.codePostal),
      ville: Value(_object.ville),
      loyerHcCentimes: Value(_object.loyerHcCentimes),
      chargesCentimes: Value(_object.chargesCentimes),
      photoChemin: Value(_object.photoChemin),
      surfaceM2: Value(_object.surfaceM2),
      classeDpe: Value(_object.classeDpe),
      dateDpe: Value(_object.dateDpe),
      nombreLots: Value(_object.nombreLots),
      prixAchatCentimes: Value(_object.prixAchatCentimes),
      fraisNotaireCentimes: Value(_object.fraisNotaireCentimes),
      travauxInitiauxCentimes: Value(_object.travauxInitiauxCentimes),
      mensualiteCreditCentimes: Value(_object.mensualiteCreditCentimes),
      taxeFonciereCentimes: Value(_object.taxeFonciereCentimes),
      assuranceCentimes: Value(_object.assuranceCentimes),
      chargesNonRecuperablesCentimes: Value(
        _object.chargesNonRecuperablesCentimes,
      ),
      fraisDiversCentimes: Value(_object.fraisDiversCentimes),
      ordre: Value(_object.ordre),
      creeLe: Value(_object.creeLe),
      modifieLe: Value(_object.modifieLe),
    ).toColumns(false);
  }
}

extension BienToInsertable on Bien {
  _$BienInsertable toInsertable() {
    return _$BienInsertable(this);
  }
}

class $BauxTable extends Baux with TableInfo<$BauxTable, Bail> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BauxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bienIdMeta = const VerificationMeta('bienId');
  @override
  late final GeneratedColumn<String> bienId = GeneratedColumn<String>(
    'bien_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES biens (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TypeBail, String> typeBail =
      GeneratedColumn<String>(
        'type_bail',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TypeBail>($BauxTable.$convertertypeBail);
  static const VerificationMeta _dateDebutMeta = const VerificationMeta(
    'dateDebut',
  );
  @override
  late final GeneratedColumn<DateTime> dateDebut = GeneratedColumn<DateTime>(
    'date_debut',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dureeMoisMeta = const VerificationMeta(
    'dureeMois',
  );
  @override
  late final GeneratedColumn<int> dureeMois = GeneratedColumn<int>(
    'duree_mois',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _depotGarantieCentimesMeta =
      const VerificationMeta('depotGarantieCentimes');
  @override
  late final GeneratedColumn<int> depotGarantieCentimes = GeneratedColumn<int>(
    'depot_garantie_centimes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateRevisionMeta = const VerificationMeta(
    'dateRevision',
  );
  @override
  late final GeneratedColumn<DateTime> dateRevision = GeneratedColumn<DateTime>(
    'date_revision',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _irlTrimestreMeta = const VerificationMeta(
    'irlTrimestre',
  );
  @override
  late final GeneratedColumn<int> irlTrimestre = GeneratedColumn<int>(
    'irl_trimestre',
    aliasedName,
    true,
    check: () => ComparableExpr(irlTrimestre).isBetweenValues(1, 4),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _irlAnneeMeta = const VerificationMeta(
    'irlAnnee',
  );
  @override
  late final GeneratedColumn<int> irlAnnee = GeneratedColumn<int>(
    'irl_annee',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _irlValeurMeta = const VerificationMeta(
    'irlValeur',
  );
  @override
  late final GeneratedColumn<double> irlValeur = GeneratedColumn<double>(
    'irl_valeur',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actifMeta = const VerificationMeta('actif');
  @override
  late final GeneratedColumn<bool> actif = GeneratedColumn<bool>(
    'actif',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("actif" IN (0, 1))',
    ),
  );
  static const VerificationMeta _creeLeMeta = const VerificationMeta('creeLe');
  @override
  late final GeneratedColumn<DateTime> creeLe = GeneratedColumn<DateTime>(
    'cree_le',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifieLeMeta = const VerificationMeta(
    'modifieLe',
  );
  @override
  late final GeneratedColumn<DateTime> modifieLe = GeneratedColumn<DateTime>(
    'modifie_le',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bienId,
    typeBail,
    dateDebut,
    dureeMois,
    depotGarantieCentimes,
    dateRevision,
    irlTrimestre,
    irlAnnee,
    irlValeur,
    actif,
    creeLe,
    modifieLe,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'baux';
  @override
  VerificationContext validateIntegrity(
    Insertable<Bail> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('bien_id')) {
      context.handle(
        _bienIdMeta,
        bienId.isAcceptableOrUnknown(data['bien_id']!, _bienIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bienIdMeta);
    }
    if (data.containsKey('date_debut')) {
      context.handle(
        _dateDebutMeta,
        dateDebut.isAcceptableOrUnknown(data['date_debut']!, _dateDebutMeta),
      );
    } else if (isInserting) {
      context.missing(_dateDebutMeta);
    }
    if (data.containsKey('duree_mois')) {
      context.handle(
        _dureeMoisMeta,
        dureeMois.isAcceptableOrUnknown(data['duree_mois']!, _dureeMoisMeta),
      );
    }
    if (data.containsKey('depot_garantie_centimes')) {
      context.handle(
        _depotGarantieCentimesMeta,
        depotGarantieCentimes.isAcceptableOrUnknown(
          data['depot_garantie_centimes']!,
          _depotGarantieCentimesMeta,
        ),
      );
    }
    if (data.containsKey('date_revision')) {
      context.handle(
        _dateRevisionMeta,
        dateRevision.isAcceptableOrUnknown(
          data['date_revision']!,
          _dateRevisionMeta,
        ),
      );
    }
    if (data.containsKey('irl_trimestre')) {
      context.handle(
        _irlTrimestreMeta,
        irlTrimestre.isAcceptableOrUnknown(
          data['irl_trimestre']!,
          _irlTrimestreMeta,
        ),
      );
    }
    if (data.containsKey('irl_annee')) {
      context.handle(
        _irlAnneeMeta,
        irlAnnee.isAcceptableOrUnknown(data['irl_annee']!, _irlAnneeMeta),
      );
    }
    if (data.containsKey('irl_valeur')) {
      context.handle(
        _irlValeurMeta,
        irlValeur.isAcceptableOrUnknown(data['irl_valeur']!, _irlValeurMeta),
      );
    }
    if (data.containsKey('actif')) {
      context.handle(
        _actifMeta,
        actif.isAcceptableOrUnknown(data['actif']!, _actifMeta),
      );
    } else if (isInserting) {
      context.missing(_actifMeta);
    }
    if (data.containsKey('cree_le')) {
      context.handle(
        _creeLeMeta,
        creeLe.isAcceptableOrUnknown(data['cree_le']!, _creeLeMeta),
      );
    } else if (isInserting) {
      context.missing(_creeLeMeta);
    }
    if (data.containsKey('modifie_le')) {
      context.handle(
        _modifieLeMeta,
        modifieLe.isAcceptableOrUnknown(data['modifie_le']!, _modifieLeMeta),
      );
    } else if (isInserting) {
      context.missing(_modifieLeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Bail map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bail(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bienId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bien_id'],
      )!,
      typeBail: $BauxTable.$convertertypeBail.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type_bail'],
        )!,
      ),
      dateDebut: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_debut'],
      )!,
      dureeMois: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duree_mois'],
      ),
      depotGarantieCentimes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}depot_garantie_centimes'],
      ),
      dateRevision: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_revision'],
      ),
      irlTrimestre: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}irl_trimestre'],
      ),
      irlAnnee: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}irl_annee'],
      ),
      irlValeur: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}irl_valeur'],
      ),
      actif: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}actif'],
      )!,
      creeLe: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cree_le'],
      )!,
      modifieLe: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modifie_le'],
      )!,
    );
  }

  @override
  $BauxTable createAlias(String alias) {
    return $BauxTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TypeBail, String, String> $convertertypeBail =
      const EnumNameConverter<TypeBail>(TypeBail.values);
}

class BauxCompanion extends UpdateCompanion<Bail> {
  final Value<String> id;
  final Value<String> bienId;
  final Value<TypeBail> typeBail;
  final Value<DateTime> dateDebut;
  final Value<int?> dureeMois;
  final Value<int?> depotGarantieCentimes;
  final Value<DateTime?> dateRevision;
  final Value<int?> irlTrimestre;
  final Value<int?> irlAnnee;
  final Value<double?> irlValeur;
  final Value<bool> actif;
  final Value<DateTime> creeLe;
  final Value<DateTime> modifieLe;
  final Value<int> rowid;
  const BauxCompanion({
    this.id = const Value.absent(),
    this.bienId = const Value.absent(),
    this.typeBail = const Value.absent(),
    this.dateDebut = const Value.absent(),
    this.dureeMois = const Value.absent(),
    this.depotGarantieCentimes = const Value.absent(),
    this.dateRevision = const Value.absent(),
    this.irlTrimestre = const Value.absent(),
    this.irlAnnee = const Value.absent(),
    this.irlValeur = const Value.absent(),
    this.actif = const Value.absent(),
    this.creeLe = const Value.absent(),
    this.modifieLe = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BauxCompanion.insert({
    required String id,
    required String bienId,
    required TypeBail typeBail,
    required DateTime dateDebut,
    this.dureeMois = const Value.absent(),
    this.depotGarantieCentimes = const Value.absent(),
    this.dateRevision = const Value.absent(),
    this.irlTrimestre = const Value.absent(),
    this.irlAnnee = const Value.absent(),
    this.irlValeur = const Value.absent(),
    required bool actif,
    required DateTime creeLe,
    required DateTime modifieLe,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bienId = Value(bienId),
       typeBail = Value(typeBail),
       dateDebut = Value(dateDebut),
       actif = Value(actif),
       creeLe = Value(creeLe),
       modifieLe = Value(modifieLe);
  static Insertable<Bail> custom({
    Expression<String>? id,
    Expression<String>? bienId,
    Expression<String>? typeBail,
    Expression<DateTime>? dateDebut,
    Expression<int>? dureeMois,
    Expression<int>? depotGarantieCentimes,
    Expression<DateTime>? dateRevision,
    Expression<int>? irlTrimestre,
    Expression<int>? irlAnnee,
    Expression<double>? irlValeur,
    Expression<bool>? actif,
    Expression<DateTime>? creeLe,
    Expression<DateTime>? modifieLe,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bienId != null) 'bien_id': bienId,
      if (typeBail != null) 'type_bail': typeBail,
      if (dateDebut != null) 'date_debut': dateDebut,
      if (dureeMois != null) 'duree_mois': dureeMois,
      if (depotGarantieCentimes != null)
        'depot_garantie_centimes': depotGarantieCentimes,
      if (dateRevision != null) 'date_revision': dateRevision,
      if (irlTrimestre != null) 'irl_trimestre': irlTrimestre,
      if (irlAnnee != null) 'irl_annee': irlAnnee,
      if (irlValeur != null) 'irl_valeur': irlValeur,
      if (actif != null) 'actif': actif,
      if (creeLe != null) 'cree_le': creeLe,
      if (modifieLe != null) 'modifie_le': modifieLe,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BauxCompanion copyWith({
    Value<String>? id,
    Value<String>? bienId,
    Value<TypeBail>? typeBail,
    Value<DateTime>? dateDebut,
    Value<int?>? dureeMois,
    Value<int?>? depotGarantieCentimes,
    Value<DateTime?>? dateRevision,
    Value<int?>? irlTrimestre,
    Value<int?>? irlAnnee,
    Value<double?>? irlValeur,
    Value<bool>? actif,
    Value<DateTime>? creeLe,
    Value<DateTime>? modifieLe,
    Value<int>? rowid,
  }) {
    return BauxCompanion(
      id: id ?? this.id,
      bienId: bienId ?? this.bienId,
      typeBail: typeBail ?? this.typeBail,
      dateDebut: dateDebut ?? this.dateDebut,
      dureeMois: dureeMois ?? this.dureeMois,
      depotGarantieCentimes:
          depotGarantieCentimes ?? this.depotGarantieCentimes,
      dateRevision: dateRevision ?? this.dateRevision,
      irlTrimestre: irlTrimestre ?? this.irlTrimestre,
      irlAnnee: irlAnnee ?? this.irlAnnee,
      irlValeur: irlValeur ?? this.irlValeur,
      actif: actif ?? this.actif,
      creeLe: creeLe ?? this.creeLe,
      modifieLe: modifieLe ?? this.modifieLe,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bienId.present) {
      map['bien_id'] = Variable<String>(bienId.value);
    }
    if (typeBail.present) {
      map['type_bail'] = Variable<String>(
        $BauxTable.$convertertypeBail.toSql(typeBail.value),
      );
    }
    if (dateDebut.present) {
      map['date_debut'] = Variable<DateTime>(dateDebut.value);
    }
    if (dureeMois.present) {
      map['duree_mois'] = Variable<int>(dureeMois.value);
    }
    if (depotGarantieCentimes.present) {
      map['depot_garantie_centimes'] = Variable<int>(
        depotGarantieCentimes.value,
      );
    }
    if (dateRevision.present) {
      map['date_revision'] = Variable<DateTime>(dateRevision.value);
    }
    if (irlTrimestre.present) {
      map['irl_trimestre'] = Variable<int>(irlTrimestre.value);
    }
    if (irlAnnee.present) {
      map['irl_annee'] = Variable<int>(irlAnnee.value);
    }
    if (irlValeur.present) {
      map['irl_valeur'] = Variable<double>(irlValeur.value);
    }
    if (actif.present) {
      map['actif'] = Variable<bool>(actif.value);
    }
    if (creeLe.present) {
      map['cree_le'] = Variable<DateTime>(creeLe.value);
    }
    if (modifieLe.present) {
      map['modifie_le'] = Variable<DateTime>(modifieLe.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BauxCompanion(')
          ..write('id: $id, ')
          ..write('bienId: $bienId, ')
          ..write('typeBail: $typeBail, ')
          ..write('dateDebut: $dateDebut, ')
          ..write('dureeMois: $dureeMois, ')
          ..write('depotGarantieCentimes: $depotGarantieCentimes, ')
          ..write('dateRevision: $dateRevision, ')
          ..write('irlTrimestre: $irlTrimestre, ')
          ..write('irlAnnee: $irlAnnee, ')
          ..write('irlValeur: $irlValeur, ')
          ..write('actif: $actif, ')
          ..write('creeLe: $creeLe, ')
          ..write('modifieLe: $modifieLe, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$BailInsertable implements Insertable<Bail> {
  Bail _object;
  _$BailInsertable(this._object);
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return BauxCompanion(
      id: Value(_object.id),
      bienId: Value(_object.bienId),
      typeBail: Value(_object.typeBail),
      dateDebut: Value(_object.dateDebut),
      dureeMois: Value(_object.dureeMois),
      depotGarantieCentimes: Value(_object.depotGarantieCentimes),
      dateRevision: Value(_object.dateRevision),
      irlTrimestre: Value(_object.irlTrimestre),
      irlAnnee: Value(_object.irlAnnee),
      irlValeur: Value(_object.irlValeur),
      actif: Value(_object.actif),
      creeLe: Value(_object.creeLe),
      modifieLe: Value(_object.modifieLe),
    ).toColumns(false);
  }
}

extension BailToInsertable on Bail {
  _$BailInsertable toInsertable() {
    return _$BailInsertable(this);
  }
}

class $LocatairesTable extends Locataires
    with TableInfo<$LocatairesTable, Locataire> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocatairesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bailIdMeta = const VerificationMeta('bailId');
  @override
  late final GeneratedColumn<String> bailId = GeneratedColumn<String>(
    'bail_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES baux (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _prenomMeta = const VerificationMeta('prenom');
  @override
  late final GeneratedColumn<String> prenom = GeneratedColumn<String>(
    'prenom',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nomMeta = const VerificationMeta('nom');
  @override
  late final GeneratedColumn<String> nom = GeneratedColumn<String>(
    'nom',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _telephoneMeta = const VerificationMeta(
    'telephone',
  );
  @override
  late final GeneratedColumn<String> telephone = GeneratedColumn<String>(
    'telephone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _creeLeMeta = const VerificationMeta('creeLe');
  @override
  late final GeneratedColumn<DateTime> creeLe = GeneratedColumn<DateTime>(
    'cree_le',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifieLeMeta = const VerificationMeta(
    'modifieLe',
  );
  @override
  late final GeneratedColumn<DateTime> modifieLe = GeneratedColumn<DateTime>(
    'modifie_le',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bailId,
    prenom,
    nom,
    telephone,
    email,
    creeLe,
    modifieLe,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'locataires';
  @override
  VerificationContext validateIntegrity(
    Insertable<Locataire> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('bail_id')) {
      context.handle(
        _bailIdMeta,
        bailId.isAcceptableOrUnknown(data['bail_id']!, _bailIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bailIdMeta);
    }
    if (data.containsKey('prenom')) {
      context.handle(
        _prenomMeta,
        prenom.isAcceptableOrUnknown(data['prenom']!, _prenomMeta),
      );
    } else if (isInserting) {
      context.missing(_prenomMeta);
    }
    if (data.containsKey('nom')) {
      context.handle(
        _nomMeta,
        nom.isAcceptableOrUnknown(data['nom']!, _nomMeta),
      );
    } else if (isInserting) {
      context.missing(_nomMeta);
    }
    if (data.containsKey('telephone')) {
      context.handle(
        _telephoneMeta,
        telephone.isAcceptableOrUnknown(data['telephone']!, _telephoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('cree_le')) {
      context.handle(
        _creeLeMeta,
        creeLe.isAcceptableOrUnknown(data['cree_le']!, _creeLeMeta),
      );
    } else if (isInserting) {
      context.missing(_creeLeMeta);
    }
    if (data.containsKey('modifie_le')) {
      context.handle(
        _modifieLeMeta,
        modifieLe.isAcceptableOrUnknown(data['modifie_le']!, _modifieLeMeta),
      );
    } else if (isInserting) {
      context.missing(_modifieLeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Locataire map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Locataire(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bailId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bail_id'],
      )!,
      prenom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prenom'],
      )!,
      nom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nom'],
      )!,
      telephone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telephone'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      creeLe: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cree_le'],
      )!,
      modifieLe: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modifie_le'],
      )!,
    );
  }

  @override
  $LocatairesTable createAlias(String alias) {
    return $LocatairesTable(attachedDatabase, alias);
  }
}

class LocatairesCompanion extends UpdateCompanion<Locataire> {
  final Value<String> id;
  final Value<String> bailId;
  final Value<String> prenom;
  final Value<String> nom;
  final Value<String?> telephone;
  final Value<String?> email;
  final Value<DateTime> creeLe;
  final Value<DateTime> modifieLe;
  final Value<int> rowid;
  const LocatairesCompanion({
    this.id = const Value.absent(),
    this.bailId = const Value.absent(),
    this.prenom = const Value.absent(),
    this.nom = const Value.absent(),
    this.telephone = const Value.absent(),
    this.email = const Value.absent(),
    this.creeLe = const Value.absent(),
    this.modifieLe = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocatairesCompanion.insert({
    required String id,
    required String bailId,
    required String prenom,
    required String nom,
    this.telephone = const Value.absent(),
    this.email = const Value.absent(),
    required DateTime creeLe,
    required DateTime modifieLe,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bailId = Value(bailId),
       prenom = Value(prenom),
       nom = Value(nom),
       creeLe = Value(creeLe),
       modifieLe = Value(modifieLe);
  static Insertable<Locataire> custom({
    Expression<String>? id,
    Expression<String>? bailId,
    Expression<String>? prenom,
    Expression<String>? nom,
    Expression<String>? telephone,
    Expression<String>? email,
    Expression<DateTime>? creeLe,
    Expression<DateTime>? modifieLe,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bailId != null) 'bail_id': bailId,
      if (prenom != null) 'prenom': prenom,
      if (nom != null) 'nom': nom,
      if (telephone != null) 'telephone': telephone,
      if (email != null) 'email': email,
      if (creeLe != null) 'cree_le': creeLe,
      if (modifieLe != null) 'modifie_le': modifieLe,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocatairesCompanion copyWith({
    Value<String>? id,
    Value<String>? bailId,
    Value<String>? prenom,
    Value<String>? nom,
    Value<String?>? telephone,
    Value<String?>? email,
    Value<DateTime>? creeLe,
    Value<DateTime>? modifieLe,
    Value<int>? rowid,
  }) {
    return LocatairesCompanion(
      id: id ?? this.id,
      bailId: bailId ?? this.bailId,
      prenom: prenom ?? this.prenom,
      nom: nom ?? this.nom,
      telephone: telephone ?? this.telephone,
      email: email ?? this.email,
      creeLe: creeLe ?? this.creeLe,
      modifieLe: modifieLe ?? this.modifieLe,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bailId.present) {
      map['bail_id'] = Variable<String>(bailId.value);
    }
    if (prenom.present) {
      map['prenom'] = Variable<String>(prenom.value);
    }
    if (nom.present) {
      map['nom'] = Variable<String>(nom.value);
    }
    if (telephone.present) {
      map['telephone'] = Variable<String>(telephone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (creeLe.present) {
      map['cree_le'] = Variable<DateTime>(creeLe.value);
    }
    if (modifieLe.present) {
      map['modifie_le'] = Variable<DateTime>(modifieLe.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocatairesCompanion(')
          ..write('id: $id, ')
          ..write('bailId: $bailId, ')
          ..write('prenom: $prenom, ')
          ..write('nom: $nom, ')
          ..write('telephone: $telephone, ')
          ..write('email: $email, ')
          ..write('creeLe: $creeLe, ')
          ..write('modifieLe: $modifieLe, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$LocataireInsertable implements Insertable<Locataire> {
  Locataire _object;
  _$LocataireInsertable(this._object);
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return LocatairesCompanion(
      id: Value(_object.id),
      bailId: Value(_object.bailId),
      prenom: Value(_object.prenom),
      nom: Value(_object.nom),
      telephone: Value(_object.telephone),
      email: Value(_object.email),
      creeLe: Value(_object.creeLe),
      modifieLe: Value(_object.modifieLe),
    ).toColumns(false);
  }
}

extension LocataireToInsertable on Locataire {
  _$LocataireInsertable toInsertable() {
    return _$LocataireInsertable(this);
  }
}

class $EcheancesTable extends Echeances
    with TableInfo<$EcheancesTable, Echeance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EcheancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bienIdMeta = const VerificationMeta('bienId');
  @override
  late final GeneratedColumn<String> bienId = GeneratedColumn<String>(
    'bien_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES biens (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TypeEcheance, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TypeEcheance>($EcheancesTable.$convertertype);
  static const VerificationMeta _titreMeta = const VerificationMeta('titre');
  @override
  late final GeneratedColumn<String> titre = GeneratedColumn<String>(
    'titre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateInitialeMeta = const VerificationMeta(
    'dateInitiale',
  );
  @override
  late final GeneratedColumn<DateTime> dateInitiale = GeneratedColumn<DateTime>(
    'date_initiale',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<StatutEcheance, String> statut =
      GeneratedColumn<String>(
        'statut',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<StatutEcheance>($EcheancesTable.$converterstatut);
  static const VerificationMeta _faiteLeMeta = const VerificationMeta(
    'faiteLe',
  );
  @override
  late final GeneratedColumn<DateTime> faiteLe = GeneratedColumn<DateTime>(
    'faite_le',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _intervalleMoisMeta = const VerificationMeta(
    'intervalleMois',
  );
  @override
  late final GeneratedColumn<int> intervalleMois = GeneratedColumn<int>(
    'intervalle_mois',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TypeDiagnostic?, String>
  typeDiagnostic = GeneratedColumn<String>(
    'type_diagnostic',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<TypeDiagnostic?>($EcheancesTable.$convertertypeDiagnosticn);
  static const VerificationMeta _automatiqueMeta = const VerificationMeta(
    'automatique',
  );
  @override
  late final GeneratedColumn<bool> automatique = GeneratedColumn<bool>(
    'automatique',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("automatique" IN (0, 1))',
    ),
  );
  static const VerificationMeta _creeLeMeta = const VerificationMeta('creeLe');
  @override
  late final GeneratedColumn<DateTime> creeLe = GeneratedColumn<DateTime>(
    'cree_le',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifieLeMeta = const VerificationMeta(
    'modifieLe',
  );
  @override
  late final GeneratedColumn<DateTime> modifieLe = GeneratedColumn<DateTime>(
    'modifie_le',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bienId,
    type,
    titre,
    date,
    dateInitiale,
    statut,
    faiteLe,
    notes,
    intervalleMois,
    typeDiagnostic,
    automatique,
    creeLe,
    modifieLe,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'echeances';
  @override
  VerificationContext validateIntegrity(
    Insertable<Echeance> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('bien_id')) {
      context.handle(
        _bienIdMeta,
        bienId.isAcceptableOrUnknown(data['bien_id']!, _bienIdMeta),
      );
    }
    if (data.containsKey('titre')) {
      context.handle(
        _titreMeta,
        titre.isAcceptableOrUnknown(data['titre']!, _titreMeta),
      );
    } else if (isInserting) {
      context.missing(_titreMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('date_initiale')) {
      context.handle(
        _dateInitialeMeta,
        dateInitiale.isAcceptableOrUnknown(
          data['date_initiale']!,
          _dateInitialeMeta,
        ),
      );
    }
    if (data.containsKey('faite_le')) {
      context.handle(
        _faiteLeMeta,
        faiteLe.isAcceptableOrUnknown(data['faite_le']!, _faiteLeMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('intervalle_mois')) {
      context.handle(
        _intervalleMoisMeta,
        intervalleMois.isAcceptableOrUnknown(
          data['intervalle_mois']!,
          _intervalleMoisMeta,
        ),
      );
    }
    if (data.containsKey('automatique')) {
      context.handle(
        _automatiqueMeta,
        automatique.isAcceptableOrUnknown(
          data['automatique']!,
          _automatiqueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_automatiqueMeta);
    }
    if (data.containsKey('cree_le')) {
      context.handle(
        _creeLeMeta,
        creeLe.isAcceptableOrUnknown(data['cree_le']!, _creeLeMeta),
      );
    } else if (isInserting) {
      context.missing(_creeLeMeta);
    }
    if (data.containsKey('modifie_le')) {
      context.handle(
        _modifieLeMeta,
        modifieLe.isAcceptableOrUnknown(data['modifie_le']!, _modifieLeMeta),
      );
    } else if (isInserting) {
      context.missing(_modifieLeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Echeance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Echeance(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bienId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bien_id'],
      ),
      type: $EcheancesTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      titre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titre'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      dateInitiale: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_initiale'],
      ),
      statut: $EcheancesTable.$converterstatut.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}statut'],
        )!,
      ),
      faiteLe: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}faite_le'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      intervalleMois: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intervalle_mois'],
      ),
      typeDiagnostic: $EcheancesTable.$convertertypeDiagnosticn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type_diagnostic'],
        ),
      ),
      automatique: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}automatique'],
      )!,
      creeLe: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cree_le'],
      )!,
      modifieLe: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modifie_le'],
      )!,
    );
  }

  @override
  $EcheancesTable createAlias(String alias) {
    return $EcheancesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TypeEcheance, String, String> $convertertype =
      const EnumNameConverter<TypeEcheance>(TypeEcheance.values);
  static JsonTypeConverter2<StatutEcheance, String, String> $converterstatut =
      const EnumNameConverter<StatutEcheance>(StatutEcheance.values);
  static JsonTypeConverter2<TypeDiagnostic, String, String>
  $convertertypeDiagnostic = const EnumNameConverter<TypeDiagnostic>(
    TypeDiagnostic.values,
  );
  static JsonTypeConverter2<TypeDiagnostic?, String?, String?>
  $convertertypeDiagnosticn = JsonTypeConverter2.asNullable(
    $convertertypeDiagnostic,
  );
}

class EcheancesCompanion extends UpdateCompanion<Echeance> {
  final Value<String> id;
  final Value<String?> bienId;
  final Value<TypeEcheance> type;
  final Value<String> titre;
  final Value<DateTime> date;
  final Value<DateTime?> dateInitiale;
  final Value<StatutEcheance> statut;
  final Value<DateTime?> faiteLe;
  final Value<String?> notes;
  final Value<int?> intervalleMois;
  final Value<TypeDiagnostic?> typeDiagnostic;
  final Value<bool> automatique;
  final Value<DateTime> creeLe;
  final Value<DateTime> modifieLe;
  final Value<int> rowid;
  const EcheancesCompanion({
    this.id = const Value.absent(),
    this.bienId = const Value.absent(),
    this.type = const Value.absent(),
    this.titre = const Value.absent(),
    this.date = const Value.absent(),
    this.dateInitiale = const Value.absent(),
    this.statut = const Value.absent(),
    this.faiteLe = const Value.absent(),
    this.notes = const Value.absent(),
    this.intervalleMois = const Value.absent(),
    this.typeDiagnostic = const Value.absent(),
    this.automatique = const Value.absent(),
    this.creeLe = const Value.absent(),
    this.modifieLe = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EcheancesCompanion.insert({
    required String id,
    this.bienId = const Value.absent(),
    required TypeEcheance type,
    required String titre,
    required DateTime date,
    this.dateInitiale = const Value.absent(),
    required StatutEcheance statut,
    this.faiteLe = const Value.absent(),
    this.notes = const Value.absent(),
    this.intervalleMois = const Value.absent(),
    this.typeDiagnostic = const Value.absent(),
    required bool automatique,
    required DateTime creeLe,
    required DateTime modifieLe,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       titre = Value(titre),
       date = Value(date),
       statut = Value(statut),
       automatique = Value(automatique),
       creeLe = Value(creeLe),
       modifieLe = Value(modifieLe);
  static Insertable<Echeance> custom({
    Expression<String>? id,
    Expression<String>? bienId,
    Expression<String>? type,
    Expression<String>? titre,
    Expression<DateTime>? date,
    Expression<DateTime>? dateInitiale,
    Expression<String>? statut,
    Expression<DateTime>? faiteLe,
    Expression<String>? notes,
    Expression<int>? intervalleMois,
    Expression<String>? typeDiagnostic,
    Expression<bool>? automatique,
    Expression<DateTime>? creeLe,
    Expression<DateTime>? modifieLe,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bienId != null) 'bien_id': bienId,
      if (type != null) 'type': type,
      if (titre != null) 'titre': titre,
      if (date != null) 'date': date,
      if (dateInitiale != null) 'date_initiale': dateInitiale,
      if (statut != null) 'statut': statut,
      if (faiteLe != null) 'faite_le': faiteLe,
      if (notes != null) 'notes': notes,
      if (intervalleMois != null) 'intervalle_mois': intervalleMois,
      if (typeDiagnostic != null) 'type_diagnostic': typeDiagnostic,
      if (automatique != null) 'automatique': automatique,
      if (creeLe != null) 'cree_le': creeLe,
      if (modifieLe != null) 'modifie_le': modifieLe,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EcheancesCompanion copyWith({
    Value<String>? id,
    Value<String?>? bienId,
    Value<TypeEcheance>? type,
    Value<String>? titre,
    Value<DateTime>? date,
    Value<DateTime?>? dateInitiale,
    Value<StatutEcheance>? statut,
    Value<DateTime?>? faiteLe,
    Value<String?>? notes,
    Value<int?>? intervalleMois,
    Value<TypeDiagnostic?>? typeDiagnostic,
    Value<bool>? automatique,
    Value<DateTime>? creeLe,
    Value<DateTime>? modifieLe,
    Value<int>? rowid,
  }) {
    return EcheancesCompanion(
      id: id ?? this.id,
      bienId: bienId ?? this.bienId,
      type: type ?? this.type,
      titre: titre ?? this.titre,
      date: date ?? this.date,
      dateInitiale: dateInitiale ?? this.dateInitiale,
      statut: statut ?? this.statut,
      faiteLe: faiteLe ?? this.faiteLe,
      notes: notes ?? this.notes,
      intervalleMois: intervalleMois ?? this.intervalleMois,
      typeDiagnostic: typeDiagnostic ?? this.typeDiagnostic,
      automatique: automatique ?? this.automatique,
      creeLe: creeLe ?? this.creeLe,
      modifieLe: modifieLe ?? this.modifieLe,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bienId.present) {
      map['bien_id'] = Variable<String>(bienId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $EcheancesTable.$convertertype.toSql(type.value),
      );
    }
    if (titre.present) {
      map['titre'] = Variable<String>(titre.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (dateInitiale.present) {
      map['date_initiale'] = Variable<DateTime>(dateInitiale.value);
    }
    if (statut.present) {
      map['statut'] = Variable<String>(
        $EcheancesTable.$converterstatut.toSql(statut.value),
      );
    }
    if (faiteLe.present) {
      map['faite_le'] = Variable<DateTime>(faiteLe.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (intervalleMois.present) {
      map['intervalle_mois'] = Variable<int>(intervalleMois.value);
    }
    if (typeDiagnostic.present) {
      map['type_diagnostic'] = Variable<String>(
        $EcheancesTable.$convertertypeDiagnosticn.toSql(typeDiagnostic.value),
      );
    }
    if (automatique.present) {
      map['automatique'] = Variable<bool>(automatique.value);
    }
    if (creeLe.present) {
      map['cree_le'] = Variable<DateTime>(creeLe.value);
    }
    if (modifieLe.present) {
      map['modifie_le'] = Variable<DateTime>(modifieLe.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EcheancesCompanion(')
          ..write('id: $id, ')
          ..write('bienId: $bienId, ')
          ..write('type: $type, ')
          ..write('titre: $titre, ')
          ..write('date: $date, ')
          ..write('dateInitiale: $dateInitiale, ')
          ..write('statut: $statut, ')
          ..write('faiteLe: $faiteLe, ')
          ..write('notes: $notes, ')
          ..write('intervalleMois: $intervalleMois, ')
          ..write('typeDiagnostic: $typeDiagnostic, ')
          ..write('automatique: $automatique, ')
          ..write('creeLe: $creeLe, ')
          ..write('modifieLe: $modifieLe, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$EcheanceInsertable implements Insertable<Echeance> {
  Echeance _object;
  _$EcheanceInsertable(this._object);
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return EcheancesCompanion(
      id: Value(_object.id),
      bienId: Value(_object.bienId),
      type: Value(_object.type),
      titre: Value(_object.titre),
      date: Value(_object.date),
      dateInitiale: Value(_object.dateInitiale),
      statut: Value(_object.statut),
      faiteLe: Value(_object.faiteLe),
      notes: Value(_object.notes),
      intervalleMois: Value(_object.intervalleMois),
      typeDiagnostic: Value(_object.typeDiagnostic),
      automatique: Value(_object.automatique),
      creeLe: Value(_object.creeLe),
      modifieLe: Value(_object.modifieLe),
    ).toColumns(false);
  }
}

extension EcheanceToInsertable on Echeance {
  _$EcheanceInsertable toInsertable() {
    return _$EcheanceInsertable(this);
  }
}

class $RappelsTable extends Rappels with TableInfo<$RappelsTable, Rappel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RappelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _echeanceIdMeta = const VerificationMeta(
    'echeanceId',
  );
  @override
  late final GeneratedColumn<String> echeanceId = GeneratedColumn<String>(
    'echeance_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES echeances (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _joursAvantMeta = const VerificationMeta(
    'joursAvant',
  );
  @override
  late final GeneratedColumn<int> joursAvant = GeneratedColumn<int>(
    'jours_avant',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, echeanceId, joursAvant];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rappels';
  @override
  VerificationContext validateIntegrity(
    Insertable<Rappel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('echeance_id')) {
      context.handle(
        _echeanceIdMeta,
        echeanceId.isAcceptableOrUnknown(data['echeance_id']!, _echeanceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_echeanceIdMeta);
    }
    if (data.containsKey('jours_avant')) {
      context.handle(
        _joursAvantMeta,
        joursAvant.isAcceptableOrUnknown(data['jours_avant']!, _joursAvantMeta),
      );
    } else if (isInserting) {
      context.missing(_joursAvantMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Rappel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Rappel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      echeanceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}echeance_id'],
      )!,
      joursAvant: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}jours_avant'],
      )!,
    );
  }

  @override
  $RappelsTable createAlias(String alias) {
    return $RappelsTable(attachedDatabase, alias);
  }
}

class RappelsCompanion extends UpdateCompanion<Rappel> {
  final Value<int> id;
  final Value<String> echeanceId;
  final Value<int> joursAvant;
  const RappelsCompanion({
    this.id = const Value.absent(),
    this.echeanceId = const Value.absent(),
    this.joursAvant = const Value.absent(),
  });
  RappelsCompanion.insert({
    this.id = const Value.absent(),
    required String echeanceId,
    required int joursAvant,
  }) : echeanceId = Value(echeanceId),
       joursAvant = Value(joursAvant);
  static Insertable<Rappel> custom({
    Expression<int>? id,
    Expression<String>? echeanceId,
    Expression<int>? joursAvant,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (echeanceId != null) 'echeance_id': echeanceId,
      if (joursAvant != null) 'jours_avant': joursAvant,
    });
  }

  RappelsCompanion copyWith({
    Value<int>? id,
    Value<String>? echeanceId,
    Value<int>? joursAvant,
  }) {
    return RappelsCompanion(
      id: id ?? this.id,
      echeanceId: echeanceId ?? this.echeanceId,
      joursAvant: joursAvant ?? this.joursAvant,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (echeanceId.present) {
      map['echeance_id'] = Variable<String>(echeanceId.value);
    }
    if (joursAvant.present) {
      map['jours_avant'] = Variable<int>(joursAvant.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RappelsCompanion(')
          ..write('id: $id, ')
          ..write('echeanceId: $echeanceId, ')
          ..write('joursAvant: $joursAvant')
          ..write(')'))
        .toString();
  }
}

class $ArtisansTable extends Artisans with TableInfo<$ArtisansTable, Artisan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArtisansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nomMeta = const VerificationMeta('nom');
  @override
  late final GeneratedColumn<String> nom = GeneratedColumn<String>(
    'nom',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entrepriseMeta = const VerificationMeta(
    'entreprise',
  );
  @override
  late final GeneratedColumn<String> entreprise = GeneratedColumn<String>(
    'entreprise',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MetierArtisan, String> metier =
      GeneratedColumn<String>(
        'metier',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MetierArtisan>($ArtisansTable.$convertermetier);
  static const VerificationMeta _telephoneMeta = const VerificationMeta(
    'telephone',
  );
  @override
  late final GeneratedColumn<String> telephone = GeneratedColumn<String>(
    'telephone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _creeLeMeta = const VerificationMeta('creeLe');
  @override
  late final GeneratedColumn<DateTime> creeLe = GeneratedColumn<DateTime>(
    'cree_le',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifieLeMeta = const VerificationMeta(
    'modifieLe',
  );
  @override
  late final GeneratedColumn<DateTime> modifieLe = GeneratedColumn<DateTime>(
    'modifie_le',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nom,
    entreprise,
    metier,
    telephone,
    email,
    notes,
    creeLe,
    modifieLe,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'artisans';
  @override
  VerificationContext validateIntegrity(
    Insertable<Artisan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nom')) {
      context.handle(
        _nomMeta,
        nom.isAcceptableOrUnknown(data['nom']!, _nomMeta),
      );
    } else if (isInserting) {
      context.missing(_nomMeta);
    }
    if (data.containsKey('entreprise')) {
      context.handle(
        _entrepriseMeta,
        entreprise.isAcceptableOrUnknown(data['entreprise']!, _entrepriseMeta),
      );
    }
    if (data.containsKey('telephone')) {
      context.handle(
        _telephoneMeta,
        telephone.isAcceptableOrUnknown(data['telephone']!, _telephoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('cree_le')) {
      context.handle(
        _creeLeMeta,
        creeLe.isAcceptableOrUnknown(data['cree_le']!, _creeLeMeta),
      );
    } else if (isInserting) {
      context.missing(_creeLeMeta);
    }
    if (data.containsKey('modifie_le')) {
      context.handle(
        _modifieLeMeta,
        modifieLe.isAcceptableOrUnknown(data['modifie_le']!, _modifieLeMeta),
      );
    } else if (isInserting) {
      context.missing(_modifieLeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Artisan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Artisan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nom'],
      )!,
      entreprise: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entreprise'],
      ),
      metier: $ArtisansTable.$convertermetier.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}metier'],
        )!,
      ),
      telephone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telephone'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      creeLe: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cree_le'],
      )!,
      modifieLe: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modifie_le'],
      )!,
    );
  }

  @override
  $ArtisansTable createAlias(String alias) {
    return $ArtisansTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MetierArtisan, String, String> $convertermetier =
      const EnumNameConverter<MetierArtisan>(MetierArtisan.values);
}

class ArtisansCompanion extends UpdateCompanion<Artisan> {
  final Value<String> id;
  final Value<String> nom;
  final Value<String?> entreprise;
  final Value<MetierArtisan> metier;
  final Value<String?> telephone;
  final Value<String?> email;
  final Value<String?> notes;
  final Value<DateTime> creeLe;
  final Value<DateTime> modifieLe;
  final Value<int> rowid;
  const ArtisansCompanion({
    this.id = const Value.absent(),
    this.nom = const Value.absent(),
    this.entreprise = const Value.absent(),
    this.metier = const Value.absent(),
    this.telephone = const Value.absent(),
    this.email = const Value.absent(),
    this.notes = const Value.absent(),
    this.creeLe = const Value.absent(),
    this.modifieLe = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ArtisansCompanion.insert({
    required String id,
    required String nom,
    this.entreprise = const Value.absent(),
    required MetierArtisan metier,
    this.telephone = const Value.absent(),
    this.email = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime creeLe,
    required DateTime modifieLe,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nom = Value(nom),
       metier = Value(metier),
       creeLe = Value(creeLe),
       modifieLe = Value(modifieLe);
  static Insertable<Artisan> custom({
    Expression<String>? id,
    Expression<String>? nom,
    Expression<String>? entreprise,
    Expression<String>? metier,
    Expression<String>? telephone,
    Expression<String>? email,
    Expression<String>? notes,
    Expression<DateTime>? creeLe,
    Expression<DateTime>? modifieLe,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nom != null) 'nom': nom,
      if (entreprise != null) 'entreprise': entreprise,
      if (metier != null) 'metier': metier,
      if (telephone != null) 'telephone': telephone,
      if (email != null) 'email': email,
      if (notes != null) 'notes': notes,
      if (creeLe != null) 'cree_le': creeLe,
      if (modifieLe != null) 'modifie_le': modifieLe,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ArtisansCompanion copyWith({
    Value<String>? id,
    Value<String>? nom,
    Value<String?>? entreprise,
    Value<MetierArtisan>? metier,
    Value<String?>? telephone,
    Value<String?>? email,
    Value<String?>? notes,
    Value<DateTime>? creeLe,
    Value<DateTime>? modifieLe,
    Value<int>? rowid,
  }) {
    return ArtisansCompanion(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      entreprise: entreprise ?? this.entreprise,
      metier: metier ?? this.metier,
      telephone: telephone ?? this.telephone,
      email: email ?? this.email,
      notes: notes ?? this.notes,
      creeLe: creeLe ?? this.creeLe,
      modifieLe: modifieLe ?? this.modifieLe,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nom.present) {
      map['nom'] = Variable<String>(nom.value);
    }
    if (entreprise.present) {
      map['entreprise'] = Variable<String>(entreprise.value);
    }
    if (metier.present) {
      map['metier'] = Variable<String>(
        $ArtisansTable.$convertermetier.toSql(metier.value),
      );
    }
    if (telephone.present) {
      map['telephone'] = Variable<String>(telephone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (creeLe.present) {
      map['cree_le'] = Variable<DateTime>(creeLe.value);
    }
    if (modifieLe.present) {
      map['modifie_le'] = Variable<DateTime>(modifieLe.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArtisansCompanion(')
          ..write('id: $id, ')
          ..write('nom: $nom, ')
          ..write('entreprise: $entreprise, ')
          ..write('metier: $metier, ')
          ..write('telephone: $telephone, ')
          ..write('email: $email, ')
          ..write('notes: $notes, ')
          ..write('creeLe: $creeLe, ')
          ..write('modifieLe: $modifieLe, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$ArtisanInsertable implements Insertable<Artisan> {
  Artisan _object;
  _$ArtisanInsertable(this._object);
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return ArtisansCompanion(
      id: Value(_object.id),
      nom: Value(_object.nom),
      entreprise: Value(_object.entreprise),
      metier: Value(_object.metier),
      telephone: Value(_object.telephone),
      email: Value(_object.email),
      notes: Value(_object.notes),
      creeLe: Value(_object.creeLe),
      modifieLe: Value(_object.modifieLe),
    ).toColumns(false);
  }
}

extension ArtisanToInsertable on Artisan {
  _$ArtisanInsertable toInsertable() {
    return _$ArtisanInsertable(this);
  }
}

class $InterventionsTable extends Interventions
    with TableInfo<$InterventionsTable, Intervention> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InterventionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bienIdMeta = const VerificationMeta('bienId');
  @override
  late final GeneratedColumn<String> bienId = GeneratedColumn<String>(
    'bien_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES biens (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _artisanIdMeta = const VerificationMeta(
    'artisanId',
  );
  @override
  late final GeneratedColumn<String> artisanId = GeneratedColumn<String>(
    'artisan_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES artisans (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coutCentimesMeta = const VerificationMeta(
    'coutCentimes',
  );
  @override
  late final GeneratedColumn<int> coutCentimes = GeneratedColumn<int>(
    'cout_centimes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _creeLeMeta = const VerificationMeta('creeLe');
  @override
  late final GeneratedColumn<DateTime> creeLe = GeneratedColumn<DateTime>(
    'cree_le',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifieLeMeta = const VerificationMeta(
    'modifieLe',
  );
  @override
  late final GeneratedColumn<DateTime> modifieLe = GeneratedColumn<DateTime>(
    'modifie_le',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bienId,
    artisanId,
    date,
    description,
    coutCentimes,
    creeLe,
    modifieLe,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'interventions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Intervention> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('bien_id')) {
      context.handle(
        _bienIdMeta,
        bienId.isAcceptableOrUnknown(data['bien_id']!, _bienIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bienIdMeta);
    }
    if (data.containsKey('artisan_id')) {
      context.handle(
        _artisanIdMeta,
        artisanId.isAcceptableOrUnknown(data['artisan_id']!, _artisanIdMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('cout_centimes')) {
      context.handle(
        _coutCentimesMeta,
        coutCentimes.isAcceptableOrUnknown(
          data['cout_centimes']!,
          _coutCentimesMeta,
        ),
      );
    }
    if (data.containsKey('cree_le')) {
      context.handle(
        _creeLeMeta,
        creeLe.isAcceptableOrUnknown(data['cree_le']!, _creeLeMeta),
      );
    } else if (isInserting) {
      context.missing(_creeLeMeta);
    }
    if (data.containsKey('modifie_le')) {
      context.handle(
        _modifieLeMeta,
        modifieLe.isAcceptableOrUnknown(data['modifie_le']!, _modifieLeMeta),
      );
    } else if (isInserting) {
      context.missing(_modifieLeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Intervention map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Intervention(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bienId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bien_id'],
      )!,
      artisanId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}artisan_id'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      coutCentimes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cout_centimes'],
      ),
      creeLe: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cree_le'],
      )!,
      modifieLe: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modifie_le'],
      )!,
    );
  }

  @override
  $InterventionsTable createAlias(String alias) {
    return $InterventionsTable(attachedDatabase, alias);
  }
}

class InterventionsCompanion extends UpdateCompanion<Intervention> {
  final Value<String> id;
  final Value<String> bienId;
  final Value<String?> artisanId;
  final Value<DateTime> date;
  final Value<String> description;
  final Value<int?> coutCentimes;
  final Value<DateTime> creeLe;
  final Value<DateTime> modifieLe;
  final Value<int> rowid;
  const InterventionsCompanion({
    this.id = const Value.absent(),
    this.bienId = const Value.absent(),
    this.artisanId = const Value.absent(),
    this.date = const Value.absent(),
    this.description = const Value.absent(),
    this.coutCentimes = const Value.absent(),
    this.creeLe = const Value.absent(),
    this.modifieLe = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InterventionsCompanion.insert({
    required String id,
    required String bienId,
    this.artisanId = const Value.absent(),
    required DateTime date,
    required String description,
    this.coutCentimes = const Value.absent(),
    required DateTime creeLe,
    required DateTime modifieLe,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bienId = Value(bienId),
       date = Value(date),
       description = Value(description),
       creeLe = Value(creeLe),
       modifieLe = Value(modifieLe);
  static Insertable<Intervention> custom({
    Expression<String>? id,
    Expression<String>? bienId,
    Expression<String>? artisanId,
    Expression<DateTime>? date,
    Expression<String>? description,
    Expression<int>? coutCentimes,
    Expression<DateTime>? creeLe,
    Expression<DateTime>? modifieLe,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bienId != null) 'bien_id': bienId,
      if (artisanId != null) 'artisan_id': artisanId,
      if (date != null) 'date': date,
      if (description != null) 'description': description,
      if (coutCentimes != null) 'cout_centimes': coutCentimes,
      if (creeLe != null) 'cree_le': creeLe,
      if (modifieLe != null) 'modifie_le': modifieLe,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InterventionsCompanion copyWith({
    Value<String>? id,
    Value<String>? bienId,
    Value<String?>? artisanId,
    Value<DateTime>? date,
    Value<String>? description,
    Value<int?>? coutCentimes,
    Value<DateTime>? creeLe,
    Value<DateTime>? modifieLe,
    Value<int>? rowid,
  }) {
    return InterventionsCompanion(
      id: id ?? this.id,
      bienId: bienId ?? this.bienId,
      artisanId: artisanId ?? this.artisanId,
      date: date ?? this.date,
      description: description ?? this.description,
      coutCentimes: coutCentimes ?? this.coutCentimes,
      creeLe: creeLe ?? this.creeLe,
      modifieLe: modifieLe ?? this.modifieLe,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bienId.present) {
      map['bien_id'] = Variable<String>(bienId.value);
    }
    if (artisanId.present) {
      map['artisan_id'] = Variable<String>(artisanId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (coutCentimes.present) {
      map['cout_centimes'] = Variable<int>(coutCentimes.value);
    }
    if (creeLe.present) {
      map['cree_le'] = Variable<DateTime>(creeLe.value);
    }
    if (modifieLe.present) {
      map['modifie_le'] = Variable<DateTime>(modifieLe.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InterventionsCompanion(')
          ..write('id: $id, ')
          ..write('bienId: $bienId, ')
          ..write('artisanId: $artisanId, ')
          ..write('date: $date, ')
          ..write('description: $description, ')
          ..write('coutCentimes: $coutCentimes, ')
          ..write('creeLe: $creeLe, ')
          ..write('modifieLe: $modifieLe, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$InterventionInsertable implements Insertable<Intervention> {
  Intervention _object;
  _$InterventionInsertable(this._object);
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return InterventionsCompanion(
      id: Value(_object.id),
      bienId: Value(_object.bienId),
      artisanId: Value(_object.artisanId),
      date: Value(_object.date),
      description: Value(_object.description),
      coutCentimes: Value(_object.coutCentimes),
      creeLe: Value(_object.creeLe),
      modifieLe: Value(_object.modifieLe),
    ).toColumns(false);
  }
}

extension InterventionToInsertable on Intervention {
  _$InterventionInsertable toInsertable() {
    return _$InterventionInsertable(this);
  }
}

class $MouvementsFinanciersTable extends MouvementsFinanciers
    with TableInfo<$MouvementsFinanciersTable, MouvementFinancier> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MouvementsFinanciersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bienIdMeta = const VerificationMeta('bienId');
  @override
  late final GeneratedColumn<String> bienId = GeneratedColumn<String>(
    'bien_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES biens (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _montantCentimesMeta = const VerificationMeta(
    'montantCentimes',
  );
  @override
  late final GeneratedColumn<int> montantCentimes = GeneratedColumn<int>(
    'montant_centimes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CategorieMouvement, String>
  categorie =
      GeneratedColumn<String>(
        'categorie',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CategorieMouvement>(
        $MouvementsFinanciersTable.$convertercategorie,
      );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _interventionIdMeta = const VerificationMeta(
    'interventionId',
  );
  @override
  late final GeneratedColumn<String> interventionId = GeneratedColumn<String>(
    'intervention_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES interventions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _creeLeMeta = const VerificationMeta('creeLe');
  @override
  late final GeneratedColumn<DateTime> creeLe = GeneratedColumn<DateTime>(
    'cree_le',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifieLeMeta = const VerificationMeta(
    'modifieLe',
  );
  @override
  late final GeneratedColumn<DateTime> modifieLe = GeneratedColumn<DateTime>(
    'modifie_le',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bienId,
    date,
    montantCentimes,
    categorie,
    note,
    interventionId,
    creeLe,
    modifieLe,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mouvements_financiers';
  @override
  VerificationContext validateIntegrity(
    Insertable<MouvementFinancier> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('bien_id')) {
      context.handle(
        _bienIdMeta,
        bienId.isAcceptableOrUnknown(data['bien_id']!, _bienIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bienIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('montant_centimes')) {
      context.handle(
        _montantCentimesMeta,
        montantCentimes.isAcceptableOrUnknown(
          data['montant_centimes']!,
          _montantCentimesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_montantCentimesMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('intervention_id')) {
      context.handle(
        _interventionIdMeta,
        interventionId.isAcceptableOrUnknown(
          data['intervention_id']!,
          _interventionIdMeta,
        ),
      );
    }
    if (data.containsKey('cree_le')) {
      context.handle(
        _creeLeMeta,
        creeLe.isAcceptableOrUnknown(data['cree_le']!, _creeLeMeta),
      );
    } else if (isInserting) {
      context.missing(_creeLeMeta);
    }
    if (data.containsKey('modifie_le')) {
      context.handle(
        _modifieLeMeta,
        modifieLe.isAcceptableOrUnknown(data['modifie_le']!, _modifieLeMeta),
      );
    } else if (isInserting) {
      context.missing(_modifieLeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MouvementFinancier map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MouvementFinancier(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bienId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bien_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      montantCentimes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}montant_centimes'],
      )!,
      categorie: $MouvementsFinanciersTable.$convertercategorie.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}categorie'],
        )!,
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      interventionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}intervention_id'],
      ),
      creeLe: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cree_le'],
      )!,
      modifieLe: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}modifie_le'],
      )!,
    );
  }

  @override
  $MouvementsFinanciersTable createAlias(String alias) {
    return $MouvementsFinanciersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CategorieMouvement, String, String>
  $convertercategorie = const EnumNameConverter<CategorieMouvement>(
    CategorieMouvement.values,
  );
}

class MouvementsFinanciersCompanion
    extends UpdateCompanion<MouvementFinancier> {
  final Value<String> id;
  final Value<String> bienId;
  final Value<DateTime> date;
  final Value<int> montantCentimes;
  final Value<CategorieMouvement> categorie;
  final Value<String?> note;
  final Value<String?> interventionId;
  final Value<DateTime> creeLe;
  final Value<DateTime> modifieLe;
  final Value<int> rowid;
  const MouvementsFinanciersCompanion({
    this.id = const Value.absent(),
    this.bienId = const Value.absent(),
    this.date = const Value.absent(),
    this.montantCentimes = const Value.absent(),
    this.categorie = const Value.absent(),
    this.note = const Value.absent(),
    this.interventionId = const Value.absent(),
    this.creeLe = const Value.absent(),
    this.modifieLe = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MouvementsFinanciersCompanion.insert({
    required String id,
    required String bienId,
    required DateTime date,
    required int montantCentimes,
    required CategorieMouvement categorie,
    this.note = const Value.absent(),
    this.interventionId = const Value.absent(),
    required DateTime creeLe,
    required DateTime modifieLe,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bienId = Value(bienId),
       date = Value(date),
       montantCentimes = Value(montantCentimes),
       categorie = Value(categorie),
       creeLe = Value(creeLe),
       modifieLe = Value(modifieLe);
  static Insertable<MouvementFinancier> custom({
    Expression<String>? id,
    Expression<String>? bienId,
    Expression<DateTime>? date,
    Expression<int>? montantCentimes,
    Expression<String>? categorie,
    Expression<String>? note,
    Expression<String>? interventionId,
    Expression<DateTime>? creeLe,
    Expression<DateTime>? modifieLe,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bienId != null) 'bien_id': bienId,
      if (date != null) 'date': date,
      if (montantCentimes != null) 'montant_centimes': montantCentimes,
      if (categorie != null) 'categorie': categorie,
      if (note != null) 'note': note,
      if (interventionId != null) 'intervention_id': interventionId,
      if (creeLe != null) 'cree_le': creeLe,
      if (modifieLe != null) 'modifie_le': modifieLe,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MouvementsFinanciersCompanion copyWith({
    Value<String>? id,
    Value<String>? bienId,
    Value<DateTime>? date,
    Value<int>? montantCentimes,
    Value<CategorieMouvement>? categorie,
    Value<String?>? note,
    Value<String?>? interventionId,
    Value<DateTime>? creeLe,
    Value<DateTime>? modifieLe,
    Value<int>? rowid,
  }) {
    return MouvementsFinanciersCompanion(
      id: id ?? this.id,
      bienId: bienId ?? this.bienId,
      date: date ?? this.date,
      montantCentimes: montantCentimes ?? this.montantCentimes,
      categorie: categorie ?? this.categorie,
      note: note ?? this.note,
      interventionId: interventionId ?? this.interventionId,
      creeLe: creeLe ?? this.creeLe,
      modifieLe: modifieLe ?? this.modifieLe,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bienId.present) {
      map['bien_id'] = Variable<String>(bienId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (montantCentimes.present) {
      map['montant_centimes'] = Variable<int>(montantCentimes.value);
    }
    if (categorie.present) {
      map['categorie'] = Variable<String>(
        $MouvementsFinanciersTable.$convertercategorie.toSql(categorie.value),
      );
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (interventionId.present) {
      map['intervention_id'] = Variable<String>(interventionId.value);
    }
    if (creeLe.present) {
      map['cree_le'] = Variable<DateTime>(creeLe.value);
    }
    if (modifieLe.present) {
      map['modifie_le'] = Variable<DateTime>(modifieLe.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MouvementsFinanciersCompanion(')
          ..write('id: $id, ')
          ..write('bienId: $bienId, ')
          ..write('date: $date, ')
          ..write('montantCentimes: $montantCentimes, ')
          ..write('categorie: $categorie, ')
          ..write('note: $note, ')
          ..write('interventionId: $interventionId, ')
          ..write('creeLe: $creeLe, ')
          ..write('modifieLe: $modifieLe, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$MouvementFinancierInsertable implements Insertable<MouvementFinancier> {
  MouvementFinancier _object;
  _$MouvementFinancierInsertable(this._object);
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return MouvementsFinanciersCompanion(
      id: Value(_object.id),
      bienId: Value(_object.bienId),
      date: Value(_object.date),
      montantCentimes: Value(_object.montantCentimes),
      categorie: Value(_object.categorie),
      note: Value(_object.note),
      interventionId: Value(_object.interventionId),
      creeLe: Value(_object.creeLe),
      modifieLe: Value(_object.modifieLe),
    ).toColumns(false);
  }
}

extension MouvementFinancierToInsertable on MouvementFinancier {
  _$MouvementFinancierInsertable toInsertable() {
    return _$MouvementFinancierInsertable(this);
  }
}

class $EncaissementsLoyersTable extends EncaissementsLoyers
    with TableInfo<$EncaissementsLoyersTable, EncaissementLoyer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EncaissementsLoyersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _bienIdMeta = const VerificationMeta('bienId');
  @override
  late final GeneratedColumn<String> bienId = GeneratedColumn<String>(
    'bien_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES biens (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _anneeMeta = const VerificationMeta('annee');
  @override
  late final GeneratedColumn<int> annee = GeneratedColumn<int>(
    'annee',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moisMeta = const VerificationMeta('mois');
  @override
  late final GeneratedColumn<int> mois = GeneratedColumn<int>(
    'mois',
    aliasedName,
    false,
    check: () => ComparableExpr(mois).isBetweenValues(1, 12),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recuMeta = const VerificationMeta('recu');
  @override
  late final GeneratedColumn<bool> recu = GeneratedColumn<bool>(
    'recu',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("recu" IN (0, 1))',
    ),
  );
  static const VerificationMeta _recuLeMeta = const VerificationMeta('recuLe');
  @override
  late final GeneratedColumn<DateTime> recuLe = GeneratedColumn<DateTime>(
    'recu_le',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [bienId, annee, mois, recu, recuLe];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'encaissements_loyers';
  @override
  VerificationContext validateIntegrity(
    Insertable<EncaissementLoyer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('bien_id')) {
      context.handle(
        _bienIdMeta,
        bienId.isAcceptableOrUnknown(data['bien_id']!, _bienIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bienIdMeta);
    }
    if (data.containsKey('annee')) {
      context.handle(
        _anneeMeta,
        annee.isAcceptableOrUnknown(data['annee']!, _anneeMeta),
      );
    } else if (isInserting) {
      context.missing(_anneeMeta);
    }
    if (data.containsKey('mois')) {
      context.handle(
        _moisMeta,
        mois.isAcceptableOrUnknown(data['mois']!, _moisMeta),
      );
    } else if (isInserting) {
      context.missing(_moisMeta);
    }
    if (data.containsKey('recu')) {
      context.handle(
        _recuMeta,
        recu.isAcceptableOrUnknown(data['recu']!, _recuMeta),
      );
    } else if (isInserting) {
      context.missing(_recuMeta);
    }
    if (data.containsKey('recu_le')) {
      context.handle(
        _recuLeMeta,
        recuLe.isAcceptableOrUnknown(data['recu_le']!, _recuLeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {bienId, annee, mois};
  @override
  EncaissementLoyer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EncaissementLoyer(
      bienId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bien_id'],
      )!,
      annee: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}annee'],
      )!,
      mois: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mois'],
      )!,
      recu: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}recu'],
      )!,
      recuLe: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recu_le'],
      ),
    );
  }

  @override
  $EncaissementsLoyersTable createAlias(String alias) {
    return $EncaissementsLoyersTable(attachedDatabase, alias);
  }
}

class EncaissementsLoyersCompanion extends UpdateCompanion<EncaissementLoyer> {
  final Value<String> bienId;
  final Value<int> annee;
  final Value<int> mois;
  final Value<bool> recu;
  final Value<DateTime?> recuLe;
  final Value<int> rowid;
  const EncaissementsLoyersCompanion({
    this.bienId = const Value.absent(),
    this.annee = const Value.absent(),
    this.mois = const Value.absent(),
    this.recu = const Value.absent(),
    this.recuLe = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EncaissementsLoyersCompanion.insert({
    required String bienId,
    required int annee,
    required int mois,
    required bool recu,
    this.recuLe = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : bienId = Value(bienId),
       annee = Value(annee),
       mois = Value(mois),
       recu = Value(recu);
  static Insertable<EncaissementLoyer> custom({
    Expression<String>? bienId,
    Expression<int>? annee,
    Expression<int>? mois,
    Expression<bool>? recu,
    Expression<DateTime>? recuLe,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (bienId != null) 'bien_id': bienId,
      if (annee != null) 'annee': annee,
      if (mois != null) 'mois': mois,
      if (recu != null) 'recu': recu,
      if (recuLe != null) 'recu_le': recuLe,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EncaissementsLoyersCompanion copyWith({
    Value<String>? bienId,
    Value<int>? annee,
    Value<int>? mois,
    Value<bool>? recu,
    Value<DateTime?>? recuLe,
    Value<int>? rowid,
  }) {
    return EncaissementsLoyersCompanion(
      bienId: bienId ?? this.bienId,
      annee: annee ?? this.annee,
      mois: mois ?? this.mois,
      recu: recu ?? this.recu,
      recuLe: recuLe ?? this.recuLe,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (bienId.present) {
      map['bien_id'] = Variable<String>(bienId.value);
    }
    if (annee.present) {
      map['annee'] = Variable<int>(annee.value);
    }
    if (mois.present) {
      map['mois'] = Variable<int>(mois.value);
    }
    if (recu.present) {
      map['recu'] = Variable<bool>(recu.value);
    }
    if (recuLe.present) {
      map['recu_le'] = Variable<DateTime>(recuLe.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EncaissementsLoyersCompanion(')
          ..write('bienId: $bienId, ')
          ..write('annee: $annee, ')
          ..write('mois: $mois, ')
          ..write('recu: $recu, ')
          ..write('recuLe: $recuLe, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$EncaissementLoyerInsertable implements Insertable<EncaissementLoyer> {
  EncaissementLoyer _object;
  _$EncaissementLoyerInsertable(this._object);
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return EncaissementsLoyersCompanion(
      bienId: Value(_object.bienId),
      annee: Value(_object.annee),
      mois: Value(_object.mois),
      recu: Value(_object.recu),
      recuLe: Value(_object.recuLe),
    ).toColumns(false);
  }
}

extension EncaissementLoyerToInsertable on EncaissementLoyer {
  _$EncaissementLoyerInsertable toInsertable() {
    return _$EncaissementLoyerInsertable(this);
  }
}

class $RevisionsLoyersTable extends RevisionsLoyers
    with TableInfo<$RevisionsLoyersTable, RevisionLoyer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RevisionsLoyersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bienIdMeta = const VerificationMeta('bienId');
  @override
  late final GeneratedColumn<String> bienId = GeneratedColumn<String>(
    'bien_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES biens (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _bailIdMeta = const VerificationMeta('bailId');
  @override
  late final GeneratedColumn<String> bailId = GeneratedColumn<String>(
    'bail_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES baux (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _datePrevueMeta = const VerificationMeta(
    'datePrevue',
  );
  @override
  late final GeneratedColumn<DateTime> datePrevue = GeneratedColumn<DateTime>(
    'date_prevue',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateEffetMeta = const VerificationMeta(
    'dateEffet',
  );
  @override
  late final GeneratedColumn<DateTime> dateEffet = GeneratedColumn<DateTime>(
    'date_effet',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ancienLoyerCentimesMeta =
      const VerificationMeta('ancienLoyerCentimes');
  @override
  late final GeneratedColumn<int> ancienLoyerCentimes = GeneratedColumn<int>(
    'ancien_loyer_centimes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nouveauLoyerCentimesMeta =
      const VerificationMeta('nouveauLoyerCentimes');
  @override
  late final GeneratedColumn<int> nouveauLoyerCentimes = GeneratedColumn<int>(
    'nouveau_loyer_centimes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ancienIrlTrimestreMeta =
      const VerificationMeta('ancienIrlTrimestre');
  @override
  late final GeneratedColumn<int> ancienIrlTrimestre = GeneratedColumn<int>(
    'ancien_irl_trimestre',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ancienIrlAnneeMeta = const VerificationMeta(
    'ancienIrlAnnee',
  );
  @override
  late final GeneratedColumn<int> ancienIrlAnnee = GeneratedColumn<int>(
    'ancien_irl_annee',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ancienIrlValeurMeta = const VerificationMeta(
    'ancienIrlValeur',
  );
  @override
  late final GeneratedColumn<double> ancienIrlValeur = GeneratedColumn<double>(
    'ancien_irl_valeur',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nouvelIrlTrimestreMeta =
      const VerificationMeta('nouvelIrlTrimestre');
  @override
  late final GeneratedColumn<int> nouvelIrlTrimestre = GeneratedColumn<int>(
    'nouvel_irl_trimestre',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nouvelIrlAnneeMeta = const VerificationMeta(
    'nouvelIrlAnnee',
  );
  @override
  late final GeneratedColumn<int> nouvelIrlAnnee = GeneratedColumn<int>(
    'nouvel_irl_annee',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nouvelIrlValeurMeta = const VerificationMeta(
    'nouvelIrlValeur',
  );
  @override
  late final GeneratedColumn<double> nouvelIrlValeur = GeneratedColumn<double>(
    'nouvel_irl_valeur',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _courrierCheminMeta = const VerificationMeta(
    'courrierChemin',
  );
  @override
  late final GeneratedColumn<String> courrierChemin = GeneratedColumn<String>(
    'courrier_chemin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _creeLeMeta = const VerificationMeta('creeLe');
  @override
  late final GeneratedColumn<DateTime> creeLe = GeneratedColumn<DateTime>(
    'cree_le',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bienId,
    bailId,
    datePrevue,
    dateEffet,
    ancienLoyerCentimes,
    nouveauLoyerCentimes,
    ancienIrlTrimestre,
    ancienIrlAnnee,
    ancienIrlValeur,
    nouvelIrlTrimestre,
    nouvelIrlAnnee,
    nouvelIrlValeur,
    courrierChemin,
    creeLe,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'revisions_loyers';
  @override
  VerificationContext validateIntegrity(
    Insertable<RevisionLoyer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('bien_id')) {
      context.handle(
        _bienIdMeta,
        bienId.isAcceptableOrUnknown(data['bien_id']!, _bienIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bienIdMeta);
    }
    if (data.containsKey('bail_id')) {
      context.handle(
        _bailIdMeta,
        bailId.isAcceptableOrUnknown(data['bail_id']!, _bailIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bailIdMeta);
    }
    if (data.containsKey('date_prevue')) {
      context.handle(
        _datePrevueMeta,
        datePrevue.isAcceptableOrUnknown(data['date_prevue']!, _datePrevueMeta),
      );
    }
    if (data.containsKey('date_effet')) {
      context.handle(
        _dateEffetMeta,
        dateEffet.isAcceptableOrUnknown(data['date_effet']!, _dateEffetMeta),
      );
    } else if (isInserting) {
      context.missing(_dateEffetMeta);
    }
    if (data.containsKey('ancien_loyer_centimes')) {
      context.handle(
        _ancienLoyerCentimesMeta,
        ancienLoyerCentimes.isAcceptableOrUnknown(
          data['ancien_loyer_centimes']!,
          _ancienLoyerCentimesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ancienLoyerCentimesMeta);
    }
    if (data.containsKey('nouveau_loyer_centimes')) {
      context.handle(
        _nouveauLoyerCentimesMeta,
        nouveauLoyerCentimes.isAcceptableOrUnknown(
          data['nouveau_loyer_centimes']!,
          _nouveauLoyerCentimesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nouveauLoyerCentimesMeta);
    }
    if (data.containsKey('ancien_irl_trimestre')) {
      context.handle(
        _ancienIrlTrimestreMeta,
        ancienIrlTrimestre.isAcceptableOrUnknown(
          data['ancien_irl_trimestre']!,
          _ancienIrlTrimestreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ancienIrlTrimestreMeta);
    }
    if (data.containsKey('ancien_irl_annee')) {
      context.handle(
        _ancienIrlAnneeMeta,
        ancienIrlAnnee.isAcceptableOrUnknown(
          data['ancien_irl_annee']!,
          _ancienIrlAnneeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ancienIrlAnneeMeta);
    }
    if (data.containsKey('ancien_irl_valeur')) {
      context.handle(
        _ancienIrlValeurMeta,
        ancienIrlValeur.isAcceptableOrUnknown(
          data['ancien_irl_valeur']!,
          _ancienIrlValeurMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ancienIrlValeurMeta);
    }
    if (data.containsKey('nouvel_irl_trimestre')) {
      context.handle(
        _nouvelIrlTrimestreMeta,
        nouvelIrlTrimestre.isAcceptableOrUnknown(
          data['nouvel_irl_trimestre']!,
          _nouvelIrlTrimestreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nouvelIrlTrimestreMeta);
    }
    if (data.containsKey('nouvel_irl_annee')) {
      context.handle(
        _nouvelIrlAnneeMeta,
        nouvelIrlAnnee.isAcceptableOrUnknown(
          data['nouvel_irl_annee']!,
          _nouvelIrlAnneeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nouvelIrlAnneeMeta);
    }
    if (data.containsKey('nouvel_irl_valeur')) {
      context.handle(
        _nouvelIrlValeurMeta,
        nouvelIrlValeur.isAcceptableOrUnknown(
          data['nouvel_irl_valeur']!,
          _nouvelIrlValeurMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nouvelIrlValeurMeta);
    }
    if (data.containsKey('courrier_chemin')) {
      context.handle(
        _courrierCheminMeta,
        courrierChemin.isAcceptableOrUnknown(
          data['courrier_chemin']!,
          _courrierCheminMeta,
        ),
      );
    }
    if (data.containsKey('cree_le')) {
      context.handle(
        _creeLeMeta,
        creeLe.isAcceptableOrUnknown(data['cree_le']!, _creeLeMeta),
      );
    } else if (isInserting) {
      context.missing(_creeLeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RevisionLoyer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RevisionLoyer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bienId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bien_id'],
      )!,
      bailId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bail_id'],
      )!,
      datePrevue: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_prevue'],
      ),
      dateEffet: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_effet'],
      )!,
      ancienLoyerCentimes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ancien_loyer_centimes'],
      )!,
      nouveauLoyerCentimes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nouveau_loyer_centimes'],
      )!,
      ancienIrlTrimestre: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ancien_irl_trimestre'],
      )!,
      ancienIrlAnnee: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ancien_irl_annee'],
      )!,
      ancienIrlValeur: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ancien_irl_valeur'],
      )!,
      nouvelIrlTrimestre: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nouvel_irl_trimestre'],
      )!,
      nouvelIrlAnnee: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nouvel_irl_annee'],
      )!,
      nouvelIrlValeur: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}nouvel_irl_valeur'],
      )!,
      courrierChemin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}courrier_chemin'],
      ),
      creeLe: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cree_le'],
      )!,
    );
  }

  @override
  $RevisionsLoyersTable createAlias(String alias) {
    return $RevisionsLoyersTable(attachedDatabase, alias);
  }
}

class RevisionsLoyersCompanion extends UpdateCompanion<RevisionLoyer> {
  final Value<String> id;
  final Value<String> bienId;
  final Value<String> bailId;
  final Value<DateTime?> datePrevue;
  final Value<DateTime> dateEffet;
  final Value<int> ancienLoyerCentimes;
  final Value<int> nouveauLoyerCentimes;
  final Value<int> ancienIrlTrimestre;
  final Value<int> ancienIrlAnnee;
  final Value<double> ancienIrlValeur;
  final Value<int> nouvelIrlTrimestre;
  final Value<int> nouvelIrlAnnee;
  final Value<double> nouvelIrlValeur;
  final Value<String?> courrierChemin;
  final Value<DateTime> creeLe;
  final Value<int> rowid;
  const RevisionsLoyersCompanion({
    this.id = const Value.absent(),
    this.bienId = const Value.absent(),
    this.bailId = const Value.absent(),
    this.datePrevue = const Value.absent(),
    this.dateEffet = const Value.absent(),
    this.ancienLoyerCentimes = const Value.absent(),
    this.nouveauLoyerCentimes = const Value.absent(),
    this.ancienIrlTrimestre = const Value.absent(),
    this.ancienIrlAnnee = const Value.absent(),
    this.ancienIrlValeur = const Value.absent(),
    this.nouvelIrlTrimestre = const Value.absent(),
    this.nouvelIrlAnnee = const Value.absent(),
    this.nouvelIrlValeur = const Value.absent(),
    this.courrierChemin = const Value.absent(),
    this.creeLe = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RevisionsLoyersCompanion.insert({
    required String id,
    required String bienId,
    required String bailId,
    this.datePrevue = const Value.absent(),
    required DateTime dateEffet,
    required int ancienLoyerCentimes,
    required int nouveauLoyerCentimes,
    required int ancienIrlTrimestre,
    required int ancienIrlAnnee,
    required double ancienIrlValeur,
    required int nouvelIrlTrimestre,
    required int nouvelIrlAnnee,
    required double nouvelIrlValeur,
    this.courrierChemin = const Value.absent(),
    required DateTime creeLe,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bienId = Value(bienId),
       bailId = Value(bailId),
       dateEffet = Value(dateEffet),
       ancienLoyerCentimes = Value(ancienLoyerCentimes),
       nouveauLoyerCentimes = Value(nouveauLoyerCentimes),
       ancienIrlTrimestre = Value(ancienIrlTrimestre),
       ancienIrlAnnee = Value(ancienIrlAnnee),
       ancienIrlValeur = Value(ancienIrlValeur),
       nouvelIrlTrimestre = Value(nouvelIrlTrimestre),
       nouvelIrlAnnee = Value(nouvelIrlAnnee),
       nouvelIrlValeur = Value(nouvelIrlValeur),
       creeLe = Value(creeLe);
  static Insertable<RevisionLoyer> custom({
    Expression<String>? id,
    Expression<String>? bienId,
    Expression<String>? bailId,
    Expression<DateTime>? datePrevue,
    Expression<DateTime>? dateEffet,
    Expression<int>? ancienLoyerCentimes,
    Expression<int>? nouveauLoyerCentimes,
    Expression<int>? ancienIrlTrimestre,
    Expression<int>? ancienIrlAnnee,
    Expression<double>? ancienIrlValeur,
    Expression<int>? nouvelIrlTrimestre,
    Expression<int>? nouvelIrlAnnee,
    Expression<double>? nouvelIrlValeur,
    Expression<String>? courrierChemin,
    Expression<DateTime>? creeLe,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bienId != null) 'bien_id': bienId,
      if (bailId != null) 'bail_id': bailId,
      if (datePrevue != null) 'date_prevue': datePrevue,
      if (dateEffet != null) 'date_effet': dateEffet,
      if (ancienLoyerCentimes != null)
        'ancien_loyer_centimes': ancienLoyerCentimes,
      if (nouveauLoyerCentimes != null)
        'nouveau_loyer_centimes': nouveauLoyerCentimes,
      if (ancienIrlTrimestre != null)
        'ancien_irl_trimestre': ancienIrlTrimestre,
      if (ancienIrlAnnee != null) 'ancien_irl_annee': ancienIrlAnnee,
      if (ancienIrlValeur != null) 'ancien_irl_valeur': ancienIrlValeur,
      if (nouvelIrlTrimestre != null)
        'nouvel_irl_trimestre': nouvelIrlTrimestre,
      if (nouvelIrlAnnee != null) 'nouvel_irl_annee': nouvelIrlAnnee,
      if (nouvelIrlValeur != null) 'nouvel_irl_valeur': nouvelIrlValeur,
      if (courrierChemin != null) 'courrier_chemin': courrierChemin,
      if (creeLe != null) 'cree_le': creeLe,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RevisionsLoyersCompanion copyWith({
    Value<String>? id,
    Value<String>? bienId,
    Value<String>? bailId,
    Value<DateTime?>? datePrevue,
    Value<DateTime>? dateEffet,
    Value<int>? ancienLoyerCentimes,
    Value<int>? nouveauLoyerCentimes,
    Value<int>? ancienIrlTrimestre,
    Value<int>? ancienIrlAnnee,
    Value<double>? ancienIrlValeur,
    Value<int>? nouvelIrlTrimestre,
    Value<int>? nouvelIrlAnnee,
    Value<double>? nouvelIrlValeur,
    Value<String?>? courrierChemin,
    Value<DateTime>? creeLe,
    Value<int>? rowid,
  }) {
    return RevisionsLoyersCompanion(
      id: id ?? this.id,
      bienId: bienId ?? this.bienId,
      bailId: bailId ?? this.bailId,
      datePrevue: datePrevue ?? this.datePrevue,
      dateEffet: dateEffet ?? this.dateEffet,
      ancienLoyerCentimes: ancienLoyerCentimes ?? this.ancienLoyerCentimes,
      nouveauLoyerCentimes: nouveauLoyerCentimes ?? this.nouveauLoyerCentimes,
      ancienIrlTrimestre: ancienIrlTrimestre ?? this.ancienIrlTrimestre,
      ancienIrlAnnee: ancienIrlAnnee ?? this.ancienIrlAnnee,
      ancienIrlValeur: ancienIrlValeur ?? this.ancienIrlValeur,
      nouvelIrlTrimestre: nouvelIrlTrimestre ?? this.nouvelIrlTrimestre,
      nouvelIrlAnnee: nouvelIrlAnnee ?? this.nouvelIrlAnnee,
      nouvelIrlValeur: nouvelIrlValeur ?? this.nouvelIrlValeur,
      courrierChemin: courrierChemin ?? this.courrierChemin,
      creeLe: creeLe ?? this.creeLe,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bienId.present) {
      map['bien_id'] = Variable<String>(bienId.value);
    }
    if (bailId.present) {
      map['bail_id'] = Variable<String>(bailId.value);
    }
    if (datePrevue.present) {
      map['date_prevue'] = Variable<DateTime>(datePrevue.value);
    }
    if (dateEffet.present) {
      map['date_effet'] = Variable<DateTime>(dateEffet.value);
    }
    if (ancienLoyerCentimes.present) {
      map['ancien_loyer_centimes'] = Variable<int>(ancienLoyerCentimes.value);
    }
    if (nouveauLoyerCentimes.present) {
      map['nouveau_loyer_centimes'] = Variable<int>(nouveauLoyerCentimes.value);
    }
    if (ancienIrlTrimestre.present) {
      map['ancien_irl_trimestre'] = Variable<int>(ancienIrlTrimestre.value);
    }
    if (ancienIrlAnnee.present) {
      map['ancien_irl_annee'] = Variable<int>(ancienIrlAnnee.value);
    }
    if (ancienIrlValeur.present) {
      map['ancien_irl_valeur'] = Variable<double>(ancienIrlValeur.value);
    }
    if (nouvelIrlTrimestre.present) {
      map['nouvel_irl_trimestre'] = Variable<int>(nouvelIrlTrimestre.value);
    }
    if (nouvelIrlAnnee.present) {
      map['nouvel_irl_annee'] = Variable<int>(nouvelIrlAnnee.value);
    }
    if (nouvelIrlValeur.present) {
      map['nouvel_irl_valeur'] = Variable<double>(nouvelIrlValeur.value);
    }
    if (courrierChemin.present) {
      map['courrier_chemin'] = Variable<String>(courrierChemin.value);
    }
    if (creeLe.present) {
      map['cree_le'] = Variable<DateTime>(creeLe.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RevisionsLoyersCompanion(')
          ..write('id: $id, ')
          ..write('bienId: $bienId, ')
          ..write('bailId: $bailId, ')
          ..write('datePrevue: $datePrevue, ')
          ..write('dateEffet: $dateEffet, ')
          ..write('ancienLoyerCentimes: $ancienLoyerCentimes, ')
          ..write('nouveauLoyerCentimes: $nouveauLoyerCentimes, ')
          ..write('ancienIrlTrimestre: $ancienIrlTrimestre, ')
          ..write('ancienIrlAnnee: $ancienIrlAnnee, ')
          ..write('ancienIrlValeur: $ancienIrlValeur, ')
          ..write('nouvelIrlTrimestre: $nouvelIrlTrimestre, ')
          ..write('nouvelIrlAnnee: $nouvelIrlAnnee, ')
          ..write('nouvelIrlValeur: $nouvelIrlValeur, ')
          ..write('courrierChemin: $courrierChemin, ')
          ..write('creeLe: $creeLe, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$RevisionLoyerInsertable implements Insertable<RevisionLoyer> {
  RevisionLoyer _object;
  _$RevisionLoyerInsertable(this._object);
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return RevisionsLoyersCompanion(
      id: Value(_object.id),
      bienId: Value(_object.bienId),
      bailId: Value(_object.bailId),
      datePrevue: Value(_object.datePrevue),
      dateEffet: Value(_object.dateEffet),
      ancienLoyerCentimes: Value(_object.ancienLoyerCentimes),
      nouveauLoyerCentimes: Value(_object.nouveauLoyerCentimes),
      ancienIrlTrimestre: Value(_object.ancienIrlTrimestre),
      ancienIrlAnnee: Value(_object.ancienIrlAnnee),
      ancienIrlValeur: Value(_object.ancienIrlValeur),
      nouvelIrlTrimestre: Value(_object.nouvelIrlTrimestre),
      nouvelIrlAnnee: Value(_object.nouvelIrlAnnee),
      nouvelIrlValeur: Value(_object.nouvelIrlValeur),
      courrierChemin: Value(_object.courrierChemin),
      creeLe: Value(_object.creeLe),
    ).toColumns(false);
  }
}

extension RevisionLoyerToInsertable on RevisionLoyer {
  _$RevisionLoyerInsertable toInsertable() {
    return _$RevisionLoyerInsertable(this);
  }
}

class $IndicesIrlTable extends IndicesIrl
    with TableInfo<$IndicesIrlTable, IndiceIrl> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IndicesIrlTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _anneeMeta = const VerificationMeta('annee');
  @override
  late final GeneratedColumn<int> annee = GeneratedColumn<int>(
    'annee',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trimestreMeta = const VerificationMeta(
    'trimestre',
  );
  @override
  late final GeneratedColumn<int> trimestre = GeneratedColumn<int>(
    'trimestre',
    aliasedName,
    false,
    check: () => ComparableExpr(trimestre).isBetweenValues(1, 4),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valeurMeta = const VerificationMeta('valeur');
  @override
  late final GeneratedColumn<double> valeur = GeneratedColumn<double>(
    'valeur',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _datePublicationMeta = const VerificationMeta(
    'datePublication',
  );
  @override
  late final GeneratedColumn<DateTime> datePublication =
      GeneratedColumn<DateTime>(
        'date_publication',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  late final GeneratedColumnWithTypeConverter<SourceIndice, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SourceIndice>($IndicesIrlTable.$convertersource);
  @override
  List<GeneratedColumn> get $columns => [
    annee,
    trimestre,
    valeur,
    datePublication,
    source,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'indices_irl';
  @override
  VerificationContext validateIntegrity(
    Insertable<IndiceIrl> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('annee')) {
      context.handle(
        _anneeMeta,
        annee.isAcceptableOrUnknown(data['annee']!, _anneeMeta),
      );
    } else if (isInserting) {
      context.missing(_anneeMeta);
    }
    if (data.containsKey('trimestre')) {
      context.handle(
        _trimestreMeta,
        trimestre.isAcceptableOrUnknown(data['trimestre']!, _trimestreMeta),
      );
    } else if (isInserting) {
      context.missing(_trimestreMeta);
    }
    if (data.containsKey('valeur')) {
      context.handle(
        _valeurMeta,
        valeur.isAcceptableOrUnknown(data['valeur']!, _valeurMeta),
      );
    } else if (isInserting) {
      context.missing(_valeurMeta);
    }
    if (data.containsKey('date_publication')) {
      context.handle(
        _datePublicationMeta,
        datePublication.isAcceptableOrUnknown(
          data['date_publication']!,
          _datePublicationMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {annee, trimestre};
  @override
  IndiceIrl map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IndiceIrl(
      annee: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}annee'],
      )!,
      trimestre: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trimestre'],
      )!,
      valeur: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}valeur'],
      )!,
      datePublication: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_publication'],
      ),
      source: $IndicesIrlTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
    );
  }

  @override
  $IndicesIrlTable createAlias(String alias) {
    return $IndicesIrlTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SourceIndice, String, String> $convertersource =
      const EnumNameConverter<SourceIndice>(SourceIndice.values);
}

class IndicesIrlCompanion extends UpdateCompanion<IndiceIrl> {
  final Value<int> annee;
  final Value<int> trimestre;
  final Value<double> valeur;
  final Value<DateTime?> datePublication;
  final Value<SourceIndice> source;
  final Value<int> rowid;
  const IndicesIrlCompanion({
    this.annee = const Value.absent(),
    this.trimestre = const Value.absent(),
    this.valeur = const Value.absent(),
    this.datePublication = const Value.absent(),
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IndicesIrlCompanion.insert({
    required int annee,
    required int trimestre,
    required double valeur,
    this.datePublication = const Value.absent(),
    required SourceIndice source,
    this.rowid = const Value.absent(),
  }) : annee = Value(annee),
       trimestre = Value(trimestre),
       valeur = Value(valeur),
       source = Value(source);
  static Insertable<IndiceIrl> custom({
    Expression<int>? annee,
    Expression<int>? trimestre,
    Expression<double>? valeur,
    Expression<DateTime>? datePublication,
    Expression<String>? source,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (annee != null) 'annee': annee,
      if (trimestre != null) 'trimestre': trimestre,
      if (valeur != null) 'valeur': valeur,
      if (datePublication != null) 'date_publication': datePublication,
      if (source != null) 'source': source,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IndicesIrlCompanion copyWith({
    Value<int>? annee,
    Value<int>? trimestre,
    Value<double>? valeur,
    Value<DateTime?>? datePublication,
    Value<SourceIndice>? source,
    Value<int>? rowid,
  }) {
    return IndicesIrlCompanion(
      annee: annee ?? this.annee,
      trimestre: trimestre ?? this.trimestre,
      valeur: valeur ?? this.valeur,
      datePublication: datePublication ?? this.datePublication,
      source: source ?? this.source,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (annee.present) {
      map['annee'] = Variable<int>(annee.value);
    }
    if (trimestre.present) {
      map['trimestre'] = Variable<int>(trimestre.value);
    }
    if (valeur.present) {
      map['valeur'] = Variable<double>(valeur.value);
    }
    if (datePublication.present) {
      map['date_publication'] = Variable<DateTime>(datePublication.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $IndicesIrlTable.$convertersource.toSql(source.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IndicesIrlCompanion(')
          ..write('annee: $annee, ')
          ..write('trimestre: $trimestre, ')
          ..write('valeur: $valeur, ')
          ..write('datePublication: $datePublication, ')
          ..write('source: $source, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class _$IndiceIrlInsertable implements Insertable<IndiceIrl> {
  IndiceIrl _object;
  _$IndiceIrlInsertable(this._object);
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return IndicesIrlCompanion(
      annee: Value(_object.annee),
      trimestre: Value(_object.trimestre),
      valeur: Value(_object.valeur),
      datePublication: Value(_object.datePublication),
      source: Value(_object.source),
    ).toColumns(false);
  }
}

extension IndiceIrlToInsertable on IndiceIrl {
  _$IndiceIrlInsertable toInsertable() {
    return _$IndiceIrlInsertable(this);
  }
}

class $ReglagesTable extends Reglages
    with TableInfo<$ReglagesTable, ReglageLigne> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReglagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cleMeta = const VerificationMeta('cle');
  @override
  late final GeneratedColumn<String> cle = GeneratedColumn<String>(
    'cle',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valeurMeta = const VerificationMeta('valeur');
  @override
  late final GeneratedColumn<String> valeur = GeneratedColumn<String>(
    'valeur',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [cle, valeur];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reglages';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReglageLigne> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cle')) {
      context.handle(
        _cleMeta,
        cle.isAcceptableOrUnknown(data['cle']!, _cleMeta),
      );
    } else if (isInserting) {
      context.missing(_cleMeta);
    }
    if (data.containsKey('valeur')) {
      context.handle(
        _valeurMeta,
        valeur.isAcceptableOrUnknown(data['valeur']!, _valeurMeta),
      );
    } else if (isInserting) {
      context.missing(_valeurMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cle};
  @override
  ReglageLigne map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReglageLigne(
      cle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cle'],
      )!,
      valeur: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valeur'],
      )!,
    );
  }

  @override
  $ReglagesTable createAlias(String alias) {
    return $ReglagesTable(attachedDatabase, alias);
  }
}

class ReglageLigne extends DataClass implements Insertable<ReglageLigne> {
  final String cle;
  final String valeur;
  const ReglageLigne({required this.cle, required this.valeur});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cle'] = Variable<String>(cle);
    map['valeur'] = Variable<String>(valeur);
    return map;
  }

  ReglagesCompanion toCompanion(bool nullToAbsent) {
    return ReglagesCompanion(cle: Value(cle), valeur: Value(valeur));
  }

  factory ReglageLigne.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReglageLigne(
      cle: serializer.fromJson<String>(json['cle']),
      valeur: serializer.fromJson<String>(json['valeur']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cle': serializer.toJson<String>(cle),
      'valeur': serializer.toJson<String>(valeur),
    };
  }

  ReglageLigne copyWith({String? cle, String? valeur}) =>
      ReglageLigne(cle: cle ?? this.cle, valeur: valeur ?? this.valeur);
  ReglageLigne copyWithCompanion(ReglagesCompanion data) {
    return ReglageLigne(
      cle: data.cle.present ? data.cle.value : this.cle,
      valeur: data.valeur.present ? data.valeur.value : this.valeur,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReglageLigne(')
          ..write('cle: $cle, ')
          ..write('valeur: $valeur')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cle, valeur);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReglageLigne &&
          other.cle == this.cle &&
          other.valeur == this.valeur);
}

class ReglagesCompanion extends UpdateCompanion<ReglageLigne> {
  final Value<String> cle;
  final Value<String> valeur;
  final Value<int> rowid;
  const ReglagesCompanion({
    this.cle = const Value.absent(),
    this.valeur = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReglagesCompanion.insert({
    required String cle,
    required String valeur,
    this.rowid = const Value.absent(),
  }) : cle = Value(cle),
       valeur = Value(valeur);
  static Insertable<ReglageLigne> custom({
    Expression<String>? cle,
    Expression<String>? valeur,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cle != null) 'cle': cle,
      if (valeur != null) 'valeur': valeur,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReglagesCompanion copyWith({
    Value<String>? cle,
    Value<String>? valeur,
    Value<int>? rowid,
  }) {
    return ReglagesCompanion(
      cle: cle ?? this.cle,
      valeur: valeur ?? this.valeur,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cle.present) {
      map['cle'] = Variable<String>(cle.value);
    }
    if (valeur.present) {
      map['valeur'] = Variable<String>(valeur.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReglagesCompanion(')
          ..write('cle: $cle, ')
          ..write('valeur: $valeur, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BailleursTable bailleurs = $BailleursTable(this);
  late final $BiensTable biens = $BiensTable(this);
  late final $BauxTable baux = $BauxTable(this);
  late final $LocatairesTable locataires = $LocatairesTable(this);
  late final $EcheancesTable echeances = $EcheancesTable(this);
  late final $RappelsTable rappels = $RappelsTable(this);
  late final $ArtisansTable artisans = $ArtisansTable(this);
  late final $InterventionsTable interventions = $InterventionsTable(this);
  late final $MouvementsFinanciersTable mouvementsFinanciers =
      $MouvementsFinanciersTable(this);
  late final $EncaissementsLoyersTable encaissementsLoyers =
      $EncaissementsLoyersTable(this);
  late final $RevisionsLoyersTable revisionsLoyers = $RevisionsLoyersTable(
    this,
  );
  late final $IndicesIrlTable indicesIrl = $IndicesIrlTable(this);
  late final $ReglagesTable reglages = $ReglagesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    bailleurs,
    biens,
    baux,
    locataires,
    echeances,
    rappels,
    artisans,
    interventions,
    mouvementsFinanciers,
    encaissementsLoyers,
    revisionsLoyers,
    indicesIrl,
    reglages,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'biens',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('baux', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'baux',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('locataires', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'biens',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('echeances', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'echeances',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('rappels', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'biens',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('interventions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'artisans',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('interventions', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'biens',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('mouvements_financiers', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'interventions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('mouvements_financiers', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'biens',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('encaissements_loyers', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'biens',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('revisions_loyers', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'baux',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('revisions_loyers', kind: UpdateKind.delete)],
    ),
  ]);
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$BailleursTableCreateCompanionBuilder =
    BailleursCompanion Function({
      required String id,
      required String prenom,
      required String nom,
      required String rue,
      required String codePostal,
      required String ville,
      required String telephone,
      required String email,
      required DateTime creeLe,
      required DateTime modifieLe,
      Value<int> rowid,
    });
typedef $$BailleursTableUpdateCompanionBuilder =
    BailleursCompanion Function({
      Value<String> id,
      Value<String> prenom,
      Value<String> nom,
      Value<String> rue,
      Value<String> codePostal,
      Value<String> ville,
      Value<String> telephone,
      Value<String> email,
      Value<DateTime> creeLe,
      Value<DateTime> modifieLe,
      Value<int> rowid,
    });

class $$BailleursTableFilterComposer
    extends Composer<_$AppDatabase, $BailleursTable> {
  $$BailleursTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prenom => $composableBuilder(
    column: $table.prenom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nom => $composableBuilder(
    column: $table.nom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rue => $composableBuilder(
    column: $table.rue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codePostal => $composableBuilder(
    column: $table.codePostal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ville => $composableBuilder(
    column: $table.ville,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telephone => $composableBuilder(
    column: $table.telephone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creeLe => $composableBuilder(
    column: $table.creeLe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modifieLe => $composableBuilder(
    column: $table.modifieLe,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BailleursTableOrderingComposer
    extends Composer<_$AppDatabase, $BailleursTable> {
  $$BailleursTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prenom => $composableBuilder(
    column: $table.prenom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nom => $composableBuilder(
    column: $table.nom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rue => $composableBuilder(
    column: $table.rue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codePostal => $composableBuilder(
    column: $table.codePostal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ville => $composableBuilder(
    column: $table.ville,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telephone => $composableBuilder(
    column: $table.telephone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creeLe => $composableBuilder(
    column: $table.creeLe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modifieLe => $composableBuilder(
    column: $table.modifieLe,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BailleursTableAnnotationComposer
    extends Composer<_$AppDatabase, $BailleursTable> {
  $$BailleursTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get prenom =>
      $composableBuilder(column: $table.prenom, builder: (column) => column);

  GeneratedColumn<String> get nom =>
      $composableBuilder(column: $table.nom, builder: (column) => column);

  GeneratedColumn<String> get rue =>
      $composableBuilder(column: $table.rue, builder: (column) => column);

  GeneratedColumn<String> get codePostal => $composableBuilder(
    column: $table.codePostal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ville =>
      $composableBuilder(column: $table.ville, builder: (column) => column);

  GeneratedColumn<String> get telephone =>
      $composableBuilder(column: $table.telephone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<DateTime> get creeLe =>
      $composableBuilder(column: $table.creeLe, builder: (column) => column);

  GeneratedColumn<DateTime> get modifieLe =>
      $composableBuilder(column: $table.modifieLe, builder: (column) => column);
}

class $$BailleursTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BailleursTable,
          Bailleur,
          $$BailleursTableFilterComposer,
          $$BailleursTableOrderingComposer,
          $$BailleursTableAnnotationComposer,
          $$BailleursTableCreateCompanionBuilder,
          $$BailleursTableUpdateCompanionBuilder,
          (Bailleur, BaseReferences<_$AppDatabase, $BailleursTable, Bailleur>),
          Bailleur,
          PrefetchHooks Function()
        > {
  $$BailleursTableTableManager(_$AppDatabase db, $BailleursTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BailleursTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BailleursTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BailleursTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> prenom = const Value.absent(),
                Value<String> nom = const Value.absent(),
                Value<String> rue = const Value.absent(),
                Value<String> codePostal = const Value.absent(),
                Value<String> ville = const Value.absent(),
                Value<String> telephone = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<DateTime> creeLe = const Value.absent(),
                Value<DateTime> modifieLe = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BailleursCompanion(
                id: id,
                prenom: prenom,
                nom: nom,
                rue: rue,
                codePostal: codePostal,
                ville: ville,
                telephone: telephone,
                email: email,
                creeLe: creeLe,
                modifieLe: modifieLe,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String prenom,
                required String nom,
                required String rue,
                required String codePostal,
                required String ville,
                required String telephone,
                required String email,
                required DateTime creeLe,
                required DateTime modifieLe,
                Value<int> rowid = const Value.absent(),
              }) => BailleursCompanion.insert(
                id: id,
                prenom: prenom,
                nom: nom,
                rue: rue,
                codePostal: codePostal,
                ville: ville,
                telephone: telephone,
                email: email,
                creeLe: creeLe,
                modifieLe: modifieLe,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BailleursTable, Bailleur>(table),
                  BaseReferences<_$AppDatabase, $BailleursTable, Bailleur>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BailleursTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BailleursTable,
      Bailleur,
      $$BailleursTableFilterComposer,
      $$BailleursTableOrderingComposer,
      $$BailleursTableAnnotationComposer,
      $$BailleursTableCreateCompanionBuilder,
      $$BailleursTableUpdateCompanionBuilder,
      (Bailleur, BaseReferences<_$AppDatabase, $BailleursTable, Bailleur>),
      Bailleur,
      PrefetchHooks Function()
    >;
typedef $$BiensTableCreateCompanionBuilder =
    BiensCompanion Function({
      required String id,
      required String nom,
      required TypeLogement typeLogement,
      required TypeLocation typeLocation,
      required String rue,
      required String codePostal,
      required String ville,
      required int loyerHcCentimes,
      required int chargesCentimes,
      Value<String?> photoChemin,
      Value<double?> surfaceM2,
      Value<ClasseDpe?> classeDpe,
      Value<DateTime?> dateDpe,
      Value<int?> nombreLots,
      Value<int?> prixAchatCentimes,
      Value<int?> fraisNotaireCentimes,
      Value<int?> travauxInitiauxCentimes,
      Value<int?> mensualiteCreditCentimes,
      Value<int?> taxeFonciereCentimes,
      Value<int?> assuranceCentimes,
      Value<int?> chargesNonRecuperablesCentimes,
      Value<int?> fraisDiversCentimes,
      required int ordre,
      required DateTime creeLe,
      required DateTime modifieLe,
      Value<int> rowid,
    });
typedef $$BiensTableUpdateCompanionBuilder =
    BiensCompanion Function({
      Value<String> id,
      Value<String> nom,
      Value<TypeLogement> typeLogement,
      Value<TypeLocation> typeLocation,
      Value<String> rue,
      Value<String> codePostal,
      Value<String> ville,
      Value<int> loyerHcCentimes,
      Value<int> chargesCentimes,
      Value<String?> photoChemin,
      Value<double?> surfaceM2,
      Value<ClasseDpe?> classeDpe,
      Value<DateTime?> dateDpe,
      Value<int?> nombreLots,
      Value<int?> prixAchatCentimes,
      Value<int?> fraisNotaireCentimes,
      Value<int?> travauxInitiauxCentimes,
      Value<int?> mensualiteCreditCentimes,
      Value<int?> taxeFonciereCentimes,
      Value<int?> assuranceCentimes,
      Value<int?> chargesNonRecuperablesCentimes,
      Value<int?> fraisDiversCentimes,
      Value<int> ordre,
      Value<DateTime> creeLe,
      Value<DateTime> modifieLe,
      Value<int> rowid,
    });

final class $$BiensTableReferences
    extends BaseReferences<_$AppDatabase, $BiensTable, Bien> {
  $$BiensTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BauxTable, List<Bail>> _bauxRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.baux,
    aliasName: 'biens__id__baux__bien_id',
  );

  $$BauxTableProcessedTableManager get bauxRefs {
    final manager = $$BauxTableTableManager(
      $_db,
      $_db.baux,
    ).filter((f) => f.bienId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_bauxRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EcheancesTable, List<Echeance>>
  _echeancesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.echeances,
    aliasName: 'biens__id__echeances__bien_id',
  );

  $$EcheancesTableProcessedTableManager get echeancesRefs {
    final manager = $$EcheancesTableTableManager(
      $_db,
      $_db.echeances,
    ).filter((f) => f.bienId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_echeancesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$InterventionsTable, List<Intervention>>
  _interventionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.interventions,
    aliasName: 'biens__id__interventions__bien_id',
  );

  $$InterventionsTableProcessedTableManager get interventionsRefs {
    final manager = $$InterventionsTableTableManager(
      $_db,
      $_db.interventions,
    ).filter((f) => f.bienId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_interventionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $MouvementsFinanciersTable,
    List<MouvementFinancier>
  >
  _mouvementsFinanciersRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.mouvementsFinanciers,
        aliasName: 'biens__id__mouvements_financiers__bien_id',
      );

  $$MouvementsFinanciersTableProcessedTableManager
  get mouvementsFinanciersRefs {
    final manager = $$MouvementsFinanciersTableTableManager(
      $_db,
      $_db.mouvementsFinanciers,
    ).filter((f) => f.bienId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _mouvementsFinanciersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EncaissementsLoyersTable, List<EncaissementLoyer>>
  _encaissementsLoyersRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.encaissementsLoyers,
        aliasName: 'biens__id__encaissements_loyers__bien_id',
      );

  $$EncaissementsLoyersTableProcessedTableManager get encaissementsLoyersRefs {
    final manager = $$EncaissementsLoyersTableTableManager(
      $_db,
      $_db.encaissementsLoyers,
    ).filter((f) => f.bienId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _encaissementsLoyersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RevisionsLoyersTable, List<RevisionLoyer>>
  _revisionsLoyersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.revisionsLoyers,
    aliasName: 'biens__id__revisions_loyers__bien_id',
  );

  $$RevisionsLoyersTableProcessedTableManager get revisionsLoyersRefs {
    final manager = $$RevisionsLoyersTableTableManager(
      $_db,
      $_db.revisionsLoyers,
    ).filter((f) => f.bienId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _revisionsLoyersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BiensTableFilterComposer extends Composer<_$AppDatabase, $BiensTable> {
  $$BiensTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nom => $composableBuilder(
    column: $table.nom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TypeLogement, TypeLogement, String>
  get typeLogement => $composableBuilder(
    column: $table.typeLogement,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<TypeLocation, TypeLocation, String>
  get typeLocation => $composableBuilder(
    column: $table.typeLocation,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get rue => $composableBuilder(
    column: $table.rue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codePostal => $composableBuilder(
    column: $table.codePostal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ville => $composableBuilder(
    column: $table.ville,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get loyerHcCentimes => $composableBuilder(
    column: $table.loyerHcCentimes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chargesCentimes => $composableBuilder(
    column: $table.chargesCentimes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoChemin => $composableBuilder(
    column: $table.photoChemin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get surfaceM2 => $composableBuilder(
    column: $table.surfaceM2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ClasseDpe?, ClasseDpe, String> get classeDpe =>
      $composableBuilder(
        column: $table.classeDpe,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get dateDpe => $composableBuilder(
    column: $table.dateDpe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nombreLots => $composableBuilder(
    column: $table.nombreLots,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get prixAchatCentimes => $composableBuilder(
    column: $table.prixAchatCentimes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fraisNotaireCentimes => $composableBuilder(
    column: $table.fraisNotaireCentimes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get travauxInitiauxCentimes => $composableBuilder(
    column: $table.travauxInitiauxCentimes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mensualiteCreditCentimes => $composableBuilder(
    column: $table.mensualiteCreditCentimes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taxeFonciereCentimes => $composableBuilder(
    column: $table.taxeFonciereCentimes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get assuranceCentimes => $composableBuilder(
    column: $table.assuranceCentimes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chargesNonRecuperablesCentimes => $composableBuilder(
    column: $table.chargesNonRecuperablesCentimes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fraisDiversCentimes => $composableBuilder(
    column: $table.fraisDiversCentimes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ordre => $composableBuilder(
    column: $table.ordre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creeLe => $composableBuilder(
    column: $table.creeLe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modifieLe => $composableBuilder(
    column: $table.modifieLe,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> bauxRefs(
    Expression<bool> Function($$BauxTableFilterComposer f) f,
  ) {
    final $$BauxTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.baux,
      getReferencedColumn: (t) => t.bienId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BauxTableFilterComposer(
            $db: $db,
            $table: $db.baux,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> echeancesRefs(
    Expression<bool> Function($$EcheancesTableFilterComposer f) f,
  ) {
    final $$EcheancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.echeances,
      getReferencedColumn: (t) => t.bienId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EcheancesTableFilterComposer(
            $db: $db,
            $table: $db.echeances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> interventionsRefs(
    Expression<bool> Function($$InterventionsTableFilterComposer f) f,
  ) {
    final $$InterventionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.interventions,
      getReferencedColumn: (t) => t.bienId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InterventionsTableFilterComposer(
            $db: $db,
            $table: $db.interventions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> mouvementsFinanciersRefs(
    Expression<bool> Function($$MouvementsFinanciersTableFilterComposer f) f,
  ) {
    final $$MouvementsFinanciersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mouvementsFinanciers,
      getReferencedColumn: (t) => t.bienId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MouvementsFinanciersTableFilterComposer(
            $db: $db,
            $table: $db.mouvementsFinanciers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> encaissementsLoyersRefs(
    Expression<bool> Function($$EncaissementsLoyersTableFilterComposer f) f,
  ) {
    final $$EncaissementsLoyersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.encaissementsLoyers,
      getReferencedColumn: (t) => t.bienId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EncaissementsLoyersTableFilterComposer(
            $db: $db,
            $table: $db.encaissementsLoyers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> revisionsLoyersRefs(
    Expression<bool> Function($$RevisionsLoyersTableFilterComposer f) f,
  ) {
    final $$RevisionsLoyersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.revisionsLoyers,
      getReferencedColumn: (t) => t.bienId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RevisionsLoyersTableFilterComposer(
            $db: $db,
            $table: $db.revisionsLoyers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BiensTableOrderingComposer
    extends Composer<_$AppDatabase, $BiensTable> {
  $$BiensTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nom => $composableBuilder(
    column: $table.nom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get typeLogement => $composableBuilder(
    column: $table.typeLogement,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get typeLocation => $composableBuilder(
    column: $table.typeLocation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rue => $composableBuilder(
    column: $table.rue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codePostal => $composableBuilder(
    column: $table.codePostal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ville => $composableBuilder(
    column: $table.ville,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get loyerHcCentimes => $composableBuilder(
    column: $table.loyerHcCentimes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chargesCentimes => $composableBuilder(
    column: $table.chargesCentimes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoChemin => $composableBuilder(
    column: $table.photoChemin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get surfaceM2 => $composableBuilder(
    column: $table.surfaceM2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classeDpe => $composableBuilder(
    column: $table.classeDpe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateDpe => $composableBuilder(
    column: $table.dateDpe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nombreLots => $composableBuilder(
    column: $table.nombreLots,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get prixAchatCentimes => $composableBuilder(
    column: $table.prixAchatCentimes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fraisNotaireCentimes => $composableBuilder(
    column: $table.fraisNotaireCentimes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get travauxInitiauxCentimes => $composableBuilder(
    column: $table.travauxInitiauxCentimes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mensualiteCreditCentimes => $composableBuilder(
    column: $table.mensualiteCreditCentimes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taxeFonciereCentimes => $composableBuilder(
    column: $table.taxeFonciereCentimes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get assuranceCentimes => $composableBuilder(
    column: $table.assuranceCentimes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chargesNonRecuperablesCentimes => $composableBuilder(
    column: $table.chargesNonRecuperablesCentimes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fraisDiversCentimes => $composableBuilder(
    column: $table.fraisDiversCentimes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ordre => $composableBuilder(
    column: $table.ordre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creeLe => $composableBuilder(
    column: $table.creeLe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modifieLe => $composableBuilder(
    column: $table.modifieLe,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BiensTableAnnotationComposer
    extends Composer<_$AppDatabase, $BiensTable> {
  $$BiensTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nom =>
      $composableBuilder(column: $table.nom, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TypeLogement, String> get typeLogement =>
      $composableBuilder(
        column: $table.typeLogement,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<TypeLocation, String> get typeLocation =>
      $composableBuilder(
        column: $table.typeLocation,
        builder: (column) => column,
      );

  GeneratedColumn<String> get rue =>
      $composableBuilder(column: $table.rue, builder: (column) => column);

  GeneratedColumn<String> get codePostal => $composableBuilder(
    column: $table.codePostal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ville =>
      $composableBuilder(column: $table.ville, builder: (column) => column);

  GeneratedColumn<int> get loyerHcCentimes => $composableBuilder(
    column: $table.loyerHcCentimes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get chargesCentimes => $composableBuilder(
    column: $table.chargesCentimes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoChemin => $composableBuilder(
    column: $table.photoChemin,
    builder: (column) => column,
  );

  GeneratedColumn<double> get surfaceM2 =>
      $composableBuilder(column: $table.surfaceM2, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ClasseDpe?, String> get classeDpe =>
      $composableBuilder(column: $table.classeDpe, builder: (column) => column);

  GeneratedColumn<DateTime> get dateDpe =>
      $composableBuilder(column: $table.dateDpe, builder: (column) => column);

  GeneratedColumn<int> get nombreLots => $composableBuilder(
    column: $table.nombreLots,
    builder: (column) => column,
  );

  GeneratedColumn<int> get prixAchatCentimes => $composableBuilder(
    column: $table.prixAchatCentimes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fraisNotaireCentimes => $composableBuilder(
    column: $table.fraisNotaireCentimes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get travauxInitiauxCentimes => $composableBuilder(
    column: $table.travauxInitiauxCentimes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get mensualiteCreditCentimes => $composableBuilder(
    column: $table.mensualiteCreditCentimes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get taxeFonciereCentimes => $composableBuilder(
    column: $table.taxeFonciereCentimes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get assuranceCentimes => $composableBuilder(
    column: $table.assuranceCentimes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get chargesNonRecuperablesCentimes => $composableBuilder(
    column: $table.chargesNonRecuperablesCentimes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fraisDiversCentimes => $composableBuilder(
    column: $table.fraisDiversCentimes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ordre =>
      $composableBuilder(column: $table.ordre, builder: (column) => column);

  GeneratedColumn<DateTime> get creeLe =>
      $composableBuilder(column: $table.creeLe, builder: (column) => column);

  GeneratedColumn<DateTime> get modifieLe =>
      $composableBuilder(column: $table.modifieLe, builder: (column) => column);

  Expression<T> bauxRefs<T extends Object>(
    Expression<T> Function($$BauxTableAnnotationComposer a) f,
  ) {
    final $$BauxTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.baux,
      getReferencedColumn: (t) => t.bienId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BauxTableAnnotationComposer(
            $db: $db,
            $table: $db.baux,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> echeancesRefs<T extends Object>(
    Expression<T> Function($$EcheancesTableAnnotationComposer a) f,
  ) {
    final $$EcheancesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.echeances,
      getReferencedColumn: (t) => t.bienId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EcheancesTableAnnotationComposer(
            $db: $db,
            $table: $db.echeances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> interventionsRefs<T extends Object>(
    Expression<T> Function($$InterventionsTableAnnotationComposer a) f,
  ) {
    final $$InterventionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.interventions,
      getReferencedColumn: (t) => t.bienId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InterventionsTableAnnotationComposer(
            $db: $db,
            $table: $db.interventions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> mouvementsFinanciersRefs<T extends Object>(
    Expression<T> Function($$MouvementsFinanciersTableAnnotationComposer a) f,
  ) {
    final $$MouvementsFinanciersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.mouvementsFinanciers,
          getReferencedColumn: (t) => t.bienId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MouvementsFinanciersTableAnnotationComposer(
                $db: $db,
                $table: $db.mouvementsFinanciers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> encaissementsLoyersRefs<T extends Object>(
    Expression<T> Function($$EncaissementsLoyersTableAnnotationComposer a) f,
  ) {
    final $$EncaissementsLoyersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.encaissementsLoyers,
          getReferencedColumn: (t) => t.bienId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EncaissementsLoyersTableAnnotationComposer(
                $db: $db,
                $table: $db.encaissementsLoyers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> revisionsLoyersRefs<T extends Object>(
    Expression<T> Function($$RevisionsLoyersTableAnnotationComposer a) f,
  ) {
    final $$RevisionsLoyersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.revisionsLoyers,
      getReferencedColumn: (t) => t.bienId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RevisionsLoyersTableAnnotationComposer(
            $db: $db,
            $table: $db.revisionsLoyers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BiensTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BiensTable,
          Bien,
          $$BiensTableFilterComposer,
          $$BiensTableOrderingComposer,
          $$BiensTableAnnotationComposer,
          $$BiensTableCreateCompanionBuilder,
          $$BiensTableUpdateCompanionBuilder,
          (Bien, $$BiensTableReferences),
          Bien,
          PrefetchHooks Function({
            bool bauxRefs,
            bool echeancesRefs,
            bool interventionsRefs,
            bool mouvementsFinanciersRefs,
            bool encaissementsLoyersRefs,
            bool revisionsLoyersRefs,
          })
        > {
  $$BiensTableTableManager(_$AppDatabase db, $BiensTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BiensTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BiensTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BiensTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nom = const Value.absent(),
                Value<TypeLogement> typeLogement = const Value.absent(),
                Value<TypeLocation> typeLocation = const Value.absent(),
                Value<String> rue = const Value.absent(),
                Value<String> codePostal = const Value.absent(),
                Value<String> ville = const Value.absent(),
                Value<int> loyerHcCentimes = const Value.absent(),
                Value<int> chargesCentimes = const Value.absent(),
                Value<String?> photoChemin = const Value.absent(),
                Value<double?> surfaceM2 = const Value.absent(),
                Value<ClasseDpe?> classeDpe = const Value.absent(),
                Value<DateTime?> dateDpe = const Value.absent(),
                Value<int?> nombreLots = const Value.absent(),
                Value<int?> prixAchatCentimes = const Value.absent(),
                Value<int?> fraisNotaireCentimes = const Value.absent(),
                Value<int?> travauxInitiauxCentimes = const Value.absent(),
                Value<int?> mensualiteCreditCentimes = const Value.absent(),
                Value<int?> taxeFonciereCentimes = const Value.absent(),
                Value<int?> assuranceCentimes = const Value.absent(),
                Value<int?> chargesNonRecuperablesCentimes =
                    const Value.absent(),
                Value<int?> fraisDiversCentimes = const Value.absent(),
                Value<int> ordre = const Value.absent(),
                Value<DateTime> creeLe = const Value.absent(),
                Value<DateTime> modifieLe = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BiensCompanion(
                id: id,
                nom: nom,
                typeLogement: typeLogement,
                typeLocation: typeLocation,
                rue: rue,
                codePostal: codePostal,
                ville: ville,
                loyerHcCentimes: loyerHcCentimes,
                chargesCentimes: chargesCentimes,
                photoChemin: photoChemin,
                surfaceM2: surfaceM2,
                classeDpe: classeDpe,
                dateDpe: dateDpe,
                nombreLots: nombreLots,
                prixAchatCentimes: prixAchatCentimes,
                fraisNotaireCentimes: fraisNotaireCentimes,
                travauxInitiauxCentimes: travauxInitiauxCentimes,
                mensualiteCreditCentimes: mensualiteCreditCentimes,
                taxeFonciereCentimes: taxeFonciereCentimes,
                assuranceCentimes: assuranceCentimes,
                chargesNonRecuperablesCentimes: chargesNonRecuperablesCentimes,
                fraisDiversCentimes: fraisDiversCentimes,
                ordre: ordre,
                creeLe: creeLe,
                modifieLe: modifieLe,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nom,
                required TypeLogement typeLogement,
                required TypeLocation typeLocation,
                required String rue,
                required String codePostal,
                required String ville,
                required int loyerHcCentimes,
                required int chargesCentimes,
                Value<String?> photoChemin = const Value.absent(),
                Value<double?> surfaceM2 = const Value.absent(),
                Value<ClasseDpe?> classeDpe = const Value.absent(),
                Value<DateTime?> dateDpe = const Value.absent(),
                Value<int?> nombreLots = const Value.absent(),
                Value<int?> prixAchatCentimes = const Value.absent(),
                Value<int?> fraisNotaireCentimes = const Value.absent(),
                Value<int?> travauxInitiauxCentimes = const Value.absent(),
                Value<int?> mensualiteCreditCentimes = const Value.absent(),
                Value<int?> taxeFonciereCentimes = const Value.absent(),
                Value<int?> assuranceCentimes = const Value.absent(),
                Value<int?> chargesNonRecuperablesCentimes =
                    const Value.absent(),
                Value<int?> fraisDiversCentimes = const Value.absent(),
                required int ordre,
                required DateTime creeLe,
                required DateTime modifieLe,
                Value<int> rowid = const Value.absent(),
              }) => BiensCompanion.insert(
                id: id,
                nom: nom,
                typeLogement: typeLogement,
                typeLocation: typeLocation,
                rue: rue,
                codePostal: codePostal,
                ville: ville,
                loyerHcCentimes: loyerHcCentimes,
                chargesCentimes: chargesCentimes,
                photoChemin: photoChemin,
                surfaceM2: surfaceM2,
                classeDpe: classeDpe,
                dateDpe: dateDpe,
                nombreLots: nombreLots,
                prixAchatCentimes: prixAchatCentimes,
                fraisNotaireCentimes: fraisNotaireCentimes,
                travauxInitiauxCentimes: travauxInitiauxCentimes,
                mensualiteCreditCentimes: mensualiteCreditCentimes,
                taxeFonciereCentimes: taxeFonciereCentimes,
                assuranceCentimes: assuranceCentimes,
                chargesNonRecuperablesCentimes: chargesNonRecuperablesCentimes,
                fraisDiversCentimes: fraisDiversCentimes,
                ordre: ordre,
                creeLe: creeLe,
                modifieLe: modifieLe,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BiensTable, Bien>(table),
                  $$BiensTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                bauxRefs = false,
                echeancesRefs = false,
                interventionsRefs = false,
                mouvementsFinanciersRefs = false,
                encaissementsLoyersRefs = false,
                revisionsLoyersRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (bauxRefs) db.baux,
                    if (echeancesRefs) db.echeances,
                    if (interventionsRefs) db.interventions,
                    if (mouvementsFinanciersRefs) db.mouvementsFinanciers,
                    if (encaissementsLoyersRefs) db.encaissementsLoyers,
                    if (revisionsLoyersRefs) db.revisionsLoyers,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (bauxRefs)
                        await $_getPrefetchedData<Bien, $BiensTable, Bail>(
                          currentTable: table,
                          referencedTable: $$BiensTableReferences
                              ._bauxRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BiensTableReferences(db, table, p0).bauxRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bienId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (echeancesRefs)
                        await $_getPrefetchedData<Bien, $BiensTable, Echeance>(
                          currentTable: table,
                          referencedTable: $$BiensTableReferences
                              ._echeancesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BiensTableReferences(
                                db,
                                table,
                                p0,
                              ).echeancesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bienId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (interventionsRefs)
                        await $_getPrefetchedData<
                          Bien,
                          $BiensTable,
                          Intervention
                        >(
                          currentTable: table,
                          referencedTable: $$BiensTableReferences
                              ._interventionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BiensTableReferences(
                                db,
                                table,
                                p0,
                              ).interventionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bienId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (mouvementsFinanciersRefs)
                        await $_getPrefetchedData<
                          Bien,
                          $BiensTable,
                          MouvementFinancier
                        >(
                          currentTable: table,
                          referencedTable: $$BiensTableReferences
                              ._mouvementsFinanciersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BiensTableReferences(
                                db,
                                table,
                                p0,
                              ).mouvementsFinanciersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bienId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (encaissementsLoyersRefs)
                        await $_getPrefetchedData<
                          Bien,
                          $BiensTable,
                          EncaissementLoyer
                        >(
                          currentTable: table,
                          referencedTable: $$BiensTableReferences
                              ._encaissementsLoyersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BiensTableReferences(
                                db,
                                table,
                                p0,
                              ).encaissementsLoyersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bienId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (revisionsLoyersRefs)
                        await $_getPrefetchedData<
                          Bien,
                          $BiensTable,
                          RevisionLoyer
                        >(
                          currentTable: table,
                          referencedTable: $$BiensTableReferences
                              ._revisionsLoyersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BiensTableReferences(
                                db,
                                table,
                                p0,
                              ).revisionsLoyersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bienId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BiensTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BiensTable,
      Bien,
      $$BiensTableFilterComposer,
      $$BiensTableOrderingComposer,
      $$BiensTableAnnotationComposer,
      $$BiensTableCreateCompanionBuilder,
      $$BiensTableUpdateCompanionBuilder,
      (Bien, $$BiensTableReferences),
      Bien,
      PrefetchHooks Function({
        bool bauxRefs,
        bool echeancesRefs,
        bool interventionsRefs,
        bool mouvementsFinanciersRefs,
        bool encaissementsLoyersRefs,
        bool revisionsLoyersRefs,
      })
    >;
typedef $$BauxTableCreateCompanionBuilder =
    BauxCompanion Function({
      required String id,
      required String bienId,
      required TypeBail typeBail,
      required DateTime dateDebut,
      Value<int?> dureeMois,
      Value<int?> depotGarantieCentimes,
      Value<DateTime?> dateRevision,
      Value<int?> irlTrimestre,
      Value<int?> irlAnnee,
      Value<double?> irlValeur,
      required bool actif,
      required DateTime creeLe,
      required DateTime modifieLe,
      Value<int> rowid,
    });
typedef $$BauxTableUpdateCompanionBuilder =
    BauxCompanion Function({
      Value<String> id,
      Value<String> bienId,
      Value<TypeBail> typeBail,
      Value<DateTime> dateDebut,
      Value<int?> dureeMois,
      Value<int?> depotGarantieCentimes,
      Value<DateTime?> dateRevision,
      Value<int?> irlTrimestre,
      Value<int?> irlAnnee,
      Value<double?> irlValeur,
      Value<bool> actif,
      Value<DateTime> creeLe,
      Value<DateTime> modifieLe,
      Value<int> rowid,
    });

final class $$BauxTableReferences
    extends BaseReferences<_$AppDatabase, $BauxTable, Bail> {
  $$BauxTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BiensTable _bienIdTable(_$AppDatabase db) =>
      db.biens.createAlias('baux__bien_id__biens__id');

  $$BiensTableProcessedTableManager get bienId {
    final $_column = $_itemColumn<String>('bien_id')!;

    final manager = $$BiensTableTableManager(
      $_db,
      $_db.biens,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bienIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$LocatairesTable, List<Locataire>>
  _locatairesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.locataires,
    aliasName: 'baux__id__locataires__bail_id',
  );

  $$LocatairesTableProcessedTableManager get locatairesRefs {
    final manager = $$LocatairesTableTableManager(
      $_db,
      $_db.locataires,
    ).filter((f) => f.bailId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_locatairesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RevisionsLoyersTable, List<RevisionLoyer>>
  _revisionsLoyersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.revisionsLoyers,
    aliasName: 'baux__id__revisions_loyers__bail_id',
  );

  $$RevisionsLoyersTableProcessedTableManager get revisionsLoyersRefs {
    final manager = $$RevisionsLoyersTableTableManager(
      $_db,
      $_db.revisionsLoyers,
    ).filter((f) => f.bailId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _revisionsLoyersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BauxTableFilterComposer extends Composer<_$AppDatabase, $BauxTable> {
  $$BauxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TypeBail, TypeBail, String> get typeBail =>
      $composableBuilder(
        column: $table.typeBail,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get dateDebut => $composableBuilder(
    column: $table.dateDebut,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dureeMois => $composableBuilder(
    column: $table.dureeMois,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get depotGarantieCentimes => $composableBuilder(
    column: $table.depotGarantieCentimes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateRevision => $composableBuilder(
    column: $table.dateRevision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get irlTrimestre => $composableBuilder(
    column: $table.irlTrimestre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get irlAnnee => $composableBuilder(
    column: $table.irlAnnee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get irlValeur => $composableBuilder(
    column: $table.irlValeur,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get actif => $composableBuilder(
    column: $table.actif,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creeLe => $composableBuilder(
    column: $table.creeLe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modifieLe => $composableBuilder(
    column: $table.modifieLe,
    builder: (column) => ColumnFilters(column),
  );

  $$BiensTableFilterComposer get bienId {
    final $$BiensTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bienId,
      referencedTable: $db.biens,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BiensTableFilterComposer(
            $db: $db,
            $table: $db.biens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> locatairesRefs(
    Expression<bool> Function($$LocatairesTableFilterComposer f) f,
  ) {
    final $$LocatairesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.locataires,
      getReferencedColumn: (t) => t.bailId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocatairesTableFilterComposer(
            $db: $db,
            $table: $db.locataires,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> revisionsLoyersRefs(
    Expression<bool> Function($$RevisionsLoyersTableFilterComposer f) f,
  ) {
    final $$RevisionsLoyersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.revisionsLoyers,
      getReferencedColumn: (t) => t.bailId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RevisionsLoyersTableFilterComposer(
            $db: $db,
            $table: $db.revisionsLoyers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BauxTableOrderingComposer extends Composer<_$AppDatabase, $BauxTable> {
  $$BauxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get typeBail => $composableBuilder(
    column: $table.typeBail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateDebut => $composableBuilder(
    column: $table.dateDebut,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dureeMois => $composableBuilder(
    column: $table.dureeMois,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get depotGarantieCentimes => $composableBuilder(
    column: $table.depotGarantieCentimes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateRevision => $composableBuilder(
    column: $table.dateRevision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get irlTrimestre => $composableBuilder(
    column: $table.irlTrimestre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get irlAnnee => $composableBuilder(
    column: $table.irlAnnee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get irlValeur => $composableBuilder(
    column: $table.irlValeur,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get actif => $composableBuilder(
    column: $table.actif,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creeLe => $composableBuilder(
    column: $table.creeLe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modifieLe => $composableBuilder(
    column: $table.modifieLe,
    builder: (column) => ColumnOrderings(column),
  );

  $$BiensTableOrderingComposer get bienId {
    final $$BiensTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bienId,
      referencedTable: $db.biens,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BiensTableOrderingComposer(
            $db: $db,
            $table: $db.biens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BauxTableAnnotationComposer
    extends Composer<_$AppDatabase, $BauxTable> {
  $$BauxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TypeBail, String> get typeBail =>
      $composableBuilder(column: $table.typeBail, builder: (column) => column);

  GeneratedColumn<DateTime> get dateDebut =>
      $composableBuilder(column: $table.dateDebut, builder: (column) => column);

  GeneratedColumn<int> get dureeMois =>
      $composableBuilder(column: $table.dureeMois, builder: (column) => column);

  GeneratedColumn<int> get depotGarantieCentimes => $composableBuilder(
    column: $table.depotGarantieCentimes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dateRevision => $composableBuilder(
    column: $table.dateRevision,
    builder: (column) => column,
  );

  GeneratedColumn<int> get irlTrimestre => $composableBuilder(
    column: $table.irlTrimestre,
    builder: (column) => column,
  );

  GeneratedColumn<int> get irlAnnee =>
      $composableBuilder(column: $table.irlAnnee, builder: (column) => column);

  GeneratedColumn<double> get irlValeur =>
      $composableBuilder(column: $table.irlValeur, builder: (column) => column);

  GeneratedColumn<bool> get actif =>
      $composableBuilder(column: $table.actif, builder: (column) => column);

  GeneratedColumn<DateTime> get creeLe =>
      $composableBuilder(column: $table.creeLe, builder: (column) => column);

  GeneratedColumn<DateTime> get modifieLe =>
      $composableBuilder(column: $table.modifieLe, builder: (column) => column);

  $$BiensTableAnnotationComposer get bienId {
    final $$BiensTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bienId,
      referencedTable: $db.biens,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BiensTableAnnotationComposer(
            $db: $db,
            $table: $db.biens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> locatairesRefs<T extends Object>(
    Expression<T> Function($$LocatairesTableAnnotationComposer a) f,
  ) {
    final $$LocatairesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.locataires,
      getReferencedColumn: (t) => t.bailId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocatairesTableAnnotationComposer(
            $db: $db,
            $table: $db.locataires,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> revisionsLoyersRefs<T extends Object>(
    Expression<T> Function($$RevisionsLoyersTableAnnotationComposer a) f,
  ) {
    final $$RevisionsLoyersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.revisionsLoyers,
      getReferencedColumn: (t) => t.bailId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RevisionsLoyersTableAnnotationComposer(
            $db: $db,
            $table: $db.revisionsLoyers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BauxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BauxTable,
          Bail,
          $$BauxTableFilterComposer,
          $$BauxTableOrderingComposer,
          $$BauxTableAnnotationComposer,
          $$BauxTableCreateCompanionBuilder,
          $$BauxTableUpdateCompanionBuilder,
          (Bail, $$BauxTableReferences),
          Bail,
          PrefetchHooks Function({
            bool bienId,
            bool locatairesRefs,
            bool revisionsLoyersRefs,
          })
        > {
  $$BauxTableTableManager(_$AppDatabase db, $BauxTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BauxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BauxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BauxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> bienId = const Value.absent(),
                Value<TypeBail> typeBail = const Value.absent(),
                Value<DateTime> dateDebut = const Value.absent(),
                Value<int?> dureeMois = const Value.absent(),
                Value<int?> depotGarantieCentimes = const Value.absent(),
                Value<DateTime?> dateRevision = const Value.absent(),
                Value<int?> irlTrimestre = const Value.absent(),
                Value<int?> irlAnnee = const Value.absent(),
                Value<double?> irlValeur = const Value.absent(),
                Value<bool> actif = const Value.absent(),
                Value<DateTime> creeLe = const Value.absent(),
                Value<DateTime> modifieLe = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BauxCompanion(
                id: id,
                bienId: bienId,
                typeBail: typeBail,
                dateDebut: dateDebut,
                dureeMois: dureeMois,
                depotGarantieCentimes: depotGarantieCentimes,
                dateRevision: dateRevision,
                irlTrimestre: irlTrimestre,
                irlAnnee: irlAnnee,
                irlValeur: irlValeur,
                actif: actif,
                creeLe: creeLe,
                modifieLe: modifieLe,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String bienId,
                required TypeBail typeBail,
                required DateTime dateDebut,
                Value<int?> dureeMois = const Value.absent(),
                Value<int?> depotGarantieCentimes = const Value.absent(),
                Value<DateTime?> dateRevision = const Value.absent(),
                Value<int?> irlTrimestre = const Value.absent(),
                Value<int?> irlAnnee = const Value.absent(),
                Value<double?> irlValeur = const Value.absent(),
                required bool actif,
                required DateTime creeLe,
                required DateTime modifieLe,
                Value<int> rowid = const Value.absent(),
              }) => BauxCompanion.insert(
                id: id,
                bienId: bienId,
                typeBail: typeBail,
                dateDebut: dateDebut,
                dureeMois: dureeMois,
                depotGarantieCentimes: depotGarantieCentimes,
                dateRevision: dateRevision,
                irlTrimestre: irlTrimestre,
                irlAnnee: irlAnnee,
                irlValeur: irlValeur,
                actif: actif,
                creeLe: creeLe,
                modifieLe: modifieLe,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BauxTable, Bail>(table),
                  $$BauxTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                bienId = false,
                locatairesRefs = false,
                revisionsLoyersRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (locatairesRefs) db.locataires,
                    if (revisionsLoyersRefs) db.revisionsLoyers,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (bienId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.bienId,
                                    referencedTable: $$BauxTableReferences
                                        ._bienIdTable(db),
                                    referencedColumn: $$BauxTableReferences
                                        ._bienIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (locatairesRefs)
                        await $_getPrefetchedData<Bail, $BauxTable, Locataire>(
                          currentTable: table,
                          referencedTable: $$BauxTableReferences
                              ._locatairesRefsTable(db),
                          managerFromTypedResult: (p0) => $$BauxTableReferences(
                            db,
                            table,
                            p0,
                          ).locatairesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bailId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (revisionsLoyersRefs)
                        await $_getPrefetchedData<
                          Bail,
                          $BauxTable,
                          RevisionLoyer
                        >(
                          currentTable: table,
                          referencedTable: $$BauxTableReferences
                              ._revisionsLoyersRefsTable(db),
                          managerFromTypedResult: (p0) => $$BauxTableReferences(
                            db,
                            table,
                            p0,
                          ).revisionsLoyersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bailId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BauxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BauxTable,
      Bail,
      $$BauxTableFilterComposer,
      $$BauxTableOrderingComposer,
      $$BauxTableAnnotationComposer,
      $$BauxTableCreateCompanionBuilder,
      $$BauxTableUpdateCompanionBuilder,
      (Bail, $$BauxTableReferences),
      Bail,
      PrefetchHooks Function({
        bool bienId,
        bool locatairesRefs,
        bool revisionsLoyersRefs,
      })
    >;
typedef $$LocatairesTableCreateCompanionBuilder =
    LocatairesCompanion Function({
      required String id,
      required String bailId,
      required String prenom,
      required String nom,
      Value<String?> telephone,
      Value<String?> email,
      required DateTime creeLe,
      required DateTime modifieLe,
      Value<int> rowid,
    });
typedef $$LocatairesTableUpdateCompanionBuilder =
    LocatairesCompanion Function({
      Value<String> id,
      Value<String> bailId,
      Value<String> prenom,
      Value<String> nom,
      Value<String?> telephone,
      Value<String?> email,
      Value<DateTime> creeLe,
      Value<DateTime> modifieLe,
      Value<int> rowid,
    });

final class $$LocatairesTableReferences
    extends BaseReferences<_$AppDatabase, $LocatairesTable, Locataire> {
  $$LocatairesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BauxTable _bailIdTable(_$AppDatabase db) =>
      db.baux.createAlias('locataires__bail_id__baux__id');

  $$BauxTableProcessedTableManager get bailId {
    final $_column = $_itemColumn<String>('bail_id')!;

    final manager = $$BauxTableTableManager(
      $_db,
      $_db.baux,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bailIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LocatairesTableFilterComposer
    extends Composer<_$AppDatabase, $LocatairesTable> {
  $$LocatairesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prenom => $composableBuilder(
    column: $table.prenom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nom => $composableBuilder(
    column: $table.nom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telephone => $composableBuilder(
    column: $table.telephone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creeLe => $composableBuilder(
    column: $table.creeLe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modifieLe => $composableBuilder(
    column: $table.modifieLe,
    builder: (column) => ColumnFilters(column),
  );

  $$BauxTableFilterComposer get bailId {
    final $$BauxTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bailId,
      referencedTable: $db.baux,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BauxTableFilterComposer(
            $db: $db,
            $table: $db.baux,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LocatairesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocatairesTable> {
  $$LocatairesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prenom => $composableBuilder(
    column: $table.prenom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nom => $composableBuilder(
    column: $table.nom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telephone => $composableBuilder(
    column: $table.telephone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creeLe => $composableBuilder(
    column: $table.creeLe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modifieLe => $composableBuilder(
    column: $table.modifieLe,
    builder: (column) => ColumnOrderings(column),
  );

  $$BauxTableOrderingComposer get bailId {
    final $$BauxTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bailId,
      referencedTable: $db.baux,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BauxTableOrderingComposer(
            $db: $db,
            $table: $db.baux,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LocatairesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocatairesTable> {
  $$LocatairesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get prenom =>
      $composableBuilder(column: $table.prenom, builder: (column) => column);

  GeneratedColumn<String> get nom =>
      $composableBuilder(column: $table.nom, builder: (column) => column);

  GeneratedColumn<String> get telephone =>
      $composableBuilder(column: $table.telephone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<DateTime> get creeLe =>
      $composableBuilder(column: $table.creeLe, builder: (column) => column);

  GeneratedColumn<DateTime> get modifieLe =>
      $composableBuilder(column: $table.modifieLe, builder: (column) => column);

  $$BauxTableAnnotationComposer get bailId {
    final $$BauxTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bailId,
      referencedTable: $db.baux,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BauxTableAnnotationComposer(
            $db: $db,
            $table: $db.baux,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LocatairesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocatairesTable,
          Locataire,
          $$LocatairesTableFilterComposer,
          $$LocatairesTableOrderingComposer,
          $$LocatairesTableAnnotationComposer,
          $$LocatairesTableCreateCompanionBuilder,
          $$LocatairesTableUpdateCompanionBuilder,
          (Locataire, $$LocatairesTableReferences),
          Locataire,
          PrefetchHooks Function({bool bailId})
        > {
  $$LocatairesTableTableManager(_$AppDatabase db, $LocatairesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocatairesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocatairesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocatairesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> bailId = const Value.absent(),
                Value<String> prenom = const Value.absent(),
                Value<String> nom = const Value.absent(),
                Value<String?> telephone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<DateTime> creeLe = const Value.absent(),
                Value<DateTime> modifieLe = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocatairesCompanion(
                id: id,
                bailId: bailId,
                prenom: prenom,
                nom: nom,
                telephone: telephone,
                email: email,
                creeLe: creeLe,
                modifieLe: modifieLe,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String bailId,
                required String prenom,
                required String nom,
                Value<String?> telephone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                required DateTime creeLe,
                required DateTime modifieLe,
                Value<int> rowid = const Value.absent(),
              }) => LocatairesCompanion.insert(
                id: id,
                bailId: bailId,
                prenom: prenom,
                nom: nom,
                telephone: telephone,
                email: email,
                creeLe: creeLe,
                modifieLe: modifieLe,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocatairesTable, Locataire>(table),
                  $$LocatairesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bailId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (bailId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bailId,
                                referencedTable: $$LocatairesTableReferences
                                    ._bailIdTable(db),
                                referencedColumn: $$LocatairesTableReferences
                                    ._bailIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LocatairesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocatairesTable,
      Locataire,
      $$LocatairesTableFilterComposer,
      $$LocatairesTableOrderingComposer,
      $$LocatairesTableAnnotationComposer,
      $$LocatairesTableCreateCompanionBuilder,
      $$LocatairesTableUpdateCompanionBuilder,
      (Locataire, $$LocatairesTableReferences),
      Locataire,
      PrefetchHooks Function({bool bailId})
    >;
typedef $$EcheancesTableCreateCompanionBuilder =
    EcheancesCompanion Function({
      required String id,
      Value<String?> bienId,
      required TypeEcheance type,
      required String titre,
      required DateTime date,
      Value<DateTime?> dateInitiale,
      required StatutEcheance statut,
      Value<DateTime?> faiteLe,
      Value<String?> notes,
      Value<int?> intervalleMois,
      Value<TypeDiagnostic?> typeDiagnostic,
      required bool automatique,
      required DateTime creeLe,
      required DateTime modifieLe,
      Value<int> rowid,
    });
typedef $$EcheancesTableUpdateCompanionBuilder =
    EcheancesCompanion Function({
      Value<String> id,
      Value<String?> bienId,
      Value<TypeEcheance> type,
      Value<String> titre,
      Value<DateTime> date,
      Value<DateTime?> dateInitiale,
      Value<StatutEcheance> statut,
      Value<DateTime?> faiteLe,
      Value<String?> notes,
      Value<int?> intervalleMois,
      Value<TypeDiagnostic?> typeDiagnostic,
      Value<bool> automatique,
      Value<DateTime> creeLe,
      Value<DateTime> modifieLe,
      Value<int> rowid,
    });

final class $$EcheancesTableReferences
    extends BaseReferences<_$AppDatabase, $EcheancesTable, Echeance> {
  $$EcheancesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BiensTable _bienIdTable(_$AppDatabase db) =>
      db.biens.createAlias('echeances__bien_id__biens__id');

  $$BiensTableProcessedTableManager? get bienId {
    final $_column = $_itemColumn<String>('bien_id');
    if ($_column == null) return null;
    final manager = $$BiensTableTableManager(
      $_db,
      $_db.biens,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bienIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$RappelsTable, List<Rappel>> _rappelsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.rappels,
    aliasName: 'echeances__id__rappels__echeance_id',
  );

  $$RappelsTableProcessedTableManager get rappelsRefs {
    final manager = $$RappelsTableTableManager(
      $_db,
      $_db.rappels,
    ).filter((f) => f.echeanceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_rappelsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EcheancesTableFilterComposer
    extends Composer<_$AppDatabase, $EcheancesTable> {
  $$EcheancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TypeEcheance, TypeEcheance, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get titre => $composableBuilder(
    column: $table.titre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateInitiale => $composableBuilder(
    column: $table.dateInitiale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<StatutEcheance, StatutEcheance, String>
  get statut => $composableBuilder(
    column: $table.statut,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get faiteLe => $composableBuilder(
    column: $table.faiteLe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalleMois => $composableBuilder(
    column: $table.intervalleMois,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TypeDiagnostic?, TypeDiagnostic, String>
  get typeDiagnostic => $composableBuilder(
    column: $table.typeDiagnostic,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get automatique => $composableBuilder(
    column: $table.automatique,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creeLe => $composableBuilder(
    column: $table.creeLe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modifieLe => $composableBuilder(
    column: $table.modifieLe,
    builder: (column) => ColumnFilters(column),
  );

  $$BiensTableFilterComposer get bienId {
    final $$BiensTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bienId,
      referencedTable: $db.biens,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BiensTableFilterComposer(
            $db: $db,
            $table: $db.biens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> rappelsRefs(
    Expression<bool> Function($$RappelsTableFilterComposer f) f,
  ) {
    final $$RappelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rappels,
      getReferencedColumn: (t) => t.echeanceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RappelsTableFilterComposer(
            $db: $db,
            $table: $db.rappels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EcheancesTableOrderingComposer
    extends Composer<_$AppDatabase, $EcheancesTable> {
  $$EcheancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titre => $composableBuilder(
    column: $table.titre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateInitiale => $composableBuilder(
    column: $table.dateInitiale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get statut => $composableBuilder(
    column: $table.statut,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get faiteLe => $composableBuilder(
    column: $table.faiteLe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalleMois => $composableBuilder(
    column: $table.intervalleMois,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get typeDiagnostic => $composableBuilder(
    column: $table.typeDiagnostic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get automatique => $composableBuilder(
    column: $table.automatique,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creeLe => $composableBuilder(
    column: $table.creeLe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modifieLe => $composableBuilder(
    column: $table.modifieLe,
    builder: (column) => ColumnOrderings(column),
  );

  $$BiensTableOrderingComposer get bienId {
    final $$BiensTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bienId,
      referencedTable: $db.biens,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BiensTableOrderingComposer(
            $db: $db,
            $table: $db.biens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EcheancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EcheancesTable> {
  $$EcheancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TypeEcheance, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get titre =>
      $composableBuilder(column: $table.titre, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get dateInitiale => $composableBuilder(
    column: $table.dateInitiale,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<StatutEcheance, String> get statut =>
      $composableBuilder(column: $table.statut, builder: (column) => column);

  GeneratedColumn<DateTime> get faiteLe =>
      $composableBuilder(column: $table.faiteLe, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get intervalleMois => $composableBuilder(
    column: $table.intervalleMois,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TypeDiagnostic?, String>
  get typeDiagnostic => $composableBuilder(
    column: $table.typeDiagnostic,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get automatique => $composableBuilder(
    column: $table.automatique,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get creeLe =>
      $composableBuilder(column: $table.creeLe, builder: (column) => column);

  GeneratedColumn<DateTime> get modifieLe =>
      $composableBuilder(column: $table.modifieLe, builder: (column) => column);

  $$BiensTableAnnotationComposer get bienId {
    final $$BiensTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bienId,
      referencedTable: $db.biens,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BiensTableAnnotationComposer(
            $db: $db,
            $table: $db.biens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> rappelsRefs<T extends Object>(
    Expression<T> Function($$RappelsTableAnnotationComposer a) f,
  ) {
    final $$RappelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rappels,
      getReferencedColumn: (t) => t.echeanceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RappelsTableAnnotationComposer(
            $db: $db,
            $table: $db.rappels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EcheancesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EcheancesTable,
          Echeance,
          $$EcheancesTableFilterComposer,
          $$EcheancesTableOrderingComposer,
          $$EcheancesTableAnnotationComposer,
          $$EcheancesTableCreateCompanionBuilder,
          $$EcheancesTableUpdateCompanionBuilder,
          (Echeance, $$EcheancesTableReferences),
          Echeance,
          PrefetchHooks Function({bool bienId, bool rappelsRefs})
        > {
  $$EcheancesTableTableManager(_$AppDatabase db, $EcheancesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EcheancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EcheancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EcheancesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> bienId = const Value.absent(),
                Value<TypeEcheance> type = const Value.absent(),
                Value<String> titre = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<DateTime?> dateInitiale = const Value.absent(),
                Value<StatutEcheance> statut = const Value.absent(),
                Value<DateTime?> faiteLe = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> intervalleMois = const Value.absent(),
                Value<TypeDiagnostic?> typeDiagnostic = const Value.absent(),
                Value<bool> automatique = const Value.absent(),
                Value<DateTime> creeLe = const Value.absent(),
                Value<DateTime> modifieLe = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EcheancesCompanion(
                id: id,
                bienId: bienId,
                type: type,
                titre: titre,
                date: date,
                dateInitiale: dateInitiale,
                statut: statut,
                faiteLe: faiteLe,
                notes: notes,
                intervalleMois: intervalleMois,
                typeDiagnostic: typeDiagnostic,
                automatique: automatique,
                creeLe: creeLe,
                modifieLe: modifieLe,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> bienId = const Value.absent(),
                required TypeEcheance type,
                required String titre,
                required DateTime date,
                Value<DateTime?> dateInitiale = const Value.absent(),
                required StatutEcheance statut,
                Value<DateTime?> faiteLe = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> intervalleMois = const Value.absent(),
                Value<TypeDiagnostic?> typeDiagnostic = const Value.absent(),
                required bool automatique,
                required DateTime creeLe,
                required DateTime modifieLe,
                Value<int> rowid = const Value.absent(),
              }) => EcheancesCompanion.insert(
                id: id,
                bienId: bienId,
                type: type,
                titre: titre,
                date: date,
                dateInitiale: dateInitiale,
                statut: statut,
                faiteLe: faiteLe,
                notes: notes,
                intervalleMois: intervalleMois,
                typeDiagnostic: typeDiagnostic,
                automatique: automatique,
                creeLe: creeLe,
                modifieLe: modifieLe,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EcheancesTable, Echeance>(table),
                  $$EcheancesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bienId = false, rappelsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (rappelsRefs) db.rappels],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (bienId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bienId,
                                referencedTable: $$EcheancesTableReferences
                                    ._bienIdTable(db),
                                referencedColumn: $$EcheancesTableReferences
                                    ._bienIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (rappelsRefs)
                    await $_getPrefetchedData<
                      Echeance,
                      $EcheancesTable,
                      Rappel
                    >(
                      currentTable: table,
                      referencedTable: $$EcheancesTableReferences
                          ._rappelsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$EcheancesTableReferences(db, table, p0).rappelsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.echeanceId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$EcheancesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EcheancesTable,
      Echeance,
      $$EcheancesTableFilterComposer,
      $$EcheancesTableOrderingComposer,
      $$EcheancesTableAnnotationComposer,
      $$EcheancesTableCreateCompanionBuilder,
      $$EcheancesTableUpdateCompanionBuilder,
      (Echeance, $$EcheancesTableReferences),
      Echeance,
      PrefetchHooks Function({bool bienId, bool rappelsRefs})
    >;
typedef $$RappelsTableCreateCompanionBuilder =
    RappelsCompanion Function({
      Value<int> id,
      required String echeanceId,
      required int joursAvant,
    });
typedef $$RappelsTableUpdateCompanionBuilder =
    RappelsCompanion Function({
      Value<int> id,
      Value<String> echeanceId,
      Value<int> joursAvant,
    });

final class $$RappelsTableReferences
    extends BaseReferences<_$AppDatabase, $RappelsTable, Rappel> {
  $$RappelsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EcheancesTable _echeanceIdTable(_$AppDatabase db) =>
      db.echeances.createAlias('rappels__echeance_id__echeances__id');

  $$EcheancesTableProcessedTableManager get echeanceId {
    final $_column = $_itemColumn<String>('echeance_id')!;

    final manager = $$EcheancesTableTableManager(
      $_db,
      $_db.echeances,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_echeanceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RappelsTableFilterComposer
    extends Composer<_$AppDatabase, $RappelsTable> {
  $$RappelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get joursAvant => $composableBuilder(
    column: $table.joursAvant,
    builder: (column) => ColumnFilters(column),
  );

  $$EcheancesTableFilterComposer get echeanceId {
    final $$EcheancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.echeanceId,
      referencedTable: $db.echeances,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EcheancesTableFilterComposer(
            $db: $db,
            $table: $db.echeances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RappelsTableOrderingComposer
    extends Composer<_$AppDatabase, $RappelsTable> {
  $$RappelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get joursAvant => $composableBuilder(
    column: $table.joursAvant,
    builder: (column) => ColumnOrderings(column),
  );

  $$EcheancesTableOrderingComposer get echeanceId {
    final $$EcheancesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.echeanceId,
      referencedTable: $db.echeances,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EcheancesTableOrderingComposer(
            $db: $db,
            $table: $db.echeances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RappelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RappelsTable> {
  $$RappelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get joursAvant => $composableBuilder(
    column: $table.joursAvant,
    builder: (column) => column,
  );

  $$EcheancesTableAnnotationComposer get echeanceId {
    final $$EcheancesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.echeanceId,
      referencedTable: $db.echeances,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EcheancesTableAnnotationComposer(
            $db: $db,
            $table: $db.echeances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RappelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RappelsTable,
          Rappel,
          $$RappelsTableFilterComposer,
          $$RappelsTableOrderingComposer,
          $$RappelsTableAnnotationComposer,
          $$RappelsTableCreateCompanionBuilder,
          $$RappelsTableUpdateCompanionBuilder,
          (Rappel, $$RappelsTableReferences),
          Rappel,
          PrefetchHooks Function({bool echeanceId})
        > {
  $$RappelsTableTableManager(_$AppDatabase db, $RappelsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RappelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RappelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RappelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> echeanceId = const Value.absent(),
                Value<int> joursAvant = const Value.absent(),
              }) => RappelsCompanion(
                id: id,
                echeanceId: echeanceId,
                joursAvant: joursAvant,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String echeanceId,
                required int joursAvant,
              }) => RappelsCompanion.insert(
                id: id,
                echeanceId: echeanceId,
                joursAvant: joursAvant,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RappelsTable, Rappel>(table),
                  $$RappelsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({echeanceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (echeanceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.echeanceId,
                                referencedTable: $$RappelsTableReferences
                                    ._echeanceIdTable(db),
                                referencedColumn: $$RappelsTableReferences
                                    ._echeanceIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RappelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RappelsTable,
      Rappel,
      $$RappelsTableFilterComposer,
      $$RappelsTableOrderingComposer,
      $$RappelsTableAnnotationComposer,
      $$RappelsTableCreateCompanionBuilder,
      $$RappelsTableUpdateCompanionBuilder,
      (Rappel, $$RappelsTableReferences),
      Rappel,
      PrefetchHooks Function({bool echeanceId})
    >;
typedef $$ArtisansTableCreateCompanionBuilder =
    ArtisansCompanion Function({
      required String id,
      required String nom,
      Value<String?> entreprise,
      required MetierArtisan metier,
      Value<String?> telephone,
      Value<String?> email,
      Value<String?> notes,
      required DateTime creeLe,
      required DateTime modifieLe,
      Value<int> rowid,
    });
typedef $$ArtisansTableUpdateCompanionBuilder =
    ArtisansCompanion Function({
      Value<String> id,
      Value<String> nom,
      Value<String?> entreprise,
      Value<MetierArtisan> metier,
      Value<String?> telephone,
      Value<String?> email,
      Value<String?> notes,
      Value<DateTime> creeLe,
      Value<DateTime> modifieLe,
      Value<int> rowid,
    });

final class $$ArtisansTableReferences
    extends BaseReferences<_$AppDatabase, $ArtisansTable, Artisan> {
  $$ArtisansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$InterventionsTable, List<Intervention>>
  _interventionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.interventions,
    aliasName: 'artisans__id__interventions__artisan_id',
  );

  $$InterventionsTableProcessedTableManager get interventionsRefs {
    final manager = $$InterventionsTableTableManager(
      $_db,
      $_db.interventions,
    ).filter((f) => f.artisanId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_interventionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ArtisansTableFilterComposer
    extends Composer<_$AppDatabase, $ArtisansTable> {
  $$ArtisansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nom => $composableBuilder(
    column: $table.nom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entreprise => $composableBuilder(
    column: $table.entreprise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MetierArtisan, MetierArtisan, String>
  get metier => $composableBuilder(
    column: $table.metier,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get telephone => $composableBuilder(
    column: $table.telephone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creeLe => $composableBuilder(
    column: $table.creeLe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modifieLe => $composableBuilder(
    column: $table.modifieLe,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> interventionsRefs(
    Expression<bool> Function($$InterventionsTableFilterComposer f) f,
  ) {
    final $$InterventionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.interventions,
      getReferencedColumn: (t) => t.artisanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InterventionsTableFilterComposer(
            $db: $db,
            $table: $db.interventions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ArtisansTableOrderingComposer
    extends Composer<_$AppDatabase, $ArtisansTable> {
  $$ArtisansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nom => $composableBuilder(
    column: $table.nom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entreprise => $composableBuilder(
    column: $table.entreprise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metier => $composableBuilder(
    column: $table.metier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telephone => $composableBuilder(
    column: $table.telephone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creeLe => $composableBuilder(
    column: $table.creeLe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modifieLe => $composableBuilder(
    column: $table.modifieLe,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ArtisansTableAnnotationComposer
    extends Composer<_$AppDatabase, $ArtisansTable> {
  $$ArtisansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nom =>
      $composableBuilder(column: $table.nom, builder: (column) => column);

  GeneratedColumn<String> get entreprise => $composableBuilder(
    column: $table.entreprise,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<MetierArtisan, String> get metier =>
      $composableBuilder(column: $table.metier, builder: (column) => column);

  GeneratedColumn<String> get telephone =>
      $composableBuilder(column: $table.telephone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get creeLe =>
      $composableBuilder(column: $table.creeLe, builder: (column) => column);

  GeneratedColumn<DateTime> get modifieLe =>
      $composableBuilder(column: $table.modifieLe, builder: (column) => column);

  Expression<T> interventionsRefs<T extends Object>(
    Expression<T> Function($$InterventionsTableAnnotationComposer a) f,
  ) {
    final $$InterventionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.interventions,
      getReferencedColumn: (t) => t.artisanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InterventionsTableAnnotationComposer(
            $db: $db,
            $table: $db.interventions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ArtisansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ArtisansTable,
          Artisan,
          $$ArtisansTableFilterComposer,
          $$ArtisansTableOrderingComposer,
          $$ArtisansTableAnnotationComposer,
          $$ArtisansTableCreateCompanionBuilder,
          $$ArtisansTableUpdateCompanionBuilder,
          (Artisan, $$ArtisansTableReferences),
          Artisan,
          PrefetchHooks Function({bool interventionsRefs})
        > {
  $$ArtisansTableTableManager(_$AppDatabase db, $ArtisansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ArtisansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ArtisansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ArtisansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nom = const Value.absent(),
                Value<String?> entreprise = const Value.absent(),
                Value<MetierArtisan> metier = const Value.absent(),
                Value<String?> telephone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> creeLe = const Value.absent(),
                Value<DateTime> modifieLe = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ArtisansCompanion(
                id: id,
                nom: nom,
                entreprise: entreprise,
                metier: metier,
                telephone: telephone,
                email: email,
                notes: notes,
                creeLe: creeLe,
                modifieLe: modifieLe,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nom,
                Value<String?> entreprise = const Value.absent(),
                required MetierArtisan metier,
                Value<String?> telephone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime creeLe,
                required DateTime modifieLe,
                Value<int> rowid = const Value.absent(),
              }) => ArtisansCompanion.insert(
                id: id,
                nom: nom,
                entreprise: entreprise,
                metier: metier,
                telephone: telephone,
                email: email,
                notes: notes,
                creeLe: creeLe,
                modifieLe: modifieLe,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ArtisansTable, Artisan>(table),
                  $$ArtisansTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({interventionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (interventionsRefs) db.interventions,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (interventionsRefs)
                    await $_getPrefetchedData<
                      Artisan,
                      $ArtisansTable,
                      Intervention
                    >(
                      currentTable: table,
                      referencedTable: $$ArtisansTableReferences
                          ._interventionsRefsTable(db),
                      managerFromTypedResult: (p0) => $$ArtisansTableReferences(
                        db,
                        table,
                        p0,
                      ).interventionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.artisanId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ArtisansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ArtisansTable,
      Artisan,
      $$ArtisansTableFilterComposer,
      $$ArtisansTableOrderingComposer,
      $$ArtisansTableAnnotationComposer,
      $$ArtisansTableCreateCompanionBuilder,
      $$ArtisansTableUpdateCompanionBuilder,
      (Artisan, $$ArtisansTableReferences),
      Artisan,
      PrefetchHooks Function({bool interventionsRefs})
    >;
typedef $$InterventionsTableCreateCompanionBuilder =
    InterventionsCompanion Function({
      required String id,
      required String bienId,
      Value<String?> artisanId,
      required DateTime date,
      required String description,
      Value<int?> coutCentimes,
      required DateTime creeLe,
      required DateTime modifieLe,
      Value<int> rowid,
    });
typedef $$InterventionsTableUpdateCompanionBuilder =
    InterventionsCompanion Function({
      Value<String> id,
      Value<String> bienId,
      Value<String?> artisanId,
      Value<DateTime> date,
      Value<String> description,
      Value<int?> coutCentimes,
      Value<DateTime> creeLe,
      Value<DateTime> modifieLe,
      Value<int> rowid,
    });

final class $$InterventionsTableReferences
    extends BaseReferences<_$AppDatabase, $InterventionsTable, Intervention> {
  $$InterventionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BiensTable _bienIdTable(_$AppDatabase db) =>
      db.biens.createAlias('interventions__bien_id__biens__id');

  $$BiensTableProcessedTableManager get bienId {
    final $_column = $_itemColumn<String>('bien_id')!;

    final manager = $$BiensTableTableManager(
      $_db,
      $_db.biens,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bienIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ArtisansTable _artisanIdTable(_$AppDatabase db) =>
      db.artisans.createAlias('interventions__artisan_id__artisans__id');

  $$ArtisansTableProcessedTableManager? get artisanId {
    final $_column = $_itemColumn<String>('artisan_id');
    if ($_column == null) return null;
    final manager = $$ArtisansTableTableManager(
      $_db,
      $_db.artisans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_artisanIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $MouvementsFinanciersTable,
    List<MouvementFinancier>
  >
  _mouvementsFinanciersRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.mouvementsFinanciers,
        aliasName: 'interventions__id__mouvements_financiers__intervention_id',
      );

  $$MouvementsFinanciersTableProcessedTableManager
  get mouvementsFinanciersRefs {
    final manager = $$MouvementsFinanciersTableTableManager(
      $_db,
      $_db.mouvementsFinanciers,
    ).filter((f) => f.interventionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _mouvementsFinanciersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$InterventionsTableFilterComposer
    extends Composer<_$AppDatabase, $InterventionsTable> {
  $$InterventionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get coutCentimes => $composableBuilder(
    column: $table.coutCentimes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creeLe => $composableBuilder(
    column: $table.creeLe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modifieLe => $composableBuilder(
    column: $table.modifieLe,
    builder: (column) => ColumnFilters(column),
  );

  $$BiensTableFilterComposer get bienId {
    final $$BiensTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bienId,
      referencedTable: $db.biens,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BiensTableFilterComposer(
            $db: $db,
            $table: $db.biens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ArtisansTableFilterComposer get artisanId {
    final $$ArtisansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.artisanId,
      referencedTable: $db.artisans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArtisansTableFilterComposer(
            $db: $db,
            $table: $db.artisans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> mouvementsFinanciersRefs(
    Expression<bool> Function($$MouvementsFinanciersTableFilterComposer f) f,
  ) {
    final $$MouvementsFinanciersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mouvementsFinanciers,
      getReferencedColumn: (t) => t.interventionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MouvementsFinanciersTableFilterComposer(
            $db: $db,
            $table: $db.mouvementsFinanciers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InterventionsTableOrderingComposer
    extends Composer<_$AppDatabase, $InterventionsTable> {
  $$InterventionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get coutCentimes => $composableBuilder(
    column: $table.coutCentimes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creeLe => $composableBuilder(
    column: $table.creeLe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modifieLe => $composableBuilder(
    column: $table.modifieLe,
    builder: (column) => ColumnOrderings(column),
  );

  $$BiensTableOrderingComposer get bienId {
    final $$BiensTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bienId,
      referencedTable: $db.biens,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BiensTableOrderingComposer(
            $db: $db,
            $table: $db.biens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ArtisansTableOrderingComposer get artisanId {
    final $$ArtisansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.artisanId,
      referencedTable: $db.artisans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArtisansTableOrderingComposer(
            $db: $db,
            $table: $db.artisans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InterventionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InterventionsTable> {
  $$InterventionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get coutCentimes => $composableBuilder(
    column: $table.coutCentimes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get creeLe =>
      $composableBuilder(column: $table.creeLe, builder: (column) => column);

  GeneratedColumn<DateTime> get modifieLe =>
      $composableBuilder(column: $table.modifieLe, builder: (column) => column);

  $$BiensTableAnnotationComposer get bienId {
    final $$BiensTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bienId,
      referencedTable: $db.biens,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BiensTableAnnotationComposer(
            $db: $db,
            $table: $db.biens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ArtisansTableAnnotationComposer get artisanId {
    final $$ArtisansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.artisanId,
      referencedTable: $db.artisans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ArtisansTableAnnotationComposer(
            $db: $db,
            $table: $db.artisans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> mouvementsFinanciersRefs<T extends Object>(
    Expression<T> Function($$MouvementsFinanciersTableAnnotationComposer a) f,
  ) {
    final $$MouvementsFinanciersTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.mouvementsFinanciers,
          getReferencedColumn: (t) => t.interventionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MouvementsFinanciersTableAnnotationComposer(
                $db: $db,
                $table: $db.mouvementsFinanciers,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$InterventionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InterventionsTable,
          Intervention,
          $$InterventionsTableFilterComposer,
          $$InterventionsTableOrderingComposer,
          $$InterventionsTableAnnotationComposer,
          $$InterventionsTableCreateCompanionBuilder,
          $$InterventionsTableUpdateCompanionBuilder,
          (Intervention, $$InterventionsTableReferences),
          Intervention,
          PrefetchHooks Function({
            bool bienId,
            bool artisanId,
            bool mouvementsFinanciersRefs,
          })
        > {
  $$InterventionsTableTableManager(_$AppDatabase db, $InterventionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InterventionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InterventionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InterventionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> bienId = const Value.absent(),
                Value<String?> artisanId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int?> coutCentimes = const Value.absent(),
                Value<DateTime> creeLe = const Value.absent(),
                Value<DateTime> modifieLe = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InterventionsCompanion(
                id: id,
                bienId: bienId,
                artisanId: artisanId,
                date: date,
                description: description,
                coutCentimes: coutCentimes,
                creeLe: creeLe,
                modifieLe: modifieLe,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String bienId,
                Value<String?> artisanId = const Value.absent(),
                required DateTime date,
                required String description,
                Value<int?> coutCentimes = const Value.absent(),
                required DateTime creeLe,
                required DateTime modifieLe,
                Value<int> rowid = const Value.absent(),
              }) => InterventionsCompanion.insert(
                id: id,
                bienId: bienId,
                artisanId: artisanId,
                date: date,
                description: description,
                coutCentimes: coutCentimes,
                creeLe: creeLe,
                modifieLe: modifieLe,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InterventionsTable, Intervention>(table),
                  $$InterventionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                bienId = false,
                artisanId = false,
                mouvementsFinanciersRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (mouvementsFinanciersRefs) db.mouvementsFinanciers,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (bienId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.bienId,
                                    referencedTable:
                                        $$InterventionsTableReferences
                                            ._bienIdTable(db),
                                    referencedColumn:
                                        $$InterventionsTableReferences
                                            ._bienIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (artisanId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.artisanId,
                                    referencedTable:
                                        $$InterventionsTableReferences
                                            ._artisanIdTable(db),
                                    referencedColumn:
                                        $$InterventionsTableReferences
                                            ._artisanIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (mouvementsFinanciersRefs)
                        await $_getPrefetchedData<
                          Intervention,
                          $InterventionsTable,
                          MouvementFinancier
                        >(
                          currentTable: table,
                          referencedTable: $$InterventionsTableReferences
                              ._mouvementsFinanciersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InterventionsTableReferences(
                                db,
                                table,
                                p0,
                              ).mouvementsFinanciersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.interventionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$InterventionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InterventionsTable,
      Intervention,
      $$InterventionsTableFilterComposer,
      $$InterventionsTableOrderingComposer,
      $$InterventionsTableAnnotationComposer,
      $$InterventionsTableCreateCompanionBuilder,
      $$InterventionsTableUpdateCompanionBuilder,
      (Intervention, $$InterventionsTableReferences),
      Intervention,
      PrefetchHooks Function({
        bool bienId,
        bool artisanId,
        bool mouvementsFinanciersRefs,
      })
    >;
typedef $$MouvementsFinanciersTableCreateCompanionBuilder =
    MouvementsFinanciersCompanion Function({
      required String id,
      required String bienId,
      required DateTime date,
      required int montantCentimes,
      required CategorieMouvement categorie,
      Value<String?> note,
      Value<String?> interventionId,
      required DateTime creeLe,
      required DateTime modifieLe,
      Value<int> rowid,
    });
typedef $$MouvementsFinanciersTableUpdateCompanionBuilder =
    MouvementsFinanciersCompanion Function({
      Value<String> id,
      Value<String> bienId,
      Value<DateTime> date,
      Value<int> montantCentimes,
      Value<CategorieMouvement> categorie,
      Value<String?> note,
      Value<String?> interventionId,
      Value<DateTime> creeLe,
      Value<DateTime> modifieLe,
      Value<int> rowid,
    });

final class $$MouvementsFinanciersTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MouvementsFinanciersTable,
          MouvementFinancier
        > {
  $$MouvementsFinanciersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BiensTable _bienIdTable(_$AppDatabase db) =>
      db.biens.createAlias('mouvements_financiers__bien_id__biens__id');

  $$BiensTableProcessedTableManager get bienId {
    final $_column = $_itemColumn<String>('bien_id')!;

    final manager = $$BiensTableTableManager(
      $_db,
      $_db.biens,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bienIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $InterventionsTable _interventionIdTable(_$AppDatabase db) => db
      .interventions
      .createAlias('mouvements_financiers__intervention_id__interventions__id');

  $$InterventionsTableProcessedTableManager? get interventionId {
    final $_column = $_itemColumn<String>('intervention_id');
    if ($_column == null) return null;
    final manager = $$InterventionsTableTableManager(
      $_db,
      $_db.interventions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_interventionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MouvementsFinanciersTableFilterComposer
    extends Composer<_$AppDatabase, $MouvementsFinanciersTable> {
  $$MouvementsFinanciersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get montantCentimes => $composableBuilder(
    column: $table.montantCentimes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CategorieMouvement, CategorieMouvement, String>
  get categorie => $composableBuilder(
    column: $table.categorie,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creeLe => $composableBuilder(
    column: $table.creeLe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modifieLe => $composableBuilder(
    column: $table.modifieLe,
    builder: (column) => ColumnFilters(column),
  );

  $$BiensTableFilterComposer get bienId {
    final $$BiensTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bienId,
      referencedTable: $db.biens,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BiensTableFilterComposer(
            $db: $db,
            $table: $db.biens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InterventionsTableFilterComposer get interventionId {
    final $$InterventionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.interventionId,
      referencedTable: $db.interventions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InterventionsTableFilterComposer(
            $db: $db,
            $table: $db.interventions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MouvementsFinanciersTableOrderingComposer
    extends Composer<_$AppDatabase, $MouvementsFinanciersTable> {
  $$MouvementsFinanciersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get montantCentimes => $composableBuilder(
    column: $table.montantCentimes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categorie => $composableBuilder(
    column: $table.categorie,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creeLe => $composableBuilder(
    column: $table.creeLe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modifieLe => $composableBuilder(
    column: $table.modifieLe,
    builder: (column) => ColumnOrderings(column),
  );

  $$BiensTableOrderingComposer get bienId {
    final $$BiensTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bienId,
      referencedTable: $db.biens,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BiensTableOrderingComposer(
            $db: $db,
            $table: $db.biens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InterventionsTableOrderingComposer get interventionId {
    final $$InterventionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.interventionId,
      referencedTable: $db.interventions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InterventionsTableOrderingComposer(
            $db: $db,
            $table: $db.interventions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MouvementsFinanciersTableAnnotationComposer
    extends Composer<_$AppDatabase, $MouvementsFinanciersTable> {
  $$MouvementsFinanciersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get montantCentimes => $composableBuilder(
    column: $table.montantCentimes,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<CategorieMouvement, String> get categorie =>
      $composableBuilder(column: $table.categorie, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get creeLe =>
      $composableBuilder(column: $table.creeLe, builder: (column) => column);

  GeneratedColumn<DateTime> get modifieLe =>
      $composableBuilder(column: $table.modifieLe, builder: (column) => column);

  $$BiensTableAnnotationComposer get bienId {
    final $$BiensTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bienId,
      referencedTable: $db.biens,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BiensTableAnnotationComposer(
            $db: $db,
            $table: $db.biens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InterventionsTableAnnotationComposer get interventionId {
    final $$InterventionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.interventionId,
      referencedTable: $db.interventions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InterventionsTableAnnotationComposer(
            $db: $db,
            $table: $db.interventions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MouvementsFinanciersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MouvementsFinanciersTable,
          MouvementFinancier,
          $$MouvementsFinanciersTableFilterComposer,
          $$MouvementsFinanciersTableOrderingComposer,
          $$MouvementsFinanciersTableAnnotationComposer,
          $$MouvementsFinanciersTableCreateCompanionBuilder,
          $$MouvementsFinanciersTableUpdateCompanionBuilder,
          (MouvementFinancier, $$MouvementsFinanciersTableReferences),
          MouvementFinancier,
          PrefetchHooks Function({bool bienId, bool interventionId})
        > {
  $$MouvementsFinanciersTableTableManager(
    _$AppDatabase db,
    $MouvementsFinanciersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MouvementsFinanciersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MouvementsFinanciersTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MouvementsFinanciersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> bienId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> montantCentimes = const Value.absent(),
                Value<CategorieMouvement> categorie = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> interventionId = const Value.absent(),
                Value<DateTime> creeLe = const Value.absent(),
                Value<DateTime> modifieLe = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MouvementsFinanciersCompanion(
                id: id,
                bienId: bienId,
                date: date,
                montantCentimes: montantCentimes,
                categorie: categorie,
                note: note,
                interventionId: interventionId,
                creeLe: creeLe,
                modifieLe: modifieLe,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String bienId,
                required DateTime date,
                required int montantCentimes,
                required CategorieMouvement categorie,
                Value<String?> note = const Value.absent(),
                Value<String?> interventionId = const Value.absent(),
                required DateTime creeLe,
                required DateTime modifieLe,
                Value<int> rowid = const Value.absent(),
              }) => MouvementsFinanciersCompanion.insert(
                id: id,
                bienId: bienId,
                date: date,
                montantCentimes: montantCentimes,
                categorie: categorie,
                note: note,
                interventionId: interventionId,
                creeLe: creeLe,
                modifieLe: modifieLe,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MouvementsFinanciersTable, MouvementFinancier>(
                    table,
                  ),
                  $$MouvementsFinanciersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bienId = false, interventionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (bienId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bienId,
                                referencedTable:
                                    $$MouvementsFinanciersTableReferences
                                        ._bienIdTable(db),
                                referencedColumn:
                                    $$MouvementsFinanciersTableReferences
                                        ._bienIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (interventionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.interventionId,
                                referencedTable:
                                    $$MouvementsFinanciersTableReferences
                                        ._interventionIdTable(db),
                                referencedColumn:
                                    $$MouvementsFinanciersTableReferences
                                        ._interventionIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MouvementsFinanciersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MouvementsFinanciersTable,
      MouvementFinancier,
      $$MouvementsFinanciersTableFilterComposer,
      $$MouvementsFinanciersTableOrderingComposer,
      $$MouvementsFinanciersTableAnnotationComposer,
      $$MouvementsFinanciersTableCreateCompanionBuilder,
      $$MouvementsFinanciersTableUpdateCompanionBuilder,
      (MouvementFinancier, $$MouvementsFinanciersTableReferences),
      MouvementFinancier,
      PrefetchHooks Function({bool bienId, bool interventionId})
    >;
typedef $$EncaissementsLoyersTableCreateCompanionBuilder =
    EncaissementsLoyersCompanion Function({
      required String bienId,
      required int annee,
      required int mois,
      required bool recu,
      Value<DateTime?> recuLe,
      Value<int> rowid,
    });
typedef $$EncaissementsLoyersTableUpdateCompanionBuilder =
    EncaissementsLoyersCompanion Function({
      Value<String> bienId,
      Value<int> annee,
      Value<int> mois,
      Value<bool> recu,
      Value<DateTime?> recuLe,
      Value<int> rowid,
    });

final class $$EncaissementsLoyersTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $EncaissementsLoyersTable,
          EncaissementLoyer
        > {
  $$EncaissementsLoyersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BiensTable _bienIdTable(_$AppDatabase db) =>
      db.biens.createAlias('encaissements_loyers__bien_id__biens__id');

  $$BiensTableProcessedTableManager get bienId {
    final $_column = $_itemColumn<String>('bien_id')!;

    final manager = $$BiensTableTableManager(
      $_db,
      $_db.biens,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bienIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EncaissementsLoyersTableFilterComposer
    extends Composer<_$AppDatabase, $EncaissementsLoyersTable> {
  $$EncaissementsLoyersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get annee => $composableBuilder(
    column: $table.annee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mois => $composableBuilder(
    column: $table.mois,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get recu => $composableBuilder(
    column: $table.recu,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recuLe => $composableBuilder(
    column: $table.recuLe,
    builder: (column) => ColumnFilters(column),
  );

  $$BiensTableFilterComposer get bienId {
    final $$BiensTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bienId,
      referencedTable: $db.biens,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BiensTableFilterComposer(
            $db: $db,
            $table: $db.biens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EncaissementsLoyersTableOrderingComposer
    extends Composer<_$AppDatabase, $EncaissementsLoyersTable> {
  $$EncaissementsLoyersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get annee => $composableBuilder(
    column: $table.annee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mois => $composableBuilder(
    column: $table.mois,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get recu => $composableBuilder(
    column: $table.recu,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recuLe => $composableBuilder(
    column: $table.recuLe,
    builder: (column) => ColumnOrderings(column),
  );

  $$BiensTableOrderingComposer get bienId {
    final $$BiensTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bienId,
      referencedTable: $db.biens,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BiensTableOrderingComposer(
            $db: $db,
            $table: $db.biens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EncaissementsLoyersTableAnnotationComposer
    extends Composer<_$AppDatabase, $EncaissementsLoyersTable> {
  $$EncaissementsLoyersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get annee =>
      $composableBuilder(column: $table.annee, builder: (column) => column);

  GeneratedColumn<int> get mois =>
      $composableBuilder(column: $table.mois, builder: (column) => column);

  GeneratedColumn<bool> get recu =>
      $composableBuilder(column: $table.recu, builder: (column) => column);

  GeneratedColumn<DateTime> get recuLe =>
      $composableBuilder(column: $table.recuLe, builder: (column) => column);

  $$BiensTableAnnotationComposer get bienId {
    final $$BiensTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bienId,
      referencedTable: $db.biens,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BiensTableAnnotationComposer(
            $db: $db,
            $table: $db.biens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EncaissementsLoyersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EncaissementsLoyersTable,
          EncaissementLoyer,
          $$EncaissementsLoyersTableFilterComposer,
          $$EncaissementsLoyersTableOrderingComposer,
          $$EncaissementsLoyersTableAnnotationComposer,
          $$EncaissementsLoyersTableCreateCompanionBuilder,
          $$EncaissementsLoyersTableUpdateCompanionBuilder,
          (EncaissementLoyer, $$EncaissementsLoyersTableReferences),
          EncaissementLoyer,
          PrefetchHooks Function({bool bienId})
        > {
  $$EncaissementsLoyersTableTableManager(
    _$AppDatabase db,
    $EncaissementsLoyersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EncaissementsLoyersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EncaissementsLoyersTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$EncaissementsLoyersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> bienId = const Value.absent(),
                Value<int> annee = const Value.absent(),
                Value<int> mois = const Value.absent(),
                Value<bool> recu = const Value.absent(),
                Value<DateTime?> recuLe = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EncaissementsLoyersCompanion(
                bienId: bienId,
                annee: annee,
                mois: mois,
                recu: recu,
                recuLe: recuLe,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String bienId,
                required int annee,
                required int mois,
                required bool recu,
                Value<DateTime?> recuLe = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EncaissementsLoyersCompanion.insert(
                bienId: bienId,
                annee: annee,
                mois: mois,
                recu: recu,
                recuLe: recuLe,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EncaissementsLoyersTable, EncaissementLoyer>(
                    table,
                  ),
                  $$EncaissementsLoyersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bienId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (bienId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bienId,
                                referencedTable:
                                    $$EncaissementsLoyersTableReferences
                                        ._bienIdTable(db),
                                referencedColumn:
                                    $$EncaissementsLoyersTableReferences
                                        ._bienIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EncaissementsLoyersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EncaissementsLoyersTable,
      EncaissementLoyer,
      $$EncaissementsLoyersTableFilterComposer,
      $$EncaissementsLoyersTableOrderingComposer,
      $$EncaissementsLoyersTableAnnotationComposer,
      $$EncaissementsLoyersTableCreateCompanionBuilder,
      $$EncaissementsLoyersTableUpdateCompanionBuilder,
      (EncaissementLoyer, $$EncaissementsLoyersTableReferences),
      EncaissementLoyer,
      PrefetchHooks Function({bool bienId})
    >;
typedef $$RevisionsLoyersTableCreateCompanionBuilder =
    RevisionsLoyersCompanion Function({
      required String id,
      required String bienId,
      required String bailId,
      Value<DateTime?> datePrevue,
      required DateTime dateEffet,
      required int ancienLoyerCentimes,
      required int nouveauLoyerCentimes,
      required int ancienIrlTrimestre,
      required int ancienIrlAnnee,
      required double ancienIrlValeur,
      required int nouvelIrlTrimestre,
      required int nouvelIrlAnnee,
      required double nouvelIrlValeur,
      Value<String?> courrierChemin,
      required DateTime creeLe,
      Value<int> rowid,
    });
typedef $$RevisionsLoyersTableUpdateCompanionBuilder =
    RevisionsLoyersCompanion Function({
      Value<String> id,
      Value<String> bienId,
      Value<String> bailId,
      Value<DateTime?> datePrevue,
      Value<DateTime> dateEffet,
      Value<int> ancienLoyerCentimes,
      Value<int> nouveauLoyerCentimes,
      Value<int> ancienIrlTrimestre,
      Value<int> ancienIrlAnnee,
      Value<double> ancienIrlValeur,
      Value<int> nouvelIrlTrimestre,
      Value<int> nouvelIrlAnnee,
      Value<double> nouvelIrlValeur,
      Value<String?> courrierChemin,
      Value<DateTime> creeLe,
      Value<int> rowid,
    });

final class $$RevisionsLoyersTableReferences
    extends
        BaseReferences<_$AppDatabase, $RevisionsLoyersTable, RevisionLoyer> {
  $$RevisionsLoyersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BiensTable _bienIdTable(_$AppDatabase db) =>
      db.biens.createAlias('revisions_loyers__bien_id__biens__id');

  $$BiensTableProcessedTableManager get bienId {
    final $_column = $_itemColumn<String>('bien_id')!;

    final manager = $$BiensTableTableManager(
      $_db,
      $_db.biens,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bienIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BauxTable _bailIdTable(_$AppDatabase db) =>
      db.baux.createAlias('revisions_loyers__bail_id__baux__id');

  $$BauxTableProcessedTableManager get bailId {
    final $_column = $_itemColumn<String>('bail_id')!;

    final manager = $$BauxTableTableManager(
      $_db,
      $_db.baux,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bailIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RevisionsLoyersTableFilterComposer
    extends Composer<_$AppDatabase, $RevisionsLoyersTable> {
  $$RevisionsLoyersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get datePrevue => $composableBuilder(
    column: $table.datePrevue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateEffet => $composableBuilder(
    column: $table.dateEffet,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ancienLoyerCentimes => $composableBuilder(
    column: $table.ancienLoyerCentimes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nouveauLoyerCentimes => $composableBuilder(
    column: $table.nouveauLoyerCentimes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ancienIrlTrimestre => $composableBuilder(
    column: $table.ancienIrlTrimestre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ancienIrlAnnee => $composableBuilder(
    column: $table.ancienIrlAnnee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ancienIrlValeur => $composableBuilder(
    column: $table.ancienIrlValeur,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nouvelIrlTrimestre => $composableBuilder(
    column: $table.nouvelIrlTrimestre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nouvelIrlAnnee => $composableBuilder(
    column: $table.nouvelIrlAnnee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get nouvelIrlValeur => $composableBuilder(
    column: $table.nouvelIrlValeur,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get courrierChemin => $composableBuilder(
    column: $table.courrierChemin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creeLe => $composableBuilder(
    column: $table.creeLe,
    builder: (column) => ColumnFilters(column),
  );

  $$BiensTableFilterComposer get bienId {
    final $$BiensTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bienId,
      referencedTable: $db.biens,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BiensTableFilterComposer(
            $db: $db,
            $table: $db.biens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BauxTableFilterComposer get bailId {
    final $$BauxTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bailId,
      referencedTable: $db.baux,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BauxTableFilterComposer(
            $db: $db,
            $table: $db.baux,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RevisionsLoyersTableOrderingComposer
    extends Composer<_$AppDatabase, $RevisionsLoyersTable> {
  $$RevisionsLoyersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get datePrevue => $composableBuilder(
    column: $table.datePrevue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateEffet => $composableBuilder(
    column: $table.dateEffet,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ancienLoyerCentimes => $composableBuilder(
    column: $table.ancienLoyerCentimes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nouveauLoyerCentimes => $composableBuilder(
    column: $table.nouveauLoyerCentimes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ancienIrlTrimestre => $composableBuilder(
    column: $table.ancienIrlTrimestre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ancienIrlAnnee => $composableBuilder(
    column: $table.ancienIrlAnnee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ancienIrlValeur => $composableBuilder(
    column: $table.ancienIrlValeur,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nouvelIrlTrimestre => $composableBuilder(
    column: $table.nouvelIrlTrimestre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nouvelIrlAnnee => $composableBuilder(
    column: $table.nouvelIrlAnnee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get nouvelIrlValeur => $composableBuilder(
    column: $table.nouvelIrlValeur,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get courrierChemin => $composableBuilder(
    column: $table.courrierChemin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creeLe => $composableBuilder(
    column: $table.creeLe,
    builder: (column) => ColumnOrderings(column),
  );

  $$BiensTableOrderingComposer get bienId {
    final $$BiensTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bienId,
      referencedTable: $db.biens,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BiensTableOrderingComposer(
            $db: $db,
            $table: $db.biens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BauxTableOrderingComposer get bailId {
    final $$BauxTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bailId,
      referencedTable: $db.baux,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BauxTableOrderingComposer(
            $db: $db,
            $table: $db.baux,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RevisionsLoyersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RevisionsLoyersTable> {
  $$RevisionsLoyersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get datePrevue => $composableBuilder(
    column: $table.datePrevue,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dateEffet =>
      $composableBuilder(column: $table.dateEffet, builder: (column) => column);

  GeneratedColumn<int> get ancienLoyerCentimes => $composableBuilder(
    column: $table.ancienLoyerCentimes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nouveauLoyerCentimes => $composableBuilder(
    column: $table.nouveauLoyerCentimes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ancienIrlTrimestre => $composableBuilder(
    column: $table.ancienIrlTrimestre,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ancienIrlAnnee => $composableBuilder(
    column: $table.ancienIrlAnnee,
    builder: (column) => column,
  );

  GeneratedColumn<double> get ancienIrlValeur => $composableBuilder(
    column: $table.ancienIrlValeur,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nouvelIrlTrimestre => $composableBuilder(
    column: $table.nouvelIrlTrimestre,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nouvelIrlAnnee => $composableBuilder(
    column: $table.nouvelIrlAnnee,
    builder: (column) => column,
  );

  GeneratedColumn<double> get nouvelIrlValeur => $composableBuilder(
    column: $table.nouvelIrlValeur,
    builder: (column) => column,
  );

  GeneratedColumn<String> get courrierChemin => $composableBuilder(
    column: $table.courrierChemin,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get creeLe =>
      $composableBuilder(column: $table.creeLe, builder: (column) => column);

  $$BiensTableAnnotationComposer get bienId {
    final $$BiensTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bienId,
      referencedTable: $db.biens,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BiensTableAnnotationComposer(
            $db: $db,
            $table: $db.biens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BauxTableAnnotationComposer get bailId {
    final $$BauxTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bailId,
      referencedTable: $db.baux,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BauxTableAnnotationComposer(
            $db: $db,
            $table: $db.baux,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RevisionsLoyersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RevisionsLoyersTable,
          RevisionLoyer,
          $$RevisionsLoyersTableFilterComposer,
          $$RevisionsLoyersTableOrderingComposer,
          $$RevisionsLoyersTableAnnotationComposer,
          $$RevisionsLoyersTableCreateCompanionBuilder,
          $$RevisionsLoyersTableUpdateCompanionBuilder,
          (RevisionLoyer, $$RevisionsLoyersTableReferences),
          RevisionLoyer,
          PrefetchHooks Function({bool bienId, bool bailId})
        > {
  $$RevisionsLoyersTableTableManager(
    _$AppDatabase db,
    $RevisionsLoyersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RevisionsLoyersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RevisionsLoyersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RevisionsLoyersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> bienId = const Value.absent(),
                Value<String> bailId = const Value.absent(),
                Value<DateTime?> datePrevue = const Value.absent(),
                Value<DateTime> dateEffet = const Value.absent(),
                Value<int> ancienLoyerCentimes = const Value.absent(),
                Value<int> nouveauLoyerCentimes = const Value.absent(),
                Value<int> ancienIrlTrimestre = const Value.absent(),
                Value<int> ancienIrlAnnee = const Value.absent(),
                Value<double> ancienIrlValeur = const Value.absent(),
                Value<int> nouvelIrlTrimestre = const Value.absent(),
                Value<int> nouvelIrlAnnee = const Value.absent(),
                Value<double> nouvelIrlValeur = const Value.absent(),
                Value<String?> courrierChemin = const Value.absent(),
                Value<DateTime> creeLe = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RevisionsLoyersCompanion(
                id: id,
                bienId: bienId,
                bailId: bailId,
                datePrevue: datePrevue,
                dateEffet: dateEffet,
                ancienLoyerCentimes: ancienLoyerCentimes,
                nouveauLoyerCentimes: nouveauLoyerCentimes,
                ancienIrlTrimestre: ancienIrlTrimestre,
                ancienIrlAnnee: ancienIrlAnnee,
                ancienIrlValeur: ancienIrlValeur,
                nouvelIrlTrimestre: nouvelIrlTrimestre,
                nouvelIrlAnnee: nouvelIrlAnnee,
                nouvelIrlValeur: nouvelIrlValeur,
                courrierChemin: courrierChemin,
                creeLe: creeLe,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String bienId,
                required String bailId,
                Value<DateTime?> datePrevue = const Value.absent(),
                required DateTime dateEffet,
                required int ancienLoyerCentimes,
                required int nouveauLoyerCentimes,
                required int ancienIrlTrimestre,
                required int ancienIrlAnnee,
                required double ancienIrlValeur,
                required int nouvelIrlTrimestre,
                required int nouvelIrlAnnee,
                required double nouvelIrlValeur,
                Value<String?> courrierChemin = const Value.absent(),
                required DateTime creeLe,
                Value<int> rowid = const Value.absent(),
              }) => RevisionsLoyersCompanion.insert(
                id: id,
                bienId: bienId,
                bailId: bailId,
                datePrevue: datePrevue,
                dateEffet: dateEffet,
                ancienLoyerCentimes: ancienLoyerCentimes,
                nouveauLoyerCentimes: nouveauLoyerCentimes,
                ancienIrlTrimestre: ancienIrlTrimestre,
                ancienIrlAnnee: ancienIrlAnnee,
                ancienIrlValeur: ancienIrlValeur,
                nouvelIrlTrimestre: nouvelIrlTrimestre,
                nouvelIrlAnnee: nouvelIrlAnnee,
                nouvelIrlValeur: nouvelIrlValeur,
                courrierChemin: courrierChemin,
                creeLe: creeLe,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RevisionsLoyersTable, RevisionLoyer>(table),
                  $$RevisionsLoyersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bienId = false, bailId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (bienId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bienId,
                                referencedTable:
                                    $$RevisionsLoyersTableReferences
                                        ._bienIdTable(db),
                                referencedColumn:
                                    $$RevisionsLoyersTableReferences
                                        ._bienIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (bailId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bailId,
                                referencedTable:
                                    $$RevisionsLoyersTableReferences
                                        ._bailIdTable(db),
                                referencedColumn:
                                    $$RevisionsLoyersTableReferences
                                        ._bailIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RevisionsLoyersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RevisionsLoyersTable,
      RevisionLoyer,
      $$RevisionsLoyersTableFilterComposer,
      $$RevisionsLoyersTableOrderingComposer,
      $$RevisionsLoyersTableAnnotationComposer,
      $$RevisionsLoyersTableCreateCompanionBuilder,
      $$RevisionsLoyersTableUpdateCompanionBuilder,
      (RevisionLoyer, $$RevisionsLoyersTableReferences),
      RevisionLoyer,
      PrefetchHooks Function({bool bienId, bool bailId})
    >;
typedef $$IndicesIrlTableCreateCompanionBuilder =
    IndicesIrlCompanion Function({
      required int annee,
      required int trimestre,
      required double valeur,
      Value<DateTime?> datePublication,
      required SourceIndice source,
      Value<int> rowid,
    });
typedef $$IndicesIrlTableUpdateCompanionBuilder =
    IndicesIrlCompanion Function({
      Value<int> annee,
      Value<int> trimestre,
      Value<double> valeur,
      Value<DateTime?> datePublication,
      Value<SourceIndice> source,
      Value<int> rowid,
    });

class $$IndicesIrlTableFilterComposer
    extends Composer<_$AppDatabase, $IndicesIrlTable> {
  $$IndicesIrlTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get annee => $composableBuilder(
    column: $table.annee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get trimestre => $composableBuilder(
    column: $table.trimestre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get valeur => $composableBuilder(
    column: $table.valeur,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get datePublication => $composableBuilder(
    column: $table.datePublication,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SourceIndice, SourceIndice, String>
  get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$IndicesIrlTableOrderingComposer
    extends Composer<_$AppDatabase, $IndicesIrlTable> {
  $$IndicesIrlTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get annee => $composableBuilder(
    column: $table.annee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get trimestre => $composableBuilder(
    column: $table.trimestre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valeur => $composableBuilder(
    column: $table.valeur,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get datePublication => $composableBuilder(
    column: $table.datePublication,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IndicesIrlTableAnnotationComposer
    extends Composer<_$AppDatabase, $IndicesIrlTable> {
  $$IndicesIrlTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get annee =>
      $composableBuilder(column: $table.annee, builder: (column) => column);

  GeneratedColumn<int> get trimestre =>
      $composableBuilder(column: $table.trimestre, builder: (column) => column);

  GeneratedColumn<double> get valeur =>
      $composableBuilder(column: $table.valeur, builder: (column) => column);

  GeneratedColumn<DateTime> get datePublication => $composableBuilder(
    column: $table.datePublication,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<SourceIndice, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);
}

class $$IndicesIrlTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IndicesIrlTable,
          IndiceIrl,
          $$IndicesIrlTableFilterComposer,
          $$IndicesIrlTableOrderingComposer,
          $$IndicesIrlTableAnnotationComposer,
          $$IndicesIrlTableCreateCompanionBuilder,
          $$IndicesIrlTableUpdateCompanionBuilder,
          (
            IndiceIrl,
            BaseReferences<_$AppDatabase, $IndicesIrlTable, IndiceIrl>,
          ),
          IndiceIrl,
          PrefetchHooks Function()
        > {
  $$IndicesIrlTableTableManager(_$AppDatabase db, $IndicesIrlTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IndicesIrlTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IndicesIrlTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IndicesIrlTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> annee = const Value.absent(),
                Value<int> trimestre = const Value.absent(),
                Value<double> valeur = const Value.absent(),
                Value<DateTime?> datePublication = const Value.absent(),
                Value<SourceIndice> source = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IndicesIrlCompanion(
                annee: annee,
                trimestre: trimestre,
                valeur: valeur,
                datePublication: datePublication,
                source: source,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int annee,
                required int trimestre,
                required double valeur,
                Value<DateTime?> datePublication = const Value.absent(),
                required SourceIndice source,
                Value<int> rowid = const Value.absent(),
              }) => IndicesIrlCompanion.insert(
                annee: annee,
                trimestre: trimestre,
                valeur: valeur,
                datePublication: datePublication,
                source: source,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$IndicesIrlTable, IndiceIrl>(table),
                  BaseReferences<_$AppDatabase, $IndicesIrlTable, IndiceIrl>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$IndicesIrlTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IndicesIrlTable,
      IndiceIrl,
      $$IndicesIrlTableFilterComposer,
      $$IndicesIrlTableOrderingComposer,
      $$IndicesIrlTableAnnotationComposer,
      $$IndicesIrlTableCreateCompanionBuilder,
      $$IndicesIrlTableUpdateCompanionBuilder,
      (IndiceIrl, BaseReferences<_$AppDatabase, $IndicesIrlTable, IndiceIrl>),
      IndiceIrl,
      PrefetchHooks Function()
    >;
typedef $$ReglagesTableCreateCompanionBuilder =
    ReglagesCompanion Function({
      required String cle,
      required String valeur,
      Value<int> rowid,
    });
typedef $$ReglagesTableUpdateCompanionBuilder =
    ReglagesCompanion Function({
      Value<String> cle,
      Value<String> valeur,
      Value<int> rowid,
    });

class $$ReglagesTableFilterComposer
    extends Composer<_$AppDatabase, $ReglagesTable> {
  $$ReglagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get cle => $composableBuilder(
    column: $table.cle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valeur => $composableBuilder(
    column: $table.valeur,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReglagesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReglagesTable> {
  $$ReglagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get cle => $composableBuilder(
    column: $table.cle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valeur => $composableBuilder(
    column: $table.valeur,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReglagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReglagesTable> {
  $$ReglagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get cle =>
      $composableBuilder(column: $table.cle, builder: (column) => column);

  GeneratedColumn<String> get valeur =>
      $composableBuilder(column: $table.valeur, builder: (column) => column);
}

class $$ReglagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReglagesTable,
          ReglageLigne,
          $$ReglagesTableFilterComposer,
          $$ReglagesTableOrderingComposer,
          $$ReglagesTableAnnotationComposer,
          $$ReglagesTableCreateCompanionBuilder,
          $$ReglagesTableUpdateCompanionBuilder,
          (
            ReglageLigne,
            BaseReferences<_$AppDatabase, $ReglagesTable, ReglageLigne>,
          ),
          ReglageLigne,
          PrefetchHooks Function()
        > {
  $$ReglagesTableTableManager(_$AppDatabase db, $ReglagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReglagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReglagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReglagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> cle = const Value.absent(),
                Value<String> valeur = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReglagesCompanion(cle: cle, valeur: valeur, rowid: rowid),
          createCompanionCallback:
              ({
                required String cle,
                required String valeur,
                Value<int> rowid = const Value.absent(),
              }) => ReglagesCompanion.insert(
                cle: cle,
                valeur: valeur,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReglagesTable, ReglageLigne>(table),
                  BaseReferences<_$AppDatabase, $ReglagesTable, ReglageLigne>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReglagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReglagesTable,
      ReglageLigne,
      $$ReglagesTableFilterComposer,
      $$ReglagesTableOrderingComposer,
      $$ReglagesTableAnnotationComposer,
      $$ReglagesTableCreateCompanionBuilder,
      $$ReglagesTableUpdateCompanionBuilder,
      (
        ReglageLigne,
        BaseReferences<_$AppDatabase, $ReglagesTable, ReglageLigne>,
      ),
      ReglageLigne,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BailleursTableTableManager get bailleurs =>
      $$BailleursTableTableManager(_db, _db.bailleurs);
  $$BiensTableTableManager get biens =>
      $$BiensTableTableManager(_db, _db.biens);
  $$BauxTableTableManager get baux => $$BauxTableTableManager(_db, _db.baux);
  $$LocatairesTableTableManager get locataires =>
      $$LocatairesTableTableManager(_db, _db.locataires);
  $$EcheancesTableTableManager get echeances =>
      $$EcheancesTableTableManager(_db, _db.echeances);
  $$RappelsTableTableManager get rappels =>
      $$RappelsTableTableManager(_db, _db.rappels);
  $$ArtisansTableTableManager get artisans =>
      $$ArtisansTableTableManager(_db, _db.artisans);
  $$InterventionsTableTableManager get interventions =>
      $$InterventionsTableTableManager(_db, _db.interventions);
  $$MouvementsFinanciersTableTableManager get mouvementsFinanciers =>
      $$MouvementsFinanciersTableTableManager(_db, _db.mouvementsFinanciers);
  $$EncaissementsLoyersTableTableManager get encaissementsLoyers =>
      $$EncaissementsLoyersTableTableManager(_db, _db.encaissementsLoyers);
  $$RevisionsLoyersTableTableManager get revisionsLoyers =>
      $$RevisionsLoyersTableTableManager(_db, _db.revisionsLoyers);
  $$IndicesIrlTableTableManager get indicesIrl =>
      $$IndicesIrlTableTableManager(_db, _db.indicesIrl);
  $$ReglagesTableTableManager get reglages =>
      $$ReglagesTableTableManager(_db, _db.reglages);
}
