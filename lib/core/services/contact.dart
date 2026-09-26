import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Ouvre le composeur de numéro ou l'application de messagerie.
abstract final class Contact {
  static Future<void> appeler(BuildContext context, String telephone) =>
      _ouvrir(
        context,
        Uri(scheme: 'tel', path: telephone.replaceAll(' ', '')),
        'Impossible d\'ouvrir le téléphone.',
      );

  static Future<void> ecrire(BuildContext context, String email) => _ouvrir(
    context,
    Uri(scheme: 'mailto', path: email.trim()),
    'Aucune application de messagerie n\'est disponible.',
  );

  static Future<void> _ouvrir(
    BuildContext context,
    Uri uri,
    String erreur,
  ) async {
    final messager = ScaffoldMessenger.of(context);
    var ouvert = false;
    try {
      ouvert = await launchUrl(uri);
    } catch (_) {
      ouvert = false;
    }
    if (!ouvert) messager.showSnackBar(SnackBar(content: Text(erreur)));
  }
}
