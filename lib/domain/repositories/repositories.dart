// Contrats d'accès aux données.
//
// L'interface et la logique métier ne dépendent QUE de ces interfaces.
// L'implémentation V1 est locale (SQLite / drift, voir lib/data) ; une
// synchronisation cloud pourra être ajoutée plus tard sans toucher aux écrans.
//
// Convention : `surveiller...` retourne un Stream mis à jour à chaque
// modification ; `enregistrer` crée ou remplace (upsert).

import '../entities/entities.dart';

/// Exécute plusieurs opérations de repositories en une seule transaction :
/// tout est enregistré, ou rien.
abstract interface class Transactions {
  Future<T> executer<T>(Future<T> Function() operations);
}

abstract interface class BailleurRepository {
  Future<Bailleur?> obtenir();
  Stream<Bailleur?> surveiller();
  Future<void> enregistrer(Bailleur bailleur);
}

abstract interface class BienRepository {
  Stream<List<Bien>> surveillerTous();
  Future<List<Bien>> tous();
  Stream<Bien?> surveiller(String id);
  Future<Bien?> parId(String id);
  Future<void> enregistrer(Bien bien);

  /// Supprime le bien et tout ce qui s'y rattache (bail, échéances,
  /// interventions, mouvements, révisions).
  Future<void> supprimer(String id);
}

abstract interface class BailRepository {
  Future<Bail?> bailActif(String bienId);
  Stream<Bail?> surveillerBailActif(String bienId);
  Stream<List<Bail>> surveillerBauxActifs();
  Future<void> enregistrer(Bail bail);

  Stream<List<Locataire>> surveillerLocataires(String bailId);
  Future<List<Locataire>> locataires(String bailId);
  Future<void> enregistrerLocataire(Locataire locataire);
  Future<void> supprimerLocataire(String id);
}

abstract interface class EcheanceRepository {
  /// Échéances non faites, triées par date, tous biens confondus
  /// (ou pour un seul bien si [bienId] est fourni).
  Stream<List<Echeance>> surveillerAFaire({String? bienId});
  Future<List<Echeance>> aFaire();

  /// Toutes les échéances d'un bien (faites comprises).
  Stream<List<Echeance>> surveillerParBien(String bienId);
  Future<Echeance?> parId(String id);
  Future<void> enregistrer(Echeance echeance);
  Future<void> enregistrerTout(List<Echeance> echeances);
  Future<void> supprimer(String id);

  /// Remplace les échéances automatiques NON faites d'un bien (appelé quand
  /// le bail change). Les échéances faites sont conservées en historique.
  Future<void> remplacerAutomatiques(String bienId, List<Echeance> nouvelles);

  Future<List<Rappel>> rappels(String echeanceId);

  /// Tous les rappels, toutes échéances confondues (programmation des
  /// notifications).
  Future<List<Rappel>> tousLesRappels();

  /// Remplace les rappels d'une échéance (jours avant la date).
  Future<List<Rappel>> definirRappels(String echeanceId, List<int> joursAvant);
}

abstract interface class ArtisanRepository {
  Stream<List<Artisan>> surveillerTous();
  Future<Artisan?> parId(String id);
  Future<void> enregistrer(Artisan artisan);
  Future<void> supprimer(String id);

  Stream<List<Intervention>> surveillerInterventions(String bienId);

  /// Enregistre l'intervention et crée / met à jour / supprime la dépense
  /// associée dans le journal financier du bien, selon son coût.
  Future<void> enregistrerIntervention(Intervention intervention);
  Future<void> supprimerIntervention(String id);
}

abstract interface class FinanceRepository {
  Stream<List<MouvementFinancier>> surveillerMouvements(
    String bienId, {
    int? annee,
  });
  Future<List<MouvementFinancier>> mouvements(String bienId, {int? annee});
  Future<void> enregistrerMouvement(MouvementFinancier mouvement);
  Future<void> supprimerMouvement(String id);

  Stream<List<EncaissementLoyer>> surveillerEncaissements(
    String bienId,
    int annee,
  );
  Future<void> definirEncaissement(EncaissementLoyer encaissement);
}

abstract interface class RevisionRepository {
  Stream<List<RevisionLoyer>> surveillerHistorique(String bienId);
  Future<void> enregistrer(RevisionLoyer revision);
}

abstract interface class IndiceIrlRepository {
  Future<List<IndiceIrl>> tous();
  Future<IndiceIrl?> trouver({required int annee, required int trimestre});
  Future<IndiceIrl?> dernier();

  /// Ajoute ou met à jour. Une valeur INSEE remplace une saisie manuelle,
  /// jamais l'inverse.
  Future<void> enregistrerTout(List<IndiceIrl> indices);
}

/// Petits réglages clé / valeur (préférences, brouillon d'onboarding...).
abstract interface class ReglagesRepository {
  Future<String?> lire(String cle);
  Stream<String?> surveiller(String cle);
  Future<void> ecrire(String cle, String valeur);
  Future<void> supprimer(String cle);
}
