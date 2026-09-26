import '../entities/entities.dart';

/// Indicateurs calculés à partir des données déclarées du bien.
///
/// Montants en centimes. Les charges locatives (payées par le locataire)
/// sont exclues : seules les charges du propriétaire sont déduites.
class IndicateursRentabilite {
  const IndicateursRentabilite({
    required this.loyersAnnuels,
    required this.chargesAnnuelles,
    required this.creditAnnuel,
    required this.coutAcquisition,
    required this.cashFlowMensuel,
    required this.rendementBrut,
    required this.rendementNet,
  });

  final int loyersAnnuels;

  /// Taxe foncière + assurance + charges non récupérables + frais divers.
  final int chargesAnnuelles;
  final int creditAnnuel;

  /// Prix d'achat + frais de notaire + travaux initiaux. `null` si inconnu.
  final int? coutAcquisition;
  final int cashFlowMensuel;
  int get cashFlowAnnuel => cashFlowMensuel * 12;

  /// Ratios (0,05 = 5 %). `null` sans coût d'acquisition.
  final double? rendementBrut;
  final double? rendementNet;
}

/// Bilan d'une année : loyers cochés « reçus » et journal.
class BilanAnnuel {
  const BilanAnnuel({
    required this.annee,
    required this.moisRecus,
    required this.loyersPercus,
    required this.autresRecettes,
    required this.depenses,
  });

  final int annee;
  final int moisRecus;
  final int loyersPercus;
  final int autresRecettes;
  final int depenses;

  int get resultat => loyersPercus + autresRecettes - depenses;
}

abstract final class Rentabilite {
  static IndicateursRentabilite indicateurs(Bien b) {
    final loyersAnnuels = b.loyerHcCentimes * 12;
    final charges =
        (b.taxeFonciereCentimes ?? 0) +
        (b.assuranceCentimes ?? 0) +
        (b.chargesNonRecuperablesCentimes ?? 0) +
        (b.fraisDiversCentimes ?? 0);
    final credit = (b.mensualiteCreditCentimes ?? 0) * 12;
    final prix = b.prixAchatCentimes;
    final cout = prix == null || prix <= 0
        ? null
        : prix +
              (b.fraisNotaireCentimes ?? 0) +
              (b.travauxInitiauxCentimes ?? 0);

    return IndicateursRentabilite(
      loyersAnnuels: loyersAnnuels,
      chargesAnnuelles: charges,
      creditAnnuel: credit,
      coutAcquisition: cout,
      cashFlowMensuel: ((loyersAnnuels - charges - credit) / 12).round(),
      rendementBrut: cout == null ? null : loyersAnnuels / cout,
      rendementNet: cout == null ? null : (loyersAnnuels - charges) / cout,
    );
  }

  /// Bilan de l'[annee] : pour chaque mois coché « reçu », le loyer hors
  /// charges en vigueur ce mois-là (voir [loyerDuMois]).
  static BilanAnnuel bilan({
    required Bien bien,
    required int annee,
    required List<EncaissementLoyer> encaissements,
    required List<MouvementFinancier> mouvements,
    List<RevisionLoyer> revisions = const [],
  }) {
    final moisRecus = [
      for (final e in encaissements)
        if (e.annee == annee && e.recu) e.mois,
    ];
    var recettes = 0;
    var depenses = 0;
    for (final m in mouvements.where((m) => m.date.year == annee)) {
      if (m.sens == SensMouvement.recette) {
        recettes += m.montantCentimes;
      } else {
        depenses += m.montantCentimes;
      }
    }
    return BilanAnnuel(
      annee: annee,
      moisRecus: moisRecus.length,
      loyersPercus: moisRecus.fold(
        0,
        (total, mois) =>
            total +
            loyerDuMois(
              bien: bien,
              revisions: revisions,
              annee: annee,
              mois: mois,
            ),
      ),
      autresRecettes: recettes,
      depenses: depenses,
    );
  }

  /// Loyer hors charges en vigueur le 1er du mois : celui fixé par la
  /// dernière révision entrée en vigueur à cette date, sinon l'ancien loyer
  /// de la première révision suivante, sinon le loyer actuel du bien.
  /// Estimation : une révision en cours de mois compte à partir du mois
  /// suivant.
  static int loyerDuMois({
    required Bien bien,
    required List<RevisionLoyer> revisions,
    required int annee,
    required int mois,
  }) {
    final premier = DateTime(annee, mois);
    final triees = [...revisions]
      ..sort((a, b) => a.dateEffet.compareTo(b.dateEffet));
    final avant = triees.where((r) => !r.dateEffet.isAfter(premier));
    if (avant.isNotEmpty) return avant.last.nouveauLoyerCentimes;
    final apres = triees.where((r) => r.dateEffet.isAfter(premier));
    if (apres.isNotEmpty) return apres.first.ancienLoyerCentimes;
    return bien.loyerHcCentimes;
  }

  /// Total des mouvements de l'[annee] par catégorie, dans l'ordre des
  /// catégories.
  static Map<CategorieMouvement, int> totauxParCategorie({
    required int annee,
    required List<MouvementFinancier> mouvements,
  }) {
    final totaux = <CategorieMouvement, int>{};
    for (final categorie in CategorieMouvement.values) {
      final total = mouvements
          .where((m) => m.date.year == annee && m.categorie == categorie)
          .fold(0, (t, m) => t + m.montantCentimes);
      if (total != 0) totaux[categorie] = total;
    }
    return totaux;
  }

  /// Mois (1 à 12) de l'[annee] dont le loyer aurait dû être reçu mais n'est
  /// pas coché : mois entièrement écoulés, après le début du bail.
  static List<int> moisEnRetard({
    required int annee,
    required List<EncaissementLoyer> encaissements,
    required DateTime aujourdhui,
    DateTime? debutBail,
  }) {
    final recus = {
      for (final e in encaissements)
        if (e.annee == annee && e.recu) e.mois,
    };
    return [
      for (var mois = 1; mois <= 12; mois++)
        if (_ecoule(annee, mois, aujourdhui) &&
            !_avantBail(annee, mois, debutBail) &&
            !recus.contains(mois))
          mois,
    ];
  }

  static bool _ecoule(int annee, int mois, DateTime aujourdhui) =>
      annee < aujourdhui.year ||
      (annee == aujourdhui.year && mois < aujourdhui.month);

  static bool _avantBail(int annee, int mois, DateTime? debut) =>
      debut != null &&
      (annee < debut.year || (annee == debut.year && mois < debut.month));
}
