import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/design/design.dart';
import '../../../app/routes.dart';
import '../../../core/format/formats.dart';
import '../../../core/widgets/composants.dart';
import '../../../core/widgets/formulaires.dart';
import '../../../core/widgets/listes.dart';
import '../../../data/providers.dart';
import '../../../domain/entities/entities.dart';

class OngletInfos extends ConsumerWidget {
  const OngletInfos({super.key, required this.bien});
  final Bien bien;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surface = bien.surfaceM2;
    final dateDpe = bien.dateDpe;
    const nonRenseigne = 'Non renseigné';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CarteListe(
          enfants: [
            LigneInfo(
              libelle: 'Type de logement',
              valeur: bien.typeLogement.libelle,
            ),
            LigneInfo(
              libelle: 'Type de location',
              valeur: bien.typeLocation.libelle,
            ),
            LigneInfo(libelle: 'Adresse', valeur: bien.adresseComplete),
            LigneInfo(
              libelle: 'Loyer hors charges',
              valeur: Formats.parMois(bien.loyerHcCentimes),
            ),
            LigneInfo(
              libelle: 'Charges',
              valeur: Formats.parMois(bien.chargesCentimes),
            ),
            LigneInfo(
              libelle: 'Surface habitable',
              valeur: surface == null
                  ? nonRenseigne
                  : '${Formats.decimal(surface).replaceAll(',00', '')} m²',
            ),
            LigneInfo(
              libelle: 'Classe énergie (DPE)',
              valeur: bien.classeDpe?.libelle ?? nonRenseigne,
            ),
            LigneInfo(
              libelle: 'Date du DPE',
              valeur: dateDpe == null ? nonRenseigne : Formats.date(dateDpe),
            ),
            if (bien.typeLogement == TypeLogement.immeuble)
              LigneInfo(
                libelle: 'Nombre de lots',
                valeur: bien.nombreLots?.toString() ?? nonRenseigne,
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.bloc),
        OutlinedButton.icon(
          onPressed: () => context.push(Routes.modifierBien(bien.id)),
          icon: const Icon(AppIcons.modifier),
          label: const Text('Modifier les informations'),
        ),
        const SizedBox(height: AppSpacing.sectionLarge),
        Center(
          child: TextButton.icon(
            onPressed: () => _supprimer(context, ref),
            style: TextButton.styleFrom(
              foregroundColor: context.couleurs.erreur,
            ),
            icon: const Icon(AppIcons.supprimer),
            label: const Text('Supprimer ce bien'),
          ),
        ),
      ],
    );
  }

  Future<void> _supprimer(BuildContext context, WidgetRef ref) async {
    final ok = await confirmerSuppression(
      context,
      titre: 'Supprimer « ${bien.nom} » ?',
      message:
          'Le bail, les locataires, les échéances, le journal et les '
          'interventions de ce bien seront supprimés définitivement.',
    );
    if (!ok || !context.mounted) return;
    final navigateur = Navigator.of(context);
    final messager = ScaffoldMessenger.of(context);
    final photo = bien.photoChemin;
    navigateur.pop();
    await ref.read(gestionBiensProvider).supprimer(bien.id);
    if (photo != null) await ref.read(photoServiceProvider).supprimer(photo);
    messager.showSnackBar(
      SnackBar(content: Text('« ${bien.nom} » a été supprimé.')),
    );
  }
}
