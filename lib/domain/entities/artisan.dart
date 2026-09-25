import '../enums.dart';
import 'copie.dart';

/// Artisan du carnet global (réutilisable sur plusieurs biens).
class Artisan {
  const Artisan({
    required this.id,
    required this.nom,
    this.entreprise,
    required this.metier,
    this.telephone,
    this.email,
    this.notes,
    required this.creeLe,
    required this.modifieLe,
  });

  final String id;
  final String nom;
  final String? entreprise;
  final MetierArtisan metier;
  final String? telephone;
  final String? email;
  final String? notes;
  final DateTime creeLe;
  final DateTime modifieLe;

  Artisan copyWith({
    String? nom,
    Object? entreprise = inchange,
    MetierArtisan? metier,
    Object? telephone = inchange,
    Object? email = inchange,
    Object? notes = inchange,
    DateTime? modifieLe,
  }) => Artisan(
    id: id,
    nom: nom ?? this.nom,
    entreprise: choisir(entreprise, this.entreprise),
    metier: metier ?? this.metier,
    telephone: choisir(telephone, this.telephone),
    email: choisir(email, this.email),
    notes: choisir(notes, this.notes),
    creeLe: creeLe,
    modifieLe: modifieLe ?? DateTime.now(),
  );
}

/// Intervention d'un artisan sur un bien. Son coût crée automatiquement une
/// dépense dans la rentabilité du bien.
class Intervention {
  const Intervention({
    required this.id,
    required this.bienId,
    this.artisanId,
    required this.date,
    required this.description,
    this.coutCentimes,
    required this.creeLe,
    required this.modifieLe,
  });

  final String id;
  final String bienId;

  /// `null` si l'artisan a été supprimé du carnet.
  final String? artisanId;
  final DateTime date;
  final String description;
  final int? coutCentimes;
  final DateTime creeLe;
  final DateTime modifieLe;

  Intervention copyWith({
    Object? artisanId = inchange,
    DateTime? date,
    String? description,
    Object? coutCentimes = inchange,
    DateTime? modifieLe,
  }) => Intervention(
    id: id,
    bienId: bienId,
    artisanId: choisir(artisanId, this.artisanId),
    date: date ?? this.date,
    description: description ?? this.description,
    coutCentimes: choisir(coutCentimes, this.coutCentimes),
    creeLe: creeLe,
    modifieLe: modifieLe ?? DateTime.now(),
  );
}
