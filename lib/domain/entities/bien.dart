import '../enums.dart';
import 'adresse.dart';
import 'copie.dart';

/// Un bien immobilier mis en location.
///
/// Les montants sont en centimes. Les données de rentabilité
/// (investissement, charges annuelles) sont optionnelles.
class Bien {
  const Bien({
    required this.id,
    required this.nom,
    required this.typeLogement,
    required this.typeLocation,
    required this.rue,
    this.complementAdresse,
    required this.codePostal,
    required this.ville,
    required this.loyerHcCentimes,
    required this.chargesCentimes,
    this.photoChemin,
    this.surfaceM2,
    this.classeDpe,
    this.dateDpe,
    this.nombreLots,
    this.prixAchatCentimes,
    this.fraisNotaireCentimes,
    this.travauxInitiauxCentimes,
    this.mensualiteCreditCentimes,
    this.taxeFonciereCentimes,
    this.assuranceCentimes,
    this.chargesNonRecuperablesCentimes,
    this.fraisDiversCentimes,
    required this.ordre,
    required this.creeLe,
    required this.modifieLe,
  });

  final String id;

  /// Nom libre affiché partout (ex. « Studio Gambetta »).
  final String nom;
  final TypeLogement typeLogement;
  final TypeLocation typeLocation;

  final String rue;

  /// Bâtiment, résidence, étage, appartement… (facultatif).
  final String? complementAdresse;
  final String codePostal;
  final String ville;

  /// Loyer mensuel hors charges.
  final int loyerHcCentimes;

  /// Provision ou forfait de charges mensuel.
  final int chargesCentimes;

  /// Chemin RELATIF de la photo dans le dossier Documents de l'application.
  final String? photoChemin;

  // Informations complémentaires
  final double? surfaceM2;
  final ClasseDpe? classeDpe;
  final DateTime? dateDpe;
  final int? nombreLots;

  // Investissement
  final int? prixAchatCentimes;
  final int? fraisNotaireCentimes;
  final int? travauxInitiauxCentimes;
  final int? mensualiteCreditCentimes;

  // Charges annuelles du propriétaire
  final int? taxeFonciereCentimes;
  final int? assuranceCentimes;
  final int? chargesNonRecuperablesCentimes;
  final int? fraisDiversCentimes;

  /// Ordre d'affichage dans les listes.
  final int ordre;
  final DateTime creeLe;
  final DateTime modifieLe;

  int get totalMensuelCentimes => loyerHcCentimes + chargesCentimes;

  /// Sur une ligne : « 12 rue Gambetta, Résidence Les Pins, 75020 Paris ».
  String get adresseComplete => formaterAdresseSurUneLigne(
    rue: rue,
    complement: complementAdresse,
    codePostal: codePostal,
    ville: ville,
  );

  /// Lignes d'un courrier, complément avant la voie (norme postale).
  List<String> get lignesAdresse => lignesAdressePostale(
    rue: rue,
    complement: complementAdresse,
    codePostal: codePostal,
    ville: ville,
  );

  Bien copyWith({
    String? nom,
    TypeLogement? typeLogement,
    TypeLocation? typeLocation,
    String? rue,
    Object? complementAdresse = inchange,
    String? codePostal,
    String? ville,
    int? loyerHcCentimes,
    int? chargesCentimes,
    Object? photoChemin = inchange,
    Object? surfaceM2 = inchange,
    Object? classeDpe = inchange,
    Object? dateDpe = inchange,
    Object? nombreLots = inchange,
    Object? prixAchatCentimes = inchange,
    Object? fraisNotaireCentimes = inchange,
    Object? travauxInitiauxCentimes = inchange,
    Object? mensualiteCreditCentimes = inchange,
    Object? taxeFonciereCentimes = inchange,
    Object? assuranceCentimes = inchange,
    Object? chargesNonRecuperablesCentimes = inchange,
    Object? fraisDiversCentimes = inchange,
    int? ordre,
    DateTime? modifieLe,
  }) => Bien(
    id: id,
    nom: nom ?? this.nom,
    typeLogement: typeLogement ?? this.typeLogement,
    typeLocation: typeLocation ?? this.typeLocation,
    rue: rue ?? this.rue,
    complementAdresse: choisir(complementAdresse, this.complementAdresse),
    codePostal: codePostal ?? this.codePostal,
    ville: ville ?? this.ville,
    loyerHcCentimes: loyerHcCentimes ?? this.loyerHcCentimes,
    chargesCentimes: chargesCentimes ?? this.chargesCentimes,
    photoChemin: choisir(photoChemin, this.photoChemin),
    surfaceM2: choisir(surfaceM2, this.surfaceM2),
    classeDpe: choisir(classeDpe, this.classeDpe),
    dateDpe: choisir(dateDpe, this.dateDpe),
    nombreLots: choisir(nombreLots, this.nombreLots),
    prixAchatCentimes: choisir(prixAchatCentimes, this.prixAchatCentimes),
    fraisNotaireCentimes: choisir(
      fraisNotaireCentimes,
      this.fraisNotaireCentimes,
    ),
    travauxInitiauxCentimes: choisir(
      travauxInitiauxCentimes,
      this.travauxInitiauxCentimes,
    ),
    mensualiteCreditCentimes: choisir(
      mensualiteCreditCentimes,
      this.mensualiteCreditCentimes,
    ),
    taxeFonciereCentimes: choisir(
      taxeFonciereCentimes,
      this.taxeFonciereCentimes,
    ),
    assuranceCentimes: choisir(assuranceCentimes, this.assuranceCentimes),
    chargesNonRecuperablesCentimes: choisir(
      chargesNonRecuperablesCentimes,
      this.chargesNonRecuperablesCentimes,
    ),
    fraisDiversCentimes: choisir(fraisDiversCentimes, this.fraisDiversCentimes),
    ordre: ordre ?? this.ordre,
    creeLe: creeLe,
    modifieLe: modifieLe ?? DateTime.now(),
  );
}
