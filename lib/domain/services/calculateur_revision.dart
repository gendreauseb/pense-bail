import '../../core/config/regles_legales.dart';
import '../../core/utils/dates.dart';
import '../entities/bail.dart';
import '../entities/bien.dart';
import '../entities/revision.dart';
import 'calculateur_bail.dart';

/// Raisons pour lesquelles la révision de loyer n'est pas possible.
enum BlocageRevision {
  pasLongueDuree(
    'Révision disponible uniquement pour les locations longue durée.',
  ),
  pasDeBail('Renseignez d\'abord les informations du bail.'),
  bailSansRevision('Ce type de bail ne prévoit pas de révision selon l\'IRL.'),
  dpeGel(
    'Ce logement est classé F ou G : la loi interdit d\'augmenter son '
    'loyer, la révision n\'est pas autorisée.',
  );

  const BlocageRevision(this.message);
  final String message;
}

/// Révision de l'année à traiter.
class CycleRevision {
  const CycleRevision({required this.datePrevue, required this.aujourdhui});

  /// Date de révision prévue au bail (ou date anniversaire).
  final DateTime datePrevue;
  final DateTime aujourdhui;

  /// La date prévue est passée : la révision est demandée en retard.
  bool get enRetard => aujourdhui.isAfter(datePrevue);

  /// La révision n'est pas rétroactive : demandée en retard, elle s'applique
  /// à partir de la date de la demande (le courrier daté d'aujourd'hui).
  DateTime get dateEffet => enRetard ? aujourdhui : datePrevue;

  /// Dernier jour pour demander la révision de cette année ; au-delà, elle
  /// est perdue.
  DateTime get dateLimiteDemande => Dates.ajouterJours(
    Dates.ajouterMois(datePrevue, ReglesLegales.delaiDemandeRevisionMois),
    -1,
  );
}

/// Indices IRL comparés : même trimestre, deux années consécutives.
class IndicesRevision {
  const IndicesRevision({
    required this.trimestre,
    required this.annee,
    required this.ancien,
    required this.nouveau,
  });

  final int trimestre;

  /// Année du nouvel indice. L'ancien est celui de l'année précédente.
  final int annee;
  final IndiceIrl? ancien;
  final IndiceIrl? nouveau;

  int get anneeAncien => annee - ReglesLegales.ecartAnneesIndices;
  bool get complets => ancien != null && nouveau != null;
}

/// Résultat du calcul, avant confirmation.
class ResultatRevision {
  const ResultatRevision({
    required this.cycle,
    required this.ancien,
    required this.nouveau,
    required this.ancienLoyerCentimes,
    required this.nouveauLoyerCentimes,
    required this.chargesCentimes,
  });

  final CycleRevision cycle;
  final IndiceIrl ancien;
  final IndiceIrl nouveau;
  final int ancienLoyerCentimes;
  final int nouveauLoyerCentimes;

  /// Charges mensuelles, inchangées par la révision.
  final int chargesCentimes;

  int get augmentationMensuelleCentimes =>
      nouveauLoyerCentimes - ancienLoyerCentimes;
  int get augmentationAnnuelleCentimes => augmentationMensuelleCentimes * 12;
  int get nouveauTotalCentimes => nouveauLoyerCentimes + chargesCentimes;

  /// L'indice a baissé : réviser ferait baisser le loyer.
  bool get baisse => nouveauLoyerCentimes < ancienLoyerCentimes;
}

abstract final class CalculateurRevision {
  /// Nouveau loyer hors charges = loyer actuel × (nouvel IRL / ancien IRL),
  /// arrondi au centime le plus proche (0,5 centime → au-dessus).
  ///
  /// Calcul exact en entiers : les IRL ont 2 décimales, on les convertit en
  /// centièmes pour éviter toute erreur d'arrondi des nombres à virgule.
  static int nouveauLoyer({
    required int loyerActuelCentimes,
    required double ancienIrl,
    required double nouvelIrl,
  }) {
    if (ancienIrl <= 0 || nouvelIrl <= 0) {
      throw ArgumentError('Les indices IRL doivent être positifs.');
    }
    final facteur = _puissance10(ReglesLegales.decimalesIrl);
    final ancien = (ancienIrl * facteur).round();
    final nouveau = (nouvelIrl * facteur).round();
    return (2 * loyerActuelCentimes * nouveau + ancien) ~/ (2 * ancien);
  }

  /// Liste vide : la révision est possible.
  static List<BlocageRevision> blocages(Bien bien, Bail? bail) => [
    if (!bien.typeLocation.revisionDisponible) BlocageRevision.pasLongueDuree,
    if (bail == null) BlocageRevision.pasDeBail,
    if (bail != null && !bail.regle.revisionIrlAutorisee)
      BlocageRevision.bailSansRevision,
    if (ReglesLegales.classesDpeSansRevision.contains(bien.classeDpe))
      BlocageRevision.dpeGel,
  ];

  /// Révision à traiter aujourd'hui : la plus ancienne date prévue qui n'a
  /// pas encore été révisée et qui peut encore l'être (moins d'un an),
  /// sinon la prochaine.
  ///
  /// Une date prévue est considérée comme traitée si une révision a pris
  /// effet ce jour-là ou après ([derniereDateEffet], dernière révision du
  /// bail ; l'utilisateur peut aussi indiquer une révision faite hors de
  /// l'application), ou si l'IRL de référence du bail est déjà celui
  /// qu'elle aurait utilisé.
  static CycleRevision? cycle(
    Bail bail, {
    required DateTime aujourdhui,
    DateTime? derniereDateEffet,
  }) {
    final jour = Dates.jour(aujourdhui);
    final encorePossibleDepuis = Dates.ajouterJours(
      Dates.ajouterMois(jour, -ReglesLegales.delaiDemandeRevisionMois),
      1,
    );
    bool traitee(DateTime date) {
      // Une révision enregistrée a pris effet à cette date ou après.
      if (derniereDateEffet != null &&
          !Dates.jour(derniereDateEffet).isBefore(date)) {
        return true;
      }
      // L'IRL de référence du bail est déjà celui de cette révision (ou plus
      // récent) : elle a été faite, éventuellement hors de l'application.
      final trimestre = bail.irlTrimestre;
      final annee = bail.irlAnnee;
      return trimestre != null &&
          annee != null &&
          annee >= anneeDernierIndice(trimestre: trimestre, date: date);
    }

    var date = CalculateurBail.prochaineRevision(bail, encorePossibleDepuis);
    while (date != null && traitee(date)) {
      date = CalculateurBail.prochaineRevision(
        bail,
        Dates.ajouterJours(date, 1),
      );
    }
    return date == null
        ? null
        : CycleRevision(datePrevue: date, aujourdhui: jour);
  }

  /// Date à partir de laquelle l'app considère l'IRL d'un trimestre comme
  /// publié (estimation, voir [ReglesLegales.jourPublicationIrl]).
  static DateTime publicationEstimee({
    required int trimestre,
    required int annee,
  }) => DateTime(annee, trimestre * 3 + 1, ReglesLegales.jourPublicationIrl);

  /// Année du dernier IRL du [trimestre] publié à la [date].
  static int anneeDernierIndice({
    required int trimestre,
    required DateTime date,
  }) {
    var annee = date.year;
    while (publicationEstimee(
      trimestre: trimestre,
      annee: annee,
    ).isAfter(date)) {
      annee--;
    }
    return annee;
  }

  /// Dernier trimestre publié à la [date] : trimestre de référence par
  /// défaut quand le bail n'en précise pas (date de signature).
  static ({int trimestre, int annee}) dernierTrimestrePublie(DateTime date) {
    var annee = date.year;
    var trimestre = 4;
    while (publicationEstimee(
      trimestre: trimestre,
      annee: annee,
    ).isAfter(date)) {
      trimestre--;
      if (trimestre == 0) {
        trimestre = 4;
        annee--;
      }
    }
    return (trimestre: trimestre, annee: annee);
  }

  /// Indices à comparer pour le [trimestre] : IRL de l'[annee] et de l'année
  /// précédente, cherchés dans la [table]. Jamais d'indice plus ancien : les
  /// années non réclamées sont perdues.
  static IndicesRevision indices({
    required int trimestre,
    required int annee,
    required List<IndiceIrl> table,
  }) {
    IndiceIrl? trouver(int a) => table
        .where((i) => i.trimestre == trimestre && i.annee == a)
        .firstOrNull;
    return IndicesRevision(
      trimestre: trimestre,
      annee: annee,
      ancien: trouver(annee - ReglesLegales.ecartAnneesIndices),
      nouveau: trouver(annee),
    );
  }

  static ResultatRevision calculer({
    required CycleRevision cycle,
    required IndiceIrl ancien,
    required IndiceIrl nouveau,
    required int loyerActuelCentimes,
    required int chargesCentimes,
  }) => ResultatRevision(
    cycle: cycle,
    ancien: ancien,
    nouveau: nouveau,
    ancienLoyerCentimes: loyerActuelCentimes,
    nouveauLoyerCentimes: nouveauLoyer(
      loyerActuelCentimes: loyerActuelCentimes,
      ancienIrl: ancien.valeur,
      nouvelIrl: nouveau.valeur,
    ),
    chargesCentimes: chargesCentimes,
  );

  static int _puissance10(int n) {
    var r = 1;
    for (var i = 0; i < n; i++) {
      r *= 10;
    }
    return r;
  }
}
