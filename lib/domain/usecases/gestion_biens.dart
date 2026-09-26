import '../../core/config/config_app.dart';
import '../../core/utils/identifiants.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';
import '../services/generateur_echeances.dart';

/// Création, modification et suppression d'un bien et de son bail. Les
/// échéances calculées depuis le bail sont recalculées à chaque changement.
class GestionBiens {
  GestionBiens({
    required this.transactions,
    required this.biens,
    required this.baux,
    required this.echeances,
  });

  final Transactions transactions;
  final BienRepository biens;
  final BailRepository baux;
  final EcheanceRepository echeances;

  /// Nouveau bien (après l'onboarding) : bien, bail éventuel, premières
  /// échéances et rappels par défaut.
  Future<void> creer({
    required Bien bien,
    Bail? bail,
    required DateTime aujourdhui,
  }) => transactions.executer(() async {
    await biens.enregistrer(bien);
    if (bail != null) await baux.enregistrer(bail);
    await _creerEcheances([
      if (bail != null)
        ...GenerateurEcheances.depuisBail(
          bien: bien,
          bail: bail,
          aujourdhui: aujourdhui,
        ),
      ...GenerateurEcheances.generiquesBien(bien: bien, aujourdhui: aujourdhui),
    ]);
  });

  /// Modifie les informations du bien. Les échéances du bail ne sont
  /// recalculées que si le type de location change (la révision en dépend) :
  /// les reports et rappels choisis par l'utilisateur sont conservés sinon.
  Future<void> modifier({required Bien bien, required DateTime aujourdhui}) =>
      transactions.executer(() async {
        final ancien = await biens.parId(bien.id);
        await biens.enregistrer(bien);
        if (ancien?.typeLocation == bien.typeLocation) return;
        final bail = await baux.bailActif(bien.id);
        if (bail != null) await _recalculer(bien, bail, aujourdhui);
      });

  /// Crée ou modifie le bail du bien. Les échéances sont recalculées si une
  /// donnée qui les détermine change (type, dates, durée).
  Future<void> enregistrerBail({
    required Bien bien,
    required Bail bail,
    required DateTime aujourdhui,
  }) => transactions.executer(() async {
    final ancien = await baux.bailActif(bien.id);
    await baux.enregistrer(bail);
    final inchange =
        ancien != null &&
        ancien.id == bail.id &&
        ancien.typeBail == bail.typeBail &&
        ancien.dateDebut == bail.dateDebut &&
        ancien.dureeMois == bail.dureeMois &&
        ancien.dateRevision == bail.dateRevision;
    if (!inchange) await _recalculer(bien, bail, aujourdhui);
  });

  /// Supprime le bien et tout ce qui s'y rattache (suppression en cascade).
  Future<void> supprimer(String bienId) => biens.supprimer(bienId);

  Future<void> _recalculer(Bien bien, Bail bail, DateTime aujourdhui) async {
    final maintenant = DateTime.now();
    final nouvelles = [
      for (final p in GenerateurEcheances.depuisBail(
        bien: bien,
        bail: bail,
        aujourdhui: aujourdhui,
      ))
        p.versEcheance(id: Identifiants.nouveau(), maintenant: maintenant),
    ];
    await echeances.remplacerAutomatiques(bien.id, nouvelles);
    for (final e in nouvelles) {
      await echeances.definirRappels(e.id, ConfigApp.rappelsParDefautJours);
    }
  }

  Future<void> _creerEcheances(List<EcheancePrevue> prevues) async {
    final maintenant = DateTime.now();
    final aCreer = [
      for (final p in prevues)
        p.versEcheance(id: Identifiants.nouveau(), maintenant: maintenant),
    ];
    await echeances.enregistrerTout(aCreer);
    for (final e in aCreer) {
      await echeances.definirRappels(e.id, ConfigApp.rappelsParDefautJours);
    }
  }
}
