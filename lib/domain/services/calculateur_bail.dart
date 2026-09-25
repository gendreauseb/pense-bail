import '../../core/config/regles_legales.dart';
import '../../core/utils/dates.dart';
import '../entities/bail.dart';

/// Calcule les dates clés d'un bail à partir des règles légales centralisées.
///
/// Fonctions pures : la date du jour est toujours passée en paramètre.
abstract final class CalculateurBail {
  /// Dernier jour de la période de bail en cours au [aPartirDe] (en tenant
  /// compte des reconductions tacites). `null` si la durée est inconnue.
  ///
  /// Sans reconduction tacite, retourne le terme unique du bail, même passé.
  static DateTime? finPeriodeEnCours(Bail bail, DateTime aPartirDe) {
    final duree = bail.dureeEffectiveMois;
    if (duree == null) return null;
    final regle = bail.regle;
    final cible = Dates.jour(aPartirDe);

    var fin = _finApres(bail.dateDebut, duree);
    final reconduction = regle.dureeReconductionMois;
    if (!regle.reconductionTacite || reconduction == null) return fin;

    var mois = duree;
    while (fin.isBefore(cible)) {
      mois += reconduction;
      fin = _finApres(bail.dateDebut, mois);
    }
    return fin;
  }

  /// Date limite (réception par le locataire) pour que le bailleur donne
  /// congé à la fin de la période de bail qui n'est pas encore « verrouillée ».
  ///
  /// Si la date limite de la période en cours est dépassée, le bail sera
  /// reconduit : on retourne celle de la période suivante.
  /// `null` si le bailleur ne peut pas donner congé pour ce type de bail.
  static DateTime? prochaineDateLimiteConge(Bail bail, DateTime aPartirDe) {
    final preavis = bail.regle.preavisCongeBailleurMois;
    if (preavis == null) return null;
    final cible = Dates.jour(aPartirDe);

    var fin = finPeriodeEnCours(bail, cible);
    if (fin == null) return null;
    var limite = dateLimiteConge(fin, preavis);

    final reconduction = bail.regle.dureeReconductionMois;
    if (limite.isBefore(cible) &&
        bail.regle.reconductionTacite &&
        reconduction != null) {
      fin = _finApres(Dates.ajouterJours(fin, 1), reconduction);
      limite = dateLimiteConge(fin, preavis);
    }
    return limite;
  }

  /// Voir [ReglesLegales.aVerifierCalculConge] : fin au 31/08 et préavis de
  /// 6 mois → date limite au 28/02.
  static DateTime dateLimiteConge(DateTime finDeBail, int preavisMois) {
    final lendemain = Dates.ajouterJours(finDeBail, 1);
    return Dates.ajouterJours(Dates.ajouterMois(lendemain, -preavisMois), -1);
  }

  /// Prochaine date de révision annuelle du loyer le [aPartirDe] ou après.
  /// `null` si la révision IRL n'est pas prévue pour ce type de bail.
  ///
  /// Date prévue au bail si renseignée (même jour et mois chaque année),
  /// sinon date anniversaire du bail.
  static DateTime? prochaineRevision(Bail bail, DateTime aPartirDe) {
    if (!bail.regle.revisionIrlAutorisee) return null;
    final cible = Dates.jour(aPartirDe);

    final dateRevision = bail.dateRevision;
    if (dateRevision != null) {
      // Jamais avant le début du bail.
      final debutPossible = Dates.ajouterJours(bail.dateDebut, 1);
      return Dates.prochaineDateAnnuelle(
        jour: dateRevision.day,
        mois: dateRevision.month,
        aPartirDe: cible.isAfter(debutPossible) ? cible : debutPossible,
      );
    }
    return Dates.prochaineOccurrence(
      origine: bail.dateDebut,
      pasMois: ReglesLegales.periodiciteRevisionMois,
      aPartirDe: cible,
    );
  }

  /// Dernier jour d'une période de [mois] mois commençant le [debut].
  static DateTime _finApres(DateTime debut, int mois) =>
      Dates.ajouterJours(Dates.ajouterMois(debut, mois), -1);
}
