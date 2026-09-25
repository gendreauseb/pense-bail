/// Le propriétaire qui utilise l'application (expéditeur des courriers).
class Bailleur {
  const Bailleur({
    required this.id,
    required this.prenom,
    required this.nom,
    required this.rue,
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
  final String codePostal;
  final String ville;
  final String telephone;
  final String email;
  final DateTime creeLe;
  final DateTime modifieLe;

  String get nomComplet => '$prenom $nom';

  Bailleur copyWith({
    String? prenom,
    String? nom,
    String? rue,
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
    codePostal: codePostal ?? this.codePostal,
    ville: ville ?? this.ville,
    telephone: telephone ?? this.telephone,
    email: email ?? this.email,
    creeLe: creeLe,
    modifieLe: modifieLe ?? DateTime.now(),
  );
}
