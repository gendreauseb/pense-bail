# Conventions de code (détail)

À lire avant d'ajouter une fonctionnalité, une table ou des tests. Les règles
incontournables sont résumées dans [CLAUDE.md](../CLAUDE.md).

## Couches

- `lib/domain/` : Dart pur, sans Flutter ni drift.
  - `entities/` : classes immuables avec `copyWith`. Un champ facultatif
    effaçable s'écrit `Object? champ = inchange` puis
    `choisir(champ, this.champ)` (`copie.dart`).
  - `repositories/repositories.dart` : interfaces. Convention :
    `surveiller…` retourne un `Stream`, les autres méthodes un `Future`.
  - `services/` : calculs purs (`abstract final class` à méthodes
    statiques). La date du jour est toujours passée en paramètre, jamais lue
    dans le service.
  - `usecases/` : opérations qui écrivent (classes `Gestion…`,
    `ReviserLoyer`, `FinaliserOnboarding`), dans `transactions.executer`.
- `lib/data/` : implémentations drift (`Drift…Repository`), services
  techniques (notifications, photos, IRL, sauvegarde), `providers.dart`.
- `lib/features/<fonctionnalité>/` : écrans et widgets privés. Un écran
  utilise les providers et les cas d'usage, jamais drift directement.
- `lib/core/` : configuration (`config/`), formats, validation, dates,
  widgets et PDF partagés.
- `lib/app/` : design system, routes, routeur, coque, état global
  (`etat_app.dart` : onboarding terminé, date du jour, échéance à ouvrir).

## Nommage

Le code métier et l'interface sont en français (classes, méthodes,
variables, messages), y compris les tests. Les termes techniques Flutter ou
anglais restent tels quels (`build`, `copyWith`, `Provider`).

## État et navigation

- Riverpod 3 : `Provider` pour les dépendances, `StreamProvider` pour les
  données de la base (`…FluxProvider`, `family` par identifiant,
  `autoDispose` pour les écrans de détail), `Notifier` pour l'état
  applicatif. Tout est surchargeable dans les tests.
- go_router : chemins dans `Routes` (`routes.dart`). Les écrans plein écran
  sont des routes de premier niveau (au-dessus de la barre) ; les
  formulaires d'un bien sont des sous-routes de `/biens/fiche/:id`.
  Paramètres facultatifs via `Routes.avec(chemin, {...})`.
- Panneaux du bas : toujours `ouvrirFeuille()` (au-dessus de la barre de
  l'app, marge pour la barre de navigation Android).
- Après un `await`, vérifier `context.mounted`, ou récupérer
  `Navigator.of(context)` / `ScaffoldMessenger.of(context)` avant l'appel.

## Base de données (drift)

- Tables dans `data/local/tables.dart`, liées aux entités par
  `@UseRowClass(…, generateInsertable: true)`. Dates stockées en texte
  (`build.yaml`), énumérations en texte (`textEnum`), clés étrangères avec
  suppression en cascade (`PRAGMA foreign_keys = ON`).
- Après toute modification d'une table : `dart run build_runner build`.
- Changement de schéma : incrémenter `schemaVersion`, ajouter l'étape dans
  `onUpgrade` (`if (de < N)`), colonnes ajoutées nullables ou avec valeur
  par défaut. Les sauvegardes JSON d'un schéma plus ancien doivent rester
  restaurables : vérifier `test/data/sauvegarde_test.dart`.
- Réglages clé / valeur : clés dans `ClesReglages`.

## Montants, dates, textes

- Montants en centimes (`int`). Affichage uniquement via `Formats` :
  `montant` (centimes seulement si non nuls), `montantComplet` (toujours les
  centimes : courriers, calculs), `parMois`, `pourcentage`, `decimal` (IRL).
- Saisie : `Formats.parseMontant` / `parseDecimal` ; champs `ChampMontant`,
  `ChampDate`. Champ facultatif enregistré via `facultatif()` (vide →
  `null`).
- Dates métier sans heure (`Dates.jour`), calculs de mois bornés
  (`Dates.ajouterMois`), écarts en jours via `Dates.joursEntre`.
- Adresses : `adresseComplete` (une ligne) et `lignesAdresse` (courrier,
  complément avant la voie).
- Validation : `Validateurs` (message clair ou `null`), puis
  `validerEtMontrerErreur(cle)` qui fait défiler jusqu'à la première erreur.

## Rappels et notifications

- Rappels par défaut : préférences de l'utilisateur
  (`GestionPreferencesRappels`), sinon `ConfigApp.rappelsParDefautJours`.
- `NotificationsLocales` reprogramme tout à chaque changement des tables
  échéances, rappels, biens ou réglages (60 notifications max, 9 h, heure
  approximative).
- Les échéances automatiques ne sont recalculées que si le type de location,
  le type de bail, les dates ou la durée changent (`GestionBiens`).

## Accessibilité

- Chaque ligne d'information est un seul élément pour les lecteurs d'écran
  (`Semantics(container: true, label: …, excludeSemantics: true)`).
- Bouton sans texte : `tooltip` obligatoire.
- Zone tactile ≥ 44 × 44 ; la mise en page doit supporter les grandes
  tailles de texte.

## Tests

- `flutter test` et `flutter analyze` sans erreur avant de rendre la main.
- Aides dans `test/helpers/` (ne pas nommer ces fichiers `*_test.dart`) :
  - `baseDeTest()` : base SQLite en mémoire ;
  - `unBien()`, `unBail()` : fabriques ;
  - `appDeTest(db:, aujourdhui:)` : l'app complète, date figée
    (`AujourdhuiFixe`), notifications inactives, réseau simulé
    indisponible.
- `test/flutter_test_config.dart` initialise les formats français.
- Tests de widgets :
  - taille d'écran réaliste : `tester.view.physicalSize = Size(1080, 2400)`,
    `devicePixelRatio = 2.625` ;
  - écritures en base réellement asynchrones : `tester.runAsync(...)` puis
    `pump`, ou une boucle d'attente bornée ;
  - `rootBundle.clear()` dans `setUp` si le test charge des assets (table
    IRL) ;
  - vérifier le texte lu par les lecteurs d'écran avec
    `find.bySemanticsLabel` ; les éléments hors écran d'une liste ne sont
    pas construits (`scrollUntilVisible`) ;
  - espace insécable des montants : `String.fromCharCode(0xA0)`.
- Un bug corrigé reçoit un test qui échoue sans la correction.

## Vérification sur appareil

Émulateur Android `Medium_Phone_API_35` (navigation par gestes : penser aux
téléphones à 3 boutons). Construire avec `flutter build apk --debug`,
installer avec `adb install -r`, lancer l'identifiant
`fr.bailleurapp.bailleur_app`, capturer l'écran avec `adb shell screencap`.
Les données présentes sur l'émulateur peuvent appartenir à l'utilisateur :
ne rien modifier sans son accord, supprimer les fichiers de test créés.

## Commits

Uniquement à la demande de l'utilisateur. Message en français : titre court
(« Étape 6 : réglages »), puis un paragraphe décrivant le contenu, puis la
ligne `Co-Authored-By` indiquée par l'outil.
