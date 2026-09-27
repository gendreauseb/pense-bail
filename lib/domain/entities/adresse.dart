/// Mise en forme des adresses postales (bailleur, biens).
library;

String? _nettoyer(String? texte) {
  final t = texte?.trim() ?? '';
  return t.isEmpty ? null : t;
}

/// « 12 rue Gambetta, Résidence Les Pins, 75020 Paris »
String formaterAdresseSurUneLigne({
  required String rue,
  required String? complement,
  required String codePostal,
  required String ville,
}) => [
  ?_nettoyer(rue),
  ?_nettoyer(complement),
  ?_nettoyer('$codePostal $ville'),
].join(', ');

/// Lignes d'une adresse sur un courrier. Le complément (bâtiment,
/// résidence, étage…) précède la voie, comme le recommande la norme postale
/// (AFNOR NF Z10-011).
List<String> lignesAdressePostale({
  required String rue,
  required String? complement,
  required String codePostal,
  required String ville,
}) => [
  ?_nettoyer(complement),
  ?_nettoyer(rue),
  ?_nettoyer('$codePostal $ville'),
];
