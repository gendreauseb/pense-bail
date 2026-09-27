import 'adresse.dart';
import 'copie.dart';

/// Le propriétaire qui utilise l'application (expéditeur des courriers).
class Bailleur {
  const Bailleur({
    required this.id,
    required this.prenom,
    required this.nom,
    required this.rue,
    this.complementAdresse,
    required this.codePostal,
    required this.ville,
    required this.telephone,
    required this.email,
    required this.creeLe,
    required this.modifieLe,
  });

  final String id;
  final String prenom;
  final String nom;
  final String rue;

  /// Bâtiment, résidence, étage, appartement… (facultatif).
  final String? complementAdresse;
  final String codePostal;
  final String ville;
  final String telephone;
  final String email;
  final DateTime creeLe;
  final DateTime modifieLe;

  String get nomComplet => '$prenom $nom';

  /// Sur une ligne : « 1 place de la Mairie, Bât. A, 69001 Lyon ».
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

  Bailleur copyWith({
    String? prenom,
    String? nom,
    String? rue,
    Object? complementAdresse = inchange,
    String? codePostal,
    String? ville,
    String? telephone,
    String? email,
    DateTime? modifieLe,
  }) => Bailleur(
    id: id,
    prenom: prenom ?? this.prenom,
    nom: nom ?? this.nom,
    rue: rue ?? this.rue,
    complementAdresse: choisir(complementAdresse, this.complementAdresse),
    codePostal: codePostal ?? this.codePostal,
    ville: ville ?? this.ville,
    telephone: telephone ?? this.telephone,
    email: email ?? this.email,
    creeLe: creeLe,
    modifieLe: modifieLe ?? DateTime.now(),
  );
}
