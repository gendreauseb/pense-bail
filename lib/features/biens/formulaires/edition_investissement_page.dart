import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/design/design.dart';
import '../../../core/format/formats.dart';
import '../../../core/widgets/composants.dart';
import '../../../core/widgets/formulaires.dart';
import '../../../data/providers.dart';
import '../../../domain/entities/entities.dart';

/// Données d'investissement et charges annuelles du propriétaire
/// (toutes facultatives), pour calculer la rentabilité.
class EditionInvestissementPage extends ConsumerWidget {
  const EditionInvestissementPage({super.key, required this.bienId});
  final String bienId;

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      switch (ref.watch(bienFluxProvider(bienId))) {
        AsyncData(value: final b?) => _Formulaire(bien: b),
        AsyncData() || AsyncError() => Scaffold(
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
  late final Bien _b = widget.bien;
  late final _prix = _c(_b.prixAchatCentimes);
  late final _notaire = _c(_b.fraisNotaireCentimes);
  late final _travaux = _c(_b.travauxInitiauxCentimes);
  late final _credit = _c(_b.mensualiteCreditCentimes);
  late final _taxe = _c(_b.taxeFonciereCentimes);
  late final _assurance = _c(_b.assuranceCentimes);
  late final _copro = _c(_b.chargesNonRecuperablesCentimes);
  late final _divers = _c(_b.fraisDiversCentimes);
  bool _enCours = false;

  static TextEditingController _c(int? centimes) =>
      TextEditingController(text: ChampMontant.texte(centimes));

  List<TextEditingController> get _tous => [
    _prix,
    _notaire,
    _travaux,
    _credit,
    _taxe,
    _assurance,
    _copro,
    _divers,
  ];

  @override
  void dispose() {
    for (final c in _tous) {
      c.dispose();
    }
    super.dispose();
  }

  static int? _v(TextEditingController c) =>
      c.text.trim().isEmpty ? null : Formats.parseMontant(c.text);

  Future<void> _enregistrer() async {
    if (!validerEtMontrerErreur(_cle)) return;
    setState(() => _enCours = true);
    final navigateur = Navigator.of(context);
    await ref
        .read(bienRepositoryProvider)
        .enregistrer(
          _b.copyWith(
            prixAchatCentimes: _v(_prix),
            fraisNotaireCentimes: _v(_notaire),
            travauxInitiauxCentimes: _v(_travaux),
            mensualiteCreditCentimes: _v(_credit),
            taxeFonciereCentimes: _v(_taxe),
            assuranceCentimes: _v(_assurance),
            chargesNonRecuperablesCentimes: _v(_copro),
            fraisDiversCentimes: _v(_divers),
          ),
        );
    navigateur.pop();
  }

  @override
  Widget build(BuildContext context) => PageFormulaire(
    cle: _cle,
    surtitre: _b.nom,
    titre: 'Chiffres de rentabilité',
    libelleAction: 'Enregistrer',
    onEnregistrer: _enregistrer,
    enCours: _enCours,
    champs: [
      const Note(
        texte:
            'Tout est facultatif. Plus vous en renseignez, plus le calcul '
            'de rentabilité est juste.',
      ),
      const SizedBox(height: AppSpacing.sectionLarge),
      const TitreSection('Investissement'),
      ChampMontant(controleur: _prix, libelle: 'Prix d\'achat'),
      ChampMontant(controleur: _notaire, libelle: 'Frais de notaire'),
      ChampMontant(controleur: _travaux, libelle: 'Travaux initiaux'),
      ChampMontant(
        controleur: _credit,
        libelle: 'Mensualité du crédit',
        aide: 'Par mois, assurance emprunteur comprise.',
      ),
      const SizedBox(height: AppSpacing.bloc),
      const TitreSection('Charges annuelles'),
      Text(
        'Montants par an, payés par vous (non refacturés au locataire).',
        style: context.textes.secondary,
      ),
      const SizedBox(height: AppSpacing.bloc),
      ChampMontant(controleur: _taxe, libelle: 'Taxe foncière'),
      ChampMontant(
        controleur: _assurance,
        libelle: 'Assurance propriétaire (PNO)',
      ),
      ChampMontant(
        controleur: _copro,
        libelle: 'Charges de copropriété non récupérables',
      ),
      ChampMontant(controleur: _divers, libelle: 'Frais divers'),
    ],
  );
}
