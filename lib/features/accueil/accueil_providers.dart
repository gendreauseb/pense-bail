import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/etat_app.dart';
import '../../data/providers.dart';
import '../../domain/entities/entities.dart';
import '../../domain/services/proximite.dart';
import '../../domain/services/tableau_de_bord.dart';

/// Données du tableau de bord, prêtes à afficher.
class DonneesAccueil {
  const DonneesAccueil({
    required this.prenom,
    required this.biens,
    required this.echeances,
    required this.synthese,
    required this.invitations,
    required this.prochaineParBien,
  });

  final String prenom;
  final List<Bien> biens;

  /// Échéances à faire, triées par date.
  final List<Echeance> echeances;
  final Synthese synthese;
  final List<Invitation> invitations;
  final Map<String, Echeance> prochaineParBien;
}

final donneesAccueilProvider = Provider<AsyncValue<DonneesAccueil>>((ref) {
  final bailleur = ref.watch(bailleurFluxProvider);
  final biens = ref.watch(biensFluxProvider);
  final baux = ref.watch(bauxActifsFluxProvider);
  final echeances = ref.watch(echeancesAFaireFluxProvider);

  for (final flux in [bailleur, biens, baux, echeances]) {
    if (flux case AsyncError(:final error, :final stackTrace)) {
      return AsyncError(error, stackTrace);
    }
  }
  if (!biens.hasValue || !baux.hasValue || !echeances.hasValue) {
    return const AsyncLoading();
  }
  return AsyncData(
    DonneesAccueil(
      prenom: bailleur.value?.prenom ?? '',
      biens: biens.requireValue,
      echeances: echeances.requireValue,
      synthese: TableauDeBord.synthese(biens.requireValue),
      invitations: TableauDeBord.invitations(
        biens.requireValue,
        baux.requireValue,
      ),
      prochaineParBien: TableauDeBord.prochaineParBien(echeances.requireValue),
    ),
  );
});

/// Filtre « Prochaines échéances » : `null` = tous les biens.
final filtreBienProvider = NotifierProvider<FiltreBien, String?>(
  FiltreBien.new,
);

class FiltreBien extends Notifier<String?> {
  @override
  String? build() => null;

  void choisir(String? bienId) => state = bienId;
}

/// Nombre d'échéances urgentes (dépassées ou dans 7 jours au plus).
final nombreUrgentesProvider = Provider<int>((ref) {
  final aujourdhui = ref.watch(aujourdhuiProvider);
  final echeances = ref.watch(echeancesAFaireFluxProvider).value ?? const [];
  return echeances
      .where(
        (e) =>
            Proximite.depuisDate(e.date, aujourdhui: aujourdhui) ==
            Proximite.urgent,
      )
      .length;
});

/// Les notifications sont-elles autorisées ? (rafraîchi après une demande)
final notificationsAutoriseesProvider = FutureProvider.autoDispose<bool>(
  (ref) => ref.watch(serviceNotificationsProvider).sontAutorisees(),
);
