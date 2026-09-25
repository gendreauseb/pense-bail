# Table des indices IRL

`irl.json` est la table d'indices embarquée dans l'application. Elle est
chargée au premier lancement, puis complétée par le fichier distant
(`ConfigApp.urlIndicesIrl`) et, en secours, par la saisie manuelle.

**Règle absolue : ne jamais inventer ni extrapoler une valeur.** Chaque valeur
doit être recopiée depuis la publication officielle de l'INSEE
(série « Indice de référence des loyers », idbank à vérifier dans
`ReglesLegales.idbankInseeIrl`).

Format attendu (le fichier distant utilise le même) :

```json
{
  "source": "INSEE - Indice de référence des loyers (IRL)",
  "miseAJour": "2026-07-15",
  "indices": [
    { "annee": 2026, "trimestre": 2, "valeur": 0.00, "datePublication": "2026-07-15" }
  ]
}
```

(`0.00` ci-dessus est un exemple de format, pas une valeur réelle.)

La table est volontairement vide à l'étape 1 : elle sera remplie à l'étape 5
(révision de loyer) à partir des données INSEE vérifiées.
