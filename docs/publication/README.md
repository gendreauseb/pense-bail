# Publication sur le Play Store

Procédure pour le test fermé puis la version publique (Android). Les
éléments marqués **[à compléter]** dépendent de l'éditeur.

Fichiers de ce dossier :

- `icone-512.png` : icône de la fiche Store (512 × 512).
- `banniere-1024x500.png` : bannière de la fiche Store.
- `politique-confidentialite.html` : page à publier sur le site de
  l'éditeur ; son adresse va dans la Play Console.

## 1. Clé d'importation (une seule fois)

Google signe l'application distribuée avec sa propre clé (« signature des
applications Play », activée par défaut). Vous signez seulement les fichiers
envoyés, avec une **clé d'importation**. Si elle est perdue ou volée, le
support de la Play Console peut la remplacer, mais cela prend plusieurs
jours : gardez-la en lieu sûr.

1. Créer la clé hors du dépôt (PowerShell) ; `keytool` demande un mot de
   passe et un nom :

   ```powershell
   New-Item -ItemType Directory -Force "$env:USERPROFILE\cles-pense-bail"
   & "C:\Program Files\Android\Android Studio1\jbr\bin\keytool.exe" -genkeypair -v -keystore "$env:USERPROFILE\cles-pense-bail\pense-bail-import.jks" -storetype PKCS12 -keyalg RSA -keysize 2048 -validity 10000 -alias pense-bail
   ```

2. Créer `android/key.properties` (ignoré par git, ne jamais le commiter) :

   ```properties
   storePassword=le mot de passe choisi
   keyPassword=le même mot de passe
   keyAlias=pense-bail
   storeFile=C:/Users/<vous>/cles-pense-bail/pense-bail-import.jks
   ```

3. Sauvegarder le fichier `.jks` et le mot de passe hors de l'ordinateur
   (gestionnaire de mots de passe, clé USB rangée à part).

Sans `key.properties`, un build de publication s'arrête avec un message :
la clé de debug n'est jamais utilisée.

## 2. Construire

Test fermé (interrupteur Premium de la bêta) :

```bash
flutter build appbundle --release --dart-define=BETA=true --build-name=1.0.0-beta.1 --build-number=1
```

Version publique (sans le drapeau) :

```bash
flutter build appbundle --release --build-name=1.0.0 --build-number=10
```

- Fichier à envoyer : `build/app/outputs/bundle/release/app-release.aab`.
- `--build-number` augmente à chaque envoi, toutes pistes confondues ; un
  numéro déjà utilisé est refusé. `--build-name` : `1.0.0-beta.2`,
  `1.0.0-beta.3`… pour la bêta.
- Gradle refuse un build bêta sans « beta » dans le numéro de version, et
  une version publique qui en contient : dans la Play Console, une version
  de test se reconnaît donc toujours.
- **Ne jamais promouvoir une version du test fermé en production** :
  chaque utilisateur aurait l'interrupteur Premium gratuit. La version
  publique est reconstruite sans `--dart-define=BETA=true`.

## 3. Play Console

### Compte

- Statut de professionnel (règlement européen sur les services
  numériques) : oui, l'application sera payante. Coordonnées de la
  micro-entreprise **[à compléter]** ; l'adresse et le téléphone sont
  affichés sur la fiche Store.
- Compte personnel créé après le 13/11/2023 : la production n'est ouverte
  qu'après un test fermé de 14 jours avec au moins 12 testeurs inscrits
  sans interruption (le test interne ne compte pas).

### Fiche Store (proposition)

- Nom : Pense-Bail
- Description courte (80 caractères au plus) :
  « Échéances, révision des loyers et infos de vos biens loués, sans oubli. »
- Description longue :

  > Pense-Bail aide les propriétaires bailleurs particuliers (1 à 10 biens)
  > à ne rater aucune échéance de leurs locations.
  >
  > • Les dates importantes calculées pour vous : révision du loyer, fin de
  > bail, date limite pour donner congé, régularisation des charges, taxe
  > foncière, déclaration des revenus fonciers, diagnostics.
  > • Des rappels avant chaque échéance, réglables.
  > • La révision du loyer selon l'IRL publié par l'INSEE, avec le courrier
  > prêt à envoyer à votre locataire.
  > • Toutes les infos de chaque bien au même endroit : bail, locataires,
  > artisans, dépenses et loyers reçus, rentabilité.
  >
  > Simple et en français, sans compte à créer. Vos données restent sur
  > votre téléphone : ni publicité, ni mesure d'audience.
  >
  > Pense-Bail est un outil d'aide : il ne remplace pas un conseil juridique
  > ou fiscal.

- Icône : `icone-512.png` ; bannière : `banniere-1024x500.png`.
- Captures d'écran (2 au moins, téléphone) : **à faire** sur l'émulateur
  avec des données d'exemple (accueil, fiche d'un bien, révision,
  courrier).
- Catégorie : Productivité. Email de contact **[à compléter]**.
- Politique de confidentialité : adresse de la page publiée
  **[à compléter]**.

### Contenu de l'application (réponses proposées)

- Accès à l'application : tout est accessible sans identifiants.
- Annonces : aucune.
- Classification du contenu (questionnaire IARC) : catégorie
  « Utilitaires, productivité, communication ou autre » ; aucune violence,
  sexualité, langage grossier, substance, jeu d'argent ; pas d'échange
  entre utilisateurs ni de partage de position. Achats numériques : non
  pour la bêta ; oui quand l'abonnement sera branché.
- Public cible : 18 ans et plus.
- Sécurité des données :
  - Collecte : **non**. Google ne demande de déclarer que les données
    envoyées hors du téléphone par l'application ; Pense-Bail n'envoie rien
    (la demande à l'INSEE ne contient aucune donnée de l'utilisateur), et
    les partages de courriers ou de sauvegardes sont faits par
    l'utilisateur lui-même.
  - Sauvegarde automatique du téléphone : c'est Android qui copie les
    données dans le compte Google de l'utilisateur ; l'éditeur n'y a pas
    accès. Le guide de Google n'en parle pas : lecture à confirmer en
    remplissant le formulaire.
  - À revoir au branchement de l'abonnement (identifiant et historique
    d'achat).
- Applications financières, de santé, d'actualité, gouvernementales : non.

## 4. Test fermé

1. Tester et publier : Test fermé, créer une piste, pays : France.
2. Testeurs : une liste d'adresses Gmail ou un groupe Google. En recruter
   15 ou plus, pour garder 12 inscrits pendant 14 jours.
3. Importer le `.aab` bêta, écrire les notes de version, envoyer en
   examen (quelques jours la première fois).
4. Envoyer aux testeurs le lien d'inscription, avec ces consignes :
   rejoindre le test depuis le lien, installer depuis le Play Store, ouvrir
   l'application régulièrement, **ne pas quitter le test** avant la fin des
   14 jours.
5. Corrections pendant le test : nouveau build bêta (numéro supérieur),
   même piste.
