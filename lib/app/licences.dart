import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Ajoute les licences des polices embarquées (SIL Open Font License) à la
/// page « Licences » de Flutter.
void enregistrerLicencesPolices() {
  LicenseRegistry.addLicense(() async* {
    for (final (police, fichier) in const [
      ('Fraunces', 'assets/fonts/OFL-Fraunces.txt'),
      ('Manrope', 'assets/fonts/OFL-Manrope.txt'),
    ]) {
      yield LicenseEntryWithLineBreaks([
        police,
      ], await rootBundle.loadString(fichier));
    }
  });
}
