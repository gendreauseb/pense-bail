import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/design/design.dart';
import '../../../app/etat_app.dart';
import '../../../app/routes.dart';
import '../../../core/config/regles_legales.dart';
import '../../../core/format/formats.dart';
import '../../../core/utils/dates.dart';
import '../../../core/widgets/choix_cartes.dart';
import '../../../core/widgets/composants.dart';
import '../../../core/widgets/formulaires.dart';
import '../../../core/widgets/listes.dart';
import '../../../data/providers.dart';
import '../../../domain/entities/entities.dart';
import '../../echeances/detail_echeance.dart';
import '../../echeances/edition_echeance_page.dart';
import '../../echeances/textes_echeances.dart';

class OngletEcheances extends ConsumerWidget {
  const OngletEcheances({super.key, required this.bien});
  final Bien bien;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aujourdhui = ref.watch(aujourdhuiProvider);
    final toutes =
        ref.watch(echeancesBienFluxProvider(bien.id)).value ?? const [];
    final aFaire = toutes.where((e) => !e.estFaite).toList();
    final faites = toutes.where((e) => e.estFaite).toList().reversed.toList();

    final groupes = <String, List<Echeance>>{
      'Calculées depuis le bail': [
        for (final e in aFaire)
          if (e.automatique) e,
      ],
      'Obligations et entretien': [
        for (final e in aFaire)
          if (!e.automatique && e.type != TypeEcheance.personnalisee) e,
      ],
      'Rappels personnels': [
        for (final e in aFaire)
          if (e.type == TypeEcheance.personnalisee) e,
      ],
    };

    Widget ligne(Echeance e) => LigneEcheance(
      echeance: e,
      sousTitre: [
        Formats.date(e.date),
        if (texteRecurrence(e.intervalleMois) case final r?) r.toLowerCase(),
      ].join(', '),
      aujourdhui: aujourdhui,
      avecTuile: false,
      dense: false,
      onTap: () => ouvrirDetailEcheance(context, e),
      onCalculer: e.type == TypeEcheance.revisionLoyer
          ? () => context.push(Routes.revision(bien.id))
          : null,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (aFaire.isEmpty)
          const EtatVide(
            icone: AppIcons.echeance,
            texte: 'Aucune échéance à venir pour ce bien.',
          ),
        for (final groupe in groupes.entries)
          if (groupe.value.isNotEmpty) ...[
            Text(groupe.key.toUpperCase(), style: context.textes.overline),
            const SizedBox(height: AppSpacing.s),
            CarteListe(enfants: [for (final e in groupe.value) ligne(e)]),
            const SizedBox(height: AppSpacing.section),
          ],
        BoutonPointille(
          libelle: 'Ajouter un rappel',
          onPressed: () => _ajouter(context),
        ),
        if (faites.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sectionLarge),
          Text('DÉJÀ FAITES', style: context.textes.overline),
          const SizedBox(height: AppSpacing.s),
          CarteListe(
            enfants: [
              for (final e in faites)
                LigneInfo(
                  libelle: e.titre,
                  valeur: e.faiteLe == null
                      ? 'Faite'
                      : 'Faite le ${Formats.date(e.faiteLe!)}',
                ),
            ],
          ),
        ],
      ],
    );
  }

  Future<void> _ajouter(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _AjoutRappel(bien: bien),
  );
}

/// Choix du rappel à ajouter, avec des dates suggérées modifiables.
class _AjoutRappel extends ConsumerWidget {
  const _AjoutRappel({required this.bien});
  final Bien bien;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aujourdhui = ref.watch(aujourdhuiProvider);
    final dansUnAn = Dates.ajouterMois(aujourdhui, 12);

    void ouvrir(Preremplissage p) {
      final routeur = GoRouter.of(context);
      Navigator.of(context).pop();
      routeur.push(Routes.avec(Routes.nouvelleEcheance, p.versParametres()));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.ecran,
        0,
        AppSpacing.ecran,
        AppSpacing.ecran,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TitreSection('Ajouter un rappel'),
          CarteAction(
            icone: AppIcons.assurance,
            titre: TypeEcheance.assurancePno.libelle,
            sousTitre: 'Chaque année, à la date de votre contrat',
            onTap: () => ouvrir(
              Preremplissage(
                bienId: bien.id,
                type: TypeEcheance.assurancePno,
                titre: TypeEcheance.assurancePno.libelle,
                date: dansUnAn,
                intervalleMois: 12,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.bloc),
          CarteAction(
            icone: AppIcons.chaudiere,
            titre: 'Entretien de la chaudière',
            sousTitre: 'Demander l\'attestation annuelle au locataire',
            onTap: () => ouvrir(
              Preremplissage(
                bienId: bien.id,
                type: TypeEcheance.entretienChaudiere,
                titre: TypeEcheance.entretienChaudiere.libelle,
                date: dansUnAn,
                intervalleMois: 12,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.bloc),
          CarteAction(
            icone: AppIcons.diagnostic,
            titre: 'Validité d\'un diagnostic',
            sousTitre: 'DPE, électricité, gaz, plomb…',
            onTap: () async {
              final p = await showModalBottomSheet<Preremplissage>(
                context: context,
                useRootNavigator: true,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (_) => _Diagnostic(bien: bien),
              );
              if (p != null && context.mounted) ouvrir(p);
            },
          ),
          const SizedBox(height: AppSpacing.bloc),
          CarteAction(
            icone: AppIcons.echeance,
            titre: 'Rappel personnel',
            sousTitre: 'Un titre, une date, une répétition',
            onTap: () => ouvrir(Preremplissage(bienId: bien.id)),
          ),
        ],
      ),
    );
  }
}

/// Diagnostic : type et date de réalisation, d'où la date d'expiration
/// (validité légale, voir ReglesLegales.diagnostics).
class _Diagnostic extends ConsumerStatefulWidget {
  const _Diagnostic({required this.bien});
  final Bien bien;

  @override
  ConsumerState<_Diagnostic> createState() => _DiagnosticState();
}

class _DiagnosticState extends ConsumerState<_Diagnostic> {
  final _cle = GlobalKey<FormState>();
  TypeDiagnostic? _type;
  DateTime? _realise;

  @override
  Widget build(BuildContext context) {
    final t = context.textes;
    final aujourdhui = ref.watch(aujourdhuiProvider);
    final type = _type;
    final regle = type == null ? null : ReglesLegales.diagnostic(type);
    final validite = regle?.validiteMois;
    final remarque = regle?.remarque;

    return Form(
      key: _cle,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.ecran,
          0,
          AppSpacing.ecran,
          AppSpacing.ecran,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TitreSection('Validité d\'un diagnostic'),
            ChampChoix<TypeDiagnostic>(
              options: TypeDiagnostic.values,
              valeurInitiale: _type,
              libelle: (d) => d.libelle,
              colonnesMax: 1,
              messageObligatoire: 'Choisissez le diagnostic.',
              onChanged: (d) => setState(() => _type = d),
            ),
            if (regle != null) ...[
              const SizedBox(height: AppSpacing.bloc),
              Note(
                icone: AppIcons.diagnostic,
                texte: [
                  if (validite != null)
                    'Valable ${_duree(validite)} pour une location.'
                  else
                    'Pas de date d\'expiration dans le cas général.',
                  ?remarque,
                ].join(' '),
              ),
            ],
            const SizedBox(height: AppSpacing.bloc),
            if (validite != null) ...[
              ChampDate(
                libelle: 'Date de réalisation du diagnostic',
                date: _realise,
                premiere: DateTime(2000),
                derniere: aujourdhui,
                messageObligatoire: 'Indiquez la date du diagnostic.',
                onChanged: (d) => setState(() => _realise = d),
              ),
              const SizedBox(height: AppSpacing.s),
              FilledButton(
                onPressed: () {
                  if (!validerEtMontrerErreur(_cle)) return;
                  Navigator.of(context).pop(
                    Preremplissage(
                      bienId: widget.bien.id,
                      type: TypeEcheance.diagnostic,
                      typeDiagnostic: type,
                      titre: 'Renouveler : ${type!.libelle}',
                      date: Dates.ajouterMois(_realise!, validite),
                      intervalleMois: validite,
                      notes:
                          'Diagnostic réalisé le ${Formats.date(_realise!)}.',
                    ),
                  );
                },
                child: const Text('Continuer'),
              ),
            ] else if (type != null)
              Text(
                'Aucun rappel n\'est nécessaire pour ce diagnostic.',
                style: t.secondary,
              ),
          ],
        ),
      ),
    );
  }

  static String _duree(int mois) => mois % 12 == 0
      ? '${mois ~/ 12} an${mois >= 24 ? 's' : ''}'
      : '$mois mois';
}
