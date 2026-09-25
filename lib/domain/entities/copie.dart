/// Marqueur utilisé par les `copyWith` pour distinguer « ne pas modifier »
/// de « remettre à null » sur les champs optionnels :
///
/// ```dart
/// bien.copyWith(surfaceM2: null)   // efface la surface
/// bien.copyWith()                  // la conserve
/// ```
const Object inchange = _Inchange();

class _Inchange {
  const _Inchange();
}

/// Valeur à utiliser dans un `copyWith` : [nouvelle] si elle a été fournie,
/// sinon [actuelle].
T choisir<T>(Object? nouvelle, T actuelle) =>
    identical(nouvelle, inchange) ? actuelle : nouvelle as T;
