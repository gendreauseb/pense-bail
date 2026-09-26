/// Chemins de navigation de l'application.
abstract final class Routes {
  static const onboarding = '/bienvenue';

  // Onglets (barre de navigation)
  static const accueil = '/accueil';
  static const biens = '/biens';
  static const artisans = '/artisans';
  static const reglages = '/reglages';

  // Écrans plein écran (au-dessus de la barre)
  static const nouvelleEcheance = '/echeances/nouvelle';
  static const nouveauBien = '/biens/nouveau';
  static const artisan = '/artisans/fiche';

  static String modifierEcheance(String id) => '/echeances/$id';
  static String revision(String bienId) => '/revision/$bienId';
  static String courrierRevision(String revisionId) =>
      '/courriers/revision/$revisionId';
  static String ficheBien(String bienId) => '/biens/fiche/$bienId';
  static String modifierBien(String bienId) => '${ficheBien(bienId)}/modifier';
  static String bail(String bienId) => '${ficheBien(bienId)}/bail';
  static String locataire(String bienId) => '${ficheBien(bienId)}/locataire';
  static String investissement(String bienId) =>
      '${ficheBien(bienId)}/investissement';
  static String mouvement(String bienId) => '${ficheBien(bienId)}/mouvement';
  static String intervention(String bienId) =>
      '${ficheBien(bienId)}/intervention';
  static String recapitulatif(String bienId, int annee) =>
      '${ficheBien(bienId)}/recapitulatif/$annee';

  /// Ajoute des paramètres facultatifs (ex. identifiant à modifier).
  static String avec(String chemin, Map<String, String?> parametres) {
    final retenus = {
      for (final e in parametres.entries)
        if (e.value != null) e.key: e.value!,
    };
    return retenus.isEmpty
        ? chemin
        : Uri(path: chemin, queryParameters: retenus).toString();
  }
}
