/// Nom de fichier sans accents ni espaces, terminé par « .pdf » :
/// ['revision-loyer', '2026', 'Studio Gambetta'] →
/// « revision-loyer-2026-studio-gambetta.pdf ».
String nomFichierPdf(List<String> parties) {
  const remplacements = {
    'à': 'a', 'â': 'a', 'ä': 'a', 'á': 'a', 'ã': 'a', 'å': 'a', //
    'ç': 'c', 'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e', //
    'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i', 'ñ': 'n', //
    'ó': 'o', 'ò': 'o', 'ô': 'o', 'ö': 'o', 'õ': 'o', //
    'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u', 'ý': 'y', 'ÿ': 'y', //
    'œ': 'oe', 'æ': 'ae',
  };
  final texte = parties
      .join('-')
      .toLowerCase()
      .split('')
      .map((c) => remplacements[c] ?? c)
      .join();
  final nettoye = texte
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
  return '$nettoye.pdf';
}
