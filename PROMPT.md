# Prompt : application mobile d'aide aux propriétaires bailleurs

## 1. Contexte et vision

Tu vas m'aider à développer une application mobile destinée aux propriétaires bailleurs particuliers en France, qui possèdent en général entre 1 et 10 biens.

Ce n'est PAS un logiciel de gestion locative complet. C'est une boîte à outils simple qui fait trois choses très bien :
1. Ne jamais rater une date importante (révision de loyer, fin de bail, assurance, diagnostics, taxes...).
2. Avoir sous la main les informations utiles de chaque bien (bail, locataire, rentabilité, artisans).
3. Gagner du temps sur les tâches administratives récurrentes, en commençant par la révision de loyer avec courrier prêt à envoyer.

Principes directeurs :
- Simplicité avant tout : chaque écran doit être compréhensible sans explication.
- Rien n'est obligatoire au-delà de l'onboarding : l'utilisateur complète les détails quand il veut, l'app l'y invite sans le forcer.
- Public parfois peu à l'aise avec le numérique : grandes zones tactiles, textes lisibles, vocabulaire clair (pas de jargon juridique sans explication).
- Tout en français, montants au format français (1 234,56 €), dates au format JJ/MM/AAAA.

## 2. Stack technique

- Flutter (Android et iOS).
- Stockage local sur l'appareil pour la V1 (base SQLite via drift ou équivalent). Pas de backend, pas de compte en ligne : les données restent sur le téléphone.
- Notifications locales pour les rappels.
- Génération de PDF pour les courriers.
- Accès caméra et galerie pour les photos des biens.
- Architecture propre et évolutive (séparation données / logique / interface) pour pouvoir ajouter plus tard une synchronisation cloud.

## 3. Onboarding (premier lancement uniquement)

Objectif : en moins de 3 minutes, l'utilisateur a configuré son profil et ses biens, et arrive sur un tableau de bord déjà utile.

### Étape 0 : Bienvenue
- 2 ou 3 écrans maximum présentant la promesse : « Ne ratez plus aucune échéance », « Tous vos biens au même endroit », « Vos courriers prêts en un clic ».
- Bouton « Commencer ».

### Étape 1 : Identité du bailleur
Champs : prénom, nom, adresse postale complète (rue, code postal, ville), téléphone, email.
- Validation du format de l'email, du téléphone français et du code postal.
- À quoi ça sert : ces informations servent d'expéditeur dans tous les courriers générés par l'app (révision de loyer, etc.). Afficher une courte phrase l'expliquant pour rassurer l'utilisateur.

### Étape 2 : Nombre de biens
- Sélecteur simple (boutons + et -, de 1 à 20).
- Message : « Vous pourrez en ajouter ou en retirer plus tard. »

### Étape 3 : Fiche de chaque bien (répétée pour chaque bien)
Indicateur de progression visible : « Bien 2 sur 3 ».
Champs :
- Nom du bien (texte libre, ex. « Studio Gambetta ») : c'est le nom affiché partout dans l'app.
- Type de logement : Appartement, Maison, Immeuble, Local professionnel.
- Type de location : Longue durée, Moyenne durée, Courte durée, Professionnelle.
- Champs conditionnels, affichés UNIQUEMENT si « Longue durée » est sélectionné (apparition fluide juste sous le choix du type de location, disparition si l'utilisateur change de type) :
    - Type de bail : Location vide, Location meublée.
    - Date de début du bail (sélecteur de date, pas de date future au-delà de 3 mois).
    - À quoi ça sert : ces deux informations permettent de calculer dès la fin de l'onboarding la date de révision du loyer (date anniversaire par défaut), la date de fin de bail et la date limite pour donner congé. Afficher une courte phrase : « Pour activer vos premiers rappels automatiquement. »
    - Si l'utilisateur change de type de location après avoir rempli ces champs, les valeurs sont conservées en mémoire pendant l'onboarding (au cas où il revient sur « Longue durée ») mais ne sont pas enregistrées pour un autre type.
- Montant du loyer mensuel hors charges (€).
- Montant des charges mensuelles (€).
- Adresse du bien.
- Photo (optionnelle) : prise de vue ou galerie. Si pas de photo, afficher une illustration par défaut selon le type de logement.

Comportements :
- Bouton « Passer la photo ».
- La progression est sauvegardée à chaque étape : si l'utilisateur quitte l'app, il reprend où il en était.
- Écran final récapitulatif (liste des biens créés) avec bouton « Accéder à mon tableau de bord ».

## 4. Tableau de bord (page d'accueil)

C'est le cœur de l'app. Il répond à une question : « Qu'est-ce que je dois faire bientôt ? »

### En-tête
- Salutation avec le prénom.
- Résumé : nombre de biens, total des loyers mensuels, total des charges.

### Bloc « Prochaines échéances »
- Liste chronologique de toutes les échéances à venir, tous biens confondus.
- Chaque ligne : date, intitulé, nom du bien, jours restants.
- Code couleur : rouge (dépassée ou dans moins de 7 jours), orange (moins de 30 jours), vert (plus tard).
- Filtre par bien.
- Appui sur une échéance : ouvre son détail avec actions « Marquer comme faite », « Reporter », « Modifier ».

### Bloc « Mes biens »
- Une carte par bien : photo, nom, type, loyer, prochaine échéance.
- Appui sur une carte : ouvre la fiche détaillée du bien.

### Invitations à compléter
- Pour les biens en longue durée, les échéances de révision, de fin de bail et de congé apparaissent dès la fin de l'onboarding, calculées à partir du type de bail et de la date de début.
- Pour ces biens, une carte discrète invite à renseigner le trimestre et la valeur de l'IRL de référence, nécessaires au calcul exact de la révision.
- Pour les autres types de location, une carte « Complétez [nom du bien] pour activer vos rappels » s'affiche tant que les informations de bail manquent.
- Les échéances génériques qui ne dépendent pas du bail (taxe foncière, déclaration des revenus fonciers) s'affichent pour tous les biens.

### Bouton « Révision de loyer »
- Bouton bien visible sur l'accueil.
- Il propose de choisir parmi les biens en location longue durée uniquement. Les autres apparaissent grisés avec la mention « Révision disponible uniquement pour les locations longue durée ».

## 5. Fiche détaillée d'un bien

Organisée en onglets. Chaque onglet a un état vide clair avec un bouton d'action (« Ajouter les informations du bail », etc.).

### Onglet « Infos »
- Toutes les données de l'onboarding, modifiables.
- Champs complémentaires optionnels : surface, classe DPE (A à G), date du DPE, nombre de lots (pour un immeuble).

### Onglet « Bail et locataire »
- Locataire : nom, prénom, téléphone, email (boutons appeler et écrire).
- Type de bail : location vide, meublée, bail mobilité, saisonnier, bail professionnel ou commercial.
- Date de début du bail, durée.
- Dépôt de garantie.
- Pour la révision : date de révision prévue au bail (par défaut la date anniversaire), trimestre de référence de l'IRL, valeur de l'IRL de référence.
- Ces informations génèrent automatiquement les échéances correspondantes.

### Onglet « Échéances »
Liste des échéances du bien, avec rappels configurables (par défaut J-30, J-7 et J-1).

Échéances calculées automatiquement à partir des données saisies :
- Révision annuelle du loyer (longue durée).
- Fin de bail et date limite pour donner congé, selon le type de bail.
- Régularisation annuelle des charges.

Échéances à date saisie par l'utilisateur (avec suggestion par défaut modifiable) :
- Renouvellement de l'assurance propriétaire non occupant.
- Vérification de l'attestation d'entretien annuel de la chaudière.
- Validité des diagnostics (DPE, électricité, gaz, etc.).
- Taxe foncière.
- Déclaration des revenus fonciers.

Échéances personnalisées : l'utilisateur peut créer ses propres rappels (titre, date, récurrence, notes).

IMPORTANT : toutes les durées et règles légales (durées de bail, préavis, validité des diagnostics) doivent être centralisées dans un seul fichier de configuration, facile à mettre à jour, et vérifiées sur des sources officielles (service-public.fr, INSEE) avant publication. Ne jamais les disperser dans le code.

### Onglet « Rentabilité »
But : que le bailleur voie en un coup d'œil ce que son bien lui rapporte vraiment.
- Données d'investissement (optionnelles) : prix d'achat, frais de notaire, montant des travaux initiaux, mensualité de crédit.
- Charges annuelles : taxe foncière, assurance, charges de copropriété non récupérables, frais divers.
- Suivi mensuel simple : case « Loyer reçu » pour chaque mois, pour repérer immédiatement un retard.
- Journal des dépenses et recettes (date, montant, catégorie, note).
- Indicateurs calculés : cash-flow mensuel et annuel, rendement brut, rendement net.
- Récapitulatif annuel exportable en PDF, utile pour préparer la déclaration de revenus.

### Onglet « Artisans »
But : retrouver en quelques secondes la bonne personne quand un problème survient.
- Carnet d'artisans global, réutilisable sur plusieurs biens.
- Fiche artisan : nom, entreprise, métier (plombier, électricien, chauffagiste, serrurier, peintre, multiservice, autre), téléphone, email, notes.
- Actions rapides : appeler, envoyer un email.
- Historique des interventions par bien : date, artisan, description, coût. Le coût alimente automatiquement l'onglet Rentabilité en tant que dépense.

## 6. Outil de révision de loyer

À quoi ça sert : chaque année, le bailleur peut réviser le loyer selon l'Indice de Référence des Loyers (IRL) publié par l'INSEE. Beaucoup oublient ou ne savent pas faire le calcul, et perdent de l'argent.

### Conditions
- Disponible uniquement pour les biens en location longue durée.
- Si la classe DPE du bien est F ou G, afficher un avertissement clair : la révision n'est pas autorisée pour ces logements.
- Rappeler que la révision ne peut intervenir qu'une fois par an, à la date prévue au bail, et qu'elle n'est pas rétroactive si le bailleur tarde à la demander.

### Étapes
1. Sélection du bien (pré-rempli si lancé depuis une fiche).
2. Vérification des données : loyer actuel hors charges, trimestre de référence, ancien IRL (pré-remplis depuis la fiche si disponibles).
3. Récupération du nouvel IRL : table des indices stockée dans l'app et mise à jour depuis un fichier distant, avec saisie manuelle possible en secours. Ne jamais inventer de valeurs d'indice.
4. Calcul : nouveau loyer = loyer actuel × (nouvel IRL / ancien IRL). La révision porte uniquement sur le loyer hors charges. Arrondi au centime.
5. Résultat : ancien loyer, nouveau loyer, augmentation mensuelle et annuelle, détail du calcul avec les indices et trimestres utilisés.
6. Confirmation : mettre à jour le loyer du bien, enregistrer la révision dans un historique, recalculer la prochaine échéance de révision.

### Courrier généré
- PDF propre et professionnel contenant : coordonnées du bailleur (issues de l'onboarding), coordonnées du locataire, adresse du bien, lieu et date, objet, rappel de la clause de révision, détail du calcul (indices, trimestres, formule), nouveau loyer hors charges, charges inchangées, nouveau total, date d'application, formule de politesse, zone de signature.
- Actions : prévisualiser, partager par email, enregistrer, imprimer.
- Conseil affiché : envoyer en recommandé avec accusé de réception pour garder une preuve.
- Mention discrète : « Outil d'aide, ne remplace pas un conseil juridique. »

## 7. Paramètres
- Modifier le profil du bailleur.
- Réglages des notifications (délais de rappel par défaut, activation par type d'échéance).
- Ajouter, modifier ou supprimer un bien.
- Sauvegarde et restauration des données (export d'un fichier).
- Suppression complète des données.
- Mentions légales et politique de confidentialité (les données restent sur l'appareil).

## 8. Modèle de données (indicatif)
Bailleur, Bien, Bail, Locataire, Echeance, Rappel, Artisan, Intervention, MouvementFinancier, RevisionLoyer, IndiceIRL.

## 9. Design
- Style sobre, rassurant et professionnel (inspiration : applis bancaires modernes).
- Palette calme, une couleur d'accent pour les actions principales, les couleurs d'alerte réservées aux échéances.
- Navigation par barre inférieure : Accueil, Biens, Artisans, Paramètres.
- Accessibilité : contrastes suffisants, tailles de texte respectant les réglages du téléphone.

## 10. Hors périmètre de la V1 (à prévoir pour plus tard)
Quittances de loyer, états des lieux, guide en cas d'impayé, calendrier des obligations DPE, gestion d'un immeuble lot par lot, synchronisation cloud et multi-appareils.

## 11. Méthode de travail
- Avance par étapes et attends ma validation entre chacune : 1) structure du projet et modèle de données, 2) onboarding, 3) tableau de bord, 4) fiche bien, 5) révision de loyer, 6) paramètres.
- Avant chaque étape, présente brièvement ce que tu vas faire et les choix techniques envisagés.
- Si une règle légale te semble incertaine, signale-le au lieu de supposer.