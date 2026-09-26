# Table des indices IRL

`irl.json` est la table d'indices embarquée dans l'application. Elle est
importée dans la base au premier lancement de l'outil de révision (puis à
chaque nouvelle version de la table), complétée par la mise à jour depuis
l'INSEE et, en secours, par la saisie manuelle.

**Règle absolue : ne jamais inventer ni extrapoler une valeur.**

## Source

Série « Indice de référence des loyers (IRL) », idbank `001515333`, banque de
données macro-économiques de l'INSEE, en accès libre :
<https://bdm.insee.fr/series/sdmx/data/SERIES_BDM/001515333>

La version actuelle (95 trimestres, du T4 2002 au T2 2026) a été générée le
26/09/2026 à partir de cette réponse, sans retouche : chaque valeur, et sa
date de parution au Journal officiel quand l'INSEE la fournit
(`DATE_JO` → `datePublicationJo`), est recopiée telle quelle.

## Mettre à jour la table embarquée

1. Télécharger la réponse SDMX à l'adresse ci-dessus.
2. Pour chaque élément `<Obs>` : `TIME_PERIOD` (« 2026-Q2 » → année 2026,
   trimestre 2), `OBS_VALUE` (valeur), `DATE_JO` (facultatif).
3. Mettre `miseAJour` à la valeur `LAST_UPDATE` de la série et `recupereLe`
   à la date du téléchargement.

L'application ne réimporte la table que si `miseAJour` change. Une valeur de
l'INSEE remplace toujours une saisie manuelle, jamais l'inverse.
