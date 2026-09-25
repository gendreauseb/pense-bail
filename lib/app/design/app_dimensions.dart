import 'package:flutter/widgets.dart';

import 'app_colors.dart';

/// Espacements (UI.md §4).
abstract final class AppSpacing {
  static const xxs = 4.0;
  static const xs = 6.0;
  static const s = 8.0;

  /// Espacement dans un bloc.
  static const blocSerre = 10.0;
  static const bloc = 12.0;

  /// Padding interne d'une ligne de liste.
  static const ligne = 14.0;

  /// Padding d'une carte.
  static const carte = 16.0;

  /// Espacement entre sections.
  static const sectionSerree = 18.0;
  static const section = 20.0;
  static const sectionLarge = 22.0;

  /// Marge horizontale des écrans.
  static const ecran = 24.0;

  static const grand = 32.0;
  static const tresGrand = 40.0;

  static const paddingEcran = EdgeInsets.symmetric(horizontal: ecran);
}

/// Rayons (UI.md §4).
abstract final class AppRadius {
  static const tuile = 12.0; // tuiles d'icône et de date
  static const bouton = 14.0;
  static const banniere = 16.0;
  static const carte = 18.0;
  static const synthese = 20.0;
  static const panneau = 24.0; // haut d'un panneau superposé
  static const complet = 999.0; // puces et pastilles

  static BorderRadius arrondi(double r) => BorderRadius.circular(r);
}

/// Dimensions fixes (UI.md §4 et §6).
abstract final class AppSizes {
  static const boutonPrincipal = 56.0;
  static const boutonSecondaire = 48.0;
  static const puceFiltre = 36.0;
  static const puceInfo = 30.0;
  static const barreNavigation = 84.0;

  /// Toute zone tactile fait au moins 44 × 44.
  static const zoneTactile = 44.0;

  static const tuileIcone = 44.0;
  static const tuileDate = Size(50, 54);

  static const boutonCentral = 56.0;
  static const boutonCentralRayon = 18.0;
  static const boutonCentralSurelevation = 26.0;

  static const visuelFiche = 240.0;
  static const carteBienLargeur = 164.0;
  static const carteBienIllustration = 96.0;

  static const icone = 22.0;
  static const iconePetite = 20.0;

  /// Pictogrammes des illustrations de biens (grand trait centré).
  static const pictogrammeGrand = 72.0;
  static const pictogramme = 56.0;
  static const pictogrammeMoyen = 40.0;
  static const pictogrammePetit = 32.0;

  /// Vignette d'un bien dans une liste.
  static const vignette = 72.0;

  static const pointPaginationActif = Size(24, 8);
  static const pointPagination = 8.0;

  static const bordure = 1.0;
  static const bordurePointillee = 1.5;
  static const soulignementOnglet = 3.0;
}

/// Ombres : quasiment absentes (UI.md §4). Seuls le bouton central de la
/// navigation et les cartes d'illustration de bienvenue en ont une.
abstract final class AppShadows {
  static List<BoxShadow> douce(AppColors c) => [
    BoxShadow(color: c.ombre, blurRadius: 24, offset: const Offset(0, 8)),
  ];
}
