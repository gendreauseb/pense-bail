import '../format/formats.dart';

/// Validations de saisie. Chaque méthode retourne un message d'erreur clair,
/// ou `null` si la saisie est correcte (format attendu par les TextFormField).
abstract final class Validateurs {
  static String? obligatoire(
    String? valeur, {
    String message = 'Ce champ est obligatoire.',
  }) => (valeur == null || valeur.trim().isEmpty) ? message : null;

  static final _deuxDecimales = RegExp(r'^\d+([.,]\d{1,2})?$');

  /// Valeur d'un IRL : positive, deux décimales au maximum (« 145,17 »).
  static String? indiceIrl(String? valeur) {
    final texte = valeur?.trim() ?? '';
    if (texte.isEmpty) return "Indiquez la valeur de l'indice.";
    final nombre = Formats.parseDecimal(texte);
    if (nombre == null || nombre <= 0 || nombre >= 1000) {
      return 'Valeur incorrecte (format : 123,45).';
    }
    if (!_deuxDecimales.hasMatch(texte)) return 'Deux décimales au maximum.';
    return null;
  }

  static final _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

  static String? email(String? valeur, {bool obligatoire = false}) {
    final v = valeur?.trim() ?? '';
    if (v.isEmpty) return obligatoire ? 'Indiquez votre adresse email.' : null;
    return _email.hasMatch(v)
        ? null
        : 'Adresse email incorrecte (exemple : prenom.nom@email.fr).';
  }

  static String? telephone(String? valeur, {bool obligatoire = false}) {
    final v = valeur?.trim() ?? '';
    if (v.isEmpty) {
      return obligatoire ? 'Indiquez votre numéro de téléphone.' : null;
    }
    return normaliserTelephone(v) == null
        ? 'Numéro incorrect : 10 chiffres commençant par 0 (exemple : 06 12 34 56 78).'
        : null;
  }

  static String? codePostal(String? valeur) {
    final v = valeur?.trim() ?? '';
    if (v.isEmpty) return 'Indiquez le code postal.';
    return estCodePostal(v)
        ? null
        : 'Code postal incorrect : 5 chiffres (exemple : 75011).';
  }

  /// 5 chiffres, département 01 à 98 (y compris outre-mer 97x / 98x).
  static bool estCodePostal(String v) {
    if (!RegExp(r'^\d{5}$').hasMatch(v)) return false;
    final departement = int.parse(v.substring(0, 2));
    return departement >= 1 && departement <= 98;
  }

  /// Numéro français normalisé au format « 06 12 34 56 78 », ou `null` si
  /// le numéro est invalide. Accepte les espaces, points, tirets et les
  /// préfixes +33 / 0033.
  static String? normaliserTelephone(String saisie) {
    var chiffres = saisie.replaceAll(RegExp(r'[\s.\-()]'), '');
    if (chiffres.startsWith('+33')) {
      chiffres = '0${chiffres.substring(3)}';
    } else if (chiffres.startsWith('0033')) {
      chiffres = '0${chiffres.substring(4)}';
    }
    if (!RegExp(r'^0[1-9]\d{8}$').hasMatch(chiffres)) return null;
    return [
      for (var i = 0; i < 10; i += 2) chiffres.substring(i, i + 2),
    ].join(' ');
  }
}
