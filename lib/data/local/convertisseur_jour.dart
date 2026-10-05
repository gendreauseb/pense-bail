import 'package:drift/drift.dart';

/// Date « calendaire » (début de bail, échéance…) enregistrée sans heure ni
/// fuseau : texte `AAAA-MM-JJ`, relu à minuit heure locale.
///
/// Jusqu'au schéma 4, ces dates étaient des instants avec décalage horaire
/// (`2026-10-15T00:00:00.000+02:00`) : relues dans un autre fuseau, elles
/// changeaient de jour. Leurs 10 premiers caractères sont le jour saisi :
/// la lecture les accepte encore (anciennes sauvegardes).
class ConvertisseurJour extends TypeConverter<DateTime, String> {
  const ConvertisseurJour();

  static final _format = RegExp(r'^(\d{4})-(\d{2})-(\d{2})');

  @override
  DateTime fromSql(String fromDb) {
    final m = _format.firstMatch(fromDb);
    if (m == null) throw FormatException('Date illisible', fromDb);
    return DateTime(
      int.parse(m.group(1)!),
      int.parse(m.group(2)!),
      int.parse(m.group(3)!),
    );
  }

  @override
  String toSql(DateTime value) => texte(value);

  /// `AAAA-MM-JJ` du jour de [d], tel qu'il est enregistré.
  static String texte(DateTime d) {
    String deux(int n) => n.toString().padLeft(2, '0');
    return '${d.year.toString().padLeft(4, '0')}-${deux(d.month)}-'
        '${deux(d.day)}';
  }
}
