import 'package:flutter/material.dart';

import '../../domain/enums.dart';

extension IconeTypeLogement on TypeLogement {
  IconData get icone => switch (this) {
    TypeLogement.appartement => Icons.apartment,
    TypeLogement.maison => Icons.house_outlined,
    TypeLogement.immeuble => Icons.domain,
    TypeLogement.localProfessionnel => Icons.storefront_outlined,
  };
}

extension IconeTypeLocation on TypeLocation {
  IconData get icone => switch (this) {
    TypeLocation.longueDuree => Icons.key_outlined,
    TypeLocation.moyenneDuree => Icons.date_range_outlined,
    TypeLocation.courteDuree => Icons.luggage_outlined,
    TypeLocation.professionnelle => Icons.business_center_outlined,
  };

  /// Précision affichée sous le libellé pour lever les doutes.
  String get precision => switch (this) {
    TypeLocation.longueDuree => 'Résidence principale du locataire',
    TypeLocation.moyenneDuree => 'Bail mobilité, étudiant…',
    TypeLocation.courteDuree => 'Saisonnier, tourisme',
    TypeLocation.professionnelle => 'Bureau, commerce',
  };
}

extension IconeTypeBail on TypeBail {
  IconData get icone => switch (this) {
    TypeBail.vide => Icons.meeting_room_outlined,
    TypeBail.meuble => Icons.chair_outlined,
    TypeBail.mobilite => Icons.work_history_outlined,
    TypeBail.saisonnier => Icons.beach_access_outlined,
    TypeBail.professionnel => Icons.business_center_outlined,
    TypeBail.commercial => Icons.storefront_outlined,
  };
}
