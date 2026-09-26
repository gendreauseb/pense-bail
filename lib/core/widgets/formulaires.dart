// Champs de formulaire communs (texte, montant, date).

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/design/design.dart';
import '../format/formats.dart';
import 'composants.dart';

/// Champ texte avec l'espacement standard des formulaires.
class ChampTexte extends StatelessWidget {
  const ChampTexte({
    super.key,
    required this.controleur,
    required this.libelle,
    this.aide,
    this.suffixe,
    this.validator,
    this.clavier,
    this.majuscules = TextCapitalization.none,
    this.formats,
    this.lignes = 1,
    this.autofill,
    this.onChanged,
  });

  final TextEditingController controleur;
  final String libelle;
  final String? aide;
  final String? suffixe;
  final String? Function(String?)? validator;
  final TextInputType? clavier;
  final TextCapitalization majuscules;
  final List<TextInputFormatter>? formats;
  final int lignes;
  final Iterable<String>? autofill;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.bloc),
    child: TextFormField(
      controller: controleur,
      decoration: InputDecoration(
        labelText: libelle,
        helperText: aide,
        suffixText: suffixe,
        alignLabelWithHint: lignes > 1,
      ),
      validator: validator,
      keyboardType: lignes > 1 ? TextInputType.multiline : clavier,
      textCapitalization: majuscules,
      inputFormatters: formats,
      minLines: lignes,
      maxLines: lignes > 1 ? lignes * 2 : 1,
      autofillHints: autofill,
      textInputAction: lignes > 1
          ? TextInputAction.newline
          : TextInputAction.next,
      autovalidateMode: AutovalidateMode.onUserInteractionIfError,
      onChanged: onChanged,
    ),
  );
}

/// Champ montant en euros (saisie « 650 », « 650,50 »).
class ChampMontant extends StatelessWidget {
  const ChampMontant({
    super.key,
    required this.controleur,
    required this.libelle,
    this.obligatoire = false,
    this.aide,
    this.validationSupplementaire,
  });

  final TextEditingController controleur;
  final String libelle;
  final bool obligatoire;
  final String? aide;

  /// Contrôle métier sur le montant saisi (en centimes), ex. plafond légal.
  final String? Function(int centimes)? validationSupplementaire;

  static final _format = FilteringTextInputFormatter.allow(
    RegExp(r'[0-9,.\s]'),
  );

  @override
  Widget build(BuildContext context) => ChampTexte(
    controleur: controleur,
    libelle: libelle,
    aide: aide,
    suffixe: '€',
    clavier: const TextInputType.numberWithOptions(decimal: true),
    formats: [_format],
    validator: (v) {
      if (v == null || v.trim().isEmpty) {
        return obligatoire ? 'Indiquez le montant.' : null;
      }
      final centimes = Formats.parseMontant(v);
      if (centimes == null) {
        return 'Montant incorrect (exemple : 650 ou 650,50).';
      }
      return validationSupplementaire?.call(centimes);
    },
  );

  /// Texte initial d'un montant existant : 65000 → « 650 » ; 66423 →
  /// « 664,23 ».
  static String texte(int? centimes) {
    if (centimes == null) return '';
    final euros = centimes ~/ 100;
    final reste = centimes % 100;
    return reste == 0 ? '$euros' : '$euros,${reste.toString().padLeft(2, '0')}';
  }
}

/// Champ date : ouvre le calendrier, affiche JJ/MM/AAAA.
class ChampDate extends StatefulWidget {
  const ChampDate({
    super.key,
    required this.libelle,
    required this.date,
    required this.onChanged,
    required this.premiere,
    required this.derniere,
    this.obligatoire = true,
    this.messageObligatoire = 'Choisissez une date.',
    this.aide,
    this.titreCalendrier,
  });

  final String libelle;
  final DateTime? date;
  final ValueChanged<DateTime?> onChanged;
  final DateTime premiere;
  final DateTime derniere;
  final bool obligatoire;
  final String messageObligatoire;
  final String? aide;
  final String? titreCalendrier;

  @override
  State<ChampDate> createState() => _ChampDateState();
}

class _ChampDateState extends State<ChampDate> {
  late final _controleur = TextEditingController(text: _texte(widget.date));

  static String _texte(DateTime? d) => d == null ? '' : Formats.date(d);

  @override
  void didUpdateWidget(ChampDate ancien) {
    super.didUpdateWidget(ancien);
    if (ancien.date != widget.date) _controleur.text = _texte(widget.date);
  }

  @override
  void dispose() {
    _controleur.dispose();
    super.dispose();
  }

  Future<void> _choisir() async {
    final actuelle = widget.date;
    final initiale = actuelle == null
        ? DateTime.now()
        : actuelle.isBefore(widget.premiere)
        ? widget.premiere
        : actuelle.isAfter(widget.derniere)
        ? widget.derniere
        : actuelle;
    final choisie = await showDatePicker(
      context: context,
      helpText: widget.titreCalendrier ?? widget.libelle,
      initialDate: initiale.isAfter(widget.derniere)
          ? widget.derniere
          : initiale.isBefore(widget.premiere)
          ? widget.premiere
          : initiale,
      firstDate: widget.premiere,
      lastDate: widget.derniere,
      confirmText: 'Choisir cette date',
      cancelText: 'Annuler',
      fieldLabelText: 'Date (JJ/MM/AAAA)',
      errorFormatText: 'Format attendu : JJ/MM/AAAA',
      errorInvalidText: 'Date hors des limites possibles',
    );
    if (choisie == null) return;
    widget.onChanged(DateTime(choisie.year, choisie.month, choisie.day));
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.bloc),
    child: TextFormField(
      controller: _controleur,
      readOnly: true,
      onTap: _choisir,
      decoration: InputDecoration(
        labelText: widget.libelle,
        helperText: widget.aide,
        hintText: 'JJ/MM/AAAA',
        suffixIcon: widget.date != null && !widget.obligatoire
            ? IconButton(
                icon: const Icon(AppIcons.fermer),
                tooltip: 'Effacer la date',
                onPressed: () => widget.onChanged(null),
              )
            : const Icon(AppIcons.calendrier),
      ),
      validator: (_) => widget.obligatoire && widget.date == null
          ? widget.messageObligatoire
          : null,
    ),
  );
}

/// Page de formulaire standard : retour, titre (et surtitre), champs,
/// barre d'action fixe, suppression facultative.
class PageFormulaire extends StatelessWidget {
  const PageFormulaire({
    super.key,
    required this.cle,
    required this.titre,
    required this.champs,
    required this.libelleAction,
    required this.onEnregistrer,
    this.surtitre,
    this.enCours = false,
    this.onSupprimer,
    this.descriptionSupprimer = 'Supprimer',
  });

  final GlobalKey<FormState> cle;
  final String? surtitre;
  final String titre;
  final List<Widget> champs;
  final String libelleAction;
  final VoidCallback? onEnregistrer;
  final bool enCours;
  final VoidCallback? onSupprimer;
  final String descriptionSupprimer;

  @override
  Widget build(BuildContext context) {
    final t = context.textes;
    final surtitre = this.surtitre;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(AppIcons.retour),
          tooltip: 'Retour',
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (onSupprimer != null)
            IconButton(
              icon: const Icon(AppIcons.supprimer),
              tooltip: descriptionSupprimer,
              onPressed: enCours ? null : onSupprimer,
            ),
        ],
      ),
      body: Form(
        key: cle,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.ecran,
            AppSpacing.s,
            AppSpacing.ecran,
            AppSpacing.ecran,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (surtitre != null) ...[
                Text(surtitre.toUpperCase(), style: t.overline),
                const SizedBox(height: AppSpacing.xs),
              ],
              Semantics(header: true, child: Text(titre, style: t.headline)),
              const SizedBox(height: AppSpacing.sectionLarge),
              ...champs,
            ],
          ),
        ),
      ),
      bottomNavigationBar: BarreActionFixe(
        libelle: libelleAction,
        onPressed: onEnregistrer,
        enCours: enCours,
      ),
    );
  }
}

/// Demande de confirmation avant une suppression. Retourne `true` si
/// l'utilisateur confirme.
Future<bool> confirmerSuppression(
  BuildContext context, {
  required String titre,
  required String message,
  String action = 'Supprimer',
}) async {
  final reponse = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(titre),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(foregroundColor: context.couleurs.erreur),
          child: Text(action),
        ),
      ],
    ),
  );
  return reponse ?? false;
}
