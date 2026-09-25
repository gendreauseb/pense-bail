import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/photo_bien.dart';
import '../../../data/photos/photo_service.dart';
import '../../../data/providers.dart';
import '../brouillon_onboarding.dart';
import '../onboarding_controller.dart';
import '../onboarding_page.dart';
import '../widgets/gabarit_etape.dart';

class EtapePhoto extends ConsumerStatefulWidget {
  const EtapePhoto({super.key, required this.brouillon});
  final BrouillonOnboarding brouillon;

  @override
  ConsumerState<EtapePhoto> createState() => _EtapePhotoState();
}

class _EtapePhotoState extends ConsumerState<EtapePhoto> {
  bool _enCours = false;

  OnboardingController get _controleur =>
      ref.read(onboardingControllerProvider.notifier);

  @override
  void initState() {
    super.initState();
    _recupererPhotoPerdue();
  }

  /// Android a pu fermer l'application pendant la prise de vue.
  Future<void> _recupererPhotoPerdue() async {
    try {
      final chemin = await ref
          .read(photoServiceProvider)
          .recupererPhotoPerdue();
      if (chemin != null && mounted) await _controleur.definirPhoto(chemin);
    } catch (_) {
      // Rien à récupérer.
    }
  }

  Future<void> _choisir(SourcePhoto source) async {
    setState(() => _enCours = true);
    try {
      final chemin = await ref.read(photoServiceProvider).choisir(source);
      if (chemin != null) await _controleur.definirPhoto(chemin);
    } on PlatformException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              source == SourcePhoto.appareil
                  ? 'Impossible d\'accéder à l\'appareil photo. Vérifiez les '
                        'autorisations dans les réglages du téléphone.'
                  : 'Impossible d\'accéder à vos photos. Vérifiez les '
                        'autorisations dans les réglages du téléphone.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _enCours = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.brouillon;
    final bien = b.bienCourant;
    final aUnePhoto = bien.photoChemin != null;
    final dernier = b.depuisRecapitulatif || b.indexBien >= b.nombreBiens - 1;
    final nom = bien.nom.trim().isEmpty ? 'votre bien' : bien.nom.trim();

    return GabaritEtape(
      entete: ProgressionBien(brouillon: b),
      titre: 'Une photo de $nom ?',
      sousTitre:
          'Facultatif : elle vous aidera à reconnaître vos biens d\'un coup d\'œil.',
      onRetour: _controleur.precedent,
      libelleAction: aUnePhoto
          ? (dernier ? 'Voir le récapitulatif' : 'Bien suivant')
          : 'Passer la photo',
      onAction: _enCours ? null : _controleur.suivant,
      contenu: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: Stack(
              fit: StackFit.expand,
              children: [
                PhotoBien(
                  chemin: bien.photoChemin,
                  typeLogement: bien.typeLogement,
                  tailleIcone: 72,
                ),
                if (_enCours)
                  const ColoredBox(
                    color: Colors.black26,
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
          if (!aUnePhoto) ...[
            const SizedBox(height: 8),
            Text(
              'Sans photo, cette illustration sera affichée.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: _enCours ? null : () => _choisir(SourcePhoto.appareil),
            icon: const Icon(Icons.photo_camera_outlined),
            label: Text(
              aUnePhoto ? 'Reprendre une photo' : 'Prendre une photo',
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _enCours ? null : () => _choisir(SourcePhoto.galerie),
            icon: const Icon(Icons.photo_library_outlined),
            label: const Text('Choisir dans la galerie'),
          ),
          if (aUnePhoto) ...[
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: _enCours ? null : () => _controleur.definirPhoto(null),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Retirer la photo'),
            ),
          ],
        ],
      ),
    );
  }
}
