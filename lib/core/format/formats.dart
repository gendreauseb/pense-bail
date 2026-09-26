import 'package:intl/intl.dart';

/// Formats français utilisés dans toute l'application.
///
/// Les montants sont manipulés en CENTIMES (int) pour éviter les erreurs
/// d'arrondi des nombres à virgule.
abstract final class Formats {
  static const locale = 'fr_FR';

  static final _euros = NumberFormat.currency(
    locale: locale,
    symbol: '€',
    decimalDigits: 2,
  );
  static final _eurosSansCentimes = NumberFormat.currency(
    locale: locale,
    symbol: '€',
    decimalDigits: 0,
  );
  static final _date = DateFormat('dd/MM/yyyy', locale);
  static final _dateLongue = DateFormat('d MMMM yyyy', locale);
  static final _pourcentage = NumberFormat('#,##0.00', locale);
  static final _decimal = NumberFormat('#,##0.00', locale);

  /// Écran : centimes affichés seulement s'ils sont non nuls.
  /// 65000 → « 650 € » ; 66423 → « 664,23 € » ; 115000 → « 1 150 € ».
  static String montant(int centimes) => centimes % 100 == 0
      ? _espaces(_eurosSansCentimes.format(centimes ~/ 100))
      : montantComplet(centimes);

  /// Courriers et calculs détaillés : toujours avec les centimes.
  /// 65000 → « 650,00 € »
  static String montantComplet(int centimes) =>
      _espaces(_euros.format(centimes / 100));

  /// 123456 → « 1 235 € » (arrondi à l'euro, pour les résumés)
  static String montantArrondi(int centimes) =>
      _espaces(_eurosSansCentimes.format((centimes / 100).round()));

  /// 62000 → « 620 € / mois »
  static String parMois(int centimes) => '${montant(centimes)} / mois';

  /// L'espace fine insécable (U+202F) utilisée par le format français n'existe
  /// pas dans les polices embarquées : on la remplace par l'espace
  /// insécable classique (U+00A0), qui empêche aussi les retours à la ligne.
  static String _espaces(String texte) => texte.replaceAll('\u202F', '\u00A0');

  /// → « 25/09/2026 »
  static String date(DateTime date) => _date.format(date);

  /// → « 25 septembre 2026 » (courriers)
  static String dateLongue(DateTime date) => _dateLongue.format(date);

  static final _jourComplet = DateFormat('EEEE d MMMM', locale);

  /// → « Vendredi 25 septembre » (en-tête du tableau de bord)
  static String jourComplet(DateTime date) {
    final texte = _jourComplet.format(date);
    return texte[0].toUpperCase() + texte.substring(1);
  }

  static final _mois = DateFormat('MMMM', locale);

  /// 1 → « janvier »
  static String nomMois(int mois) => _mois.format(DateTime(2000, mois));

  static final _moisAbrege = DateFormat('MMM', locale);

  /// → « SEPT », « DÉC », « MAI » (tuiles de date)
  static String moisAbrege(DateTime date) =>
      _moisAbrege.format(date).replaceAll('.', '').toUpperCase();

  /// 0.0534 → « 5,34 % »
  static String pourcentage(double ratio) =>
      '${_pourcentage.format(ratio * 100)} %';

  /// 145.17 → « 145,17 » (indices IRL)
  static String decimal(double valeur) => _decimal.format(valeur);

  /// (1, 2026) → « 1er trimestre 2026 » ; (2) → « 2e trimestre »
  static String trimestre(int trimestre, [int? annee]) {
    final rang = trimestre == 1 ? '1er' : '${trimestre}e';
    return annee == null ? '$rang trimestre' : '$rang trimestre $annee';
  }

  /// Convertit une saisie utilisateur en centimes.
  /// Accepte « 1 234,56 », « 1234.5 », « 1 234 € », « 650 ».
  /// Retourne `null` si la saisie est vide ou invalide.
  static int? parseMontant(String saisie) {
    final nettoye = _nettoyerNombre(saisie);
    if (nettoye == null) return null;
    final valeur = double.tryParse(nettoye);
    if (valeur == null || valeur < 0) return null;
    return (valeur * 100).round();
  }

  /// Convertit une saisie décimale (surface, indice IRL...) en double.
  static double? parseDecimal(String saisie) {
    final nettoye = _nettoyerNombre(saisie);
    return nettoye == null ? null : double.tryParse(nettoye);
  }

  static String? _nettoyerNombre(String saisie) {
    final s = saisie
        .replaceAll('€', '')
        .replaceAll(RegExp(r'[\s\u00A0\u202F]'), '')
        .replaceAll(',', '.');
    if (s.isEmpty) return null;
    return RegExp(r'^\d+(\.\d+)?$').hasMatch(s) ? s : null;
  }
}
