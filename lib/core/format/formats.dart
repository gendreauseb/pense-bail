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

  /// 123456 → « 1 234,56 € »
  static String montant(int centimes) => _euros.format(centimes / 100);

  /// 123456 → « 1 235 € » (arrondi, pour les résumés)
  static String montantArrondi(int centimes) =>
      _eurosSansCentimes.format((centimes / 100).round());

  /// → « 25/09/2026 »
  static String date(DateTime date) => _date.format(date);

  /// → « 25 septembre 2026 » (courriers)
  static String dateLongue(DateTime date) => _dateLongue.format(date);

  /// 0.0534 → « 5,34 % »
  static String pourcentage(double ratio) =>
      '${_pourcentage.format(ratio * 100)} %';

  /// 145.17 → « 145,17 » (indices IRL)
  static String decimal(double valeur) => _decimal.format(valeur);

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
        .replaceAll(RegExp(r'[\s  ]'), '')
        .replaceAll(',', '.');
    if (s.isEmpty) return null;
    return RegExp(r'^\d+(\.\d+)?$').hasMatch(s) ? s : null;
  }
}
