import '../entities/entities.dart';

/// Chiffres de la carte de synthèse.
class Synthese {
  const Synthese({
    required this.nombreBiens,
    required this.loyersCentimes,
    required this.chargesCentimes,
  });

  final int nombreBiens;
  final int loyersCentimes;
  final int chargesCentimes;
}

enum TypeInvitation {
  /// Longue durée : trimestre et valeur de l'IRL de référence manquants.
  irlManquant,

  /// Informations de bail manquantes : aucun rappel lié au bail.
  bailManquant,
}

/// Invitation discrète à compléter un bien.
class Invitation {
  const Invitation({required this.bien, required this.type});
  final Bien bien;
  final TypeInvitation type;
}

/// Logique du tableau de bord (fonctions pures).
abstract final class TableauDeBord {
  static Synthese synthese(List<Bien> biens) => Synthese(
    nombreBiens: biens.length,
    loyersCentimes: biens.fold(0, (s, b) => s + b.loyerHcCentimes),
    chargesCentimes: biens.fold(0, (s, b) => s + b.chargesCentimes),
  );

  static List<Invitation> invitations(List<Bien> biens, List<Bail> baux) {
    final bailParBien = {for (final b in baux) b.bienId: b};
    return [
      for (final bien in biens)
        if (_invitation(bien, bailParBien[bien.id]) case final type?)
          Invitation(bien: bien, type: type),
    ];
  }

  static TypeInvitation? _invitation(Bien bien, Bail? bail) {
    if (bail == null) return TypeInvitation.bailManquant;
    final revision =
        bien.typeLocation.revisionDisponible && bail.regle.revisionIrlAutorisee;
    if (revision && !bail.irlReferenceComplet) {
      return TypeInvitation.irlManquant;
    }
    return null;
  }

  /// Première échéance à faire de chaque bien (liste triée par date).
  static Map<String, Echeance> prochaineParBien(List<Echeance> aFaire) {
    final resultat = <String, Echeance>{};
    for (final e in aFaire) {
      final bienId = e.bienId;
      if (bienId != null) resultat.putIfAbsent(bienId, () => e);
    }
    return resultat;
  }

  /// Filtre par bien. `null` : tous les biens, échéances communes comprises.
  static List<Echeance> filtrer(List<Echeance> aFaire, String? bienId) =>
      bienId == null ? aFaire : [...aFaire.where((e) => e.bienId == bienId)];
}
