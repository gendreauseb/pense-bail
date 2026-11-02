import '../../core/config/config_app.dart';
import '../../core/utils/identifiants.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';
import '../services/acces_biens.dart';
import '../services/generateur_echeances.dart';
import '../services/sortie_bien.dart';
import 'verrou_biens.dart';

/// Création, modification et suppression d'un bien et de son bail. Les
/// échéances calculées depuis le bail sont recalculées à chaque changement.
class GestionBiens {
  GestionBiens({
    required this.transactions,
    required this.biens,
    required this.baux,
    required this.echeances,
    required this.droits,
    Future<List<int>> Function()? rappelsParDefaut,
  }) : rappelsParDefaut =
           rappelsParDefaut ?? (() async => ConfigApp.rappelsParDefautJours);

  final Transactions transactions;
  final BienRepository biens;
  final BailRepository baux;
  final EcheanceRepository echeances;

  /// Droits actuels (limite du nombre de biens).
  final Future<Droits> Function() droits;

  /// Rappels des nouvelles échéances (préférences de l'utilisateur).
  final Future<List<int>> Function() rappelsParDefaut;

  late final _verrou = VerrouBiens(biens: biens, droits: droits);

  /// Nouveau bien (après l'onboarding) : bien, bail éventuel, premières
  /// échéances et rappels par défaut.
  ///
  /// Lève [LimiteBiensAtteinte] si les droits ne permettent pas un bien de
  /// plus.
  Future<void> creer({
    required Bien bien,
    Bail? bail,
    required DateTime aujourdhui,
  }) async {
    final droitsActuels = await droits();
    return transactions.executer(() async {
      if (!AccesBiens.peutAjouter(await biens.tous(), droitsActuels)) {
        throw LimiteBiensAtteinte(droitsActuels.maxBiensActifs!);
      }
      await biens.enregistrer(bien);
      if (bail != null) await baux.enregistrer(bail);
      await _creerEcheances([
        if (bail != null)
          ...GenerateurEcheances.depuisBail(
            bien: bien,
            bail: bail,
            aujourdhui: aujourdhui,
          ),
        ...GenerateurEcheances.generiquesBien(
          bien: bien,
          aujourdhui: aujourdhui,
        ),
      ]);
    });
  }

  /// Modifie les informations du bien (photo et investissement compris).
  /// Les échéances du bail ne sont recalculées que si le type de location
  /// change (la révision en dépend) : les reports et rappels choisis par
  /// l'utilisateur sont conservés sinon.
  ///
  /// Lève [BienVerrouille] si le bien est en lecture seule.
  Future<void> modifier({
    required Bien bien,
    required DateTime aujourdhui,
  }) async {
    await _verrou.verifierModifiable(bien.id);
    return transactions.executer(() async {
      final ancien = await biens.parId(bien.id);
      await biens.enregistrer(bien);
      if (ancien?.typeLocation == bien.typeLocation) return;
      final bail = await baux.bailActif(bien.id);
      if (bail != null) await _recalculer(bien, bail, aujourdhui);
    });
  }

  /// Crée ou modifie le bail du bien. Les échéances sont recalculées si une
  /// donnée qui les détermine change (type, dates, durée, révision exclue
  /// ou non par la clause du bail).
  ///
  /// Lève [BienVerrouille] si le bien est en lecture seule.
  Future<void> enregistrerBail({
    required Bien bien,
    required Bail bail,
    required DateTime aujourdhui,
  }) async {
    await _verrou.verifierModifiable(bien.id);
    return transactions.executer(() async {
      final ancien = await baux.bailActif(bien.id);
      await baux.enregistrer(bail);
      final inchange =
          ancien != null &&
          ancien.id == bail.id &&
          ancien.typeBail == bail.typeBail &&
          ancien.dateDebut == bail.dateDebut &&
          ancien.dureeMois == bail.dureeMois &&
          ancien.dateRevision == bail.dateRevision &&
          ancien.revisionPrevue == bail.revisionPrevue;
      if (!inchange) await _recalculer(bien, bail, aujourdhui);
    });
  }

  /// Ajoute ou modifie un locataire du bail du bien [bienId].
  ///
  /// Lève [BienVerrouille] si le bien est en lecture seule.
  Future<void> enregistrerLocataire({
    required String bienId,
    required Locataire locataire,
  }) => transactions.executer(() async {
    await _verrou.verifierModifiable(bienId);
    await baux.enregistrerLocataire(locataire);
  });

  /// Retire un locataire du bail du bien [bienId].
  ///
  /// Lève [BienVerrouille] si le bien est en lecture seule.
  Future<void> supprimerLocataire({
    required String bienId,
    required String locataireId,
  }) => transactions.executer(() async {
    await _verrou.verifierModifiable(bienId);
    await baux.supprimerLocataire(locataireId);
  });

  /// Déclare la vente du bien : il passe en lecture seule dans toutes les
  /// versions et ne compte plus dans la limite de la version gratuite. Les
  /// échéances concernées sont arrêtées (voir SortieBien) ; rien n'est
  /// effacé. Toujours permis, comme la suppression.
  Future<void> declarerVente({
    required String bienId,
    required DateTime date,
    int? prixCentimes,
    int? fraisCentimes,
    required bool loue,
  }) => _changerEtat(
    bienId,
    (b) => b.copyWith(
      venduLe: date,
      prixVenteCentimes: prixCentimes,
      fraisVenteCentimes: fraisCentimes,
      venduLoue: loue,
    ),
  );

  /// Annule la vente : le bien redevient tel qu'il était (en location, ou
  /// retiré s'il l'était) et ses échéances arrêtées sont rétablies.
  Future<void> annulerVente(String bienId) => _changerEtat(
    bienId,
    (b) => b.copyWith(
      venduLe: null,
      prixVenteCentimes: null,
      fraisVenteCentimes: null,
      venduLoue: null,
    ),
  );

  /// « Je ne le loue plus » : lecture seule, hors limite de la version
  /// gratuite ; seules les échéances du bail sont arrêtées.
  Future<void> retirerDeLaLocation({
    required String bienId,
    required DateTime date,
  }) => _changerEtat(bienId, (b) => b.copyWith(retireLe: date));

  /// Remet en location un bien retiré : ses échéances arrêtées sont
  /// rétablies. En version gratuite, il peut redevenir le bien actif à la
  /// place d'un autre (voir AccesBiens.perdraientAcces).
  Future<void> remettreEnLocation(String bienId) =>
      _changerEtat(bienId, (b) => b.copyWith(retireLe: null));

  /// Change l'état du bien puis met le statut de chaque échéance non faite
  /// en accord : arrêtée ou à faire.
  Future<void> _changerEtat(String bienId, Bien Function(Bien) changer) =>
      transactions.executer(() async {
        final bien = await biens.parId(bienId);
        if (bien == null) return;
        final modifie = changer(bien);
        await biens.enregistrer(modifie);
        for (final e in await echeances.parBien(bienId)) {
          if (e.estFaite) continue;
          final statut = SortieBien.statut(e, modifie);
          if (statut != e.statut) {
            await echeances.enregistrer(e.copyWith(statut: statut));
          }
        }
      });

  /// Supprime le bien et tout ce qui s'y rattache (suppression en cascade).
  /// Toujours permis, même pour un bien en lecture seule : c'est
  /// l'utilisateur qui supprime, pas le changement de version.
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
    final rappels = await rappelsParDefaut();
    for (final e in nouvelles) {
      await echeances.definirRappels(e.id, rappels);
    }
  }

  Future<void> _creerEcheances(List<EcheancePrevue> prevues) async {
    final maintenant = DateTime.now();
    final aCreer = [
      for (final p in prevues)
        p.versEcheance(id: Identifiants.nouveau(), maintenant: maintenant),
    ];
    await echeances.enregistrerTout(aCreer);
    final rappels = await rappelsParDefaut();
    for (final e in aCreer) {
      await echeances.definirRappels(e.id, rappels);
    }
  }
}
