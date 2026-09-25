import '../../core/format/formats.dart';
import '../../core/validation/validateurs.dart';
import '../../domain/entities/entities.dart';

enum EtapeOnboarding {
  bienvenue,
  identite,
  nombreBiens,
  bien,
  photoBien,
  recapitulatif,
}

/// Coordonnées du bailleur, telles que saisies.
class BrouillonIdentite {
  const BrouillonIdentite({
    this.prenom = '',
    this.nom = '',
    this.rue = '',
    this.codePostal = '',
    this.ville = '',
    this.telephone = '',
    this.email = '',
  });

  final String prenom;
  final String nom;
  final String rue;
  final String codePostal;
  final String ville;
  final String telephone;
  final String email;

  Bailleur versBailleur({required String id, required DateTime maintenant}) =>
      Bailleur(
        id: id,
        prenom: prenom.trim(),
        nom: nom.trim(),
        rue: rue.trim(),
        codePostal: codePostal.trim(),
        ville: ville.trim(),
        telephone: Validateurs.normaliserTelephone(telephone) ?? '',
        email: email.trim(),
        creeLe: maintenant,
        modifieLe: maintenant,
      );

  Map<String, dynamic> toJson() => {
    'prenom': prenom,
    'nom': nom,
    'rue': rue,
    'codePostal': codePostal,
    'ville': ville,
    'telephone': telephone,
    'email': email,
  };

  factory BrouillonIdentite.fromJson(Map<String, dynamic> json) =>
      BrouillonIdentite(
        prenom: json['prenom'] as String? ?? '',
        nom: json['nom'] as String? ?? '',
        rue: json['rue'] as String? ?? '',
        codePostal: json['codePostal'] as String? ?? '',
        ville: json['ville'] as String? ?? '',
        telephone: json['telephone'] as String? ?? '',
        email: json['email'] as String? ?? '',
      );
}

/// Fiche d'un bien en cours de saisie. Les montants sont gardés tels que
/// tapés (« 650,50 ») pour être réaffichés à l'identique.
///
/// Le type de bail et la date de début sont conservés même si l'utilisateur
/// quitte « Longue durée » (au cas où il y revient), mais ne sont enregistrés
/// que pour une location longue durée.
class BrouillonBien {
  const BrouillonBien({
    required this.id,
    this.nom = '',
    this.typeLogement,
    this.typeLocation,
    this.typeBail,
    this.dateDebutBail,
    this.loyer = '',
    this.charges = '',
    this.rue = '',
    this.codePostal = '',
    this.ville = '',
    this.photoChemin,
  });

  final String id;
  final String nom;
  final TypeLogement? typeLogement;
  final TypeLocation? typeLocation;
  final TypeBail? typeBail;
  final DateTime? dateDebutBail;
  final String loyer;
  final String charges;
  final String rue;
  final String codePostal;
  final String ville;
  final String? photoChemin;

  bool get estLongueDuree => typeLocation == TypeLocation.longueDuree;

  int? get loyerCentimes => Formats.parseMontant(loyer);

  /// Charges non renseignées = 0.
  int? get chargesCentimes =>
      charges.trim().isEmpty ? 0 : Formats.parseMontant(charges);

  bool get estComplet =>
      nom.trim().isNotEmpty &&
      typeLogement != null &&
      typeLocation != null &&
      (!estLongueDuree || (typeBail != null && dateDebutBail != null)) &&
      loyerCentimes != null &&
      chargesCentimes != null &&
      rue.trim().isNotEmpty &&
      Validateurs.estCodePostal(codePostal.trim()) &&
      ville.trim().isNotEmpty;

  Bien versBien({required int ordre, required DateTime maintenant}) {
    assert(estComplet);
    return Bien(
      id: id,
      nom: nom.trim(),
      typeLogement: typeLogement!,
      typeLocation: typeLocation!,
      rue: rue.trim(),
      codePostal: codePostal.trim(),
      ville: ville.trim(),
      loyerHcCentimes: loyerCentimes!,
      chargesCentimes: chargesCentimes!,
      photoChemin: photoChemin,
      ordre: ordre,
      creeLe: maintenant,
      modifieLe: maintenant,
    );
  }

  /// Bail créé uniquement pour une location longue durée.
  Bail? versBail({required String id, required DateTime maintenant}) {
    if (!estLongueDuree || typeBail == null || dateDebutBail == null) {
      return null;
    }
    return Bail(
      id: id,
      bienId: this.id,
      typeBail: typeBail!,
      dateDebut: dateDebutBail!,
      actif: true,
      creeLe: maintenant,
      modifieLe: maintenant,
    );
  }

  BrouillonBien copyWith({
    String? nom,
    TypeLogement? typeLogement,
    TypeLocation? typeLocation,
    TypeBail? typeBail,
    DateTime? dateDebutBail,
    String? loyer,
    String? charges,
    String? rue,
    String? codePostal,
    String? ville,
    Object? photoChemin = inchange,
  }) => BrouillonBien(
    id: id,
    nom: nom ?? this.nom,
    typeLogement: typeLogement ?? this.typeLogement,
    typeLocation: typeLocation ?? this.typeLocation,
    typeBail: typeBail ?? this.typeBail,
    dateDebutBail: dateDebutBail ?? this.dateDebutBail,
    loyer: loyer ?? this.loyer,
    charges: charges ?? this.charges,
    rue: rue ?? this.rue,
    codePostal: codePostal ?? this.codePostal,
    ville: ville ?? this.ville,
    photoChemin: identical(photoChemin, inchange)
        ? this.photoChemin
        : photoChemin as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'typeLogement': typeLogement?.name,
    'typeLocation': typeLocation?.name,
    'typeBail': typeBail?.name,
    'dateDebutBail': dateDebutBail?.toIso8601String(),
    'loyer': loyer,
    'charges': charges,
    'rue': rue,
    'codePostal': codePostal,
    'ville': ville,
    'photoChemin': photoChemin,
  };

  factory BrouillonBien.fromJson(Map<String, dynamic> json) => BrouillonBien(
    id: json['id'] as String,
    nom: json['nom'] as String? ?? '',
    typeLogement: _enum(TypeLogement.values, json['typeLogement']),
    typeLocation: _enum(TypeLocation.values, json['typeLocation']),
    typeBail: _enum(TypeBail.values, json['typeBail']),
    dateDebutBail: json['dateDebutBail'] == null
        ? null
        : DateTime.tryParse(json['dateDebutBail'] as String),
    loyer: json['loyer'] as String? ?? '',
    charges: json['charges'] as String? ?? '',
    rue: json['rue'] as String? ?? '',
    codePostal: json['codePostal'] as String? ?? '',
    ville: json['ville'] as String? ?? '',
    photoChemin: json['photoChemin'] as String?,
  );
}

/// État complet de l'onboarding, sauvegardé à chaque modification pour
/// reprendre là où l'utilisateur s'est arrêté.
class BrouillonOnboarding {
  const BrouillonOnboarding({
    this.etape = EtapeOnboarding.bienvenue,
    this.indexBien = 0,
    this.nombreBiens = 1,
    this.identite = const BrouillonIdentite(),
    this.biens = const [],
    this.depuisRecapitulatif = false,
  });

  static const version = 1;

  final EtapeOnboarding etape;

  /// Bien affiché pour les étapes [EtapeOnboarding.bien] et
  /// [EtapeOnboarding.photoBien].
  final int indexBien;
  final int nombreBiens;
  final BrouillonIdentite identite;

  /// Peut contenir plus de fiches que [nombreBiens] si l'utilisateur a réduit
  /// le nombre : elles sont gardées au cas où il l'augmente à nouveau.
  final List<BrouillonBien> biens;

  /// Modification lancée depuis le récapitulatif : on y revient ensuite.
  final bool depuisRecapitulatif;

  List<BrouillonBien> get biensRetenus => biens.take(nombreBiens).toList();

  BrouillonBien get bienCourant => biens[indexBien];

  BrouillonOnboarding copyWith({
    EtapeOnboarding? etape,
    int? indexBien,
    int? nombreBiens,
    BrouillonIdentite? identite,
    List<BrouillonBien>? biens,
    bool? depuisRecapitulatif,
  }) => BrouillonOnboarding(
    etape: etape ?? this.etape,
    indexBien: indexBien ?? this.indexBien,
    nombreBiens: nombreBiens ?? this.nombreBiens,
    identite: identite ?? this.identite,
    biens: biens ?? this.biens,
    depuisRecapitulatif: depuisRecapitulatif ?? this.depuisRecapitulatif,
  );

  Map<String, dynamic> toJson() => {
    'version': version,
    'etape': etape.name,
    'indexBien': indexBien,
    'nombreBiens': nombreBiens,
    'identite': identite.toJson(),
    'biens': [for (final b in biens) b.toJson()],
    'depuisRecapitulatif': depuisRecapitulatif,
  };

  factory BrouillonOnboarding.fromJson(Map<String, dynamic> json) {
    final biens = [
      for (final b in json['biens'] as List? ?? const [])
        BrouillonBien.fromJson(Map<String, dynamic>.from(b as Map)),
    ];
    final nombre = json['nombreBiens'] as int? ?? 1;
    var etape =
        _enum(EtapeOnboarding.values, json['etape']) ??
        EtapeOnboarding.bienvenue;
    var index = json['indexBien'] as int? ?? 0;
    // Sécurité : un brouillon incohérent reprend au choix du nombre de biens.
    final surUnBien =
        etape == EtapeOnboarding.bien || etape == EtapeOnboarding.photoBien;
    if (surUnBien && (index < 0 || index >= biens.length)) {
      etape = EtapeOnboarding.nombreBiens;
      index = 0;
    }
    return BrouillonOnboarding(
      etape: etape,
      indexBien: index,
      nombreBiens: nombre,
      identite: BrouillonIdentite.fromJson(
        Map<String, dynamic>.from(json['identite'] as Map? ?? const {}),
      ),
      biens: biens,
      depuisRecapitulatif: json['depuisRecapitulatif'] as bool? ?? false,
    );
  }
}

T? _enum<T extends Enum>(List<T> valeurs, Object? nom) {
  for (final v in valeurs) {
    if (v.name == nom) return v;
  }
  return null;
}
