import '../enums.dart';
import 'copie.dart';

/// Une date importante à ne pas rater.
class Echeance {
  const Echeance({
    required this.id,
    this.bienId,
    required this.type,
    required this.titre,
    required this.date,
    this.dateInitiale,
    required this.statut,
    this.faiteLe,
    this.notes,
    this.intervalleMois,
    this.typeDiagnostic,
    required this.automatique,
    required this.creeLe,
    required this.modifieLe,
  });

  final String id;

  /// Bien concerné. `null` : échéance globale (ex. déclaration de revenus,
  /// commune à tous les biens).
  final String? bienId;
  final TypeEcheance type;
  final String titre;
  final DateTime date;

  /// Date d'origine si l'échéance a été reportée.
  final DateTime? dateInitiale;
  final StatutEcheance statut;
  final DateTime? faiteLe;
  final String? notes;

  /// Récurrence en mois (12 = annuelle). `null` : pas de récurrence.
  /// Quand l'échéance est marquée faite, l'occurrence suivante est créée.
  final int? intervalleMois;

  /// Pour les échéances de type [TypeEcheance.diagnostic].
  final TypeDiagnostic? typeDiagnostic;

  /// `true` : calculée à partir du bail, recalculée quand le bail change.
  final bool automatique;
  final DateTime creeLe;
  final DateTime modifieLe;

  bool get estFaite => statut == StatutEcheance.faite;
  bool get estReportee => dateInitiale != null;

  Echeance copyWith({
    TypeEcheance? type,
    String? titre,
    DateTime? date,
    Object? dateInitiale = inchange,
    StatutEcheance? statut,
    Object? faiteLe = inchange,
    Object? notes = inchange,
    Object? intervalleMois = inchange,
    Object? typeDiagnostic = inchange,
    bool? automatique,
    DateTime? modifieLe,
  }) => Echeance(
    id: id,
    bienId: bienId,
    type: type ?? this.type,
    titre: titre ?? this.titre,
    date: date ?? this.date,
    dateInitiale: choisir(dateInitiale, this.dateInitiale),
    statut: statut ?? this.statut,
    faiteLe: choisir(faiteLe, this.faiteLe),
    notes: choisir(notes, this.notes),
    intervalleMois: choisir(intervalleMois, this.intervalleMois),
    typeDiagnostic: choisir(typeDiagnostic, this.typeDiagnostic),
    automatique: automatique ?? this.automatique,
    creeLe: creeLe,
    modifieLe: modifieLe ?? DateTime.now(),
  );
}

/// Notification programmée X jours avant une échéance.
class Rappel {
  const Rappel({
    required this.id,
    required this.echeanceId,
    required this.joursAvant,
  });

  /// Sert aussi d'identifiant de notification locale.
  final int id;
  final String echeanceId;
  final int joursAvant;
}
