import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../domain/enums.dart';

/// Icônes au trait (Lucide, trait de 2), centralisées ici (UI.md §5).
abstract final class AppIcons {
  // Navigation
  static const accueil = LucideIcons.house;
  static const biens = LucideIcons.building2;
  static const ajouter = LucideIcons.plus;
  static const artisans = LucideIcons.wrench;
  static const reglages = LucideIcons.settings;

  // Actions
  static const retour = LucideIcons.arrowLeft;
  static const retirer = LucideIcons.minus;
  static const suivant = LucideIcons.chevronRight;
  static const selectionne = LucideIcons.circleCheck;
  static const appareilPhoto = LucideIcons.camera;
  static const galerie = LucideIcons.images;
  static const supprimer = LucideIcons.trash2;
  static const calendrier = LucideIcons.calendar;
  static const notifications = LucideIcons.bell;

  // Contenus
  static const logo = LucideIcons.calendarCheck;
  static const echeance = LucideIcons.calendarClock;
  static const rappel = LucideIcons.bellRing;
  static const courrier = LucideIcons.mail;
  static const document = LucideIcons.fileText;
  static const calcul = LucideIcons.calculator;
  static const personne = LucideIcons.user;
  static const information = LucideIcons.info;
  static const confidentialite = LucideIcons.shieldCheck;

  static IconData typeLogement(TypeLogement t) => switch (t) {
    TypeLogement.appartement => LucideIcons.building2,
    TypeLogement.maison => LucideIcons.house,
    TypeLogement.immeuble => LucideIcons.building,
    TypeLogement.localProfessionnel => LucideIcons.store,
  };

  static IconData typeLocation(TypeLocation t) => switch (t) {
    TypeLocation.longueDuree => LucideIcons.keyRound,
    TypeLocation.moyenneDuree => LucideIcons.calendarRange,
    TypeLocation.courteDuree => LucideIcons.luggage,
    TypeLocation.professionnelle => LucideIcons.briefcase,
  };

  static IconData typeBail(TypeBail t) => switch (t) {
    TypeBail.vide => LucideIcons.doorOpen,
    TypeBail.meuble => LucideIcons.sofa,
    TypeBail.mobilite => LucideIcons.calendarRange,
    TypeBail.saisonnier => LucideIcons.luggage,
    TypeBail.professionnel => LucideIcons.briefcase,
    TypeBail.commercial => LucideIcons.store,
  };
}
