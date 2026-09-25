import '../enums.dart';

/// Valeur de l'Indice de Référence des Loyers pour un trimestre.
///
/// Les valeurs proviennent exclusivement de l'INSEE (fichier embarqué ou
/// mis à jour à distance) ou d'une saisie manuelle de l'utilisateur.
/// Aucune valeur ne doit être inventée ou extrapolée.
class IndiceIrl {
  const IndiceIrl({
    required this.annee,
    required this.trimestre,
    required this.valeur,
    this.datePublication,
    required this.source,
  });

  final int annee;

  /// 1 à 4.
  final int trimestre;
  final double valeur;
  final DateTime? datePublication;
  final SourceIndice source;

  /// « T2 2026 »
  String get libelle => 'T$trimestre $annee';
}

/// Révision de loyer confirmée (historique).
class RevisionLoyer {
  const RevisionLoyer({
    required this.id,
    required this.bienId,
    required this.bailId,
    required this.dateEffet,
    required this.ancienLoyerCentimes,
    required this.nouveauLoyerCentimes,
    required this.ancienIrlTrimestre,
    required this.ancienIrlAnnee,
    required this.ancienIrlValeur,
    required this.nouvelIrlTrimestre,
    required this.nouvelIrlAnnee,
    required this.nouvelIrlValeur,
    this.courrierChemin,
    required this.creeLe,
  });

  final String id;
  final String bienId;
  final String bailId;

  /// Date à partir de laquelle le nouveau loyer s'applique.
  final DateTime dateEffet;
  final int ancienLoyerCentimes;
  final int nouveauLoyerCentimes;
  final int ancienIrlTrimestre;
  final int ancienIrlAnnee;
  final double ancienIrlValeur;
  final int nouvelIrlTrimestre;
  final int nouvelIrlAnnee;
  final double nouvelIrlValeur;

  /// PDF du courrier généré, s'il a été enregistré.
  final String? courrierChemin;
  final DateTime creeLe;

  int get augmentationMensuelleCentimes =>
      nouveauLoyerCentimes - ancienLoyerCentimes;
}
