import 'package:bailleur_app/domain/entities/entities.dart';

final _t0 = DateTime(2026, 1, 1);

Bien unBien({
  String id = 'bien-1',
  String nom = 'Studio Gambetta',
  TypeLocation typeLocation = TypeLocation.longueDuree,
  ClasseDpe? classeDpe,
  int loyerHcCentimes = 65000,
}) => Bien(
  id: id,
  nom: nom,
  typeLogement: TypeLogement.appartement,
  typeLocation: typeLocation,
  rue: '12 rue Gambetta',
  codePostal: '75020',
  ville: 'Paris',
  loyerHcCentimes: loyerHcCentimes,
  chargesCentimes: 5000,
  classeDpe: classeDpe,
  ordre: 0,
  creeLe: _t0,
  modifieLe: _t0,
);

Bail unBail({
  String id = 'bail-1',
  String bienId = 'bien-1',
  TypeBail typeBail = TypeBail.vide,
  required DateTime debut,
  int? dureeMois,
  DateTime? dateRevision,
  bool actif = true,
}) => Bail(
  id: id,
  bienId: bienId,
  typeBail: typeBail,
  dateDebut: debut,
  dureeMois: dureeMois,
  dateRevision: dateRevision,
  actif: actif,
  creeLe: _t0,
  modifieLe: _t0,
);
