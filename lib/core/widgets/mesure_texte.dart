import 'package:flutter/material.dart';

/// Mesure du texte à la taille choisie sur le téléphone : sert à changer de
/// mise en page en grand texte plutôt que de couper les mots
/// (« Apparte-ment »).
abstract final class MesureTexte {
  /// Chaque mot du [texte] tient-il sur une ligne de [largeur] ?
  static bool motsTiennent(
    BuildContext context,
    String texte,
    TextStyle style,
    double largeur,
  ) {
    final scaler = MediaQuery.textScalerOf(context);
    for (final mot in texte.split(RegExp(r'\s+'))) {
      final mesure = TextPainter(
        text: TextSpan(text: mot, style: style),
        textScaler: scaler,
        textDirection: TextDirection.ltr,
        maxLines: 1,
      )..layout();
      final largeurMot = mesure.width;
      mesure.dispose();
      if (largeurMot > largeur) return false;
    }
    return true;
  }
}
