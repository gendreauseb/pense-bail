import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/format/formats.dart';
import '../../../core/widgets/photo_bien.dart';
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
    final incomplets = [
      for (final (i, bien) in biens.indexed)
        if (!bien.estComplet) i,
    ];
    final totalLoyers = biens.fold<int>(
      0,
      (s, x) => s + (x.loyerCentimes ?? 0),
    );
    final theme = Theme.of(context);

    return GabaritEtape(
      titre: 'Tout est prêt !',
      sousTitre:
          '${biens.length} ${biens.length > 1 ? 'biens' : 'bien'} · '
          '${Formats.montant(totalLoyers)} de loyers par mois (hors charges)',
      onRetour: _controleur.precedent,
      libelleAction: 'Accéder à mon tableau de bord',
      actionEnCours: _enCours,
      onAction: incomplets.isEmpty ? _terminer : null,
      contenu: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CarteIdentite(
            brouillon: b,
            onModifier: _enCours ? null : _controleur.modifierIdentite,
          ),
          const SizedBox(height: 24),
          const TitreSection('Vos biens'),
          for (final (i, bien) in biens.indexed) ...[
            _CarteBien(
              bien: bien,
              onModifier: _enCours ? null : () => _controleur.modifierBien(i),
            ),
            const SizedBox(height: 12),
          ],
          if (incomplets.isNotEmpty)
            Text(
              'Complétez les biens signalés pour continuer.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
        ],
      ),
    );
  }
}

class _CarteIdentite extends StatelessWidget {
  const _CarteIdentite({required this.brouillon, required this.onModifier});
  final BrouillonOnboarding brouillon;
  final VoidCallback? onModifier;

  @override
  Widget build(BuildContext context) {
    final id = brouillon.identite;
    final texte = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
        child: Row(
          children: [
            const Icon(Icons.person_outline, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${id.prenom.trim()} ${id.nom.trim()}',
                    style: texte.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${id.rue.trim()}, ${id.codePostal.trim()} ${id.ville.trim()}',
                    style: texte.bodyMedium,
                  ),
                ],
              ),
            ),
            TextButton(onPressed: onModifier, child: const Text('Modifier')),
          ],
        ),
      ),
    );
  }
}

class _CarteBien extends StatelessWidget {
  const _CarteBien({required this.bien, required this.onModifier});
  final BrouillonBien bien;
  final VoidCallback? onModifier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final texte = theme.textTheme;
    final type = [
      bien.typeLogement?.libelle,
      bien.typeLocation?.libelle,
    ].whereType<String>().join(' · ');
    final loyer = bien.loyerCentimes;
    final charges = bien.chargesCentimes ?? 0;

    return Card(
      shape: bien.estComplet
          ? null
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: theme.colorScheme.error, width: 1.5),
            ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
        child: Row(
          children: [
            SizedBox.square(
              dimension: 72,
              child: PhotoBien(
                chemin: bien.photoChemin,
                typeLogement: bien.typeLogement,
                rayon: 12,
                tailleIcone: 32,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bien.nom.trim().isEmpty ? 'Bien sans nom' : bien.nom.trim(),
                    style: texte.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (type.isNotEmpty) Text(type, style: texte.bodyMedium),
                  if (loyer != null)
                    Text(
                      charges > 0
                          ? '${Formats.montant(loyer)} + ${Formats.montant(charges)} de charges'
                          : Formats.montant(loyer),
                      style: texte.bodyMedium,
                    ),
                  if (bien.estLongueDuree &&
                      bien.typeBail != null &&
                      bien.dateDebutBail != null)
                    Text(
                      '${bien.typeBail!.libelle} depuis le ${Formats.date(bien.dateDebutBail!)}',
                      style: texte.bodySmall,
                    ),
                  if (!bien.estComplet)
                    Text(
                      'Informations à compléter',
                      style: texte.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            TextButton(onPressed: onModifier, child: const Text('Modifier')),
          ],
        ),
      ),
    );
  }
}
