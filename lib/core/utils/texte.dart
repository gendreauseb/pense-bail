/// Saisie facultative : texte sans espaces superflus, ou `null` si vide.
String? facultatif(String saisie) {
  final texte = saisie.trim();
  return texte.isEmpty ? null : texte;
}
