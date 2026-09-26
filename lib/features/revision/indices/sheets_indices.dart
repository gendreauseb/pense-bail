import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/design/design.dart';
import '../../../core/format/formats.dart';
import '../../../core/validation/validateurs.dart';
import '../../../core/widgets/composants.dart';
import '../../../core/widgets/formulaires.dart';
import '../../../core/widgets/listes.dart';
import '../../../data/providers.dart';
import '../../../domain/entities/entities.dart';

/// Saisie manuelle d'un IRL, en secours, recopié depuis insee.fr.
Future<void> ouvrirSaisieIndice(
  BuildContext context, {
  required int trimestre,
  required int annee,
}) => showModalBottomSheet<void>(
  context: context,
  useRootNavigator: true,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => _SaisieIndice(trimestre: trimestre, annee: annee),
);

class _SaisieIndice extends ConsumerStatefulWidget {
  const _SaisieIndice({required this.trimestre, required this.annee});
  final int trimestre;
  final int annee;

  @override
  ConsumerState<_SaisieIndice> createState() => _SaisieIndiceState();
}

class _SaisieIndiceState extends ConsumerState<_SaisieIndice> {
  final _cle = GlobalKey<FormState>();
  final _valeur = TextEditingController();
  bool _enCours = false;

  @override
  void dispose() {
    _valeur.dispose();
    super.dispose();
  }

  Future<void> _enregistrer() async {
    if (!validerEtMontrerErreur(_cle)) return;
    setState(() => _enCours = true);
    final navigateur = Navigator.of(context);
    await ref
        .read(serviceIndicesIrlProvider)
        .saisir(
          annee: widget.annee,
          trimestre: widget.trimestre,
          valeur: Formats.parseDecimal(_valeur.text)!,
        );
    navigateur.pop();
  }

  @override
  Widget build(BuildContext context) {
    final libelle = Formats.trimestre(widget.trimestre, widget.annee);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Form(
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
              const TitreSection('Saisir l\'indice'),
              Text(
                'Recopiez la valeur de l\'IRL du $libelle publiée sur '
                'insee.fr (« Indice de référence des loyers »). Vérifiez-la '
                'bien : elle sert au calcul de votre révision.',
                style: context.textes.secondary,
              ),
              const SizedBox(height: AppSpacing.bloc),
              ChampTexte(
                controleur: _valeur,
                libelle: 'IRL du $libelle',
                aide: 'Format : 123,45',
                clavier: const TextInputType.numberWithOptions(decimal: true),
                formats: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                ],
                validator: Validateurs.indiceIrl,
              ),
              const SizedBox(height: AppSpacing.s),
              FilledButton(
                onPressed: _enCours ? null : _enregistrer,
                child: const Text('Enregistrer l\'indice'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Choix de l'année du nouvel indice, pour les cas où l'estimation de la
/// date de publication ne convient pas.
Future<void> ouvrirChoixAnnee(
  BuildContext context, {
  required int trimestre,
  required List<IndiceIrl> table,
  required int anneeParDefaut,
  required int anneeActuelle,
  required ValueChanged<int> onChoisie,
}) => showModalBottomSheet<void>(
  context: context,
  useRootNavigator: true,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (context) {
    final t = context.textes;
    final annees = [
      for (final i in table)
        if (i.trimestre == trimestre && i.annee <= anneeParDefaut + 1) i.annee,
    ]..sort((a, b) => b.compareTo(a));
    final candidates = [
      for (final a in annees)
        if (annees.contains(a - 1)) a,
    ].take(3);

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
          const TitreSection('Indice à utiliser'),
          Text(
            'Par défaut, Pense-Bail retient le dernier IRL publié à la date de '
            'révision prévue au bail. Choisissez une autre année seulement si '
            'vous êtes sûr de vous.',
            style: t.secondary,
          ),
          const SizedBox(height: AppSpacing.bloc),
          if (candidates.isEmpty)
            Text('Aucun autre indice disponible.', style: t.secondary)
          else
            CarteListe(
              enfants: [
                for (final a in candidates)
                  ListTile(
                    title: Text(
                      'IRL du ${Formats.trimestre(trimestre, a)}',
                      style: t.rowTitle,
                    ),
                    subtitle: Text(
                      [
                        'Comparé à ${a - 1}',
                        if (a == anneeParDefaut) 'par défaut',
                      ].join(', '),
                      style: t.secondary,
                    ),
                    trailing: a == anneeActuelle
                        ? Icon(
                            AppIcons.selectionne,
                            color: context.couleurs.primary,
                          )
                        : null,
                    onTap: () {
                      onChoisie(a);
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
        ],
      ),
    );
  },
);
