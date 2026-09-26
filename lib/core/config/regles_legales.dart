// ============================================================================
//  RÈGLES LÉGALES — SOURCE UNIQUE
// ============================================================================
//
// Toutes les durées, préavis et validités utilisés par l'application sont
// définis ICI et nulle part ailleurs. Aucune autre partie du code ne doit
// contenir de valeur légale « en dur ».
//
// ⚠ AVANT CHAQUE PUBLICATION : vérifier chaque règle sur les sources
// officielles (service-public.fr, legifrance.gouv.fr, insee.fr,
// impots.gouv.fr), puis mettre à jour [ReglesLegales.derniereVerification].
// Les règles marquées `aVerifier` sont celles dont l'interprétation retenue
// est incertaine ou simplifiée : elles doivent être confirmées en priorité.
//
// Références principales :
//  - Loi n° 89-462 du 6 juillet 1989 (baux d'habitation vides et meublés,
//    bail mobilité)
//  - Loi n° 86-1290 du 23 décembre 1986, art. 57 A (bail professionnel)
//  - Code de commerce, art. L145-1 et suivants (bail commercial)
//  - Code de la construction et de l'habitation (diagnostics)
//  - Loi n° 2021-1104 « Climat et résilience » (gel des loyers F et G)
// ============================================================================

import '../../domain/enums.dart';

/// Règles d'un type de bail.
class RegleBail {
  const RegleBail({
    required this.dureeMois,
    this.dureeMinMois,
    this.dureeMaxMois,
    required this.reconductionTacite,
    this.dureeReconductionMois,
    required this.preavisCongeBailleurMois,
    required this.preavisCongeLocataireMois,
    required this.revisionIrlAutorisee,
    required this.depotGarantieMaxMois,
    required this.references,
    this.aVerifier,
  });

  /// Durée par défaut du bail. `null` : fixée librement au contrat
  /// (dans les bornes [dureeMinMois] / [dureeMaxMois]).
  final int? dureeMois;
  final int? dureeMinMois;
  final int? dureeMaxMois;

  /// Le bail se renouvelle-t-il automatiquement à son terme ?
  final bool reconductionTacite;

  /// Durée de chaque reconduction (si [reconductionTacite]).
  final int? dureeReconductionMois;

  /// Préavis minimal pour que le BAILLEUR donne congé avant le terme.
  /// `null` : le bailleur ne peut pas donner congé (le bail s'arrête seul).
  final int? preavisCongeBailleurMois;

  /// Préavis du locataire (information affichée, pas d'échéance générée).
  final int? preavisCongeLocataireMois;

  /// Le loyer peut-il être révisé chaque année selon l'IRL ?
  final bool revisionIrlAutorisee;

  /// Dépôt de garantie maximum, en mois de loyer hors charges.
  /// `null` : pas de plafond légal ; `0` : dépôt interdit.
  final int? depotGarantieMaxMois;

  final String references;
  final String? aVerifier;
}

/// Règles d'un diagnostic immobilier (dans le cadre d'une location).
class RegleDiagnostic {
  const RegleDiagnostic({
    required this.validiteMois,
    required this.references,
    this.remarque,
    this.aVerifier,
  });

  /// Durée de validité. `null` : illimitée sous conditions (voir [remarque]).
  final int? validiteMois;
  final String references;
  final String? remarque;
  final String? aVerifier;
}

/// Date indicative d'une échéance fiscale annuelle (modifiable par l'utilisateur).
class DateAnnuelleSuggeree {
  const DateAnnuelleSuggeree({
    required this.jour,
    required this.mois,
    required this.explication,
    this.aVerifier,
  });

  final int jour;
  final int mois;
  final String explication;
  final String? aVerifier;
}

abstract final class ReglesLegales {
  /// Date de la dernière vérification complète sur les sources officielles.
  /// `null` tant que la vérification n'a pas été faite : NE PAS PUBLIER.
  static const DateTime? derniereVerification = null;

  // --------------------------------------------------------------------------
  // Baux
  // --------------------------------------------------------------------------

  static const Map<TypeBail, RegleBail> baux = {
    TypeBail.vide: RegleBail(
      // 3 ans si le bailleur est une personne physique (ou SCI familiale),
      // 6 ans si c'est une personne morale. L'app vise les particuliers.
      dureeMois: 36,
      reconductionTacite: true,
      dureeReconductionMois: 36,
      preavisCongeBailleurMois: 6,
      // 1 mois en zone tendue et dans certains cas (mutation, santé...).
      preavisCongeLocataireMois: 3,
      revisionIrlAutorisee: true,
      depotGarantieMaxMois: 1,
      references: 'Loi 89-462, art. 10, 15, 17-1, 22',
      aVerifier:
          'Durée de 6 ans si bailleur personne morale (hors SCI '
          'familiale) : non géré en V1.',
    ),
    TypeBail.meuble: RegleBail(
      // 1 an ; 9 mois non reconductible pour un étudiant.
      dureeMois: 12,
      reconductionTacite: true,
      dureeReconductionMois: 12,
      preavisCongeBailleurMois: 3,
      preavisCongeLocataireMois: 1,
      revisionIrlAutorisee: true,
      depotGarantieMaxMois: 2,
      references: 'Loi 89-462, art. 25-6, 25-7, 25-8, 25-9',
      aVerifier:
          'Bail étudiant de 9 mois (sans reconduction) : non géré '
          'en V1, l\'utilisateur peut saisir la durée à la main.',
    ),
    TypeBail.mobilite: RegleBail(
      dureeMois: null,
      dureeMinMois: 1,
      dureeMaxMois: 10,
      reconductionTacite: false,
      preavisCongeBailleurMois: null,
      preavisCongeLocataireMois: 1,
      revisionIrlAutorisee: false,
      depotGarantieMaxMois: 0,
      references: 'Loi 89-462, art. 25-12 à 25-18',
      aVerifier:
          'Confirmer : pas de révision de loyer en cours de bail '
          'mobilité, dépôt de garantie interdit, pas de congé du bailleur.',
    ),
    TypeBail.saisonnier: RegleBail(
      dureeMois: null,
      dureeMaxMois: 3, // 90 jours consécutifs maximum pour un même locataire
      reconductionTacite: false,
      preavisCongeBailleurMois: null,
      preavisCongeLocataireMois: null,
      revisionIrlAutorisee: false,
      depotGarantieMaxMois: null,
      references: 'Code du tourisme (meublé de tourisme), code civil',
      aVerifier:
          'Plafond de 90 jours exprimé ici en 3 mois : à affiner '
          'en jours si l\'app gère un jour la courte durée.',
    ),
    TypeBail.professionnel: RegleBail(
      dureeMois: 72, // 6 ans minimum
      reconductionTacite: true,
      dureeReconductionMois: 72,
      preavisCongeBailleurMois: 6,
      preavisCongeLocataireMois: 6, // à tout moment, avec 6 mois de préavis
      revisionIrlAutorisee: false, // indice libre au contrat (souvent ILAT)
      depotGarantieMaxMois: null,
      references: 'Loi 86-1290, art. 57 A',
      aVerifier:
          'Durée de reconduction (6 ans) et modalités de révision '
          '(indice contractuel) à confirmer.',
    ),
    TypeBail.commercial: RegleBail(
      dureeMois: 108, // 9 ans minimum (bail « 3-6-9 »)
      // À l'échéance, sans congé ni demande de renouvellement, le bail se
      // prolonge tacitement pour une durée indéterminée (pas de nouvelle
      // période de 9 ans).
      reconductionTacite: false,
      preavisCongeBailleurMois: 6,
      preavisCongeLocataireMois: 6, // à chaque période triennale
      revisionIrlAutorisee: false, // révision triennale ILC / ILAT
      depotGarantieMaxMois: null,
      references: 'Code de commerce, art. L145-4, L145-9, L145-38',
      aVerifier:
          'Prolongation tacite à durée indéterminée : l\'app ne '
          'génère que la première échéance de fin de bail.',
    ),
  };

  static RegleBail bail(TypeBail type) => baux[type]!;

  // --------------------------------------------------------------------------
  // Congé
  // --------------------------------------------------------------------------

  /// Le congé doit être REÇU par le locataire au plus tard la veille du jour
  /// situé « préavis » mois avant le lendemain du terme. Exemple : bail vide
  /// se terminant le 31/08/2026 → congé reçu au plus tard le 28/02/2026.
  /// Choix volontairement prudent : on conseille toujours d'envoyer bien avant.
  static const String aVerifierCalculConge =
      'Mode de calcul exact du délai de préavis (jour de réception, '
      'fin de mois) à confirmer ; l\'app retient une date prudente.';

  // --------------------------------------------------------------------------
  // Révision de loyer (IRL)
  // --------------------------------------------------------------------------

  // Sources : loi n° 89-462, art. 17-1 (version en vigueur depuis le
  // 24/08/2022, legifrance.gouv.fr) ; service-public.gouv.fr, fiche F1311
  // « Révision du loyer » (mise à jour du 08/08/2025), consultées le
  // 26/09/2026.

  /// Une révision au plus par an, à la date prévue au bail (ou, à défaut, à
  /// la date anniversaire du bail).
  static const int periodiciteRevisionMois = 12;

  /// Le bailleur a un an à compter de la date de révision pour la demander.
  /// Passé ce délai, il perd la révision de l'année. La révision n'est
  /// jamais rétroactive : demandée en retard, elle s'applique à partir de la
  /// date de la demande.
  static const int delaiDemandeRevisionMois = 12;

  /// Nouveau loyer = loyer actuel × IRL du trimestre de référence de l'année
  /// / IRL du même trimestre de l'année précédente (service-public.gouv.fr).
  /// Les années non réclamées sont perdues : on ne compare jamais à un
  /// indice plus ancien, même si le loyer n'a pas été révisé depuis.
  static const int ecartAnneesIndices = 1;

  /// Jour du mois suivant la fin d'un trimestre à partir duquel l'app
  /// considère l'IRL de ce trimestre comme publié (l'INSEE le publie vers
  /// la mi-avril, mi-juillet, mi-octobre et mi-janvier).
  static const int jourPublicationIrl = 15;

  static const String aVerifierIndiceUtilise =
      'Indice retenu : le dernier IRL du trimestre de référence publié à la '
      'date de révision prévue, y compris quand la révision est demandée en '
      'retard. La date de publication est estimée (15 du mois qui suit le '
      "trimestre) : l'utilisateur peut choisir une autre année.";

  /// À défaut de trimestre indiqué au bail : dernier IRL publié à la date
  /// de signature du bail.
  static const String trimestreParDefautExplication =
      "Si le bail ne précise pas le trimestre, c'est celui du dernier IRL "
      'publié à la date de signature du bail.';

  /// Article cité dans le courrier de révision.
  static String referenceLegaleRevision(TypeBail type) => switch (type) {
    TypeBail.meuble =>
      'aux articles 25-9 et 17-1 de la loi n° 89-462 du 6 juillet 1989',
    _ => "à l'article 17-1 de la loi n° 89-462 du 6 juillet 1989",
  };

  /// Logements pour lesquels toute hausse de loyer est interdite (gel des
  /// loyers des « passoires thermiques »).
  static const Set<ClasseDpe> classesDpeSansRevision = {
    ClasseDpe.f,
    ClasseDpe.g,
  };

  static const String aVerifierGelDpe =
      'Gel des loyers F/G : applicable aux baux conclus, renouvelés ou '
      'reconduits depuis le 24/08/2022 en métropole (dates différentes en '
      'outre-mer). L\'app bloque la révision pour tout bien classé F ou G, '
      'sans tenir compte de la date du bail.';

  /// Nombre de décimales de l'IRL publié par l'INSEE.
  static const int decimalesIrl = 2;

  /// Identifiant de la série « Indice de référence des loyers (IRL) » dans
  /// la banque de données macro-économiques de l'INSEE (vérifié le
  /// 26/09/2026).
  static const String idbankInseeIrl = '001515333';

  // --------------------------------------------------------------------------
  // Charges
  // --------------------------------------------------------------------------

  /// Les provisions pour charges sont régularisées au moins une fois par an.
  static const int periodiciteRegularisationChargesMois = 12;

  static const String aVerifierRegularisation =
      'En meublé, les charges peuvent être au forfait (pas de '
      'régularisation). L\'app génère l\'échéance dans tous les cas, '
      'l\'utilisateur peut la supprimer.';

  // --------------------------------------------------------------------------
  // Diagnostics (validité dans le cadre d'une LOCATION)
  // --------------------------------------------------------------------------

  static const Map<TypeDiagnostic, RegleDiagnostic> diagnostics = {
    TypeDiagnostic.dpe: RegleDiagnostic(
      validiteMois: 120,
      references: 'CCH, art. L126-26 et suivants',
      remarque:
          'Les DPE réalisés avant le 01/07/2021 ont une validité '
          'réduite (fin 2022 ou fin 2024 selon leur date).',
      aVerifier: 'Dates de fin de validité des anciens DPE.',
    ),
    TypeDiagnostic.electricite: RegleDiagnostic(
      validiteMois: 72,
      references: 'Loi 89-462, art. 3-3 ; décret 2016-1105',
      remarque: 'Obligatoire si l\'installation a plus de 15 ans.',
    ),
    TypeDiagnostic.gaz: RegleDiagnostic(
      validiteMois: 72,
      references: 'Loi 89-462, art. 3-3 ; décret 2016-1104',
      remarque: 'Obligatoire si l\'installation a plus de 15 ans.',
    ),
    TypeDiagnostic.plomb: RegleDiagnostic(
      validiteMois: 72,
      references: 'CSP, art. L1334-5 et suivants',
      remarque:
          'Logements construits avant 1949. Validité illimitée si '
          'absence de plomb (ou concentration inférieure au seuil).',
    ),
    TypeDiagnostic.amiante: RegleDiagnostic(
      validiteMois: null,
      references: 'CSP, art. R1334-14 et suivants',
      remarque:
          'Permis de construire antérieur au 01/07/1997. Validité '
          'illimitée si absence d\'amiante.',
      aVerifier: 'Règles de validité en cas de présence d\'amiante.',
    ),
    TypeDiagnostic.erp: RegleDiagnostic(
      validiteMois: 6,
      references: 'Code de l\'environnement, art. L125-5',
    ),
  };

  static RegleDiagnostic diagnostic(TypeDiagnostic type) => diagnostics[type]!;

  // --------------------------------------------------------------------------
  // Calendrier fiscal (dates indicatives, modifiables)
  // --------------------------------------------------------------------------

  static const DateAnnuelleSuggeree taxeFonciere = DateAnnuelleSuggeree(
    jour: 15,
    mois: 10,
    explication:
        'Date limite de paiement habituelle de la taxe foncière '
        '(mi-octobre, quelques jours de plus en paiement en ligne).',
    aVerifier: 'Date fixée chaque année : à vérifier sur impots.gouv.fr.',
  );

  static const DateAnnuelleSuggeree declarationRevenus = DateAnnuelleSuggeree(
    jour: 20,
    mois: 5,
    explication:
        'Déclaration annuelle des revenus, dont les revenus fonciers '
        '(fin mai / début juin selon le département).',
    aVerifier:
        'Dates fixées chaque année et variables selon le '
        'département : à vérifier sur impots.gouv.fr.',
  );
}
