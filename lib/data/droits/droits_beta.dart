import '../../core/config/cles_reglages.dart';
import '../../core/config/config_app.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';

/// Statut gratuit / Premium simulé pendant la bêta, choisi par le testeur
/// dans les réglages. Aucun achat.
///
/// C'est la seule source des droits : l'abonnement réel (RevenueCat) la
/// remplacera sans que le reste de l'application change. Hors bêta, la
/// version est toujours gratuite.
class DroitsBeta implements SourceDroits {
  DroitsBeta({required this._reglages, this.estBeta = ConfigApp.estBeta});

  final ReglagesRepository _reglages;

  /// Paramètre pour les tests ; en production : ConfigApp.estBeta.
  final bool estBeta;

  static const _premium = 'premium';
  static const _gratuit = 'gratuit';

  @override
  Stream<Droits> surveiller() {
    if (!estBeta) return Stream.value(Droits.gratuit);
    return _reglages
        .surveiller(ClesReglages.modePremiumBeta)
        .map(_depuisValeur)
        .distinct();
  }

  /// Bascule du testeur. Sans effet hors bêta.
  Future<void> definirPremium(bool premium) async {
    if (!estBeta) return;
    await _reglages.ecrire(
      ClesReglages.modePremiumBeta,
      premium ? _premium : _gratuit,
    );
  }

  /// Simule l'expiration d'un abonnement : version gratuite, et le message
  /// de fin d'abonnement sera affiché sur l'accueil (une fois). L'abonnement
  /// réel fera de même quand il constatera l'expiration. Sans effet hors
  /// bêta.
  Future<void> simulerFinAbonnement() async {
    if (!estBeta) return;
    await definirPremium(false);
    await _reglages.ecrire(ClesReglages.finAbonnementAAnnoncer, 'true');
  }

  static Droits _depuisValeur(String? valeur) => switch (valeur) {
    _premium => Droits.premium,
    _gratuit => Droits.gratuit,
    _ => ConfigApp.betaPremiumParDefaut ? Droits.premium : Droits.gratuit,
  };
}
