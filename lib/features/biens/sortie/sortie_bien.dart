// Bien vendu ou retiré de la location : choix depuis « Supprimer ce bien »,
// déclaration de la vente, confirmations (decisions.md, « Biens vendus ou
// retirés de la location »).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/design/design.dart';
import '../../../app/etat_app.dart';
import '../../../app/routes.dart';
import '../../../core/format/formats.dart';
import '../../../core/widgets/choix_cartes.dart';
import '../../../core/widgets/composants.dart';
import '../../../core/widgets/feuille.dart';
import '../../../core/widgets/formulaires.dart';
import '../../../data/providers.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/services/acces_biens.dart';
import '../../../domain/services/sortie_bien.dart';

enum _Choix { vendu, plusLoue, supprimer }

/// « Supprimer ce bien » : vendu, plus loué (réversible) ou suppression
/// définitive. Un bien vendu ne propose que la suppression.
Future<void> ouvrirSortieBien(
  BuildContext context,
  WidgetRef ref,
  Bien bien,
) async {
  final choix = bien.vendu
      ? _Choix.supprimer
      : await ouvrirFeuille<_Choix>(
          context,
          builder: (context) => _Choix3(bien: bien),
        );
  if (choix == null || !context.mounted) return;
  switch (choix) {
    case _Choix.vendu:
      await context.push(Routes.vente(bien.id));
    case _Choix.plusLoue:
      await _retirer(context, ref, bien);
    case _Choix.supprimer:
      await _supprimer(context, ref, bien);
  }
}

class _Choix3 extends StatelessWidget {
  const _Choix3({required this.bien});
  final Bien bien;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.ecran,
      0,
      AppSpacing.ecran,
      AppSpacing.ecran,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const TitreSection('Supprimer ce bien'),
        Text(
          'Un bien vendu ou que vous ne louez plus reste consultable, avec '
          'son historique. Il ne compte plus dans vos biens loués.',
          style: context.textes.secondary,
        ),
        const SizedBox(height: AppSpacing.bloc),
        CarteAction(
          icone: AppIcons.vente,
          titre: 'Je l\'ai vendu',
          sousTitre: 'Date, prix et bilan de la vente',
          onTap: () => Navigator.of(context).pop(_Choix.vendu),
        ),
        if (!bien.retire) ...[
          const SizedBox(height: AppSpacing.bloc),
          CarteAction(
            icone: AppIcons.plusLoue,
            titre: 'Je ne le loue plus',
            sousTitre: 'Vous pourrez le remettre en location',
            onTap: () => Navigator.of(context).pop(_Choix.plusLoue),
          ),
        ],
        const SizedBox(height: AppSpacing.bloc),
        CarteAction(
          icone: AppIcons.supprimer,
          titre: 'Supprimer définitivement',
          sousTitre: 'Le bien et tout son historique',
          onTap: () => Navigator.of(context).pop(_Choix.supprimer),
        ),
      ],
    ),
  );
}

Future<void> _supprimer(BuildContext context, WidgetRef ref, Bien bien) async {
  final ok = await confirmerSuppression(
    context,
    titre: 'Supprimer « ${bien.nom} » ?',
    message:
        'Le bail, les locataires, les échéances, le journal et les '
        'interventions de ce bien seront supprimés définitivement.',
    action: 'Supprimer définitivement',
  );
  if (!ok || !context.mounted) return;
  final navigateur = Navigator.of(context);
  final messager = ScaffoldMessenger.of(context);
  final photo = bien.photoChemin;
  navigateur.pop();
  await ref.read(gestionBiensProvider).supprimer(bien.id);
  if (photo != null) await ref.read(photoServiceProvider).supprimer(photo);
  messager.showSnackBar(
    SnackBar(content: Text('« ${bien.nom} » a été supprimé.')),
  );
}

Future<void> _retirer(BuildContext context, WidgetRef ref, Bien bien) async {
  final aujourdhui = ref.read(aujourdhuiProvider);
  final echeances = await ref.read(echeanceRepositoryProvider).parBien(bien.id);
  if (!context.mounted) return;
  final ok = await _confirmer(
    context,
    titre: 'Ne plus louer « ${bien.nom} » ?',
    texte:
        'Le bien reste consultable mais ne se modifie plus, jusqu\'à ce que '
        'vous le remettiez en location.',
    arretees: SortieBien.aArreter(
      bien.copyWith(retireLe: aujourdhui),
      echeances,
    ),
    action: 'Je ne le loue plus',
  );
  if (!ok) return;
  await ref
      .read(gestionBiensProvider)
      .retirerDeLaLocation(bienId: bien.id, date: aujourdhui);
}

/// Annule la vente, après confirmation (et avertissement si un autre bien
/// passe en lecture seule).
Future<void> annulerVente(BuildContext context, WidgetRef ref, Bien bien) =>
    _revenir(
      context,
      ref,
      bien,
      titre: 'Annuler la vente de « ${bien.nom} » ?',
      action: 'Annuler la vente',
      executer: () => ref.read(gestionBiensProvider).annulerVente(bien.id),
    );

/// Remet en location un bien retiré, après confirmation.
Future<void> remettreEnLocation(
  BuildContext context,
  WidgetRef ref,
  Bien bien,
) => _revenir(
  context,
  ref,
  bien,
  titre: 'Remettre « ${bien.nom} » en location ?',
  action: 'Remettre en location',
  executer: () => ref.read(gestionBiensProvider).remettreEnLocation(bien.id),
);

Future<void> _revenir(
  BuildContext context,
  WidgetRef ref,
  Bien bien, {
  required String titre,
  required String action,
  required Future<void> Function() executer,
}) async {
  final biens = ref.read(biensFluxProvider).value ?? const <Bien>[];
  final droits = ref.read(droitsProvider).value ?? Droits.premium;
  // Une vente annulée rend le bien retiré s'il l'était : il ne reprend pas
  // la place d'un autre.
  final perdants = bien.vendu && bien.retireLe != null
      ? const <Bien>[]
      : AccesBiens.perdraientAcces(biens, bien, droits);
  final texte = [
    if (bien.vendu && bien.retireLe != null)
      'Le bien redevient « plus en location », comme avant la vente.'
    else
      'Le bien redevient modifiable et ses échéances arrêtées reprennent.',
    if (perdants.isNotEmpty)
      'Ce bien redeviendra votre bien actif : '
          '${perdants.map((b) => '« ${b.nom} »').join(', ')} '
          '${perdants.length > 1 ? 'passeront' : 'passera'} en lecture seule '
          'dans la version gratuite.',
  ].join('\n\n');
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(titre),
      content: Text(texte),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Ne rien changer'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(action),
        ),
      ],
    ),
  );
  if (ok == true) await executer();
}

/// Confirmation d'une vente ou d'un retrait, avec la liste des échéances
/// arrêtées.
Future<bool> _confirmer(
  BuildContext context, {
  required String titre,
  required String texte,
  required List<Echeance> arretees,
  required String action,
}) async {
  final t = context.textes;
  final reponse = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(titre),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(texte),
            const SizedBox(height: AppSpacing.bloc),
            if (arretees.isEmpty)
              const Text('Aucune échéance n\'est arrêtée.')
            else ...[
              Text(
                'Ces échéances sont arrêtées : plus affichées ni rappelées, '
                'mais conservées.',
              ),
              const SizedBox(height: AppSpacing.s),
              for (final e in arretees)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
                  child: Text(
                    '${e.titre}, le ${Formats.date(e.date)}',
                    style: t.secondary,
                  ),
                ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Ne rien changer'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(action),
        ),
      ],
    ),
  );
  return reponse ?? false;
}

/// « Je l'ai vendu » : date (obligatoire), prix et frais (facultatifs),
/// logement loué ou libre.
class DeclarationVentePage extends ConsumerWidget {
  const DeclarationVentePage({super.key, required this.bienId});
  final String bienId;

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      switch (ref.watch(bienFluxProvider(bienId))) {
        AsyncData(value: final b?) => _Formulaire(bien: b),
        AsyncData() => Scaffold(
          appBar: AppBar(),
          body: const Center(child: Text('Ce bien n\'existe plus.')),
        ),
        _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
      };
}

class _Formulaire extends ConsumerStatefulWidget {
  const _Formulaire({required this.bien});
  final Bien bien;

  @override
  ConsumerState<_Formulaire> createState() => _FormulaireState();
}

class _FormulaireState extends ConsumerState<_Formulaire> {
  final _cle = GlobalKey<FormState>();
  late final _prix = TextEditingController(
    text: ChampMontant.texte(widget.bien.prixVenteCentimes),
  );
  late final _frais = TextEditingController(
    text: ChampMontant.texte(widget.bien.fraisVenteCentimes),
  );
  late DateTime? _date = widget.bien.venduLe;
  late bool? _loue = widget.bien.venduLoue;

  /// Vente déjà déclarée : modification des informations seulement.
  bool get _modification => widget.bien.vendu;
  bool _enCours = false;

  @override
  void dispose() {
    _prix.dispose();
    _frais.dispose();
    super.dispose();
  }

  static int? _montant(TextEditingController c) =>
      c.text.trim().isEmpty ? null : Formats.parseMontant(c.text);

  Future<void> _enregistrer() async {
    if (!validerEtMontrerErreur(_cle)) return;
    final bien = widget.bien;
    final date = _date!;
    final loue = _loue!;
    final echeances = await ref
        .read(echeanceRepositoryProvider)
        .parBien(bien.id);
    if (!mounted) return;
    final ok =
        _modification ||
        await _confirmer(
          context,
          titre: 'Déclarer la vente de « ${bien.nom} » ?',
          texte:
              'Le bien reste consultable mais ne se modifie plus. Vous pourrez '
              'annuler la vente.',
          arretees: SortieBien.aArreter(
            bien.copyWith(venduLe: date, venduLoue: loue),
            echeances,
          ),
          action: 'Déclarer la vente',
        );
    if (!ok || !mounted) return;
    setState(() => _enCours = true);
    final navigateur = Navigator.of(context);
    await ref
        .read(gestionBiensProvider)
        .declarerVente(
          bienId: bien.id,
          date: date,
          prixCentimes: _montant(_prix),
          fraisCentimes: _montant(_frais),
          loue: loue,
        );
    navigateur.pop();
  }

  @override
  Widget build(BuildContext context) {
    final aujourdhui = ref.watch(aujourdhuiProvider);
    return PageFormulaire(
      cle: _cle,
      surtitre: widget.bien.nom,
      titre: _modification ? 'Modifier la vente' : 'Déclarer la vente',
      libelleAction: _modification ? 'Enregistrer' : 'Continuer',
      onEnregistrer: _enregistrer,
      enCours: _enCours,
      champs: [
        ChampDate(
          libelle: 'Date de la vente',
          aide: 'Date de l\'acte chez le notaire',
          date: _date,
          premiere: widget.bien.creeLe.isBefore(DateTime(2000))
              ? widget.bien.creeLe
              : DateTime(2000),
          derniere: aujourdhui,
          messageObligatoire: 'Indiquez la date de la vente.',
          onChanged: (d) => setState(() => _date = d),
        ),
        ChampMontant(controleur: _prix, libelle: 'Prix de vente (facultatif)'),
        ChampMontant(
          controleur: _frais,
          libelle: 'Frais de vente (facultatif)',
          aide: 'Agence, diagnostics, mainlevée…',
        ),
        const SizedBox(height: AppSpacing.bloc),
        const TitreSection('Le logement était-il loué au moment de la vente ?'),
        ChampChoix<bool>(
          options: const [true, false],
          valeurInitiale: _loue,
          libelle: (loue) =>
              loue ? 'Oui, il était loué' : 'Non, il était libre',
          precision: (loue) => loue
              ? 'L\'acquéreur reprend le bail'
              : 'Vous ferez la dernière régularisation des charges',
          colonnesMax: 1,
          messageObligatoire: 'Indiquez si le logement était loué.',
          onChanged: (loue) => setState(() => _loue = loue),
        ),
        const SizedBox(height: AppSpacing.bloc),
        const Note(
          texte:
              'Le prix et les frais servent au bilan de la vente (Pense-Bail '
              'Premium). Vous pouvez les laisser vides.',
        ),
      ],
    );
  }
}
