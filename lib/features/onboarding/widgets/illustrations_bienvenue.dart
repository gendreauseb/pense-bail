// Illustrations décoratives des écrans de bienvenue : cartes légèrement
// inclinées, avec une ombre douce (UI.md §4 et §7). Exemples fictifs,
// masqués aux lecteurs d'écran (le titre et le texte portent le message).

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../app/design/design.dart';
import '../../../core/format/formats.dart';
import '../../../core/utils/dates.dart';
import '../../../core/widgets/composants.dart';
import '../../../core/widgets/photo_bien.dart';
import '../../../core/widgets/statut_echeance.dart';
import '../../../domain/enums.dart';
import '../../../domain/services/proximite.dart';

/// Taille de conception : l'illustration est réduite si l'écran est petit.
const _tailleConception = Size(320, 270);
const _largeurCarte = 272.0;

double _degres(double d) => d * math.pi / 180;

/// Cadre commun : taille fixe, réduction si nécessaire, ignoré par les
/// lecteurs d'écran et insensible à la taille de texte (purement décoratif).
class _Cadre extends StatelessWidget {
  const _Cadre({required this.enfants});
  final List<Widget> enfants;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: MediaQuery.withNoTextScaling(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: SizedBox.fromSize(
          size: _tailleConception,
          child: Stack(clipBehavior: Clip.none, children: enfants),
        ),
      ),
    ),
  );
}

class _CarteInclinee extends StatelessWidget {
  const _CarteInclinee({
    required this.alignement,
    required this.angle,
    required this.enfant,
    this.largeur = _largeurCarte,
  });

  final Alignment alignement;
  final double angle;
  final Widget enfant;
  final double largeur;

  @override
  Widget build(BuildContext context) {
    final c = context.couleurs;
    return Align(
      alignment: alignement,
      child: Transform.rotate(
        angle: _degres(angle),
        child: Container(
          width: largeur,
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: AppRadius.arrondi(AppRadius.carte),
            border: Border.all(color: c.border),
            boxShadow: AppShadows.douce(c),
          ),
          padding: const EdgeInsets.all(AppSpacing.ligne),
          child: enfant,
        ),
      ),
    );
  }
}

/// Écran 1 : trois échéances aux statuts différents.
class IllustrationEcheances extends StatelessWidget {
  const IllustrationEcheances({super.key});

  @override
  Widget build(BuildContext context) {
    final aujourdhui = Dates.aujourdhui();
    Widget ligne(int jours, String titre, String bien) {
      final date = Dates.ajouterJours(aujourdhui, jours);
      final proximite = Proximite.depuisDate(date, aujourdhui: aujourdhui);
      return Row(
        children: [
          TuileDate(date: date, proximite: proximite),
          const SizedBox(width: AppSpacing.bloc),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(titre, style: context.textes.rowTitle, maxLines: 1),
                Text(bien, style: context.textes.secondary, maxLines: 1),
              ],
            ),
          ),
          PastilleStatut(
            texte: textePastille(date, aujourdhui: aujourdhui),
            proximite: proximite,
          ),
        ],
      );
    }

    return _Cadre(
      enfants: [
        _CarteInclinee(
          alignement: const Alignment(-0.2, 1),
          angle: 3,
          enfant: ligne(67, 'Assurance PNO', 'Local Victor Hugo'),
        ),
        _CarteInclinee(
          alignement: const Alignment(0.25, 0),
          angle: -2,
          enfant: ligne(19, 'Taxe foncière', 'Maison des Tilleuls'),
        ),
        _CarteInclinee(
          alignement: const Alignment(-0.15, -1),
          angle: -4,
          enfant: ligne(4, 'Révision du loyer', 'Studio Gambetta'),
        ),
      ],
    );
  }
}

/// Écran 2 : trois biens en éventail.
class IllustrationBiens extends StatelessWidget {
  const IllustrationBiens({super.key});

  static const _largeur = AppSizes.carteBienLargeur;

  @override
  Widget build(BuildContext context) {
    Widget carte(TypeLogement type, String nom, int loyerCentimes) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: AppSizes.carteBienIllustration,
          child: IllustrationArrondie(type: type),
        ),
        const SizedBox(height: AppSpacing.blocSerre),
        Text(nom, style: context.textes.rowTitle, maxLines: 1),
        Text(Formats.parMois(loyerCentimes), style: context.textes.secondary),
      ],
    );

    return _Cadre(
      enfants: [
        _CarteInclinee(
          alignement: const Alignment(-1, 0.4),
          angle: -7,
          largeur: _largeur,
          enfant: carte(TypeLogement.maison, 'Les Tilleuls', 115000),
        ),
        _CarteInclinee(
          alignement: const Alignment(1, 0.4),
          angle: 7,
          largeur: _largeur,
          enfant: carte(TypeLogement.localProfessionnel, 'Victor Hugo', 90000),
        ),
        _CarteInclinee(
          alignement: const Alignment(0, -0.6),
          angle: 0,
          largeur: _largeur,
          enfant: carte(TypeLogement.appartement, 'Studio Gambetta', 62000),
        ),
      ],
    );
  }
}

/// Illustration de bien aux coins arrondis (tuile).
class IllustrationArrondie extends StatelessWidget {
  const IllustrationArrondie({super.key, required this.type});
  final TypeLogement type;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: AppRadius.arrondi(AppRadius.tuile),
    child: IllustrationBien(
      typeLogement: type,
      tailleIcone: AppSizes.pictogrammeMoyen,
    ),
  );
}

/// Écran 3 : un courrier prêt à envoyer.
class IllustrationCourrier extends StatelessWidget {
  const IllustrationCourrier({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.couleurs;
    Widget trait(double largeur) => Padding(
      padding: const EdgeInsets.only(top: AppSpacing.s),
      child: Container(
        width: largeur,
        height: AppSpacing.s,
        decoration: BoxDecoration(
          color: c.divider,
          borderRadius: AppRadius.arrondi(AppRadius.complet),
        ),
      ),
    );

    return _Cadre(
      enfants: [
        _CarteInclinee(
          alignement: const Alignment(0.5, 0.2),
          angle: 6,
          largeur: 220,
          enfant: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [trait(120), trait(170), trait(150), trait(90)],
          ),
        ),
        _CarteInclinee(
          alignement: const Alignment(-0.3, 0),
          angle: -3,
          largeur: 240,
          enfant: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const TuileIcone(icone: AppIcons.courrier),
                  const SizedBox(width: AppSpacing.bloc),
                  Expanded(
                    child: Text(
                      'Révision du loyer',
                      style: context.textes.rowTitle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s),
              trait(180),
              trait(200),
              trait(140),
              const SizedBox(height: AppSpacing.bloc),
              const PastilleStatut(
                texte: 'Prêt à envoyer',
                proximite: Proximite.aVenir,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
