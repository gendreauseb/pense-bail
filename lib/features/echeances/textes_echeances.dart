// Explications en langage clair des échéances (design-system.md §8 : un terme
// juridique est toujours accompagné d'une explication). Les durées citées
// proviennent de ReglesLegales, jamais écrites ici.

import '../../core/config/regles_legales.dart';
import '../../core/format/formats.dart';
import '../../domain/entities/entities.dart';
import '../../domain/services/calculateur_bail.dart';

/// Explication d'une échéance. Le texte s'adapte au [bail] (fin de bail
/// selon la [date] de l'échéance et [aujourdhui], charges en meublé) et au
/// [diagnostic] quand ils sont connus.
String? explicationEcheance(
  TypeEcheance type, {
  Bail? bail,
  DateTime? date,
  DateTime? aujourdhui,
  TypeDiagnostic? diagnostic,
}) {
  final vide = ReglesLegales.bail(TypeBail.vide).preavisCongeBailleurMois;
  final meuble = ReglesLegales.bail(TypeBail.meuble).preavisCongeBailleurMois;
  if (type == TypeEcheance.finBail && bail != null && date != null) {
    final regle = bail.regle;
    final preavis = regle.preavisCongeBailleurMois;
    if (!regle.reconductionTacite && preavis == null) {
      return 'Fin du bail : ce type de bail se termine à cette date, il '
          "n'est pas reconduit.";
    }
    if (regle.reconductionTacite && preavis != null && aujourdhui != null) {
      final limite = CalculateurBail.dateLimiteConge(date, preavis);
      if (aujourdhui.isAfter(limite)) {
        return 'Fin de la période en cours du bail. La date limite pour '
            'donner congé à cette date (${Formats.date(limite)}) est '
            'passée : le bail sera reconduit automatiquement (on dit '
            '« tacitement ») pour la même durée.';
      }
    }
  }
  return switch (type) {
    TypeEcheance.revisionLoyer =>
      'Une fois par an, vous pouvez augmenter le loyer selon l\'Indice de '
          'référence des loyers (IRL) publié par l\'INSEE. La révision '
          'n\'est pas rétroactive : demandez-la à la date prévue.',
    TypeEcheance.finBail =>
      'Fin de la période en cours du bail. Sans congé, le bail est '
          'reconduit automatiquement (on dit « tacitement ») pour la même '
          'durée.',
    TypeEcheance.dateLimiteConge =>
      'Dernier jour pour que votre locataire reçoive votre congé, si vous '
          'souhaitez récupérer ou vendre le logement (préavis de $vide mois '
          'en location vide, $meuble mois en meublée). Envoyez-le en '
          'recommandé avec accusé de réception, bien avant cette date. '
          '${ReglesLegales.noteCalculConge}',
    TypeEcheance.regularisationCharges =>
      'Une fois par an, comparez les provisions de charges versées par le '
          'locataire aux dépenses réelles, puis remboursez ou demandez la '
          'différence.'
          '${bail?.typeBail == TypeBail.meuble ? ' ${ReglesLegales.noteRegularisationMeuble}' : ''}',
    TypeEcheance.assurancePno =>
      'Assurance propriétaire non occupant (PNO) : elle protège votre bien '
          'quand il est loué ou vide. Vérifiez son renouvellement.',
    TypeEcheance.entretienChaudiere =>
      'Le locataire doit faire entretenir la chaudière chaque année. '
          'Demandez-lui l\'attestation d\'entretien.',
    TypeEcheance.diagnostic => [
      'Faites refaire ce diagnostic avant son expiration : il doit être '
          'valide lors de la signature d\'un nouveau bail.',
      if (diagnostic != null) ...[
        ?ReglesLegales.diagnostic(diagnostic).remarque,
        if (ReglesLegales.diagnostic(diagnostic).aVerifier != null)
          ReglesLegales.noteDiagnosticAVerifier,
      ],
    ].join(' '),
    TypeEcheance.taxeFonciere =>
      '${ReglesLegales.taxeFonciere.explication} Date indicative : vérifiez '
          'celle de votre avis d\'imposition.',
    TypeEcheance.declarationRevenus =>
      '${ReglesLegales.declarationRevenus.explication} Date indicative : '
          'vérifiez le calendrier sur impots.gouv.fr.',
    TypeEcheance.personnalisee => null,
  };
}

/// « Se répète chaque année », « tous les 3 ans »…
String? texteRecurrence(int? intervalleMois) => switch (intervalleMois) {
  null => null,
  1 => 'Se répète chaque mois',
  3 => 'Se répète chaque trimestre',
  6 => 'Se répète tous les 6 mois',
  12 => 'Se répète chaque année',
  final m when m % 12 == 0 => 'Se répète tous les ${m ~/ 12} ans',
  final m => 'Se répète tous les $m mois',
};

/// « 30 j, 7 j et 1 j avant » ; « le jour même ».
String? texteRappels(List<int> joursAvant) {
  if (joursAvant.isEmpty) return null;
  final tries = [...joursAvant]..sort((a, b) => b.compareTo(a));
  final morceaux = [
    for (final j in tries) j == 0 ? 'le jour même' : '$j j avant',
  ];
  if (morceaux.length == 1) return 'Rappel ${morceaux.single}';
  final dernier = morceaux.removeLast();
  return 'Rappels ${morceaux.join(', ')} et $dernier';
}

/// Puce d'un délai de rappel : « 30 j avant », « Le jour même ».
String texteDelaiRappel(int jours) =>
    jours == 0 ? 'Le jour même' : '$jours j avant';
