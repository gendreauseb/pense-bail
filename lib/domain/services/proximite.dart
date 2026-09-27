import '../../core/config/config_app.dart';
import '../../core/utils/dates.dart';

/// Statut d'une échéance selon sa proximité (design-system.md §2, règle
/// stricte).
enum Proximite {
  /// Dépassée ou dans 7 jours ou moins.
  urgent,

  /// Dans 8 à 30 jours.
  bientot,

  /// Dans 31 à 90 jours.
  aVenir,

  /// Au-delà de 90 jours.
  lointain;

  static Proximite depuisJours(int joursRestants) {
    if (joursRestants <= ConfigApp.seuilUrgentJours) return urgent;
    if (joursRestants <= ConfigApp.seuilBientotJours) return bientot;
    if (joursRestants <= ConfigApp.seuilAVenirJours) return aVenir;
    return lointain;
  }

  static Proximite depuisDate(DateTime date, {required DateTime aujourdhui}) =>
      depuisJours(Dates.joursEntre(aujourdhui, date));
}

/// Texte de la pastille de statut (design-system.md §6) : jamais la couleur
/// seule.
///
/// « 4 j » (liste dense) ou « Dans 4 j » (fiche), puis « 5 mois » au-delà de
/// 90 jours, puis l'année au-delà de 18 mois.
String textePastille(
  DateTime date, {
  required DateTime aujourdhui,
  bool dense = true,
}) {
  final jours = Dates.joursEntre(aujourdhui, date);
  if (jours < 0) return 'En retard';
  if (jours == 0) return 'Aujourd\'hui';
  if (jours <= ConfigApp.seuilAVenirJours) {
    return dense ? '$jours j' : 'Dans $jours j';
  }
  final limiteMois = Dates.ajouterMois(
    Dates.jour(aujourdhui),
    ConfigApp.pastilleAnneeAuDelaDeMois,
  );
  if (date.isAfter(limiteMois)) return '${date.year}';
  final mois =
      (date.year - aujourdhui.year) * 12 + date.month - aujourdhui.month;
  final moisComplets = date.day < aujourdhui.day ? mois - 1 : mois;
  final affiche = moisComplets < 3 ? 3 : moisComplets;
  return dense ? '$affiche mois' : 'Dans $affiche mois';
}
