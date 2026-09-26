import '../../core/config/config_app.dart';
import '../enums.dart';

/// Préférences de rappel choisies dans les réglages.
class PreferencesRappels {
  const PreferencesRappels({
    this.delaisParDefaut = ConfigApp.rappelsParDefautJours,
    this.typesDesactives = const {},
  });

  /// Rappels ajoutés aux nouvelles échéances, en jours avant la date, du
  /// plus éloigné au plus proche.
  final List<int> delaisParDefaut;

  /// Types d'échéance pour lesquels aucune notification n'est envoyée (les
  /// échéances restent affichées dans l'application).
  final Set<TypeEcheance> typesDesactives;

  bool notifie(TypeEcheance type) => !typesDesactives.contains(type);

  PreferencesRappels copyWith({
    List<int>? delaisParDefaut,
    Set<TypeEcheance>? typesDesactives,
  }) => PreferencesRappels(
    delaisParDefaut: delaisParDefaut ?? this.delaisParDefaut,
    typesDesactives: typesDesactives ?? this.typesDesactives,
  );

  Map<String, Object?> versJson() => {
    'delaisParDefaut': delaisParDefaut,
    'typesDesactives': [for (final t in typesDesactives) t.name],
  };

  /// Valeurs inconnues ignorées : un réglage abîmé ne bloque jamais l'app.
  factory PreferencesRappels.depuisJson(Map<String, Object?> json) {
    final delais = json['delaisParDefaut'];
    final types = json['typesDesactives'];
    final parNom = {for (final t in TypeEcheance.values) t.name: t};
    return PreferencesRappels(
      delaisParDefaut: delais is List
          ? ([
              for (final d in delais)
                if (d is int && ConfigApp.rappelsProposesJours.contains(d)) d,
            ]..sort((a, b) => b.compareTo(a)))
          : ConfigApp.rappelsParDefautJours,
      typesDesactives: types is List
          ? {for (final t in types) ?parNom[t]}
          : const {},
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PreferencesRappels &&
      _memesListes(other.delaisParDefaut, delaisParDefaut) &&
      other.typesDesactives.length == typesDesactives.length &&
      other.typesDesactives.containsAll(typesDesactives);

  @override
  int get hashCode => Object.hash(
    Object.hashAll(delaisParDefaut),
    Object.hashAllUnordered(typesDesactives),
  );

  static bool _memesListes(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
