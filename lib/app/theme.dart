import 'package:flutter/material.dart';

/// Thème sobre et rassurant (inspiration : applis bancaires modernes).
/// Une seule couleur d'accent pour les actions ; les couleurs d'alerte sont
/// réservées aux échéances (voir [CouleursEcheance]).
abstract final class ThemeApp {
  static const _accent = Color(0xFF1D4E89); // bleu profond
  static const _fond = Color(0xFFF5F7FA);

  static ThemeData clair() {
    final schema = ColorScheme.fromSeed(
      seedColor: _accent,
      primary: _accent,
      surface: Colors.white,
      brightness: Brightness.light,
    );
    return _base(schema).copyWith(scaffoldBackgroundColor: _fond);
  }

  static ThemeData sombre() {
    final schema = ColorScheme.fromSeed(
      seedColor: _accent,
      brightness: Brightness.dark,
    );
    return _base(schema);
  }

  static ThemeData _base(ColorScheme schema) {
    const tailleMinBouton = Size(64, 56); // grandes zones tactiles
    final bordure = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    );
    return ThemeData(
      colorScheme: schema,
      useMaterial3: true,
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      textTheme: Typography.material2021().black.apply(
        bodyColor: schema.onSurface,
        displayColor: schema.onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: schema.surface,
        foregroundColor: schema.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: schema.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: schema.outlineVariant),
        ),
        margin: EdgeInsets.zero,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: tailleMinBouton,
          shape: bordure,
          textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: tailleMinBouton,
          shape: bordure,
          textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: schema.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        labelTextStyle: WidgetStatePropertyAll(
          const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
      extensions: const [CouleursEcheance.standard],
    );
  }
}

/// Couleurs d'alerte des échéances (contrastes suffisants sur fond clair).
@immutable
class CouleursEcheance extends ThemeExtension<CouleursEcheance> {
  const CouleursEcheance({
    required this.urgent,
    required this.proche,
    required this.lointain,
  });

  final Color urgent; // dépassée ou < 7 jours
  final Color proche; // < 30 jours
  final Color lointain; // plus tard

  static const standard = CouleursEcheance(
    urgent: Color(0xFFC62828),
    proche: Color(0xFFB35900),
    lointain: Color(0xFF2E7D32),
  );

  @override
  CouleursEcheance copyWith({Color? urgent, Color? proche, Color? lointain}) =>
      CouleursEcheance(
        urgent: urgent ?? this.urgent,
        proche: proche ?? this.proche,
        lointain: lointain ?? this.lointain,
      );

  @override
  CouleursEcheance lerp(CouleursEcheance? other, double t) {
    if (other == null) return this;
    return CouleursEcheance(
      urgent: Color.lerp(urgent, other.urgent, t)!,
      proche: Color.lerp(proche, other.proche, t)!,
      lointain: Color.lerp(lointain, other.lointain, t)!,
    );
  }
}
