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

## Points ouverts (à trancher par l'utilisateur)

- Chiffrer la sauvegarde par mot de passe ? (elle contient les données des
  locataires en clair).
- Indice retenu pour une révision demandée en retard : dernier IRL publié à
  la date prévue (choix actuel) ou à la date de la demande ? Date de
  publication estimée au 15 du mois qui suit le trimestre.
- Règles marquées `aVerifier` dans `regles_legales.dart` (calcul du délai de
  congé, gel F/G quelle que soit la date du bail, validité des anciens DPE,
  amiante, dates fiscales).

## Avant publication

- Vérifier chaque règle de `regles_legales.dart` sur les sources officielles,
  puis renseigner `ReglesLegales.derniereVerification`.
- Renseigner `ConfigApp.editeur` et `ConfigApp.contactEditeur` (mentions
  légales).
- Régénérer `assets/irl/irl.json` (voir `assets/irl/LISEZMOI.md`).
- Tester sur iOS (jamais fait) et sur un Android à navigation 3 boutons.
