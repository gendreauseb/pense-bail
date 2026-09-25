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
  static String modifierEcheance(String id) => '/echeances/$id';
  static String revision(String bienId) => '/revision/$bienId';
  static String ficheBien(String bienId) => '/biens/fiche/$bienId';
}
