import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

import '../../core/utils/identifiants.dart';

enum SourcePhoto { appareil, galerie }

/// Prise de vue / choix dans la galerie et stockage des photos des biens.
///
/// Les photos sont copiées dans le dossier Documents de l'application et
/// référencées par un chemin RELATIF (ex. « photos/abc.jpg ») : sur iOS, le
/// chemin absolu du dossier change à chaque mise à jour de l'application.
class PhotoService {
  PhotoService(this._documents, {ImagePicker? picker})
    : _picker = picker ?? ImagePicker();

  final Directory _documents;
  final ImagePicker _picker;

  static const _dossier = 'photos';

  /// Retourne le chemin relatif de la photo, ou `null` si l'utilisateur annule.
  Future<String?> choisir(SourcePhoto source) async {
    final fichier = await _picker.pickImage(
      source: source == SourcePhoto.appareil
          ? ImageSource.camera
          : ImageSource.gallery,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 85,
    );
    return fichier == null ? null : _conserver(fichier);
  }

  /// Android peut fermer l'application pendant la prise de vue : la photo est
  /// alors récupérée au redémarrage.
  Future<String?> recupererPhotoPerdue() async {
    if (!Platform.isAndroid) return null;
    final reponse = await _picker.retrieveLostData();
    final fichier = reponse.file;
    return (reponse.isEmpty || fichier == null) ? null : _conserver(fichier);
  }

  File fichier(String cheminRelatif) =>
      File(p.join(_documents.path, cheminRelatif));

  Future<void> supprimer(String? cheminRelatif) async {
    if (cheminRelatif == null) return;
    final f = fichier(cheminRelatif);
    if (await f.exists()) await f.delete();
  }

  Future<String> _conserver(XFile source) async {
    final dossier = Directory(p.join(_documents.path, _dossier));
    await dossier.create(recursive: true);
    final extension = p.extension(source.path).toLowerCase();
    final relatif = p.join(
      _dossier,
      '${Identifiants.nouveau()}${extension.isEmpty ? '.jpg' : extension}',
    );
    await source.saveTo(p.join(_documents.path, relatif));
    return relatif;
  }
}
