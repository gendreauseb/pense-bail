import '../../core/config/regles_legales.dart';
import '../entities/bail.dart';
import '../entities/bien.dart';

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

  /// Le nouvel IRL à utiliser est celui du même trimestre, un an plus tard.
  static ({int trimestre, int annee}) trimestreNouvelIrl({
    required int trimestreReference,
    required int anneeReference,
  }) => (trimestre: trimestreReference, annee: anneeReference + 1);

  /// Liste vide : la révision est possible.
  static List<BlocageRevision> blocages(Bien bien, Bail? bail) => [
    if (!bien.typeLocation.revisionDisponible) BlocageRevision.pasLongueDuree,
    if (bail == null) BlocageRevision.pasDeBail,
    if (bail != null && !bail.regle.revisionIrlAutorisee)
      BlocageRevision.bailSansRevision,
    if (ReglesLegales.classesDpeSansRevision.contains(bien.classeDpe))
      BlocageRevision.dpeGel,
  ];

  static int _puissance10(int n) {
    var r = 1;
    for (var i = 0; i < n; i++) {
      r *= 10;
    }
    return r;
  }
}
