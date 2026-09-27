import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/design/design.dart';
import '../../app/routes.dart';
import '../../core/config/regles_legales.dart';
import '../../core/format/formats.dart';
import '../../core/widgets/composants.dart';
import '../../core/widgets/feuille.dart';
import '../../core/widgets/photo_bien.dart';
import '../../data/photos/photo_service.dart';
import '../../data/providers.dart';
import '../../domain/entities/entities.dart';
import 'onglets/onglet_artisans.dart';
import 'onglets/onglet_bail.dart';
import 'onglets/onglet_echeances.dart';
import 'onglets/onglet_infos.dart';
import 'onglets/onglet_rentabilite.dart';

/// Fiche d'un bien (design-system.md §7) : visuel, panneau superposé, chiffres
/// clés, onglets, barre « Réviser le loyer » en longue durée.
class FicheBienPage extends ConsumerStatefulWidget {
  const FicheBienPage({super.key, required this.bienId});
  final String bienId;

  @override
  ConsumerState<FicheBienPage> createState() => _FicheBienPageState();
}

const _onglets = ['Infos', 'Bail', 'Échéances', 'Rentabilité', 'Artisans'];

class _FicheBienPageState extends ConsumerState<FicheBienPage>
    with SingleTickerProviderStateMixin {
  late final _controleurOnglets = TabController(
    length: _onglets.length,
    vsync: this,
  )..addListener(() => setState(() {}));

  /// Le visuel a défilé sous la barre d'état : on affiche un fond derrière
  /// elle pour que le contenu ne passe pas sous l'heure et les icônes.
  final _defilement = ScrollController();
  bool _visuelMasque = false;

  @override
  void initState() {
    super.initState();
    _defilement.addListener(() {
      final masque =
          _defilement.offset >
          AppSizes.visuelFiche - MediaQuery.paddingOf(context).top;
      if (masque != _visuelMasque) setState(() => _visuelMasque = masque);
    });
  }

  @override
  void dispose() {
    _controleurOnglets.dispose();
    _defilement.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bien = ref.watch(bienFluxProvider(widget.bienId));
    return switch (bien) {
      AsyncData(value: final b?) => _fiche(context, b),
      AsyncData() || AsyncError() => Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Ce bien n\'existe plus.')),
      ),
      _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
    };
  }

  Widget _fiche(BuildContext context, Bien bien) {
    final echeances =
        ref.watch(echeancesBienFluxProvider(bien.id)).value ?? const [];
    final revision = echeances
        .where((e) => e.type == TypeEcheance.revisionLoyer && !e.estFaite)
        .firstOrNull;
    final longueDuree = bien.typeLocation.revisionDisponible;
    final dpeGel = ReglesLegales.classesDpeSansRevision.contains(
      bien.classeDpe,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Barre d'état lisible : icônes claires sur une photo, foncées sur
      // l'illustration (fond pâle).
      value: bien.photoChemin == null || _visuelMasque
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Stack(
          children: [
            ListView(
              controller: _defilement,
              padding: EdgeInsets.zero,
              children: [
                _Visuel(bien: bien),
                // Panneau ivoire superposé au visuel (haut arrondi de 24).
                Transform.translate(
                  offset: const Offset(0, -AppRadius.panneau),
                  child: _Panneau(
                    bien: bien,
                    prochaineRevision: revision?.date,
                    controleur: _controleurOnglets,
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.paddingOf(context).top,
              child: IgnorePointer(
                child: AnimatedOpacity(
                  opacity: _visuelMasque ? 1 : 0,
                  duration: const Duration(milliseconds: 150),
                  child: ColoredBox(color: context.couleurs.background),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: longueDuree
            ? BarreActionFixe(
                libelle: 'Réviser le loyer',
                onPressed: () => context.push(Routes.revision(bien.id)),
                legende: dpeGel
                    ? 'Révision impossible : logement classé F ou G.'
                    : revision == null
                    ? 'Renseignez le bail pour connaître la date de révision.'
                    : 'Prochaine révision le ${Formats.date(revision.date)}',
              )
            : null,
      ),
    );
  }
}

class _Visuel extends ConsumerWidget {
  const _Visuel({required this.bien});
  final Bien bien;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.couleurs;
    final styleBouton = IconButton.styleFrom(
      backgroundColor: c.surface,
      foregroundColor: c.textPrimary,
    );
    return SizedBox(
      height: AppSizes.visuelFiche,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PhotoBien(
            chemin: bien.photoChemin,
            typeLogement: bien.typeLogement,
            rayon: 0,
            tailleIcone: AppSizes.pictogrammeGrand,
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.bloc,
                AppSpacing.s,
                AppSpacing.bloc,
                AppSpacing.ecran + AppSpacing.bloc,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(AppIcons.retour),
                      tooltip: 'Retour',
                      style: styleBouton,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      onPressed: () => _photo(context, ref),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(
                          AppSizes.zoneTactile,
                          AppSizes.zoneTactile,
                        ),
                        backgroundColor: c.surface,
                        foregroundColor: c.textPrimary,
                        textStyle: context.textes.label,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.ligne,
                        ),
                      ),
                      icon: const Icon(AppIcons.photo),
                      label: Text(
                        bien.photoChemin == null
                            ? 'Ajouter une photo'
                            : 'Changer la photo',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _photo(BuildContext context, WidgetRef ref) async {
    final choix = await ouvrirFeuille<_ChoixPhoto>(
      context,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.ecran,
          0,
          AppSpacing.ecran,
          AppSpacing.ecran,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TitreSection('Photo du bien'),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pop(_ChoixPhoto.appareil),
              icon: const Icon(AppIcons.appareilPhoto),
              label: const Text('Prendre une photo'),
            ),
            const SizedBox(height: AppSpacing.bloc),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pop(_ChoixPhoto.galerie),
              icon: const Icon(AppIcons.galerie),
              label: const Text('Choisir dans la galerie'),
            ),
            if (bien.photoChemin != null) ...[
              const SizedBox(height: AppSpacing.bloc),
              TextButton.icon(
                onPressed: () => Navigator.of(context).pop(_ChoixPhoto.retirer),
                icon: const Icon(AppIcons.supprimer),
                label: const Text('Retirer la photo'),
              ),
            ],
          ],
        ),
      ),
    );
    if (choix == null || !context.mounted) return;

    final photos = ref.read(photoServiceProvider);
    final biens = ref.read(bienRepositoryProvider);
    final messager = ScaffoldMessenger.of(context);
    String? nouveau;
    if (choix != _ChoixPhoto.retirer) {
      try {
        nouveau = await photos.choisir(
          choix == _ChoixPhoto.appareil
              ? SourcePhoto.appareil
              : SourcePhoto.galerie,
        );
      } on PlatformException {
        messager.showSnackBar(
          const SnackBar(
            content: Text(
              'Accès refusé. Vérifiez les autorisations dans les réglages '
              'du téléphone.',
            ),
          ),
        );
        return;
      }
      if (nouveau == null) return;
    }
    final ancienne = bien.photoChemin;
    await biens.enregistrer(bien.copyWith(photoChemin: nouveau));
    if (ancienne != null) await photos.supprimer(ancienne);
  }
}

enum _ChoixPhoto { appareil, galerie, retirer }

class _Panneau extends StatelessWidget {
  const _Panneau({
    required this.bien,
    required this.prochaineRevision,
    required this.controleur,
  });

  final Bien bien;
  final DateTime? prochaineRevision;
  final TabController controleur;

  @override
  Widget build(BuildContext context) {
    final c = context.couleurs;
    final t = context.textes;
    final revision = prochaineRevision;

    return Container(
      decoration: BoxDecoration(
        color: c.background,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.panneau),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.ecran,
        AppSpacing.ecran,
        AppSpacing.ecran,
        AppSpacing.ecran,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(header: true, child: Text(bien.nom, style: t.headline)),
          const SizedBox(height: AppSpacing.xxs),
          Text(bien.adresseComplete, style: t.secondary),
          const SizedBox(height: AppSpacing.bloc),
          Wrap(
            spacing: AppSpacing.s,
            runSpacing: AppSpacing.s,
            children: [
              PuceInfo(
                libelle: bien.typeLogement.libelle,
                icone: AppIcons.typeLogement(bien.typeLogement),
              ),
              PuceInfo(
                libelle: bien.typeLocation.libelle,
                icone: AppIcons.typeLocation(bien.typeLocation),
              ),
              if (bien.classeDpe case final dpe?)
                PuceInfo(
                  libelle: 'DPE ${dpe.libelle}',
                  icone: AppIcons.energie,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.section),
          _ChiffresCles(
            loyer: bien.loyerHcCentimes,
            charges: bien.chargesCentimes,
            revision: revision,
            revisionPossible: bien.typeLocation.revisionDisponible,
          ),
          const SizedBox(height: AppSpacing.sectionSerree),
          TabBar(
            controller: controleur,
            isScrollable: true,
            tabs: [for (final o in _onglets) Tab(text: o)],
          ),
          const SizedBox(height: AppSpacing.section),
          switch (controleur.index) {
            0 => OngletInfos(bien: bien),
            1 => OngletBail(bien: bien),
            2 => OngletEcheances(bien: bien),
            3 => OngletRentabilite(bien: bien),
            _ => OngletArtisans(bien: bien),
          },
        ],
      ),
    );
  }
}

/// Carte des chiffres clés : loyer HC, charges, prochaine révision.
class _ChiffresCles extends StatelessWidget {
  const _ChiffresCles({
    required this.loyer,
    required this.charges,
    required this.revision,
    required this.revisionPossible,
  });

  final int loyer;
  final int charges;
  final DateTime? revision;
  final bool revisionPossible;

  @override
  Widget build(BuildContext context) {
    final t = context.textes;
    final revision = this.revision;
    Widget colonne(String valeur, String libelle) => Expanded(
      child: Semantics(
        container: true,
        label: '$libelle : $valeur',
        excludeSemantics: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(valeur, style: t.figure),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(libelle, style: t.caption),
          ],
        ),
      ),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.carte),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            colonne(Formats.montant(loyer), 'Loyer hors charges'),
            const SizedBox(width: AppSpacing.bloc),
            colonne(Formats.montant(charges), 'Charges'),
            const SizedBox(width: AppSpacing.bloc),
            colonne(
              revision != null
                  ? Formats.date(revision)
                  : revisionPossible
                  ? 'À définir'
                  : 'Sans objet',
              'Prochaine révision',
            ),
          ],
        ),
      ),
    );
  }
}
