import '../../core/config/regles_legales.dart';
import '../../core/utils/dates.dart';
import '../enums.dart';

/// Date de renouvellement d'un diagnostic, d'après sa validité légale
/// (voir [ReglesLegales.diagnostics]).
abstract final class CalculateurDiagnostic {
  /// Date à laquelle le diagnostic réalisé le [realise] n'est plus valable
  /// pour une location. `null` : pas d'expiration dans le cas général.
  static DateTime? expiration(TypeDiagnostic type, DateTime realise) {
    final validite = ReglesLegales.diagnostic(type).validiteMois;
    return validite == null ? null : Dates.ajouterMois(realise, validite);
  }
}
