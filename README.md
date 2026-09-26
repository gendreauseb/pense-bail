# Pense-Bail

Boîte à outils mobile (Flutter, Android et iOS) pour les propriétaires bailleurs
particuliers. Cahier des charges : [PROMPT.md](PROMPT.md). Design system :
[UI.md](UI.md), qui fait foi pour tout ce qui touche l'interface.

## Architecture

```
lib/
  core/
    config/regles_legales.dart   ← SEULE source des règles légales (durées, préavis…)
    config/config_app.dart       ← réglages produit (rappels J-30/J-7/J-1, seuils de couleur…)
    format/                      ← montants (1 234,56 €) et dates (JJ/MM/AAAA)
    pdf/                         ← style des documents PDF, aperçu / partage / impression
    utils/                       ← calcul de dates, identifiants
  domain/                        ← Dart pur, sans Flutter ni base de données
    entities/                    ← Bailleur, Bien, Bail, Locataire, Echeance, Rappel…
    repositories/                ← interfaces d'accès aux données
    services/                    ← calculs métier (bail, révision IRL, échéances)
  data/
    local/                       ← schéma SQLite (drift)
    irl/                         ← table IRL : import embarqué, mise à jour INSEE, saisie
    repositories/                ← implémentation locale des interfaces
    providers.dart               ← injection (Riverpod)
  app/design/                    ← tokens (AppColors, AppTextStyles, AppSpacing, AppRadius) et thème
  app/                           ← navigation (go_router), coque de l'app
  features/                      ← écrans, un dossier par fonctionnalité
assets/irl/                      ← table des indices IRL (voir LISEZMOI.md)
```

Les écrans ne dépendent que des interfaces de `domain/repositories` : une
synchronisation cloud pourra être ajoutée en fournissant d'autres
implémentations.

Toutes les données restent sur le téléphone. Le seul accès réseau est la
lecture de la série IRL publiée par l'INSEE (`ConfigApp.urlIndicesIrl`,
accès libre, aucune donnée envoyée), au plus une fois par semaine à
l'ouverture de l'outil de révision, ou à la demande.

## Commandes

```bash
flutter pub get
dart run build_runner build   # à relancer après toute modification des tables
flutter test
flutter run
```

## Avant publication

- Vérifier chaque règle de `regles_legales.dart` (champs `aVerifier`) sur
  service-public.fr / Légifrance, puis renseigner `derniereVerification`.
- Régénérer `assets/irl/irl.json` depuis l'INSEE (voir
  [assets/irl/LISEZMOI.md](assets/irl/LISEZMOI.md)) : aucune valeur inventée.
