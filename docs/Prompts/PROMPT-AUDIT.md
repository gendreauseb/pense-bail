# Pense-Bail : audit complet de l'application

Lis d'abord `CLAUDE.md`, puis `docs/cahier-des-charges.md`, `docs/design-system.md`, `docs/conventions-code.md` et `docs/decisions.md`. Ces documents sont les références de l'audit : chaque constat doit pouvoir être rattaché à l'une de leurs règles, à une règle de `regles_legales.dart`, ou à un défaut objectif (bug, crash, incohérence).

## Règles de l'audit

- **Lecture seule.** Tu ne corriges rien dans `lib/`, `test/`, `docs/` ni dans la configuration. Le seul fichier que tu crées est le rapport. Si tu as besoin d'un test ou d'un script pour vérifier une hypothèse, crée-le dans un dossier temporaire hors du dépôt (ou supprime-le avant de rendre la main) et indique dans le rapport le test qu'il faudrait ajouter.
- **Preuve obligatoire.** Chaque constat cite un fichier et une ligne, une sortie de commande ou une capture d'écran. Pas de constat « probable » sans vérification : s'il n'a pas pu être vérifié, il va dans la section « À vérifier manuellement ».
- **Émulateur.** Les données présentes peuvent être les miennes : ne les modifie pas. Pour tester l'interface, fais d'abord une sauvegarde depuis l'app ou demande-moi l'autorisation de travailler sur une installation vierge.
- **Pas de commit.**
- Si un audit précédent existe dans `docs/`, compare : constats corrigés, toujours présents, nouveaux.

## Axe 1 : santé technique

- `flutter pub get`, `flutter analyze`, `flutter test --coverage` : résultats complets. Couverture par dossier (`domain/services`, `domain/usecases`, `data`, `features`), avec les fichiers du domaine les moins couverts.
- `dart run build_runner build` puis `git status` : les fichiers générés sont-ils à jour ?
- Base de données : `schemaVersion` et chaque étape `onUpgrade` cohérentes avec `tables.dart` ; colonnes ajoutées nullables ou avec valeur par défaut ; une sauvegarde JSON de chaque ancien schéma reste restaurable (`test/data/sauvegarde_test.dart` le couvre-t-il vraiment ?).
- `flutter pub outdated` : dépendances en retard, en particulier celles qui touchent aux notifications, au PDF et à la base.
- Qualité des tests : tests qui n'assertent rien d'utile, tests qui dépendent de la date réelle au lieu d'une date fixée, aides de test nommées `*_test.dart`.

## Axe 2 : règles métier

- `regles_legales.dart` : pour chaque règle, présence de la source, d'au moins un test, et utilisation effective dans le code (pas de valeur légale recopiée ailleurs). Liste des règles marquées `aVerifier` et, pour chacune, vérifie que l'utilisateur en est bien averti à l'écran. Tu ne certifies pas le droit : signale ce qui te paraît douteux, la vérification sur les sources officielles reste à faire par moi.
- `decisions.md` : reprends chaque décision une par une et indique si le code la respecte (oui, non, partiellement), avec la preuve.
- Calculs et cas limites, à vérifier par lecture du code et des tests : révision IRL (trimestre de référence, indice non encore publié, baisse de l'indice, révision demandée en retard), dates (29 février, fins de mois via `Dates.ajouterMois`, passage d'année, fuseau horaire), délais de bail et de congé, génération et recalcul des échéances, rentabilité (rendements, cash-flow, mois en retard, loyer en vigueur selon l'historique des révisions).
- Montants : uniquement des `int` en centimes, aucun `double` pour un montant, affichage uniquement via `Formats`, centimes toujours présents dans les courriers et PDF.
- Services du domaine : aucun ne lit la date du jour lui-même.
- IRL : aucune valeur d'indice inventée ou écrite en dur hors de la table embarquée ; une valeur INSEE n'est jamais remplacée par une saisie.

## Axe 3 : gratuit / Premium

Vérifie l'implémentation récente contre ces règles :

- un seul bien actif en gratuit : le plus ancien, trié par `creeLe`, puis `ordre`, puis `id` ; si on le supprime, le plus ancien des restants prend le relais ;
- les autres biens restent visibles mais en lecture seule ; leurs échéances restent affichées, notifiées, et peuvent être marquées faites ou reportées ;
- l'ajout d'un bien au-delà de la limite est refusé dans le cas d'usage, pas seulement dans l'interface. Cherche tout chemin qui créerait ou modifierait un bien sans passer par lui (onboarding, restauration de sauvegarde, formulaires) ;
- verrous Premium : génération du courrier de révision (le calcul reste visible), rentabilité, artisans ; ce qui a déjà été produit reste consultable ;
- aucune donnée n'est supprimée ni modifiée par un changement de mode ;
- les écrans demandent si une fonctionnalité est disponible, jamais directement le statut d'abonnement ; une seule source du statut, remplaçable par RevenueCat ;
- hors build bêta (`--dart-define=BETA=true` absent) : section bêta et badge absents, app en gratuit ; le statut simulé est exclu de la sauvegarde ;
- teste concrètement le passage Premium vers gratuit avec plusieurs biens, puis le retour en Premium.

## Axe 4 : interface, rédaction, accessibilité

Recherches systématiques dans `lib/features/` et `lib/core/widgets/` (hors `lib/app/design/`), avec la liste des occurrences :

- couleurs en dur (`Color(`, `Colors.`), tailles de police, marges et rayons numériques, `TextStyle(` construit directement, `showModalBottomSheet` au lieu de `ouvrirFeuille()` ;
- `IconButton` ou bouton sans texte dépourvu de `tooltip` ; zones tactiles inférieures à 44 ; information transmise par la seule couleur (statuts d'échéance, verrous) ; lignes d'information non regroupées pour les lecteurs d'écran ;
- rédaction de toutes les chaînes affichées : vouvoiement, tirets cadratins (`—`), boutons « OK » seuls ou libellés vagues, dates hors format JJ/MM/AAAA, termes juridiques non expliqués, phrases trop longues, fautes.

Puis vérification sur l'émulateur, avec captures dans le rapport : parcours d'onboarding complet, accueil, fiche d'un bien (chaque onglet), révision et courrier, réglages, mode gratuit et Premium ; affichage avec la plus grande taille de texte du système ; un jeu de 20 biens avec des noms et adresses très longs ; mode sombre si le design system le prévoit. Confronte chaque écran au design system.

## Axe 5 : architecture, données, publication

- Couches : aucun import de Flutter ou de drift dans `lib/domain/` ; aucun écran n'utilise drift directement ; écritures faites dans des cas d'usage avec `transactions.executer`.
- Confidentialité : l'INSEE est le seul appel réseau (recherche de `http`, `Uri`, `url_launcher` hors appels et emails) ; permissions Android et iOS déclarées, chacune justifiée, avec les textes d'explication iOS en français ; données des locataires dans les journaux (`print`, `debugPrint`).
- Notifications : limite de 60 respectée, reprogrammation après redémarrage, comportement si l'autorisation est refusée.
- Robustesse : base vide, INSEE indisponible, photo supprimée du disque, sauvegarde corrompue ou d'un schéma plus récent.
- Publication : état de la liste « Avant publication » de `decisions.md`, identifiant d'application, version, icônes, mentions légales, ce qui manque pour iOS (jamais testé).

## Rapport

Fichier `docs/audit-AAAA-MM-JJ.md` (date du jour), structuré ainsi :

1. Synthèse en quelques phrases : état général, nombre de constats par sévérité, les trois priorités.
2. Résultats des commandes (analyse, tests, couverture, génération, dépendances).
3. Constats par axe, chacun avec : identifiant (A1-01, A2-03…), sévérité (**bloquant** : faux, dangereux pour l'utilisateur ou empêche la publication ; **important** : écart net à une règle documentée ; **mineur** : cosmétique ou amélioration), preuve, règle concernée, correction proposée et test à ajouter.
4. Tableau de conformité de `decisions.md`.
5. À vérifier manuellement.
6. Lots de correction proposés, dans l'ordre où tu les ferais.

Avant de commencer, présente-moi en quelques lignes ton plan et le temps que tu estimes pour chaque axe. À la fin, donne-moi la synthèse et attends ma validation avant toute correction.
