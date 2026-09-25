import '../../core/config/regles_legales.dart';
import '../enums.dart';
import 'copie.dart';

/// Contrat de location d'un bien. Un seul bail actif par bien en V1
/// (les anciens baux sont conservés avec `actif = false`).
class Bail {
  const Bail({
    required this.id,
    required this.bienId,
    required this.typeBail,
    required this.dateDebut,
    this.dureeMois,
    this.depotGarantieCentimes,
    this.dateRevision,
    this.irlTrimestre,
    this.irlAnnee,
    this.irlValeur,
    required this.actif,
    required this.creeLe,
    required this.modifieLe,
  });

  final String id;
  final String bienId;
  final TypeBail typeBail;
  final DateTime dateDebut;

  /// Durée saisie. `null` : durée légale par défaut du type de bail.
  final int? dureeMois;
  final int? depotGarantieCentimes;

  /// Date de révision prévue au bail. `null` : date anniversaire du bail.
  /// Seuls le jour et le mois comptent : la révision a lieu chaque année.
  final DateTime? dateRevision;

  /// IRL de référence (trimestre 1 à 4, année, valeur).
  final int? irlTrimestre;
  final int? irlAnnee;
  final double? irlValeur;

  final bool actif;
  final DateTime creeLe;
  final DateTime modifieLe;

  RegleBail get regle => ReglesLegales.bail(typeBail);

  /// Durée effective : saisie, sinon durée légale par défaut.
  int? get dureeEffectiveMois => dureeMois ?? regle.dureeMois;

  bool get irlReferenceComplet =>
      irlTrimestre != null && irlAnnee != null && irlValeur != null;

  Bail copyWith({
    TypeBail? typeBail,
    DateTime? dateDebut,
    Object? dureeMois = inchange,
    Object? depotGarantieCentimes = inchange,
    Object? dateRevision = inchange,
    Object? irlTrimestre = inchange,
    Object? irlAnnee = inchange,
    Object? irlValeur = inchange,
    bool? actif,
    DateTime? modifieLe,
  }) => Bail(
    id: id,
    bienId: bienId,
    typeBail: typeBail ?? this.typeBail,
    dateDebut: dateDebut ?? this.dateDebut,
    dureeMois: choisir(dureeMois, this.dureeMois),
    depotGarantieCentimes: choisir(
      depotGarantieCentimes,
      this.depotGarantieCentimes,
    ),
    dateRevision: choisir(dateRevision, this.dateRevision),
    irlTrimestre: choisir(irlTrimestre, this.irlTrimestre),
    irlAnnee: choisir(irlAnnee, this.irlAnnee),
    irlValeur: choisir(irlValeur, this.irlValeur),
    actif: actif ?? this.actif,
    creeLe: creeLe,
    modifieLe: modifieLe ?? DateTime.now(),
  );
}

/// Locataire rattaché à un bail (plusieurs en cas de colocation).
class Locataire {
  const Locataire({
    required this.id,
    required this.bailId,
    required this.prenom,
    required this.nom,
    this.telephone,
    this.email,
    required this.creeLe,
    required this.modifieLe,
  });

  final String id;
  final String bailId;
  final String prenom;
  final String nom;
  final String? telephone;
  final String? email;
  final DateTime creeLe;
  final DateTime modifieLe;

  String get nomComplet => '$prenom $nom'.trim();

  Locataire copyWith({
    String? prenom,
    String? nom,
    Object? telephone = inchange,
    Object? email = inchange,
    DateTime? modifieLe,
  }) => Locataire(
    id: id,
    bailId: bailId,
    prenom: prenom ?? this.prenom,
    nom: nom ?? this.nom,
    telephone: choisir(telephone, this.telephone),
    email: choisir(email, this.email),
    creeLe: creeLe,
    modifieLe: modifieLe ?? DateTime.now(),
  );
}
