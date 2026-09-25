/// Outils de calcul sur les dates « calendaires » (sans heure).
///
/// Toutes les dates métier (début de bail, échéances...) sont normalisées à
/// minuit heure locale via [jour].
abstract final class Dates {
  /// Supprime l'heure.
  static DateTime jour(DateTime d) => DateTime(d.year, d.month, d.day);

  static DateTime aujourdhui() => jour(DateTime.now());

  /// Ajoute (ou retire) des mois en restant dans le mois cible :
  /// 31/01 + 1 mois → 28/02 (ou 29/02), et non 03/03.
  static DateTime ajouterMois(DateTime d, int mois) {
    final totalMois = d.year * 12 + (d.month - 1) + mois;
    final annee = totalMois ~/ 12;
    final moisCible = totalMois % 12 + 1;
    final dernierJour = DateTime(annee, moisCible + 1, 0).day;
    final jourCible = d.day > dernierJour ? dernierJour : d.day;
    return DateTime(annee, moisCible, jourCible);
  }

  static DateTime ajouterJours(DateTime d, int jours) =>
      DateTime(d.year, d.month, d.day + jours);

  /// Nombre de jours calendaires de [de] à [a] (négatif si [a] est passé).
  /// Calculé en UTC pour ne pas être faussé par les changements d'heure.
  static int joursEntre(DateTime de, DateTime a) {
    final d1 = DateTime.utc(de.year, de.month, de.day);
    final d2 = DateTime.utc(a.year, a.month, a.day);
    return d2.difference(d1).inDays;
  }

  /// Première date de la suite `origine + k × pasMois` (k ≥ 1) qui tombe le
  /// [aPartirDe] ou après. Chaque terme est recalculé depuis l'origine pour
  /// ne pas « dériver » (31/01 → 28/02 → 28/03...).
  static DateTime prochaineOccurrence({
    required DateTime origine,
    required int pasMois,
    required DateTime aPartirDe,
  }) {
    assert(pasMois > 0);
    final cible = jour(aPartirDe);
    final ecartMois =
        (cible.year - origine.year) * 12 + cible.month - origine.month;
    // On part d'un terme forcément antérieur à la cible (ou du 1er terme),
    // puis on avance jusqu'au premier terme qui convient.
    var k = ecartMois ~/ pasMois - 1;
    if (k < 1) k = 1;
    var candidate = ajouterMois(origine, k * pasMois);
    while (candidate.isBefore(cible)) {
      k++;
      candidate = ajouterMois(origine, k * pasMois);
    }
    return candidate;
  }

  /// Prochaine date annuelle (jour/mois fixes) le [aPartirDe] ou après.
  static DateTime prochaineDateAnnuelle({
    required int jour,
    required int mois,
    required DateTime aPartirDe,
  }) {
    final cible = Dates.jour(aPartirDe);
    var candidate = DateTime(cible.year, mois, 1).copyWithJour(jour);
    if (candidate.isBefore(cible)) {
      candidate = DateTime(cible.year + 1, mois, 1).copyWithJour(jour);
    }
    return candidate;
  }
}

extension on DateTime {
  /// Même mois, jour donné, borné au dernier jour du mois.
  DateTime copyWithJour(int jour) {
    final dernier = DateTime(year, month + 1, 0).day;
    return DateTime(year, month, jour > dernier ? dernier : jour);
  }
}
