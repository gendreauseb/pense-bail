# Décisions et points ouverts

À consulter avant de modifier un comportement déjà en place. Mettre ce
fichier à jour quand l'utilisateur tranche un point.

## Décisions prises

Interface
- Le design system fait foi sur le cahier des charges : 4 statuts
  d'échéance (≤ 7 j, 8 à 30 j, 31 à 90 j, au-delà), barre de navigation à 5
  emplacements avec « + » central, onglet « Réglages », nom « Pense-Bail ».
- Montants affichés avec centimes seulement s'ils sont non nuls ; courriers
  et PDF toujours avec centimes.
- Polices Fraunces et Manrope embarquées (hors ligne).
- Cloche de l'accueil sans cercle ; la pastille compte les échéances
  urgentes.
- Téléphone et email du bailleur facultatifs.
- Complément d'adresse facultatif (bailleur et biens) : après la voie sur
  une ligne, sur sa propre ligne avant la voie dans les courriers (norme
  AFNOR NF Z10-011).
- Grand texte : un libellé et sa valeur, ou des chiffres côte à côte,
  passent les uns sous les autres quand un mot ne tient plus
  (`LigneInfo`, `ChiffresEnColonnes`) ; le texte des barres fixes (action,
  navigation) est plafonné à 130 % pour qu'elles n'envahissent pas l'écran.
- Onglets qui défilent (fiche du bien) : un fondu sur le bord indique qu'il
  y en a d'autres.
- Typographie française : espace insécable avant « : ; ? ! » » et après
  « « » dans toutes les chaînes, vérifiée par un test.

Échéances et rappels
- Rappels J-30, J-7, J-1 par défaut, modifiables dans les réglages ; envoi
  vers 9 h (heure approximative, pas d'autorisation « alarmes exactes »).
- Un type d'échéance désactivé reste affiché, sans notification.
- « Appliquer à toutes les échéances » remplace les rappels réglés
  échéance par échéance (après avertissement).
- Échéances automatiques recalculées seulement si le type de location, le
  type de bail, les dates, la durée du bail ou la clause de révision
  changent (les reports et les rappels choisis sont conservés sinon).
  Clause à « Non » : le rappel de révision est supprimé ; « Oui » ou « Je ne
  sais pas » : il est recréé.

Rentabilité
- Rendement brut = loyers annuels HC / (prix + notaire + travaux) ; net :
  mêmes loyers moins les charges du propriétaire.
- Cash-flow = loyer HC − crédit − charges du propriétaire (ni vacance ni
  fiscalité).
- Bilan : mois cochés « reçu » × loyer en vigueur ce mois-là (d'après
  l'historique des révisions ; une révision en cours de mois compte à partir
  du mois suivant).
- Mois « en retard » : mois entièrement écoulé, non coché, à partir du mois
  où le bien a été ajouté dans l'application et du début du bail (le mois de
  début seulement si le bail commence le 1er). Couleur neutre avec une icône
  (les couleurs d'alerte sont réservées aux échéances).
- Journal sans catégorie « Loyer » (suivi par les cases) ni « Intervention »
  (ajoutée automatiquement).

Révision de loyer
- Indices : table INSEE embarquée (série 001515333), mise à jour depuis
  l'INSEE au plus une fois par semaine, saisie manuelle en secours ; une
  valeur INSEE n'est jamais remplacée par une saisie.
- Ancien indice = même trimestre, année précédente : les années non
  réclamées sont perdues.
- Demandée en retard (moins d'un an) : effet à la date du courrier.
- Une date de révision est considérée comme faite si une révision a pris
  effet ce jour-là ou après, si l'IRL de référence du bail est déjà celui de
  cette année, ou si l'utilisateur l'indique (« J'ai déjà révisé »).
- Clause de révision : « Votre bail prévoit-il la révision du loyer ? »
  (oui / non / je ne sais pas), retenue sur le bail (schéma 6), modifiable
  dans le bail et demandée au début de la révision tant qu'elle est
  inconnue. « Non » : ni rappel de révision ni révision.
- Trimestre par défaut : dernier IRL publié à la signature du bail. Le
  courrier dit « L'indice de référence est celui du … trimestre », sans
  affirmer qu'il figure au bail.
- Règles incertaines : une note « À vérifier » pour l'utilisateur
  (`noteUtilisateur` et `note…` de `regles_legales.dart`) là où la règle
  s'applique (bail, révision en retard, congé, charges en meublé,
  diagnostics, DPE F et G).
- Baisse de l'indice : révision possible, avec une note (non obligatoire).
- Courrier : article 17-1 de la loi du 6 juillet 1989 (meublé : articles
  25-9 et 17-1) ; « Au locataire » si aucun locataire n'est enregistré.

Données
- Sauvegarde : un fichier JSON (tables SQLite telles quelles, photos en
  base64), restauration après vérification (tables et colonnes connues,
  chemins de photos sûrs, schéma pas plus récent).
- Dates calendaires (début de bail, échéances, mouvements…) enregistrées
  sans heure ni fuseau, en texte AAAA-MM-JJ (schéma 5) : une échéance du
  15/10 reste au 15/10 sur un téléphone réglé sur un autre fuseau.
  Horodatages (`creeLe`, `modifieLe`) inchangés.
- Chaque version du schéma a sa référence dans `drift_schemas/` ; la mise
  à jour de la base et la restauration d'une sauvegarde sont testées depuis
  chacune.

Version gratuite et Premium
- Gratuit : un seul bien actif ; onboarding, fiche, bail, locataires,
  échéances et rappels, contrôle du DPE (F et G), calcul de la révision de
  loyer (confirmation comprise : le loyer est mis à jour).
- Premium : biens illimités, courrier de révision (PDF), rentabilité
  (onglet, journal, cases « Loyer reçu », investissement, récapitulatif
  annuel), carnet d'artisans et interventions.
- Les écrans demandent `Droits.autorise(Fonctionnalite)`, jamais « a-t-il
  payé ? ». Le statut vient uniquement de `SourceDroits` (aujourd'hui
  `DroitsBeta`, simulation ; plus tard l'abonnement réel).
- Chaque écriture concernée passe par un cas d'usage qui contrôle les
  droits (`VerrouBiens`) : les écrans masquent les actions, les cas
  d'usage les refusent quel que soit le chemin (`BienVerrouille`,
  `LimiteBiensAtteinte`, `FonctionnaliteReservee`, message prêt à
  afficher).
- Bien actif en gratuit : le plus ancien (`creeLe`, puis `ordre`, puis
  `id`). S'il est supprimé, le plus ancien des restants le remplace.
- Perte du Premium : rien n'est supprimé ni modifié.
  - Autres biens : visibles partout avec la mention « Lecture seule »,
    bandeau sur la fiche. Pas de modification, de photo, de bail, de
    locataire, ni d'invitation à compléter. Suppression possible.
  - Leurs échéances restent affichées et notifiées ; « faite » et
    « reporter » restent possibles, pas l'ajout, la modification ni la
    suppression (ni le déplacement vers le bien actif). Les échéances
    communes à tous les biens ne sont pas concernées.
  - Révision sur un bien verrouillé : calcul visible, confirmation refusée.
  - Rentabilité et artisans : ce qui est déjà saisi reste consultable, en
    lecture seule (appeler et écrire restent possibles) ; sans données,
    seul le bandeau Premium s'affiche.
- Courrier de révision : chaque révision mémorise si son courrier était
  inclus à la confirmation (`courrierInclus`, schéma 4 ; vrai pour les
  révisions antérieures). En gratuit, la révision s'enregistre sans
  courrier ; les courriers déjà produits restent consultables ; repasser en
  Premium les rend tous disponibles.
- Ajout d'un bien au-delà de la limite : refusé dans `GestionBiens` ; le
  « + », la liste des biens et les réglages mènent à l'écran Premium.
  L'onboarding crée tous les biens déclarés ; en gratuit, une note
  prévient dès plus d'un bien que les suivants seront en lecture seule.
- Écran « Pense-Bail Premium » : ce qui est inclus, ce qui reste gratuit,
  « L'abonnement sera bientôt disponible » ; en bêta, bouton d'activation.
- Fin d'abonnement : message unique sur l'accueil (bien qui reste actif,
  autres biens en lecture seule, ce qui reste gratuit et consultable, rien
  n'est supprimé). Déclenché par le réglage `premium.fin_a_annoncer`, effacé
  une fois le message fermé.
- Bêta (`--dart-define=BETA=true`) : section « Mode bêta » en tête des
  réglages (interrupteur Premium, « Simuler la fin de l'abonnement »),
  badge « Bêta : gratuit / Premium » sur l'accueil, Premium par défaut.
  L'interrupteur seul n'affiche pas le message de fin. Sans le drapeau, la
  section n'existe pas et l'app est en gratuit.
- Réglages propres au téléphone (`ClesReglages.propresAuTelephone` : mode
  bêta, message de fin à annoncer) : jamais exportés, ignorés dans une
  sauvegarde restaurée, conservés par « Tout effacer ».

Biens vendus ou retirés de la location (schéma 7)
- « Supprimer ce bien » propose : « Je l'ai vendu », « Je ne le loue plus »
  (réversible : « Remettre en location »), « Supprimer définitivement ».
- Vendu : date (obligatoire), prix et frais de vente facultatifs (décidé le
  02/11/2026), « Le logement était-il loué au moment de la vente ? » (oui /
  non, obligatoire). Lecture seule dans les deux modes, section « Biens
  vendus » repliée sous la liste ; « Annuler la vente » possible sans limite
  de temps (le bien redevient « plus en location » s'il l'était) ; vente
  modifiable (« Modifier la vente »).
- Retiré (« Je ne le loue plus ») : lecture seule aussi (décidé le
  02/11/2026), mention « Plus en location », date du retrait = jour de la
  déclaration. Reste dans la liste des biens.
- Ni vendus ni retirés : pas de révision, pas de « Réviser le loyer ». Accueil
  et synthèse : biens vendus absents des cartes et des filtres (leurs
  échéances gardées restent listées avec leur nom) ; la synthèse ne compte
  que les biens loués.
- Les biens vendus ou retirés ne comptent pas dans la limite du gratuit.
  Contournement accepté (déclarer vendu le plus ancien pour activer le
  suivant). Remettre en location un bien plus ancien que le bien actif :
  avertissement (« ce bien redeviendra votre bien actif, X passera en
  lecture seule »).
- Échéances : arrêtées (statut « arrêtée » : masquées, jamais notifiées,
  pas effacées, rétablies si la vente est annulée ou le bien remis en
  location), liste montrée avant de confirmer. Vente : révision, fin de bail, congé, PNO,
  chaudière, diagnostics, taxes foncières suivantes arrêtées ; taxe
  foncière de l'année gardée ; régularisation des charges gardée si vendu
  libre (arrêtée si loué : l'acquéreur reprend le bail). Une occurrence
  suivante créée après la vente (taxe foncière de l'année faite) naît
  arrêtée. Retrait : seules les échéances du bail s'arrêtent (régularisation
  gardée). Règles dans `regles_legales.dart`, marquées `aVerifier`. La
  déclaration des revenus fonciers est générale et n'est pas touchée.
- Bilan de vente (Premium ; déclarer une vente ou un retrait est gratuit) :
  plus-value brute = prix de vente − frais de vente − (achat + notaire +
  travaux initiaux) ; bilan = plus-value brute + loyers encaissés −
  dépenses du journal hors catégorie « Crédit ». Jamais les charges
  estimées de la fiche. Travaux initiaux et travaux du journal affichés sur
  deux lignes (aide : « avant la première location » / « depuis »).
  Mention « hors impôt sur la plus-value et crédit ». Affiché en tête de
  l'onglet Rentabilité du bien vendu, à la place de « Ce que le bien
  rapporte » ; les autres recettes du journal y sont comptées (ligne
  séparée). Récapitulatif PDF de l'année toujours exportable. Sans prix de
  vente ou d'achat : pas de bilan, invitation à compléter.

Publication
- Distribution de la bêta par le test fermé de la Play Console (lien
  d'inscription, installation depuis le Play Store), pas par un APK.
- Icône : le logo de l'application (calendrier coché blanc sur bleu canard),
  remplaçable plus tard par une icône de graphiste. Écran de lancement
  ivoire avec ce logo, clair aussi en mode sombre.
- Sauvegarde automatique du téléphone conservée (Google sur Android, iCloud
  sur iPhone) : base et photos seulement (`res/xml/regles_*.xml`) ; dit dans
  les mentions légales et la politique de confidentialité.
- Politique de confidentialité publiée sur le site de l'éditeur
  (`docs/publication/politique-confidentialite.html`).
- Build bêta : numéro de version contenant « beta » (contrôlé par Gradle),
  jamais promu en production ; la version publique est reconstruite sans le
  drapeau.

## Décidé, à implémenter

- **Notifications limitées au bien actif en version gratuite** (décidé le
  25/10/2026). Les échéances des biens en lecture seule ne sont plus
  notifiées (sinon on peut saisir tous ses biens pendant l'essai, résilier
  et garder tous ses rappels gratuitement). Remplacera « Leurs échéances
  restent affichées et notifiées » dans « Perte du Premium » une fois
  implémenté. Questions restantes : voir les points ouverts.

## Points ouverts (à trancher par l'utilisateur)

- Notifications limitées au bien actif : les échéances des biens en
  lecture seule restent-elles affichées sur l'accueil ? Les échéances
  communes à tous les biens restent-elles notifiées ?
- Chiffrer la sauvegarde par mot de passe ? (elle contient les données des
  locataires en clair).
- Interprétations juridiques incertaines (révision demandée en retard,
  délai de congé, gel F/G, anciens DPE, amiante, dates fiscales…) : listées
  dans `docs/a-verifier.md` §1, à confirmer avant la production.
- Abonnement réel : si l'expiration est constatée pendant que l'utilisateur
  est sur un autre onglet, le message de fin s'affiche par-dessus (l'accueil
  reste chargé). À décider au branchement : attendre le retour sur
  l'accueil ?

## Reste à faire (état au 02/11/2026)

Les numéros A… renvoient à `docs/audit-2026-10-05.md`. Rayer ou retirer une
ligne une fois faite.

1. iOS, avant sa sortie : icône, écran de lancement, langue française par
   défaut (A5-04).
2. Notifications limitées au bien actif en version gratuite, avant la
   production. Corriger en même temps les textes qui promettent les rappels
   pour tous les biens : écran Premium (« Toujours gratuit »), message de
   fin d'abonnement, cahier des charges.

En attente de l'utilisateur
- Bannière jaune pour les rappels désactivés : à confirmer, puis à inscrire
  dans « Interface » ci-dessus.
- Illustration de l'onboarding : « Prêt à envoyer » ou « Loyer révisé » ?
- Coordonnées de l'éditeur, adresse de la politique de confidentialité,
  clé d'envoi (voir `docs/a-verifier.md`).

## Avant publication

Liste des vérifications et démarches (règles légales, essais sur
téléphone, test fermé, production) : `docs/a-verifier.md`.
