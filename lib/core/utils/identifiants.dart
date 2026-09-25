import 'package:uuid/uuid.dart';

abstract final class Identifiants {
  static const _uuid = Uuid();

  /// Nouvel identifiant unique (UUID v4).
  static String nouveau() => _uuid.v4();
}
