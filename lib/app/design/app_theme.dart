import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_text_styles.dart';

/// ThemeData unique de Pense-Bail, entièrement dérivé des tokens.
/// Mode sombre hors périmètre V1 : il suffira d'un second jeu de tokens.
abstract final class AppTheme {
  static ThemeData clair() => _construire(AppColors.clair, AppTextStyles.clair);

  static ThemeData _construire(AppColors c, AppTextStyles t) {
    final schema = ColorScheme(
      brightness: Brightness.light,
      primary: c.primary,
      onPrimary: c.onPrimary,
      primaryContainer: c.primarySoft,
      onPrimaryContainer: c.primary,
      secondary: c.primary,
      onSecondary: c.onPrimary,
      secondaryContainer: c.primarySoft,
      onSecondaryContainer: c.primary,
      tertiary: c.sandIcon,
      onTertiary: c.onPrimary,
      error: c.erreur,
      onError: c.onPrimary,
      surface: c.surface,
      onSurface: c.textPrimary,
      onSurfaceVariant: c.textSecondary,
      surfaceContainerLowest: c.surface,
      surfaceContainerLow: c.surface,
      surfaceContainer: c.surface,
      surfaceContainerHigh: c.background,
      surfaceContainerHighest: c.background,
      outline: c.borderDashed,
      outlineVariant: c.border,
      shadow: c.textPrimary,
      inverseSurface: c.textPrimary,
      onInverseSurface: c.surface,
      surfaceTint: Colors.transparent,
    );

    final arrondiBouton = RoundedRectangleBorder(
      borderRadius: AppRadius.arrondi(AppRadius.bouton),
    );
    OutlineInputBorder bordureChamp(Color couleur, [double largeur = 1]) =>
        OutlineInputBorder(
          borderRadius: AppRadius.arrondi(AppRadius.bouton),
          borderSide: BorderSide(color: couleur, width: largeur),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: schema,
      scaffoldBackgroundColor: c.background,
      canvasColor: c.background,
      fontFamily: AppFonts.manrope,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      splashFactory: InkRipple.splashFactory,
      dividerColor: c.divider,
      extensions: [c, t],

      // Correspondance avec les styles Material, pour les widgets standard.
      textTheme: TextTheme(
        displayLarge: t.displayLarge,
        displayMedium: t.displayLarge,
        displaySmall: t.headline,
        headlineLarge: t.headline,
        headlineMedium: t.headline,
        headlineSmall: t.headline,
        titleLarge: t.title,
        titleMedium: t.rowTitle,
        titleSmall: t.label.copyWith(color: c.textPrimary),
        bodyLarge: t.body,
        bodyMedium: t.body.copyWith(fontSize: 14),
        bodySmall: t.secondary,
        labelLarge: t.label,
        labelMedium: t.caption,
        labelSmall: t.caption,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: c.background,
        foregroundColor: c.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: t.title,
        iconTheme: IconThemeData(color: c.textPrimary, size: AppSizes.icone),
      ),

      iconTheme: IconThemeData(color: c.textSecondary, size: AppSizes.icone),

      cardTheme: CardThemeData(
        color: c.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.arrondi(AppRadius.carte),
          side: BorderSide(color: c.border, width: AppSizes.bordure),
        ),
      ),

      dividerTheme: DividerThemeData(color: c.divider, thickness: 1, space: 1),

      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(
            Size(double.infinity, AppSizes.boutonPrincipal),
          ),
          shape: WidgetStatePropertyAll(arrondiBouton),
          textStyle: WidgetStatePropertyAll(t.button),
          elevation: const WidgetStatePropertyAll(0),
          backgroundColor: WidgetStateProperty.resolveWith((etats) {
            if (etats.contains(WidgetState.disabled)) return c.dotInactive;
            if (etats.contains(WidgetState.pressed)) return c.primaryPressed;
            return c.primary;
          }),
          foregroundColor: WidgetStatePropertyAll(c.onPrimary),
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(
            Size(double.infinity, AppSizes.boutonSecondaire),
          ),
          shape: WidgetStatePropertyAll(arrondiBouton),
          textStyle: WidgetStatePropertyAll(t.label.copyWith(fontSize: 15)),
          foregroundColor: WidgetStatePropertyAll(c.primary),
          backgroundColor: WidgetStatePropertyAll(c.surface),
          side: WidgetStatePropertyAll(BorderSide(color: c.border)),
          iconSize: const WidgetStatePropertyAll(AppSizes.iconePetite),
        ),
      ),

      // Lien texte : primary, 14, gras, sans soulignement.
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(
            Size(AppSizes.zoneTactile, AppSizes.zoneTactile),
          ),
          textStyle: WidgetStatePropertyAll(t.label),
          foregroundColor: WidgetStatePropertyAll(c.primary),
          iconSize: const WidgetStatePropertyAll(AppSizes.iconePetite),
          shape: WidgetStatePropertyAll(arrondiBouton),
        ),
      ),

      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(
            Size(AppSizes.zoneTactile, AppSizes.zoneTactile),
          ),
          foregroundColor: WidgetStatePropertyAll(c.textPrimary),
          iconSize: const WidgetStatePropertyAll(AppSizes.icone),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.carte,
          vertical: AppSpacing.carte,
        ),
        labelStyle: t.body.copyWith(color: c.textSecondary),
        floatingLabelStyle: t.label.copyWith(color: c.primary),
        hintStyle: t.body.copyWith(color: c.textSecondary),
        helperStyle: t.secondary,
        helperMaxLines: 3,
        errorStyle: t.secondary.copyWith(
          color: c.erreur,
          fontWeight: FontWeight.w600,
        ),
        errorMaxLines: 3,
        suffixStyle: t.body.copyWith(color: c.textSecondary),
        border: bordureChamp(c.borderDashed),
        enabledBorder: bordureChamp(c.borderDashed),
        focusedBorder: bordureChamp(c.primary, 2),
        errorBorder: bordureChamp(c.erreur),
        focusedErrorBorder: bordureChamp(c.erreur, 2),
      ),

      // Onglets : actif en gras souligné de 3, ligne de base sous l'ensemble.
      tabBarTheme: TabBarThemeData(
        labelStyle: t.label.copyWith(color: c.textPrimary),
        unselectedLabelStyle: t.label.copyWith(
          color: c.textSecondary,
          fontWeight: FontWeight.w600,
        ),
        labelColor: c.textPrimary,
        unselectedLabelColor: c.textSecondary,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: c.primary,
            width: AppSizes.soulignementOnglet,
          ),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: c.border,
        tabAlignment: TabAlignment.start,
        labelPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.bloc),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: c.primary,
        linearTrackColor: c.primarySoft,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: c.textPrimary,
        contentTextStyle: t.body.copyWith(color: c.surface, fontSize: 14),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.arrondi(AppRadius.bouton),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.background,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: c.dotInactive,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.panneau),
          ),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: t.title,
        contentTextStyle: t.body,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.arrondi(AppRadius.panneau),
        ),
      ),

      datePickerTheme: DatePickerThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        headerBackgroundColor: c.primary,
        headerForegroundColor: c.onPrimary,
        headerHeadlineStyle: t.headline.copyWith(color: c.onPrimary),
        headerHelpStyle: t.label.copyWith(color: c.onPrimary),
        dayStyle: t.body.copyWith(fontSize: 14),
        weekdayStyle: t.caption,
        yearStyle: t.body,
        todayBorder: BorderSide(color: c.primary),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.arrondi(AppRadius.panneau),
        ),
        cancelButtonStyle: TextButton.styleFrom(textStyle: t.label),
        confirmButtonStyle: TextButton.styleFrom(textStyle: t.label),
      ),
    );
  }
}
