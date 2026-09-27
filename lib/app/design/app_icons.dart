import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../domain/enums.dart';

/// Icônes au trait (Lucide, trait de 2), centralisées ici (design-system.md
/// §5).
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
  static const notificationsCoupees = LucideIcons.bellOff;
  static const modifier = LucideIcons.pencil;
  static const verrou = LucideIcons.lock;
  static const fermer = LucideIcons.x;
  static const appeler = LucideIcons.phone;
  static const ecrire = LucideIcons.mail;
  static const photo = LucideIcons.imagePlus;
  static const precedent = LucideIcons.chevronLeft;

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
  static const locataire = LucideIcons.userRound;
  static const bail = LucideIcons.fileSignature;
  static const argent = LucideIcons.wallet;
  static const recette = LucideIcons.trendingUp;
  static const depense = LucideIcons.trendingDown;
  static const intervention = LucideIcons.hammer;
  static const assurance = LucideIcons.umbrella;
  static const chaudiere = LucideIcons.flame;
  static const diagnostic = LucideIcons.clipboardCheck;
  static const adresse = LucideIcons.mapPin;
  static const surface = LucideIcons.ruler;
  static const energie = LucideIcons.leaf;
  static const attention = LucideIcons.triangleAlert;
  static const partager = LucideIcons.share2;
  static const imprimer = LucideIcons.printer;
  static const enregistrer = LucideIcons.download;
  static const actualiser = LucideIcons.refreshCw;
  static const historique = LucideIcons.history;

  static IconData metier(MetierArtisan m) => switch (m) {
    MetierArtisan.plombier => LucideIcons.droplet,
    MetierArtisan.electricien => LucideIcons.zap,
    MetierArtisan.chauffagiste => LucideIcons.flame,
    MetierArtisan.serrurier => LucideIcons.keyRound,
    MetierArtisan.peintre => LucideIcons.paintRoller,
    MetierArtisan.multiservice => LucideIcons.wrench,
    MetierArtisan.autre => LucideIcons.hardHat,
  };

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
