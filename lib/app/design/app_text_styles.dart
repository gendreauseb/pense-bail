import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Familles embarquées (assets/fonts, fonctionnement hors ligne).
abstract final class AppFonts {
  /// Titres et chiffres clés (graisse 600 uniquement).
  static const fraunces = 'Fraunces';

  /// Tout le reste (400, 600, 700).
  static const manrope = 'Manrope';
}

/// Styles de texte Pense-Bail (UI.md §3).
///
/// Les tailles sont données en points logiques : elles suivent le réglage
/// de taille de texte du téléphone.
@immutable
class AppTextStyles extends ThemeExtension<AppTextStyles> {
  const AppTextStyles({
    required this.displayLarge,
    required this.headline,
    required this.title,
    required this.figure,
    required this.body,
    required this.rowTitle,
    required this.button,
    required this.label,
    required this.secondary,
    required this.caption,
    required this.overline,
    required this.nav,
    required this.tuileJour,
    required this.tuileMois,
  });

  /// Titre des écrans de bienvenue.
  final TextStyle displayLarge;

  /// Titre de page (« Bonjour Marc », nom du bien).
  final TextStyle headline;

  /// Titre de section (« Prochaines échéances »).
  final TextStyle title;

  /// Montants et chiffres clés.
  final TextStyle figure;

  /// Paragraphes.
  final TextStyle body;

  /// Titre d'une ligne de liste.
  final TextStyle rowTitle;

  /// Bouton principal.
  final TextStyle button;

  /// Liens, onglets, puces.
  final TextStyle label;

  /// Sous-titre d'une ligne, adresses.
  final TextStyle secondary;

  /// Pastilles de statut, légendes.
  final TextStyle caption;

  /// En-têtes de groupe (à afficher en MAJUSCULES).
  final TextStyle overline;

  /// Libellés de la barre de navigation.
  final TextStyle nav;

  /// Tuile de date : jour (Fraunces 20) et mois abrégé en majuscules.
  final TextStyle tuileJour;
  final TextStyle tuileMois;

  factory AppTextStyles.depuis(AppColors c) {
    TextStyle fraunces(double taille, {double? hauteur}) => TextStyle(
      fontFamily: AppFonts.fraunces,
      fontSize: taille,
      height: hauteur,
      fontWeight: FontWeight.w600,
      color: c.textPrimary,
    );
    TextStyle manrope(
      double taille,
      FontWeight poids,
      Color couleur, {
      double? hauteur,
      double? espacement,
    }) => TextStyle(
      fontFamily: AppFonts.manrope,
      fontSize: taille,
      fontWeight: poids,
      height: hauteur,
      letterSpacing: espacement,
      color: couleur,
    );

    return AppTextStyles(
      displayLarge: fraunces(34, hauteur: 1.12),
      headline: fraunces(27, hauteur: 1.2),
      title: fraunces(21, hauteur: 1.25),
      figure: fraunces(22, hauteur: 1.15),
      body: manrope(16, FontWeight.w400, c.textPrimary, hauteur: 1.5),
      rowTitle: manrope(15, FontWeight.w700, c.textPrimary, hauteur: 1.3),
      button: manrope(17, FontWeight.w700, c.onPrimary),
      label: manrope(14, FontWeight.w700, c.primary),
      secondary: manrope(13, FontWeight.w400, c.textSecondary, hauteur: 1.4),
      caption: manrope(12, FontWeight.w700, c.textSecondary),
      overline: manrope(12, FontWeight.w700, c.textSecondary, espacement: 0.8),
      nav: manrope(11, FontWeight.w600, c.textSecondary),
      tuileJour: fraunces(20, hauteur: 1.1),
      tuileMois: manrope(11, FontWeight.w700, c.textSecondary, espacement: 0.8),
    );
  }

  static final clair = AppTextStyles.depuis(AppColors.clair);

  @override
  AppTextStyles copyWith() => this;

  @override
  AppTextStyles lerp(AppTextStyles? other, double t) =>
      (other == null || t < 0.5) ? this : other;
}
