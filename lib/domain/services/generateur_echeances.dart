import '../../core/config/regles_legales.dart';
import '../../core/utils/dates.dart';
import '../entities/bail.dart';
import '../entities/bien.dart';
import '../entities/echeance.dart';
import '../enums.dart';
import 'calculateur_bail.dart';

/// Échéance calculée, pas encore enregistrée (sans identifiant).
class EcheancePrevue {
  const EcheancePrevue({
    required this.bienId,
    required this.type,
    required this.date,
    this.intervalleMois,
    required this.automatique,
  });

  final String? bienId;
  final TypeEcheance type;
  final DateTime date;
  final int? intervalleMois;
  final bool automatique;

  Echeance versEcheance({required String id, required DateTime maintenant}) =>
      Echeance(
        id: id,
        bienId: bienId,
        type: type,
        titre: type.libelle,
        date: date,
        statut: StatutEcheance.aFaire,
        intervalleMois: intervalleMois,
        automatique: automatique,
        creeLe: maintenant,
        modifieLe: maintenant,
      );
}

/// Produit les échéances d'un bien à partir de ses données.
abstract final class GenerateurEcheances {
  /// Échéances calculées depuis le bail (révision, fin de bail, congé,
  /// régularisation des charges). Elles sont marquées `automatique` et
  /// recalculées à chaque modification du bail.
  static List<EcheancePrevue> depuisBail({
    required Bien bien,
    required Bail bail,
    required DateTime aujourdhui,
  }) {
    final regle = bail.regle;
    final resultat = <EcheancePrevue>[];

    if (bien.typeLocation.revisionDisponible) {
      final revision = CalculateurBail.prochaineRevision(bail, aujourdhui);
      if (revision != null) {
        resultat.add(
          EcheancePrevue(
            bienId: bien.id,
            type: TypeEcheance.revisionLoyer,
            date: revision,
            intervalleMois: ReglesLegales.periodiciteRevisionMois,
            automatique: true,
          ),
        );
      }
    }

    final fin = CalculateurBail.finPeriodeEnCours(bail, aujourdhui);
    if (fin != null && !fin.isBefore(Dates.jour(aujourdhui))) {
      resultat.add(
        EcheancePrevue(
          bienId: bien.id,
          type: TypeEcheance.finBail,
          date: fin,
          intervalleMois: regle.reconductionTacite
              ? regle.dureeReconductionMois
              : null,
          automatique: true,
        ),
      );
    }

    final conge = CalculateurBail.prochaineDateLimiteConge(bail, aujourdhui);
    if (conge != null && !conge.isBefore(Dates.jour(aujourdhui))) {
      resultat.add(
        EcheancePrevue(
          bienId: bien.id,
          type: TypeEcheance.dateLimiteConge,
          date: conge,
          intervalleMois: regle.reconductionTacite
              ? regle.dureeReconductionMois
              : null,
          automatique: true,
        ),
      );
    }

    final duree = bail.dureeEffectiveMois;
    final pas = ReglesLegales.periodiciteRegularisationChargesMois;
    if (duree != null && duree >= pas) {
      resultat.add(
        EcheancePrevue(
          bienId: bien.id,
          type: TypeEcheance.regularisationCharges,
          date: Dates.prochaineOccurrence(
            origine: bail.dateDebut,
            pasMois: pas,
            aPartirDe: aujourdhui,
          ),
          intervalleMois: pas,
          automatique: true,
        ),
      );
    }

    return resultat;
  }

  /// Échéances d'un bien qui ne dépendent pas du bail (date suggérée,
  /// modifiable par l'utilisateur).
  static List<EcheancePrevue> generiquesBien({
    required Bien bien,
    required DateTime aujourdhui,
  }) {
    const taxe = ReglesLegales.taxeFonciere;
    return [
      EcheancePrevue(
        bienId: bien.id,
        type: TypeEcheance.taxeFonciere,
        date: Dates.prochaineDateAnnuelle(
          jour: taxe.jour,
          mois: taxe.mois,
          aPartirDe: aujourdhui,
        ),
        intervalleMois: 12,
        automatique: false,
      ),
    ];
  }

  /// Échéances communes à tous les biens (une seule déclaration de revenus
  /// par foyer fiscal).
  static List<EcheancePrevue> globales({required DateTime aujourdhui}) {
    const declaration = ReglesLegales.declarationRevenus;
    return [
      EcheancePrevue(
        bienId: null,
        type: TypeEcheance.declarationRevenus,
        date: Dates.prochaineDateAnnuelle(
          jour: declaration.jour,
          mois: declaration.mois,
          aPartirDe: aujourdhui,
        ),
        intervalleMois: 12,
        automatique: false,
      ),
    ];
  }
}
