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
    utils/                       ← calcul de dates, identifiants
  domain/                        ← Dart pur, sans Flutter ni base de données
    entities/                    ← Bailleur, Bien, Bail, Locataire, Echeance, Rappel…
    repositories/                ← interfaces d'accès aux données
    services/                    ← calculs métier (bail, révision IRL, échéances)
  data/
    local/                       ← schéma SQLite (drift)
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
- Remplir la table IRL à partir des publications INSEE (aucune valeur inventée).
