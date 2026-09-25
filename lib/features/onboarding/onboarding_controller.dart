import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/etat_app.dart';
import '../../core/config/cles_reglages.dart';
import '../../core/utils/dates.dart';
import '../../core/utils/identifiants.dart';
import '../../data/photos/photo_service.dart';
import '../../data/providers.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/usecases/finaliser_onboarding.dart';
import 'brouillon_onboarding.dart';

final finaliserOnboardingProvider = Provider<FinaliserOnboarding>(
  (ref) => FinaliserOnboarding(
    transactions: ref.watch(transactionsProvider),
    bailleurs: ref.watch(bailleurRepositoryProvider),
    biens: ref.watch(bienRepositoryProvider),
    baux: ref.watch(bailRepositoryProvider),
    echeances: ref.watch(echeanceRepositoryProvider),
    reglages: ref.watch(reglagesRepositoryProvider),
  ),
);

final onboardingControllerProvider =
    AsyncNotifierProvider<OnboardingController, BrouillonOnboarding>(
      OnboardingController.new,
    );

/// Pilote l'onboarding : navigation entre les étapes, saisie, sauvegarde
/// automatique du brouillon et enregistrement final.
class OnboardingController extends AsyncNotifier<BrouillonOnboarding> {
  late ReglagesRepository _reglages;
  late PhotoService _photos;
  Timer? _minuterie;
  bool _termine = false;

  /// Dernier état connu, pour pouvoir sauvegarder même pendant la
  /// destruction du contrôleur (où `state` n'est plus accessible).
  BrouillonOnboarding? _dernier;

  static const _delaiSauvegarde = Duration(milliseconds: 400);

  @override
  Future<BrouillonOnboarding> build() async {
    _reglages = ref.read(reglagesRepositoryProvider);
    _photos = ref.read(photoServiceProvider);
    ref.onDispose(() {
      if (_minuterie?.isActive ?? false) {
        _minuterie!.cancel();
        _sauvegarder();
      }
    });

    final json = await _reglages.lire(ClesReglages.brouillonOnboarding);
    var brouillon = const BrouillonOnboarding();
    if (json != null) {
      try {
        brouillon = BrouillonOnboarding.fromJson(
          jsonDecode(json) as Map<String, dynamic>,
        );
      } catch (e) {
        debugPrint('Brouillon d\'onboarding illisible, ignoré : $e');
      }
    }
    return _dernier = brouillon;
  }

  BrouillonOnboarding get _b => state.requireValue;

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  void suivant() {
    final b = _b;
    switch (b.etape) {
      case EtapeOnboarding.bienvenue:
        _aller(b.copyWith(etape: EtapeOnboarding.identite));
      case EtapeOnboarding.identite:
        _aller(
          b.depuisRecapitulatif
              ? _versRecapitulatif(b)
              : b.copyWith(etape: EtapeOnboarding.nombreBiens),
        );
      case EtapeOnboarding.nombreBiens:
        final biens = [
          ...b.biens,
          for (var i = b.biens.length; i < b.nombreBiens; i++)
            BrouillonBien(id: Identifiants.nouveau()),
        ];
        _aller(
          b.copyWith(etape: EtapeOnboarding.bien, indexBien: 0, biens: biens),
        );
      case EtapeOnboarding.bien:
        _aller(b.copyWith(etape: EtapeOnboarding.photoBien));
      case EtapeOnboarding.photoBien:
        final dernier = b.indexBien >= b.nombreBiens - 1;
        _aller(
          b.depuisRecapitulatif || dernier
              ? _versRecapitulatif(b)
              : b.copyWith(
                  etape: EtapeOnboarding.bien,
                  indexBien: b.indexBien + 1,
                ),
        );
      case EtapeOnboarding.recapitulatif:
        break;
    }
  }

  /// Retourne `false` s'il n'y a pas d'étape précédente.
  bool precedent() {
    final b = _b;
    switch (b.etape) {
      case EtapeOnboarding.bienvenue:
        return false;
      case EtapeOnboarding.identite:
        _aller(
          b.depuisRecapitulatif
              ? _versRecapitulatif(b)
              : b.copyWith(etape: EtapeOnboarding.bienvenue),
        );
      case EtapeOnboarding.nombreBiens:
        _aller(b.copyWith(etape: EtapeOnboarding.identite));
      case EtapeOnboarding.bien:
        if (b.depuisRecapitulatif) {
          _aller(_versRecapitulatif(b));
        } else if (b.indexBien == 0) {
          _aller(b.copyWith(etape: EtapeOnboarding.nombreBiens));
        } else {
          _aller(
            b.copyWith(
              etape: EtapeOnboarding.photoBien,
              indexBien: b.indexBien - 1,
            ),
          );
        }
      case EtapeOnboarding.photoBien:
        _aller(b.copyWith(etape: EtapeOnboarding.bien));
      case EtapeOnboarding.recapitulatif:
        _aller(
          b.copyWith(
            etape: EtapeOnboarding.photoBien,
            indexBien: b.nombreBiens - 1,
          ),
        );
    }
    return true;
  }

  /// Depuis le récapitulatif : modifier les coordonnées ou un bien, puis
  /// revenir directement au récapitulatif.
  void modifierIdentite() => _aller(
    _b.copyWith(etape: EtapeOnboarding.identite, depuisRecapitulatif: true),
  );

  void modifierBien(int index) => _aller(
    _b.copyWith(
      etape: EtapeOnboarding.bien,
      indexBien: index,
      depuisRecapitulatif: true,
    ),
  );

  BrouillonOnboarding _versRecapitulatif(BrouillonOnboarding b) => b.copyWith(
    etape: EtapeOnboarding.recapitulatif,
    depuisRecapitulatif: false,
  );

  // ---------------------------------------------------------------------------
  // Saisie
  // ---------------------------------------------------------------------------

  void majIdentite(BrouillonIdentite identite) =>
      _maj(_b.copyWith(identite: identite));

  void definirNombreBiens(int nombre) => _maj(_b.copyWith(nombreBiens: nombre));

  void majBienCourant(BrouillonBien bien) {
    final biens = [..._b.biens]..[_b.indexBien] = bien;
    _maj(_b.copyWith(biens: biens));
  }

  /// Remplace (ou retire, si [chemin] est null) la photo du bien courant.
  Future<void> definirPhoto(String? chemin) async {
    final ancienne = _b.bienCourant.photoChemin;
    majBienCourant(_b.bienCourant.copyWith(photoChemin: chemin));
    if (ancienne != null && ancienne != chemin) {
      await _photos.supprimer(ancienne);
    }
  }

  // ---------------------------------------------------------------------------
  // Fin
  // ---------------------------------------------------------------------------

  Future<void> terminer() async {
    final b = _b;
    final retenus = b.biensRetenus;
    if (retenus.length != b.nombreBiens ||
        !retenus.every((x) => x.estComplet)) {
      throw StateError('Tous les biens doivent être complétés.');
    }

    _minuterie?.cancel();
    _termine = true;
    final maintenant = DateTime.now();
    try {
      await ref
          .read(finaliserOnboardingProvider)
          .executer(
            bailleur: b.identite.versBailleur(
              id: Identifiants.nouveau(),
              maintenant: maintenant,
            ),
            biensInitiaux: [
              for (final (i, bien) in retenus.indexed)
                BienInitial(
                  bien: bien.versBien(ordre: i, maintenant: maintenant),
                  bail: bien.versBail(
                    id: Identifiants.nouveau(),
                    maintenant: maintenant,
                  ),
                ),
            ],
            aujourdhui: Dates.aujourdhui(),
          );
    } catch (_) {
      _termine = false;
      rethrow;
    }

    // Photos des fiches abandonnées (nombre de biens réduit).
    for (final abandonne in b.biens.skip(b.nombreBiens)) {
      await _photos.supprimer(abandonne.photoChemin);
    }
    ref.read(onboardingTermineProvider.notifier).marquerTermine();
  }

  // ---------------------------------------------------------------------------
  // Sauvegarde
  // ---------------------------------------------------------------------------

  /// Changement d'étape : sauvegarde immédiate.
  void _aller(BrouillonOnboarding b) {
    state = AsyncData(_dernier = b);
    _minuterie?.cancel();
    _sauvegarder();
  }

  /// Saisie : sauvegarde différée pour ne pas écrire à chaque lettre.
  void _maj(BrouillonOnboarding b) {
    state = AsyncData(_dernier = b);
    _minuterie?.cancel();
    _minuterie = Timer(_delaiSauvegarde, _sauvegarder);
  }

  Future<void> _sauvegarder() async {
    final b = _dernier;
    if (_termine || b == null) return;
    await _reglages.ecrire(
      ClesReglages.brouillonOnboarding,
      jsonEncode(b.toJson()),
    );
  }
}
