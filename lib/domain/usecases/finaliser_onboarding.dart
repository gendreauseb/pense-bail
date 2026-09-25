import '../../core/config/cles_reglages.dart';
import '../../core/config/config_app.dart';
import '../../core/utils/identifiants.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';
import '../services/generateur_echeances.dart';

/// Un bien saisi pendant l'onboarding, avec son bail éventuel
/// (uniquement pour une location longue durée).
class BienInitial {
  const BienInitial({required this.bien, this.bail});
  final Bien bien;
  final Bail? bail;
}

/// Enregistre en une seule fois le résultat de l'onboarding : bailleur,
/// biens, baux, premières échéances et leurs rappels par défaut.
class FinaliserOnboarding {
  FinaliserOnboarding({
    required this.transactions,
    required this.bailleurs,
    required this.biens,
    required this.baux,
    required this.echeances,
    required this.reglages,
  });

  final Transactions transactions;
  final BailleurRepository bailleurs;
  final BienRepository biens;
  final BailRepository baux;
  final EcheanceRepository echeances;
  final ReglagesRepository reglages;

  Future<void> executer({
    required Bailleur bailleur,
    required List<BienInitial> biensInitiaux,
    required DateTime aujourdhui,
  }) {
    final maintenant = DateTime.now();

    final prevues = <EcheancePrevue>[
      for (final initial in biensInitiaux) ...[
        if (initial.bail != null)
          ...GenerateurEcheances.depuisBail(
            bien: initial.bien,
            bail: initial.bail!,
            aujourdhui: aujourdhui,
          ),
        ...GenerateurEcheances.generiquesBien(
          bien: initial.bien,
          aujourdhui: aujourdhui,
        ),
      ],
      ...GenerateurEcheances.globales(aujourdhui: aujourdhui),
    ];
    final aCreer = [
      for (final p in prevues)
        p.versEcheance(id: Identifiants.nouveau(), maintenant: maintenant),
    ];

    return transactions.executer(() async {
      await bailleurs.enregistrer(bailleur);
      for (final initial in biensInitiaux) {
        await biens.enregistrer(initial.bien);
        if (initial.bail != null) await baux.enregistrer(initial.bail!);
      }
      await echeances.enregistrerTout(aCreer);
      for (final echeance in aCreer) {
        await echeances.definirRappels(
          echeance.id,
          ConfigApp.rappelsParDefautJours,
        );
      }
      await reglages.ecrire(ClesReglages.onboardingTermine, 'true');
      await reglages.supprimer(ClesReglages.brouillonOnboarding);
    });
  }
}
