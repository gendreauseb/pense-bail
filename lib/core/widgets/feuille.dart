import 'package:flutter/material.dart';

/// Ouvre un panneau du bas (« bottom sheet ») de l'application.
///
/// - Au-dessus de la barre de navigation de l'app et du bouton « + ».
/// - Hors des zones système : `useSafeArea` ne protège que le haut et les
///   côtés ; la marge du bas évite que le contenu passe sous la barre de
///   navigation d'Android (boutons ou geste) ou l'indicateur d'accueil
///   d'iOS.
/// - Peut dépasser la moitié de l'écran (contenus longs, clavier).
Future<T?> ouvrirFeuille<T>(
  BuildContext context, {
  required WidgetBuilder builder,
}) => showModalBottomSheet<T>(
  context: context,
  useRootNavigator: true,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (context) => SafeArea(top: false, child: builder(context)),
);
