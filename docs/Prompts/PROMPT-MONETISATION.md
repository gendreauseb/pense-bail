# Pense-Bail : gratuit / Premium et mode bêta (sans RevenueCat)

Lis d'abord `CLAUDE.md`, puis `docs/conventions-code.md`, `docs/design-system.md` et `docs/decisions.md`. Toutes leurs règles s'appliquent ici (couches, Riverpod, tokens, rédaction, accessibilité, tests, pas de tiret cadratin).

## Objectif

Introduire une version gratuite et une version Premium, sans aucun achat réel pour l'instant. Les bêta-testeurs doivent pouvoir basculer eux-mêmes entre les deux modes depuis les réglages, pour voir les différences et tester la perte du Premium. Plus tard, RevenueCat remplacera uniquement la source du statut : rien d'autre dans l'app ne doit en dépendre.

## Règles produit (décisions prises, à reporter dans `docs/decisions.md`)

Version gratuite :
- un seul bien actif ;
- onboarding, fiche du bien, bail, locataires ;
- tableau de bord des échéances et rappels ;
- alerte DPE (logements F et G) ;
- outil de révision de loyer : calcul et résultat visibles.

Premium :
- biens actifs illimités ;
- courrier de révision de loyer (génération du PDF) ;
- rentabilité : onglet rentabilité, journal des mouvements, cases « Loyer reçu », récapitulatif annuel ;
- carnet d'artisans : onglet de la barre de navigation, onglet de la fiche, interventions.

Perte du Premium :
- aucune donnée n'est jamais supprimée ni modifiée par le changement de mode ;
- le bien actif en gratuit est toujours le plus ancien : tri par `creeLe`, puis `ordre`, puis `id` (les biens créés à l'onboarding partagent le même `creeLe`). Jamais la position d'affichage seule, puisque `ordre` est modifiable ;
- si ce bien est supprimé, le plus ancien des biens restants devient le bien actif ;
- les autres biens restent visibles partout (accueil, liste, fiche) mais passent en lecture seule : pas de modification, pas d'ajout de bail, locataire, échéance ou intervention ;
- leurs échéances restent affichées sur l'accueil et leurs notifications continuent d'être programmées. On peut toujours marquer une échéance comme faite ou la reporter, sinon les rappels continueraient sans fin : c'est l'information vitale, le Premium débloque la gestion ;
- les fonctionnalités Premium redeviennent verrouillées, mais ce qui a déjà été produit reste consultable (courriers de révision générés, historique des révisions, données de rentabilité déjà saisies en lecture seule) ;
- l'ajout d'un bien au-delà du premier est refusé en gratuit, y compris dans le cas d'usage (pas seulement dans l'interface).

## Architecture attendue

Domaine (Dart pur) :
- `lib/domain/entities/droits.dart` : `Droits` (immuable) avec au minimum `estPremium` et `maxBiensActifs` (`null` = illimité), plus un enum `Fonctionnalite` (`biensIllimites`, `courrierRevision`, `rentabilite`, `artisans`) et une méthode `autorise(Fonctionnalite)`. Les écrans demandent « cette fonctionnalité est-elle disponible ? », jamais « l'utilisateur a-t-il payé ? ».
- Interface `SourceDroits` dans `repositories.dart` : `Stream<Droits> surveiller()`.
- `lib/domain/services/acces_biens.dart` : calcul pur des identifiants de biens actifs à partir de la liste des biens et des `Droits`.
- Le cas d'usage de création de bien (`GestionBiens`) reçoit les droits (ou un accès à la source) et refuse au-delà de la limite avec une erreur métier claire.

Données :
- `lib/data/droits/droits_beta.dart` : implémentation de `SourceDroits` qui lit une clé de la table des réglages (`ClesReglages.modePremiumBeta`). C'est le seul fichier que RevenueCat remplacera. Dans un build non bêta, elle renvoie toujours la version gratuite.
- Exclure cette clé de la sauvegarde et de la restauration (`ServiceSauvegarde`), et vérifier `test/data/sauvegarde_test.dart` : un statut simulé ne doit pas voyager avec les données.
- Providers dans `providers.dart` : `sourceDroitsProvider`, `droitsProvider` (StreamProvider), `biensActifsProvider` (ensemble d'identifiants). Surchargeables dans les tests ; ajouter un paramètre `droits` à `appDeTest()`.

Configuration :
- `ConfigApp.estBeta = bool.fromEnvironment('BETA')`, activé par `--dart-define=BETA=true`. Sans ce drapeau, la section bêta n'existe pas et l'app est en gratuit.
- `ConfigApp.maxBiensGratuit = 1`.
- Mode par défaut d'une installation bêta : Premium (à confirmer, voir plus bas).

Interface (widgets partagés dans `lib/core/widgets/`, tokens uniquement) :
- un composant de verrou réutilisable (bandeau ou ligne avec icône cadenas, libellé lisible par les lecteurs d'écran, information jamais transmise par la couleur seule) qui explique en une phrase ce que débloque le Premium ;
- un écran « Pense-Bail Premium » (route plein écran dans `Routes`) qui présente ce qui est inclus. Aucun achat : un texte indiquant que l'abonnement sera bientôt disponible, et en bêta un bouton qui active le mode Premium simulé ;
- un badge discret dans l'en-tête de l'accueil, visible uniquement en bêta, qui indique le mode actif (« Bêta : gratuit » ou « Bêta : Premium »).

Section « Mode bêta » dans `reglages_page.dart` (uniquement si `ConfigApp.estBeta`) :
- un interrupteur Gratuit / Premium ;
- une action « Simuler la fin de l'abonnement » qui passe en gratuit ET affiche le message que verrait un vrai abonné à l'expiration : ce qui reste accessible, quel bien reste actif (par son nom) et que rien n'a été supprimé. Ce message apparaît une seule fois, sur l'accueil.

## Découpage en phases

Applique la méthode de `CLAUDE.md` : avant chaque phase, présente brièvement le plan et les choix techniques ; après, résumé, défauts trouvés, points à confirmer, puis attends ma validation avant la phase suivante. `flutter analyze` et `flutter test` sans erreur à chaque fin de phase. Pas de commit sans ma demande.

1. **Socle** : entité `Droits`, `Fonctionnalite`, `SourceDroits`, `DroitsBeta`, service `AccesBiens`, providers, clé de réglage, exclusion de la sauvegarde, configuration bêta. Tests unitaires du calcul du bien actif (ordre modifié, `creeLe` identiques, suppression du plus ancien) et de la source bêta.
2. **Mode bêta dans les réglages** : section, interrupteur, badge de l'accueil. Test de widget : la section n'apparaît pas hors bêta.
3. **Limite de biens** : refus dans `GestionBiens`, bouton « + » et ajout de bien qui mènent vers l'écran Premium en gratuit, biens verrouillés en lecture seule dans la liste et la fiche, échéances toujours visibles et pouvant être marquées faites. Tests de domaine et de widgets.
4. **Fonctionnalités Premium** : verrou sur la génération du courrier de révision (le calcul reste visible), sur l'onglet rentabilité et le récapitulatif, sur les artisans (onglet de la barre et onglet de la fiche). Ce qui existe déjà reste consultable.
5. **Écran Premium et fin d'abonnement simulée** : écran de présentation, action de simulation, message unique sur l'accueil.
6. **Finitions** : mise à jour de `docs/decisions.md` (décisions ci-dessus, section « Avant publication » : brancher RevenueCat dans `SourceDroits`), de `docs/cahier-des-charges.md`, vérification sur l'émulateur Android des deux modes et du passage Premium vers gratuit avec plusieurs biens (sans toucher à mes données existantes sans mon accord).

## Points à me signaler dans le plan de la phase 1

- Onboarding en mode gratuit : l'étape « nombre de biens » propose jusqu'à 20 biens. Je propose de laisser l'onboarding créer tous les biens déclarés (les données sont saisies, rien n'est perdu) ; ceux au-delà du premier sont simplement verrouillés ensuite. Dis-moi si tu vois un problème d'expérience.
- Mode par défaut à l'installation en bêta : Premium (pour que les testeurs découvrent tout), sauf avis contraire.
- Tout autre endroit du code où un bien est modifié sans passer par `GestionBiens` et qui contournerait le verrou.
