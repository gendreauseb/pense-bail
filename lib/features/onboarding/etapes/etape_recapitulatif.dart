import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/design/design.dart';
import '../../../core/format/formats.dart';
import '../../../core/widgets/photo_bien.dart';
import '../../../domain/entities/adresse.dart';
import '../brouillon_onboarding.dart';
import '../onboarding_controller.dart';
import '../widgets/gabarit_etape.dart';

class EtapeRecapitulatif extends ConsumerStatefulWidget {
  const EtapeRecapitulatif({super.key, required this.brouillon});
  final BrouillonOnboarding brouillon;

  @override
  ConsumerState<EtapeRecapitulatif> createState() => _EtapeRecapitulatifState();
}

class _EtapeRecapitulatifState extends ConsumerState<EtapeRecapitulatif> {
  bool _enCours = false;

  OnboardingController get _controleur =>
      ref.read(onboardingControllerProvider.notifier);

  Future<void> _terminer() async {
    setState(() => _enCours = true);
    try {
      // La navigation vers le tableau de bord est automatique.
      await _controleur.terminer();
    } catch (e) {
      if (!mounted) return;
      setState(() => _enCours = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'L\'enregistrement n\'a pas abouti. Vos informations sont '
            'conservées : réessayez.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.brouillon;
    final biens = b.biensRetenus;
    final incomplets = biens.where((x) => !x.estComplet).length;
    final totalLoyers = biens.fold<int>(
      0,
      (s, x) => s + (x.loyerCentimes ?? 0),
    );
    final id = b.identite;

    return GabaritEtape(
      titre: 'Tout est prêt !',
      sousTitre:
          '${biens.length} ${biens.length > 1 ? 'biens' : 'bien'}, '
          '${Formats.parMois(totalLoyers)} de loyers (hors charges).',
      onRetour: _controleur.precedent,
      libelleAction: 'Accéder à mon tableau de bord',
      actionEnCours: _enCours,
      onAction: incomplets == 0 ? _terminer : null,
      contenu: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TitreSection('Vos coordonnées'),
          Card(
            clipBehavior: Clip.antiAlias,
            child: _Ligne(
              visuel: const TuileIcone(icone: AppIcons.personne),
              titre: '${id.prenom.trim()} ${id.nom.trim()}',
              lignes: [
                formaterAdresseSurUneLigne(
                  rue: id.rue,
                  complement: id.complementAdresse,
                  codePostal: id.codePostal,
                  ville: id.ville,
                ),
              ],
              descriptionModifier: 'Modifier vos coordonnées',
              onModifier: _enCours ? null : _controleur.modifierIdentite,
            ),
          ),
          const SizedBox(height: AppSpacing.sectionLarge),
          TitreSection(biens.length > 1 ? 'Vos biens' : 'Votre bien'),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (final (i, bien) in biens.indexed) ...[
                  if (i > 0)
                    const Divider(
                      indent: AppSpacing.ligne,
                      endIndent: AppSpacing.ligne,
                    ),
                  _LigneBien(
                    bien: bien,
                    onModifier: _enCours
                        ? null
                        : () => _controleur.modifierBien(i),
                  ),
                ],
              ],
            ),
          ),
          if (incomplets > 0) ...[
            const SizedBox(height: AppSpacing.bloc),
            Text(
              'Complétez les biens signalés pour continuer.',
              style: context.textes.secondary.copyWith(
                color: context.couleurs.erreur,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LigneBien extends StatelessWidget {
  const _LigneBien({required this.bien, required this.onModifier});
  final BrouillonBien bien;
  final VoidCallback? onModifier;

  @override
  Widget build(BuildContext context) {
    final loyer = bien.loyerCentimes;
    final charges = bien.chargesCentimes ?? 0;
    final nom = bien.nom.trim().isEmpty ? 'Bien sans nom' : bien.nom.trim();
    final bail =
        bien.estLongueDuree &&
            bien.typeBail != null &&
            bien.dateDebutBail != null
        ? '${bien.typeBail!.libelle} depuis le '
              '${Formats.date(bien.dateDebutBail!)}'
        : null;

    return _Ligne(
      visuel: SizedBox.square(
        dimension: AppSizes.vignette,
        child: PhotoBien(
          chemin: bien.photoChemin,
          typeLogement: bien.typeLogement,
          rayon: AppRadius.tuile,
          tailleIcone: AppSizes.pictogrammePetit,
        ),
      ),
      titre: nom,
      lignes: [
        [
          bien.typeLogement?.libelle,
          bien.typeLocation?.libelle,
        ].whereType<String>().join(', '),
        if (loyer != null)
          charges > 0
              ? '${Formats.parMois(loyer)} + ${Formats.montant(charges)} '
                    'de charges'
              : Formats.parMois(loyer),
        ?bail,
      ],
      alerte: bien.estComplet ? null : 'Informations à compléter',
      descriptionModifier: 'Modifier $nom',
      onModifier: onModifier,
    );
  }
}

/// Ligne de liste entièrement cliquable, avec chevron (design-system.md §6).
class _Ligne extends StatelessWidget {
  const _Ligne({
    required this.visuel,
    required this.titre,
    required this.lignes,
    required this.descriptionModifier,
    required this.onModifier,
    this.alerte,
  });

  final Widget visuel;
  final String titre;
  final List<String> lignes;
  final String? alerte;
  final String descriptionModifier;
  final VoidCallback? onModifier;

  @override
  Widget build(BuildContext context) {
    final t = context.textes;
    final c = context.couleurs;
    final alerte = this.alerte;
    return Semantics(
      button: true,
      hint: descriptionModifier,
      child: InkWell(
        onTap: onModifier,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.ligne),
          child: Row(
            children: [
              visuel,
              const SizedBox(width: AppSpacing.bloc),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titre, style: t.rowTitle),
                    for (final ligne in lignes.where((l) => l.isNotEmpty))
                      Text(ligne, style: t.secondary),
                    if (alerte != null)
                      Text(alerte, style: t.caption.copyWith(color: c.erreur)),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s),
              Icon(AppIcons.suivant, color: c.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
