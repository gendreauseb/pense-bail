# À vérifier

Tout ce qu'il reste à vérifier ou à faire soi-même : règles légales,
essais sur téléphone, démarches de publication. Cocher une ligne quand
elle est faite, avec la date et la source consultée. Les points de code
restant à corriger sont dans le rapport d'audit, pas ici.

Mettre ce fichier à jour à chaque changement qui ajoute une règle, un texte
juridique ou une démarche.

## 1. Règles légales

Toutes les règles sont dans `lib/core/config/regles_legales.dart`, avec leur
référence. Sources : legifrance.gouv.fr (textes), service-public.gouv.fr
(fiches pratiques), insee.fr, impots.gouv.fr.

Quand toute la section est vérifiée : renseigner
`ReglesLegales.derniereVerification` (la date s'affiche dans les mentions
légales ; tant qu'elle est vide, ne pas publier en production).

### 1.1 Interprétations incertaines (en priorité)

L'application affiche déjà une note « À vérifier » pour chacune, sauf
mention contraire.

- [ ] **Gel des loyers F et G.** L'app bloque la révision de tout logement
  classé F ou G, quelle que soit la date du bail. Vérifier : baux concernés
  (signés, renouvelés ou reconduits depuis le 24/08/2022 en métropole ?),
  dates en outre-mer, article exact (loi 2021-1104, art. 159 ?). Texte
  affiché : `noteGelDpe`.
- [ ] **Clause de révision.** La révision n'est possible que si le bail la
  prévoit (loi 89-462, art. 17-1). Vérifier que c'est bien la règle pour les
  baux vides et meublés. Texte affiché : `clauseRevisionExplication`.
- [ ] **Date limite de congé.** Calcul retenu : congé reçu au plus tard la
  veille du jour situé « préavis » mois avant le lendemain du terme (fin au
  31/08, préavis 6 mois → 28/02). Vérifier le mode de calcul exact (jour de
  réception, fins de mois).
- [ ] **Bail commencé un 29 février.** L'app fixe la fin de période au 27/02
  (anniversaire retenu au 28/02) ; une autre lecture donne le 28/02. Pas de
  note affichée.
- [ ] **Révision demandée en retard.** L'app retient l'IRL publié à la date
  prévue au bail (pas à la date de la demande), avec effet à la date du
  courrier, sans rétroactivité, dans la limite d'un an. Vérifier les trois
  points. Texte affiché : `noteIndiceEnRetard`.
- [ ] **Deux révisions rapprochées.** Révision 2025 demandée en retard (effet
  le 05/10/2026), puis révision 2026 au 01/11/2026, quatre semaines plus
  tard. Conforme aux décisions ; à confirmer. Pas de note affichée.
- [ ] **Bail vide, bailleur société** (hors SCI familiale) : 6 ans au lieu de
  3. Non calculé ; note dans le bail.
- [ ] **Bail étudiant meublé de 9 mois**, sans reconduction. Non géré ;
  note dans le bail.
- [ ] **Bail mobilité** : ni révision du loyer, ni dépôt de garantie, ni
  congé du bailleur, durée de 1 à 10 mois, pas de reconduction.
- [ ] **Bail professionnel** : 6 ans, reconduction de 6 ans, préavis de
  6 mois, indice contractuel (souvent l'ILAT, non calculé).
- [ ] **Bail commercial** : 9 ans, prolongation tacite sans durée fixe,
  révision triennale (non calculée), préavis de 6 mois.
- [ ] **Location saisonnière** : 90 jours au plus pour un même locataire
  (l'app arrondit à 3 mois). Pas de note affichée.
- [ ] **Charges en meublé** : au forfait, pas de régularisation (l'app crée
  l'échéance quand même). Texte affiché : `noteRegularisationMeuble`.
- [ ] **DPE anciens** : validité réduite des DPE réalisés avant le
  01/07/2021 (fin 2022 ou fin 2024 selon leur date).
- [ ] **Amiante** : règles de validité en cas de présence d'amiante.
- [ ] **Logements G** : interdits à la location en nouveau bail depuis 2025
  (critère de décence, calendrier F en 2028, E en 2034 à vérifier).
  L'application ne le signale pas : décider s'il faut une alerte.

### 1.2 Valeurs à confirmer

- [ ] **Bail vide** : 3 ans, reconduit pour 3 ans ; congé du bailleur
  6 mois ; préavis du locataire 3 mois (1 mois en zone tendue et cas
  particuliers) ; dépôt de garantie 1 mois de loyer hors charges au plus
  (loi 89-462, art. 10, 15, 22).
- [ ] **Bail meublé** : 1 an, reconduit pour 1 an ; congé du bailleur
  3 mois ; préavis du locataire 1 mois ; dépôt 2 mois au plus (art. 25-6 à
  25-9).
- [ ] **Révision** : une fois par an à la date prévue, sinon à la date
  anniversaire ; nouveau loyer = loyer × IRL du trimestre de référence /
  IRL du même trimestre un an plus tôt ; années non réclamées perdues ;
  trimestre par défaut : dernier IRL publié à la signature du bail
  (art. 17-1).
- [ ] **Courrier de révision** : articles cités (17-1 ; meublé 25-9 et
  17-1), envoi conseillé en recommandé avec accusé de réception.
- [ ] **Régularisation des charges** : au moins une fois par an (art. 23 ;
  meublé : art. 25-10).
- [ ] **Entretien de la chaudière** : annuel, à la charge du locataire (code
  de l'environnement, art. R224-41-4 et suivants).
- [ ] **Diagnostics** (validité pour une location) : DPE 10 ans ;
  électricité et gaz 6 ans (installation de plus de 15 ans) ; plomb 6 ans
  (avant 1949, illimité si absence) ; amiante illimité si absence ; ERP
  6 mois.
- [ ] **Calendrier fiscal** (à revoir chaque année) : taxe foncière vers le
  15/10 ; déclaration des revenus vers le 20/05, variable selon le
  département.
- [ ] **IRL** : série INSEE 001515333 ; publication vers le 15 du mois qui
  suit chaque trimestre.

### 1.3 Textes affichés à relire

- [ ] Explications des échéances (`lib/features/echeances/textes_echeances.dart`).
- [ ] Notes « À vérifier » des baux (`noteUtilisateur` dans
  `regles_legales.dart`) et les autres `note…` du même fichier.
- [ ] Courrier de révision complet (`courrier_revision.dart`), sur un
  courrier réel généré par l'application.
- [ ] Écran de révision : textes des étapes 1 à 3.
- [ ] Mentions légales de l'application et politique de confidentialité
  (`docs/publication/politique-confidentialite.html`).

## 2. Essais sur téléphone

- [ ] **Lecteur d'écran (TalkBack)** : parcourir l'accueil, une fiche, la
  révision ; chaque ligne lue en une fois, chaque champ annoncé avec son
  libellé.
- [ ] **Notifications réelles** : rappel reçu vers 9 h, et encore après un
  redémarrage du téléphone.
- [ ] **Texte agrandi** (200 %) et **téléphone en français** (les
  dialogues système de l'émulateur sont en anglais).
- [ ] **Android à navigation à 3 boutons.**
- [ ] **Accueil sans aucun bien** (après suppression du dernier).
- [ ] **Message « … est faite. Annuler »** : durée d'affichage acceptable ?
- [ ] **Sauvegarde Google** : installer l'application sur un second
  téléphone avec le même compte, vérifier que les biens et les photos
  reviennent et que les rappels sont reprogrammés.
- [ ] **Sauvegarde manuelle** : exporter un fichier, le restaurer sur un
  autre téléphone.
- [ ] **iOS** : jamais testé (voir section 4).

## 3. Avant le test fermé

Procédure détaillée : `docs/publication/README.md`.

- [ ] Créer la clé d'importation et `android/key.properties` ; sauvegarder
  le fichier `.jks` et le mot de passe hors de l'ordinateur.
- [ ] Coordonnées de l'éditeur (nom, statut, SIRET, adresse, email) :
  `ConfigApp.editeur`, `ConfigApp.contactEditeur`, politique de
  confidentialité.
- [ ] Publier la politique de confidentialité sur le site ; noter son
  adresse.
- [ ] Play Console : statut de professionnel, fiche Store (captures à
  faire à ce moment-là), sécurité des données (lecture sur la sauvegarde
  Android à confirmer), classification du contenu, public cible.
- [ ] Recruter au moins 15 testeurs (12 doivent rester inscrits 14 jours).
- [ ] Build bêta : `--dart-define=BETA=true --build-name=1.0.0-beta.N`.

## 4. Avant la production

- [ ] Section 1 entièrement vérifiée, `ReglesLegales.derniereVerification`
  renseignée.
- [ ] Table IRL régénérée (`assets/irl/LISEZMOI.md`) si un trimestre est
  paru.
- [ ] Abonnement réel (RevenueCat) : nouvelle implémentation de
  `SourceDroits` à la place de `DroitsBeta` dans `sourceDroitsProvider` ; à
  l'expiration constatée, écrire `ClesReglages.finAbonnementAAnnoncer` (le
  message de l'accueil fait le reste) ; remplacer « bientôt disponible » de
  l'écran Premium par l'achat et la restauration des achats.
- [ ] Politique de confidentialité et formulaire « Sécurité des données »
  mis à jour pour les achats.
- [ ] iOS : icône et écran de lancement, langue française par défaut
  (audit A5-04), essais complets.
- [ ] Version publique reconstruite **sans** `--dart-define=BETA=true` ;
  ne jamais promouvoir une version du test fermé.
