import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/design/design.dart';
import '../../app/etat_app.dart';
import '../../core/config/cles_reglages.dart';
import '../../core/format/formats.dart';
import '../../data/providers.dart';
import '../../data/sauvegarde/service_sauvegarde.dart';

// Sauvegarde, restauration et effacement des données (réglages).

void _message(ScaffoldMessengerState messager, String texte) =>
    messager.showSnackBar(SnackBar(content: Text(texte)));

/// Enregistre un fichier de sauvegarde à l'endroit choisi par l'utilisateur.
/// Retourne `true` si le fichier a été enregistré.
Future<bool> sauvegarderDonnees(BuildContext context, WidgetRef ref) async {
  final messager = ScaffoldMessenger.of(context);
  final service = ref.read(serviceSauvegardeProvider);
  try {
    final fichier = await FilePicker.saveFile(
      dialogTitle: 'Enregistrer la sauvegarde',
      fileName: service.nomFichier(),
      bytes: await service.exporter(),
      mimeType: 'application/json',
      type: FileType.custom,
      allowedExtensions: const ['json'],
    );
    if (fichier == null) return false;
    _message(
      messager,
      'Sauvegarde enregistrée. Conservez-la en lieu sûr : elle contient '
      'toutes vos données.',
    );
    return true;
  } on Exception {
    _message(messager, 'La sauvegarde n\'a pas pu être enregistrée.');
    return false;
  }
}

/// Choisit un fichier de sauvegarde, le vérifie, demande confirmation puis
/// remplace toutes les données.
Future<void> restaurerDonnees(BuildContext context, WidgetRef ref) async {
  final messager = ScaffoldMessenger.of(context);
  final service = ref.read(serviceSauvegardeProvider);

  final Sauvegarde sauvegarde;
  try {
    final fichier = await FilePicker.pickFile(
      dialogTitle: 'Choisir une sauvegarde',
      type: FileType.custom,
      allowedExtensions: const ['json'],
    );
    if (fichier == null) return;
    sauvegarde = service.lire(await fichier.xFile.readAsBytes());
  } on SauvegardeInvalide catch (e) {
    _message(messager, e.message);
    return;
  } on Exception {
    _message(messager, 'Ce fichier n\'a pas pu être lu.');
    return;
  }
  if (!context.mounted) return;

  final biens = sauvegarde.nombreBiens;
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Restaurer cette sauvegarde ?'),
      content: Text(
        'Sauvegarde du ${Formats.date(sauvegarde.creeLe)} '
        '($biens bien${biens > 1 ? 's' : ''}). Toutes les données actuelles '
        'de l\'application seront remplacées par celles de la sauvegarde.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Remplacer mes données'),
        ),
      ],
    ),
  );
  if (ok != true) return;

  try {
    await service.restaurer(sauvegarde);
  } on Exception {
    _message(messager, 'La restauration a échoué. Vos données sont intactes.');
    return;
  }
  final termine =
      await ref
          .read(reglagesRepositoryProvider)
          .lire(ClesReglages.onboardingTermine) ==
      'true';
  final onboarding = ref.read(onboardingTermineProvider.notifier);
  termine ? onboarding.marquerTermine() : onboarding.reinitialiser();
  _message(messager, 'Sauvegarde restaurée.');
}

/// Supprime définitivement toutes les données, après confirmation (avec la
/// possibilité de sauvegarder d'abord), puis revient à l'accueil de
/// l'onboarding.
Future<void> effacerDonnees(BuildContext context, WidgetRef ref) async {
  final choix = await showDialog<_ChoixEffacement>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Tout effacer ?'),
      content: const Text(
        'Toutes vos données (profil, biens, baux, locataires, échéances, '
        'photos) seront supprimées de ce téléphone. Cette action est '
        'définitive.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(_ChoixEffacement.annuler),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () =>
              Navigator.of(context).pop(_ChoixEffacement.sauvegarder),
          child: const Text('Sauvegarder d\'abord'),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: context.couleurs.erreur),
          onPressed: () => Navigator.of(context).pop(_ChoixEffacement.effacer),
          child: const Text('Tout effacer'),
        ),
      ],
    ),
  );
  switch (choix) {
    case null || _ChoixEffacement.annuler:
      return;
    case _ChoixEffacement.sauvegarder:
      if (context.mounted) await sauvegarderDonnees(context, ref);
      return;
    case _ChoixEffacement.effacer:
      await ref.read(serviceSauvegardeProvider).effacerTout();
      ref.read(onboardingTermineProvider.notifier).reinitialiser();
  }
}

enum _ChoixEffacement { annuler, sauvegarder, effacer }
