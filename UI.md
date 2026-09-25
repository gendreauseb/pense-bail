# Pense-Bail : règles de design (design system V1)

## 1. Intention

Pense-Bail doit inspirer confiance et calme : le bailleur ouvre l'app pour être rassuré, pas pour être stressé. Le style est sobre, chaleureux et « patrimonial » : un bleu canard profond sur un fond ivoire, des titres à empattements, beaucoup d'air, peu d'ombres. L'information clé de chaque écran est une date ou un montant, jamais une photo.

Toutes ces valeurs doivent être centralisées dans des fichiers de tokens (AppColors, AppTextStyles, AppSpacing, AppRadius) et un ThemeData unique. Aucune couleur, taille ou marge ne doit être écrite en dur dans les écrans.

## 2. Couleurs

### Base
| Token | Hex | Usage |
| --- | --- | --- |
| primary | #0E4F58 | Bleu canard : boutons principaux, onglet actif, navigation active, carte de synthèse |
| primaryPressed | #0A3A41 | État appuyé des éléments primaires |
| primarySoft | #E2EEEE | Fonds de tuiles d'icônes, illustration des appartements, pastilles « plus tard » |
| background | #F5F3EE | Fond ivoire de tous les écrans |
| surface | #FFFFFF | Cartes, barre de navigation, barre d'action fixe |
| border | #E3DED4 | Bordure des cartes et des puces |
| divider | #EEEAE2 | Séparateurs entre lignes d'une liste |
| borderDashed | #BFB7A8 | Bouton en pointillés « Ajouter un rappel » |
| textPrimary | #14262A | Texte principal, puce de filtre active (fond) |
| textSecondary | #5B6B6E | Sous-titres, légendes, icônes inactives |
| textMuted | #4A5A5D | Paragraphes d'introduction, pastilles neutres |
| dotInactive | #CFC8BA | Points de pagination inactifs |
| sand | #EFE9DE | Illustration par défaut des maisons |
| sandIcon | #6B5530 | Pictogramme sur fond sand |

### Statuts des échéances (règle stricte)
| Statut | Condition | Fond | Texte |
| --- | --- | --- | --- |
| Urgent | Dépassée ou dans 7 jours ou moins | #FBE4D6 | #9A3A0B |
| Bientôt | Dans 8 à 30 jours | #FAEFD2 | #7A5200 |
| À venir | Dans 31 à 90 jours | #E2EEEE | #0E4F58 |
| Lointain | Au-delà de 90 jours | #F0EDE6 | #4A5A5D |

- Pastille de notification non lue : #C2530F.
- Bannières d'information (données à compléter) : fond #FAEFD2, texte #5A3D00.
- La couleur n'est jamais le seul indicateur : chaque statut affiche aussi un texte (nombre de jours, mois ou année).

## 3. Typographie

Deux familles, embarquées dans l'app (pas de chargement réseau, l'app doit fonctionner hors ligne) :
- **Fraunces** (poids 600) pour les titres et les chiffres clés.
- **Manrope** (400, 600, 700) pour tout le reste.

| Style | Police | Taille / interligne | Poids | Usage |
| --- | --- | --- | --- | --- |
| displayLarge | Fraunces | 34 / 1.12 | 600 | Titre des écrans de bienvenue |
| headline | Fraunces | 27 à 28 | 600 | Titre de page (« Bonjour Marc », nom du bien) |
| title | Fraunces | 21 | 600 | Titres de section (« Prochaines échéances ») |
| figure | Fraunces | 20 à 24 | 600 | Montants et chiffres clés, jour dans une tuile de date |
| body | Manrope | 16 / 1.5 | 400 | Paragraphes |
| rowTitle | Manrope | 15 | 700 | Titre d'une ligne de liste |
| button | Manrope | 17 | 700 | Bouton principal |
| label | Manrope | 13 à 14 | 600 à 700 | Liens, onglets, puces |
| secondary | Manrope | 13 | 400 | Sous-titre d'une ligne, adresses |
| caption | Manrope | 12 | 600 à 700 | Pastilles de statut, légendes |
| overline | Manrope | 12, majuscules, espacement 0,8 | 700 | En-têtes de groupe (« CALCULÉES DEPUIS LE BAIL ») |
| nav | Manrope | 11 | 600 (700 si actif) | Libellés de la barre de navigation |

Les tailles doivent suivre le réglage de taille de texte du téléphone sans casser la mise en page.

## 4. Espacements, rayons, dimensions

- Marge horizontale des écrans : 24.
- Espacement entre sections : 18 à 22. Espacement dans un bloc : 10 à 12.
- Padding interne d'une ligne de liste : 14. Padding d'une carte : 16.
- Rayons : cartes 18, carte de synthèse 20, boutons 14, tuiles d'icône et de date 12, haut d'un panneau superposé 24, puces et pastilles entièrement arrondies.
- Hauteurs : bouton principal 56, bouton secondaire 48, puces de filtre 36, puces d'information 30, barre de navigation 84.
- Toute zone tactile fait au moins 44 × 44.
- Ombres : quasiment absentes. Seuls le bouton central de la navigation et les cartes d'illustration de l'écran de bienvenue ont une ombre douce. Les cartes se distinguent par leur bordure, pas par une ombre.

## 5. Iconographie et illustrations

- Icônes au trait (style Lucide), épaisseur 2, extrémités arrondies, 20 à 22 px. Jamais d'emoji.
- Icônes inactives en textSecondary, actives en primary.
- Illustration par défaut quand un bien n'a pas de photo : un grand pictogramme au trait centré sur un fond coloré. Appartement ou immeuble sur primarySoft, maison sur sand, local professionnel sur primarySoft. L'app doit rester belle sans aucune photo.
- Les photos réelles sont affichées en format recadré (cover), jamais déformées.

## 6. Composants

- **Bouton principal** : fond primary, texte blanc, 56 de haut, pleine largeur, rayon 14.
- **Lien texte** : primary, 14, gras, sans soulignement.
- **Carte** : fond surface, bordure border 1 px, rayon 18.
- **Carte de synthèse** : fond primary, texte blanc, 3 colonnes égales (valeur en Fraunces, libellé en caption à 85 % d'opacité).
- **Carte d'action** (ex. « Réviser un loyer ») : carte avec tuile d'icône 44 × 44 sur primarySoft, titre, sous-titre et chevron à droite. Toute la carte est cliquable.
- **Tuile de date** : 50 × 54, rayon 12, jour en Fraunces 20 et mois abrégé en majuscules (caption 11, espacement 0,8). Sa couleur suit le statut de l'échéance.
- **Ligne d'échéance** : tuile de date (sur le tableau de bord) ou rien (dans une fiche), titre rowTitle, sous-titre secondary (bien concerné, ou date au format JJ/MM/AAAA avec les rappels), pastille de statut à droite. Les lignes sont regroupées dans une carte et séparées par un divider inset de 14.
- **Pastille de statut** : caption gras, rayon complet, couleurs de la section 2. Texte : « X j » dans les listes denses, « Dans X j » dans une fiche, puis « X mois » au-delà de 90 jours, puis l'année au-delà de 18 mois.
- **Action rapide dans une ligne** : quand une échéance a une action directe (révision de loyer), la pastille est remplacée par un petit bouton primary « Calculer ».
- **Puces de filtre** : 36 de haut, inactive = fond blanc et bordure, active = fond textPrimary et texte blanc. Défilement horizontal.
- **Puces d'information** (type de bien, type de location) : 30 de haut, fond blanc, bordure, non cliquables.
- **Bannière d'information** : fond #FAEFD2, rayon 14 à 16, texte 13 en #5A3D00, action à droite (« Compléter », « Ajouter »). Réservée aux données manquantes.
- **Onglets** : texte label, inactif en textSecondary, actif en textPrimary gras avec soulignement primary de 3 px, ligne de base border sous l'ensemble.
- **Bouton pointillé** : 48 de haut, bordure 1,5 px pointillée borderDashed, fond transparent, pour ajouter un élément à une liste.
- **Barre de navigation** : fond surface, bordure haute, 5 emplacements : Accueil, Biens, bouton central « + », Artisans, Réglages. Le bouton central fait 56 × 56, rayon 18, fond primary, surélevé de 26 px avec ombre douce ; il ouvre un choix « Ajouter une échéance » ou « Ajouter un bien ».
- **Barre d'action fixe** : en bas de la fiche d'un bien en longue durée, fond surface, bordure haute, bouton principal « Réviser le loyer » et une légende caption centrée en dessous.
- **Pagination** (bienvenue) : point actif allongé 24 × 8 en primary, points inactifs 8 × 8 en dotInactive.

## 7. Écrans de référence

- **Bienvenue** (2 à 3 écrans) : logo en haut, illustration de trois cartes d'échéances légèrement inclinées au centre, titre displayLarge, paragraphe body, pagination, bouton « Commencer » et lien « Passer l'introduction ».
- **Tableau de bord** : date du jour et salutation avec bouton notifications, carte de synthèse, carte d'action « Réviser un loyer », section « Prochaines échéances » (filtres + liste), bannières « Complétez… » le cas échéant, section « Mes biens » en cartes horizontales défilantes (164 de large, illustration de 96 de haut), barre de navigation.
- **Fiche d'un bien** : visuel de 240 de haut (photo ou illustration) avec bouton retour et bouton « Ajouter une photo », panneau ivoire superposé à rayon 24 contenant nom, adresse, puces, carte des chiffres clés (loyer HC, charges, prochaine révision), onglets Infos / Bail / Échéances / Rentabilité / Artisans, contenu de l'onglet, barre d'action fixe si location longue durée.

## 8. Rédaction de l'interface

- Vouvoiement, phrases courtes, vocabulaire simple. Un terme juridique est toujours accompagné d'une explication.
- Dates au format JJ/MM/AAAA, ou jour + mois abrégé en majuscules dans les tuiles (29 SEPT).
- Montants au format français : « 1 150 € », « 620 € / mois ».
- Pas de tiret cadratin dans les textes de l'interface : utiliser une virgule, un deux-points, des parenthèses ou un point.
- Les boutons disent ce qu'ils font (« Réviser le loyer », « Compléter »), jamais « OK » ou « Valider » seuls.

## 9. Accessibilité

- Contraste minimum 4,5:1 pour le texte (3:1 au-delà de 24 px). Les combinaisons de la section 2 respectent cette règle, ne pas les éclaircir.
- Libellé d'accessibilité sur chaque bouton qui ne contient qu'une icône (retour, notifications, « + »).
- Statuts jamais transmis par la couleur seule.

## 10. Hors périmètre V1

Mode sombre non prévu en V1, mais les tokens doivent être structurés pour pouvoir l'ajouter sans toucher aux écrans.