# Pense-Bail : cahier des charges (V1)

Fonctionnel de l'application. Issu du PROMPT.md d'origine, mis à jour avec
les décisions prises depuis (voir [decisions.md](decisions.md)). Pour tout ce
qui touche l'interface, [design-system.md](design-system.md) fait foi en cas
de contradiction.

## 1. Vision

Application mobile pour les propriétaires bailleurs particuliers en France
(en général 1 à 10 biens). Ce n'est PAS un logiciel de gestion locative
complet, mais une boîte à outils qui fait trois choses très bien :
1. Ne jamais rater une date importante (révision de loyer, fin de bail,
   assurance, diagnostics, taxes…).
2. Avoir sous la main les informations utiles de chaque bien (bail,
   locataire, rentabilité, artisans).
3. Gagner du temps sur les tâches administratives récurrentes, à commencer
   par la révision de loyer avec courrier prêt à envoyer.

Principes directeurs :
- Simplicité avant tout : chaque écran se comprend sans explication.
- Rien n'est obligatoire au-delà de l'onboarding : l'app invite à compléter
  sans forcer.
- Public parfois peu à l'aise avec le numérique : grandes zones tactiles,
  textes lisibles, pas de jargon juridique sans explication.
- Tout en français, montants au format français, dates JJ/MM/AAAA.

## 2. Contraintes techniques

- Flutter, Android et iOS.
- Données uniquement sur l'appareil (SQLite via drift) : pas de backend, pas
  de compte. Seul accès réseau : la série IRL publiée par l'INSEE.
- Notifications locales pour les rappels.
- PDF pour les courriers et exports.
- Appareil photo et galerie pour les photos des biens.
- Architecture séparant données / logique / interface, pour pouvoir ajouter
  une synchronisation cloud plus tard.

## 3. Onboarding (premier lancement)

Objectif : en moins de 3 minutes, profil et biens configurés, tableau de
bord déjà utile. La progression est sauvegardée à chaque étape (reprise là où
l'utilisateur s'est arrêté).

0. **Bienvenue** : 2 ou 3 écrans de promesse (« Ne ratez plus aucune
   échéance », « Tous vos biens au même endroit », « Vos courriers prêts en
   un clic »), bouton « Commencer ». Lien « J'ai une sauvegarde : la
   restaurer » pour reprendre ses données sur un nouveau téléphone.
1. **Identité du bailleur** : prénom, nom, adresse (rue, complément
   facultatif, code postal, ville), téléphone et email facultatifs.
   Validation email, téléphone français, code postal. Phrase expliquant que
   ces données sont l'expéditeur des courriers.
2. **Nombre de biens** : boutons + et − (1 à 20), « Vous pourrez en ajouter
   ou en retirer plus tard. »
3. **Fiche de chaque bien** (« Bien 2 sur 3 ») : nom libre (affiché
   partout), type de logement (appartement, maison, immeuble, local
   professionnel), type de location (longue, moyenne, courte durée,
   professionnelle), loyer mensuel hors charges, charges mensuelles,
   adresse (avec complément facultatif), photo facultative (sinon
   illustration selon le type).
   - Si « Longue durée » uniquement : type de bail (vide ou meublé) et date
     de début (pas plus de 3 mois dans le futur), avec la phrase « Pour
     activer vos premiers rappels automatiquement. » Valeurs conservées en
     mémoire si l'utilisateur change de type, mais enregistrées seulement en
     longue durée.
   - Bouton « Passer la photo ».
4. **Récapitulatif** avec « Accéder à mon tableau de bord ».

## 4. Tableau de bord

Répond à : « Qu'est-ce que je dois faire bientôt ? »
- En-tête : date, salutation, cloche (nombre d'échéances urgentes).
- Synthèse : nombre de biens, total des loyers, total des charges.
- Action « Réviser un loyer » : choix parmi les biens en longue durée ; les
  autres grisés avec « Révision disponible uniquement pour les locations
  longue durée ».
- « Prochaines échéances » : liste chronologique tous biens confondus
  (date, intitulé, bien, pastille de statut), filtre par bien. Statuts : voir
  le design system (4 niveaux, la couleur n'est jamais seule). Appui : détail
  avec « Marquer comme faite », « Reporter », « Modifier ».
- Invitations à compléter : IRL de référence manquant (longue durée), bail
  manquant (autres types).
- « Mes biens » : une carte par bien (photo, nom, type, loyer, prochaine
  échéance), ouvre la fiche.
- Échéances automatiques dès l'onboarding (révision, fin de bail, date
  limite de congé) ; échéances génériques (taxe foncière, déclaration des
  revenus fonciers) pour tous les biens.

## 5. Fiche d'un bien

Onglets, chacun avec un état vide et une action claire.
- **Infos** : données de l'onboarding modifiables, plus surface, classe DPE,
  date du DPE, nombre de lots (immeuble). Suppression du bien.
- **Bail et locataire** : locataires (appeler, écrire), type de bail (vide,
  meublé, mobilité, saisonnier, professionnel, commercial), début, durée,
  dépôt de garantie, date de révision (défaut : anniversaire), trimestre et
  valeur de l'IRL de référence, historique des révisions (courriers).
- **Échéances** : automatiques (révision, fin de bail, congé,
  régularisation des charges), à date suggérée modifiable (assurance PNO,
  chaudière, diagnostics, taxe foncière, déclaration), personnelles (titre,
  date, récurrence, notes). Rappels configurables, J-30, J-7, J-1 par
  défaut.
- **Rentabilité** : investissement (prix, notaire, travaux, crédit),
  charges annuelles du propriétaire, case « Loyer reçu » par mois, journal
  des dépenses et recettes, cash-flow mensuel et annuel, rendements brut et
  net, récapitulatif annuel en PDF.
- **Artisans** : carnet global (nom, entreprise, métier, téléphone, email,
  notes ; appeler, écrire), interventions par bien (date, artisan,
  description, coût). Le coût alimente automatiquement les dépenses.

Toutes les durées et règles légales sont centralisées dans
`lib/core/config/regles_legales.dart` et vérifiées sur les sources
officielles avant publication.

## 6. Révision de loyer

Chaque année, le bailleur peut réviser le loyer selon l'IRL (INSEE).
- Uniquement en longue durée. DPE F ou G : révision interdite, message
  clair. Une fois par an, à la date prévue au bail, jamais rétroactive.
- Étapes : bien (prérempli depuis une fiche), vérification des données
  (loyer HC, trimestre de référence), indices IRL (table embarquée, mise à
  jour depuis l'INSEE, saisie manuelle en secours ; jamais de valeur
  inventée), calcul (loyer × nouvel IRL / ancien IRL, hors charges, arrondi
  au centime), résultat (ancien et nouveau loyer, évolution mensuelle et
  annuelle, détail du calcul), confirmation (loyer mis à jour, historique,
  prochaine révision recalculée).
- Courrier PDF : coordonnées du bailleur et du locataire, adresse du bien,
  lieu et date, objet, rappel de la clause, détail du calcul, nouveau loyer,
  charges inchangées, nouveau total, date d'application, politesse,
  signature. Actions : aperçu, partage, impression, enregistrement. Conseil :
  envoi en recommandé avec accusé de réception. Mention : « Outil d'aide, ne
  remplace pas un conseil juridique. »

## 7. Réglages

Profil du bailleur ; rappels (délais par défaut, notifications par type
d'échéance) ; biens (ajout, accès aux fiches) ; sauvegarde et restauration
(fichier) ; suppression complète ; mentions légales et confidentialité
(données sur l'appareil).

## 8. Modèle de données

Bailleur, Bien, Bail, Locataire, Echeance, Rappel, Artisan, Intervention,
MouvementFinancier, EncaissementLoyer, RevisionLoyer, IndiceIRL, Reglages.

## 9. Hors périmètre V1

Quittances de loyer, états des lieux, guide en cas d'impayé, calendrier des
obligations DPE, gestion d'un immeuble lot par lot, synchronisation cloud et
multi-appareils, mode sombre (tokens prêts).
