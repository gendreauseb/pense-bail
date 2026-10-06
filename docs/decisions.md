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

Échéances et rappels
- Rappels J-30, J-7, J-1 par défaut, modifiables dans les réglages ; envoi
  vers 9 h (heure approximative, pas d'autorisation « alarmes exactes »).
- Un type d'échéance désactivé reste affiché, sans notification.
- « Appliquer à toutes les échéances » remplace les rappels réglés
  échéance par échéance (après avertissement).
- Échéances automatiques recalculées seulement si le type de location, le
  type de bail, les dates ou la durée du bail changent (les reports et les
  rappels choisis sont conservés sinon).

Rentabilité
- Rendement brut = loyers annuels HC / (prix + notaire + travaux) ; net :
  mêmes loyers moins les charges du propriétaire.
- Cash-flow = loyer HC − crédit − charges du propriétaire (ni vacance ni
  fiscalité).
- Bilan : mois cochés « reçu » × loyer en vigueur ce mois-là (d'après
  l'historique des révisions ; une révision en cours de mois compte à partir
  du mois suivant).
- Mois « en retard » : mois entièrement écoulé, après le début du bail, non
  coché.
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
- Trimestre par défaut : dernier IRL publié à la signature du bail.
- Baisse de l'indice : révision possible, avec une note (non obligatoire).
- Courrier : article 17-1 de la loi du 6 juillet 1989 (meublé : articles
  25-9 et 17-1) ; « Au locataire » si aucun locataire n'est enregistré.

Données
- Sauvegarde : un fichier JSON (tables SQLite telles quelles, photos en
  base64), restauration après vérification (tables et colonnes connues,
  chemins de photos sûrs, schéma pas plus récent).

Version gratuite et Premium
- Gratuit : un seul bien actif ; onboarding, fiche, bail, locataires,
  échéances et rappels, alerte DPE, calcul de la révision de loyer
  (confirmation comprise : le loyer est mis à jour).
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

Biens vendus ou retirés de la location (étape après la monétisation)
- « Supprimer ce bien » propose : « Je l'ai vendu », « Je ne le loue plus »
  (réversible : « Remettre en location »), « Supprimer définitivement ».
- Vendu : date (obligatoire), prix de vente, frais de vente facultatifs.
  Lecture seule dans les deux modes, section « Biens vendus » repliée ;
  « Annuler la vente » possible sans limite de temps.
- Les biens vendus ou retirés ne comptent pas dans la limite du gratuit.
  Contournement accepté (déclarer vendu le plus ancien pour activer le
  suivant). Remettre en location un bien plus ancien que le bien actif :
  avertissement (« ce bien redeviendra votre bien actif, X passera en
  lecture seule »).
- Échéances : arrêtées (masquées, pas effacées) selon le cas, liste
  montrée avant de confirmer. Vente : révision, fin de bail, congé, PNO,
  chaudière, diagnostics, taxes foncières suivantes arrêtées ; taxe
  foncière de l'année gardée ; régularisation des charges gardée si vendu
  libre. Retrait : seules les échéances du bail s'arrêtent (régularisation
  gardée). Règles dans `regles_legales.dart`, marquées `aVerifier`. La
  déclaration des revenus fonciers est générale et n'est pas touchée.
- Bilan de vente (Premium ; déclarer une vente ou un retrait est gratuit) :
  plus-value brute = prix de vente − frais de vente − (achat + notaire +
  travaux initiaux) ; bilan = plus-value brute + loyers encaissés −
  dépenses du journal hors catégorie « Crédit ». Jamais les charges
  estimées de la fiche. Travaux initiaux et travaux du journal affichés sur
  deux lignes (aide : « avant la première location » / « depuis »).
  Mention « hors impôt sur la plus-value et crédit ».

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

## Points ouverts (à trancher par l'utilisateur)

- Chiffrer la sauvegarde par mot de passe ? (elle contient les données des
  locataires en clair).
- Indice retenu pour une révision demandée en retard : dernier IRL publié à
  la date prévue (choix actuel) ou à la date de la demande ? Date de
  publication estimée au 15 du mois qui suit le trimestre.
- Règles marquées `aVerifier` dans `regles_legales.dart` (calcul du délai de
  congé, gel F/G quelle que soit la date du bail, validité des anciens DPE,
  amiante, dates fiscales).
- Abonnement réel : si l'expiration est constatée pendant que l'utilisateur
  est sur un autre onglet, le message de fin s'affiche par-dessus (l'accueil
  reste chargé). À décider au branchement : attendre le retour sur
  l'accueil ?

## Avant le test fermé

Voir `docs/publication/README.md` (procédure complète).

- Créer la clé d'importation et `android/key.properties` (hors du dépôt,
  sauvegardés en lieu sûr).
- Renseigner `ConfigApp.editeur` et `ConfigApp.contactEditeur`, compléter
  la politique de confidentialité et la publier sur le site.
- Play Console : fiche Store (captures d'écran à faire), sécurité des
  données, classification du contenu, statut de professionnel.

## Avant publication

- Vérifier chaque règle de `regles_legales.dart` sur les sources officielles,
  puis renseigner `ReglesLegales.derniereVerification`.
- Régénérer `assets/irl/irl.json` (voir `assets/irl/LISEZMOI.md`).
- Tester sur iOS (jamais fait) et sur un Android à navigation 3 boutons.
  iOS : icône et écran de lancement encore ceux de Flutter, région de
  développement à passer en `fr` (audit A5-01, A5-04).
- Brancher l'abonnement réel (RevenueCat) : nouvelle implémentation de
  `SourceDroits` à la place de `DroitsBeta` dans `sourceDroitsProvider`. À
  l'expiration constatée, écrire `ClesReglages.finAbonnementAAnnoncer` (le
  message de l'accueil fait le reste). Remplacer « bientôt disponible » de
  l'écran Premium par l'achat et la restauration des achats.
- Mettre à jour la politique de confidentialité et le formulaire « Sécurité
  des données » (achats : identifiant et historique d'achat).
- Construire la version publiée sans `--dart-define=BETA=true`.
