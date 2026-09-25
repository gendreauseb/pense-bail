// Énumérations du domaine.
//
// ATTENTION : les valeurs sont stockées en base par leur nom (`.name`).
// Renommer une valeur casse les données existantes : ajouter une migration
// si c'est vraiment nécessaire.

enum TypeLogement {
  appartement('Appartement'),
  maison('Maison'),
  immeuble('Immeuble'),
  localProfessionnel('Local professionnel');

  const TypeLogement(this.libelle);
  final String libelle;
}

enum TypeLocation {
  longueDuree('Longue durée'),
  moyenneDuree('Moyenne durée'),
  courteDuree('Courte durée'),
  professionnelle('Professionnelle');

  const TypeLocation(this.libelle);
  final String libelle;

  /// La révision de loyer (IRL) n'est proposée que pour la longue durée.
  bool get revisionDisponible => this == TypeLocation.longueDuree;
}

enum TypeBail {
  vide('Location vide'),
  meuble('Location meublée'),
  mobilite('Bail mobilité'),
  saisonnier('Location saisonnière'),
  professionnel('Bail professionnel'),
  commercial('Bail commercial');

  const TypeBail(this.libelle);
  final String libelle;

  /// Types proposés pendant l'onboarding pour une location longue durée.
  static const longueDuree = [TypeBail.vide, TypeBail.meuble];
}

enum ClasseDpe {
  a,
  b,
  c,
  d,
  e,
  f,
  g;

  String get libelle => name.toUpperCase();
}

enum TypeEcheance {
  revisionLoyer('Révision du loyer'),
  finBail('Fin du bail'),
  dateLimiteConge('Date limite pour donner congé'),
  regularisationCharges('Régularisation des charges'),
  assurancePno('Renouvellement assurance PNO'),
  entretienChaudiere('Attestation d\'entretien de la chaudière'),
  diagnostic('Validité d\'un diagnostic'),
  taxeFonciere('Taxe foncière'),
  declarationRevenus('Déclaration des revenus fonciers'),
  personnalisee('Rappel personnel');

  const TypeEcheance(this.libelle);
  final String libelle;
}

enum StatutEcheance { aFaire, faite }

enum TypeDiagnostic {
  dpe('DPE (performance énergétique)'),
  electricite('Diagnostic électricité'),
  gaz('Diagnostic gaz'),
  plomb('Constat de risque d\'exposition au plomb (CREP)'),
  amiante('Diagnostic amiante'),
  erp('État des risques (ERP)');

  const TypeDiagnostic(this.libelle);
  final String libelle;
}

enum MetierArtisan {
  plombier('Plombier'),
  electricien('Électricien'),
  chauffagiste('Chauffagiste'),
  serrurier('Serrurier'),
  peintre('Peintre'),
  multiservice('Multiservice'),
  autre('Autre');

  const MetierArtisan(this.libelle);
  final String libelle;
}

enum SensMouvement { recette, depense }

enum CategorieMouvement {
  loyer('Loyer', SensMouvement.recette),
  autreRecette('Autre recette', SensMouvement.recette),
  travaux('Travaux', SensMouvement.depense),
  intervention('Intervention artisan', SensMouvement.depense),
  taxeFonciere('Taxe foncière', SensMouvement.depense),
  assurance('Assurance', SensMouvement.depense),
  copropriete('Charges de copropriété', SensMouvement.depense),
  credit('Crédit', SensMouvement.depense),
  fraisGestion('Frais de gestion', SensMouvement.depense),
  autreDepense('Autre dépense', SensMouvement.depense);

  const CategorieMouvement(this.libelle, this.sens);
  final String libelle;
  final SensMouvement sens;
}

enum SourceIndice { insee, manuel }
