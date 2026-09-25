import 'package:flutter/material.dart';

/// Couleurs d'un statut d'échéance (fond + texte, contraste ≥ 4,5:1).
@immutable
class CouleursStatut {
  const CouleursStatut({required this.fond, required this.texte});
  final Color fond;
  final Color texte;
}

/// Palette Pense-Bail (UI.md §2).
///
/// Exposée comme extension de thème : les écrans lisent `context.couleurs`
/// et non des constantes, pour pouvoir ajouter un mode sombre plus tard
/// sans toucher aux écrans.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary,
    required this.primaryPressed,
    required this.primarySoft,
    required this.onPrimary,
    required this.background,
    required this.surface,
    required this.border,
    required this.divider,
    required this.borderDashed,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.dotInactive,
    required this.sand,
    required this.sandIcon,
    required this.notification,
    required this.banniereFond,
    required this.banniereTexte,
    required this.urgent,
    required this.bientot,
    required this.aVenir,
    required this.lointain,
    required this.ombre,
  });

  final Color primary;
  final Color primaryPressed;
  final Color primarySoft;
  final Color onPrimary;
  final Color background;
  final Color surface;
  final Color border;
  final Color divider;
  final Color borderDashed;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color dotInactive;
  final Color sand;
  final Color sandIcon;

  /// Pastille de notification non lue.
  final Color notification;

  /// Bannières « données à compléter » (réservées aux données manquantes).
  final Color banniereFond;
  final Color banniereTexte;

  /// Statuts des échéances (règle stricte, voir ConfigApp pour les seuils).
  final CouleursStatut urgent;
  final CouleursStatut bientot;
  final CouleursStatut aVenir;
  final CouleursStatut lointain;

  /// Ombre douce (bouton central, cartes d'illustration de bienvenue).
  final Color ombre;

  /// Couleurs des erreurs de saisie (reprend le statut urgent, lisible
  /// sur fond ivoire comme sur fond blanc).
  Color get erreur => urgent.texte;

  static const clair = AppColors(
    primary: Color(0xFF0E4F58),
    primaryPressed: Color(0xFF0A3A41),
    primarySoft: Color(0xFFE2EEEE),
    onPrimary: Color(0xFFFFFFFF),
    background: Color(0xFFF5F3EE),
    surface: Color(0xFFFFFFFF),
    border: Color(0xFFE3DED4),
    divider: Color(0xFFEEEAE2),
    borderDashed: Color(0xFFBFB7A8),
    textPrimary: Color(0xFF14262A),
    textSecondary: Color(0xFF5B6B6E),
    textMuted: Color(0xFF4A5A5D),
    dotInactive: Color(0xFFCFC8BA),
    sand: Color(0xFFEFE9DE),
    sandIcon: Color(0xFF6B5530),
    notification: Color(0xFFC2530F),
    banniereFond: Color(0xFFFAEFD2),
    banniereTexte: Color(0xFF5A3D00),
    urgent: CouleursStatut(fond: Color(0xFFFBE4D6), texte: Color(0xFF9A3A0B)),
    bientot: CouleursStatut(fond: Color(0xFFFAEFD2), texte: Color(0xFF7A5200)),
    aVenir: CouleursStatut(fond: Color(0xFFE2EEEE), texte: Color(0xFF0E4F58)),
    lointain: CouleursStatut(fond: Color(0xFFF0EDE6), texte: Color(0xFF4A5A5D)),
    ombre: Color(0x1F14262A),
  );

  @override
  AppColors copyWith() => this;

  /// Pas d'animation entre palettes (un seul thème en V1).
  @override
  AppColors lerp(AppColors? other, double t) =>
      (other == null || t < 0.5) ? this : other;
}
