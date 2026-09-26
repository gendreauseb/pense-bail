import 'package:flutter/material.dart';

import '../../app/design/design.dart';
import '../../core/config/config_app.dart';
import '../../core/config/regles_legales.dart';
import '../../core/format/formats.dart';
import '../../core/widgets/composants.dart';

/// Mentions légales et politique de confidentialité.
class MentionsLegalesPage extends StatelessWidget {
  const MentionsLegalesPage({super.key});

  static const _application = 'Pense-Bail';

  @override
  Widget build(BuildContext context) {
    final t = context.textes;
    final verification = ReglesLegales.derniereVerification;
    final editeur = ConfigApp.editeur;
    final contact = ConfigApp.contactEditeur;

    Widget section(String titre, List<String> paragraphes) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sectionLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitreSection(titre),
          for (final p in paragraphes) ...[
            Text(p, style: t.body),
            const SizedBox(height: AppSpacing.s),
          ],
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(AppIcons.retour),
          tooltip: 'Retour',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.ecran,
          AppSpacing.s,
          AppSpacing.ecran,
          AppSpacing.ecran,
        ),
        children: [
          Text('RÉGLAGES', style: t.overline),
          const SizedBox(height: AppSpacing.xs),
          Semantics(
            header: true,
            child: Text(
              'Mentions légales et confidentialité',
              style: t.headline,
            ),
          ),
          const SizedBox(height: AppSpacing.sectionLarge),
          const Note(
            icone: AppIcons.confidentialite,
            texte:
                'Vos données restent sur votre téléphone. Pense-Bail ne '
                'demande aucun compte et n\'envoie rien à un serveur.',
          ),
          const SizedBox(height: AppSpacing.sectionLarge),
          section('Vos données', [
            'Toutes les informations saisies (profil, biens, baux, '
                'locataires, montants, photos, rappels) sont enregistrées '
                'uniquement dans l\'application, sur ce téléphone. Il n\'y a '
                'ni publicité, ni mesure d\'audience, ni partage avec des '
                'tiers.',
            'Seul accès à internet : l\'application télécharge les indices '
                'de référence des loyers publiés par l\'INSEE (bdm.insee.fr). '
                'Cette demande ne contient aucune de vos informations.',
            'Les courriers, récapitulatifs et sauvegardes ne quittent le '
                'téléphone que lorsque vous choisissez de les partager, de '
                'les imprimer ou de les enregistrer.',
          ]),
          section('Les données de vos locataires', [
            'Vous êtes responsable des informations que vous saisissez sur '
                'vos locataires : n\'enregistrez que celles utiles à la '
                'gestion de la location, et conservez vos fichiers de '
                'sauvegarde en lieu sûr, car ils contiennent ces informations.',
          ]),
          section('Supprimer vos données', [
            'Réglages, puis « Tout effacer » supprime définitivement toutes '
                'les données et photos de l\'application. Désinstaller '
                'l\'application a le même effet. Pensez à faire une '
                'sauvegarde avant si vous souhaitez les conserver.',
          ]),
          section('Avertissement', [
            'Pense-Bail est un outil d\'aide. Ses calculs, rappels et '
                'courriers s\'appuient sur les textes en vigueur, mais ne '
                'remplacent pas un conseil juridique ou fiscal. En cas de '
                'doute, consultez service-public.gouv.fr ou un '
                'professionnel (ADIL, notaire, avocat).',
            if (verification != null)
              'Règles légales vérifiées le ${Formats.date(verification)}.',
            'Sources : service-public.gouv.fr, legifrance.gouv.fr, insee.fr, '
                'impots.gouv.fr.',
          ]),
          if (editeur != null) section('Éditeur', [editeur, ?contact]),
          section('Crédits', [
            'Polices Fraunces et Manrope (SIL Open Font License 1.1). '
                'Icônes Lucide.',
          ]),
          OutlinedButton(
            onPressed: () => showLicensePage(
              context: context,
              applicationName: _application,
            ),
            child: const Text('Licences des composants'),
          ),
        ],
      ),
    );
  }
}
