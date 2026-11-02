import '../../core/config/regles_legales.dart';
import '../entities/entities.dart';

/// Échéances d'un bien vendu ou retiré de la location (voir
/// [ReglesLegales.arreteesALaVente] et [ReglesLegales.arreteesAuRetrait]).
abstract final class SortieBien {
  /// L'échéance [echeance] du bien [bien] doit-elle être arrêtée, vu l'état
  /// du bien ? Toujours `false` pour un bien en location.
  static bool doitEtreArretee(Echeance echeance, Bien bien) {
    final venduLe = bien.venduLe;
    if (venduLe != null) {
      return switch (echeance.type) {
        TypeEcheance.taxeFonciere => echeance.date.year > venduLe.year,
        TypeEcheance.regularisationCharges => bien.venduLoue == true,
        final type => ReglesLegales.arreteesALaVente.contains(type),
      };
    }
    if (bien.retireLe != null) {
      return ReglesLegales.arreteesAuRetrait.contains(echeance.type);
    }
    return false;
  }

  /// Statut que doit avoir une échéance non faite, vu l'état du bien.
  static StatutEcheance statut(Echeance echeance, Bien bien) =>
      doitEtreArretee(echeance, bien)
      ? StatutEcheance.arretee
      : StatutEcheance.aFaire;

  /// Échéances à faire de [echeances] qui seraient arrêtées pour [bien]
  /// (liste montrée avant de confirmer la vente ou le retrait).
  static List<Echeance> aArreter(Bien bien, List<Echeance> echeances) => [
    for (final e in echeances)
      if (e.estAFaire && doitEtreArretee(e, bien)) e,
  ];
}
