# Pense-Bail

Application Flutter (Android et iOS) pour propriétaires bailleurs
particuliers en France (1 à 10 biens). Boîte à outils simple, pas un
logiciel de gestion locative : ne rater aucune échéance, retrouver les
infos de chaque bien, réviser un loyer avec courrier prêt à envoyer.
Public parfois peu à l'aise avec le numérique : simplicité, textes clairs,
grandes zones tactiles. Tout en français.

## Documents de référence (à lire selon la tâche)

- [docs/cahier-des-charges.md](docs/cahier-des-charges.md) : fonctionnel
  (onboarding, accueil, fiche, révision, réglages).
- [docs/design-system.md](docs/design-system.md) : couleurs, typographie,
  composants, rédaction. **Fait foi pour l'interface ; à relire avant de
  toucher un écran.**
- [docs/conventions-code.md](docs/conventions-code.md) : couches, Riverpod,
  drift et migrations, formulaires, tests, vérification sur émulateur.
- [docs/decisions.md](docs/decisions.md) : décisions prises, points ouverts,
  liste avant publication.

## Commandes

```bash
flutter pub get
dart run build_runner build   # après toute modification de lib/data/local/tables.dart
flutter analyze
flutter test
```

## Architecture

```
lib/core/config/regles_legales.dart   seule source des règles légales
lib/core/config/config_app.dart       réglages produit (rappels, seuils, INSEE…)
lib/core/{format,validation,utils,widgets,pdf}/
lib/domain/   Dart pur : entities, repositories (interfaces), services (calculs), usecases
lib/data/     drift (local/), repositories, notifications, photos, irl, sauvegarde, providers.dart
lib/app/      design/ (tokens, thème), routes, routeur, coque, état global
lib/features/ écrans : onboarding, accueil, echeances, biens, artisans, revision, reglages
```

Stack : Riverpod 3, go_router, drift (SQLite), flutter_local_notifications,
pdf + printing, file_picker, http (INSEE uniquement).

## Règles incontournables

- **Règles légales** : uniquement dans `regles_legales.dart`, avec la source ;
  interprétation incertaine → champ `aVerifier` et signalement à
  l'utilisateur, jamais de supposition. Aucune valeur d'indice IRL inventée.
- **Données locales** : rien ne quitte le téléphone ; seul appel réseau, la
  série IRL de l'INSEE.
- **Interface** : aucune couleur, taille ou marge en dur ; tokens
  (`context.couleurs`, `context.textes`, `AppSpacing`, `AppRadius`,
  `AppSizes`, `AppIcons`) et widgets partagés de `lib/core/widgets/`.
  Panneaux du bas via `ouvrirFeuille()`.
- **Rédaction** : vouvoiement, phrases courtes, terme juridique toujours
  expliqué, pas de tiret cadratin, boutons qui disent ce qu'ils font (jamais
  « OK » seul). Dates JJ/MM/AAAA.
- **Montants** en centimes (`int`), affichés via `Formats` (centimes seulement
  si non nuls ; courriers : toujours).
- **Schéma de base** modifié → `schemaVersion` + étape `onUpgrade` ; les
  anciennes sauvegardes doivent rester restaurables.
- **Accessibilité** : zone tactile ≥ 44, info jamais transmise par la
  couleur seule, libellé sur les boutons icône.
- Code, noms et messages en français ; `flutter analyze` et `flutter test`
  sans erreur avant de rendre la main.

## Méthode de travail

- Avant un changement important : présenter brièvement le plan et les choix
  techniques. Après : résumé, défauts trouvés, points à confirmer ; attendre
  la validation avant d'enchaîner sur autre chose.
- Vérifier en vrai sur l'émulateur Android quand l'interface change (voir
  conventions). Ne pas modifier les données de l'utilisateur sur l'émulateur.
- Commit uniquement quand l'utilisateur le demande (message en français).
- Bug corrigé → test qui échoue sans la correction.

## Pièges connus

- Les outils d'écriture de fichiers décodent `\uXXXX` en caractères réels, et
  les scripts Python ou heredocs peuvent réduire `\'` : pour du Dart, préférer
  les chaînes entre guillemets doubles quand il y a une apostrophe, et
  vérifier les octets après un `\u`.
- Fichiers d'aide de test : ne pas les nommer `*_test.dart`.
- `useSafeArea` d'un bottom sheet ne protège pas le bas de l'écran (d'où
  `ouvrirFeuille()`).
