import '../enums.dart';
import 'copie.dart';

/// Ligne du journal des dépenses et recettes d'un bien.
class MouvementFinancier {
  const MouvementFinancier({
    required this.id,
    required this.bienId,
    required this.date,
    required this.montantCentimes,
    required this.categorie,
    this.note,
    this.interventionId,
    required this.creeLe,
    required this.modifieLe,
  });

  final String id;
  final String bienId;
  final DateTime date;

  /// Toujours positif : le sens est donné par la catégorie.
  final int montantCentimes;
  final CategorieMouvement categorie;
  final String? note;

  /// Renseigné si la dépense a été créée depuis une intervention d'artisan.
  final String? interventionId;
  final DateTime creeLe;
  final DateTime modifieLe;

  SensMouvement get sens => categorie.sens;

  /// Montant signé : positif pour une recette, négatif pour une dépense.
  int get montantSigneCentimes =>
      sens == SensMouvement.recette ? montantCentimes : -montantCentimes;

  MouvementFinancier copyWith({
    DateTime? date,
    int? montantCentimes,
    CategorieMouvement? categorie,
    Object? note = inchange,
    DateTime? modifieLe,
  }) => MouvementFinancier(
    id: id,
    bienId: bienId,
    date: date ?? this.date,
    montantCentimes: montantCentimes ?? this.montantCentimes,
    categorie: categorie ?? this.categorie,
    note: choisir(note, this.note),
    interventionId: interventionId,
    creeLe: creeLe,
    modifieLe: modifieLe ?? DateTime.now(),
  );
}

/// Case « Loyer reçu » d'un mois donné.
class EncaissementLoyer {
  const EncaissementLoyer({
    required this.bienId,
    required this.annee,
    required this.mois,
    required this.recu,
    this.recuLe,
  });

  final String bienId;
  final int annee;

  /// 1 à 12.
  final int mois;
  final bool recu;
  final DateTime? recuLe;
}
