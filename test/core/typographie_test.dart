import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

// Typographie française : espace insécable (U+00A0) après « et avant
// » : ; ? !, pour qu'un signe ne se retrouve jamais seul en début de ligne.
// Ce test parcourt le texte de tous les littéraux de chaîne de lib/ (pas le
// code, les commentaires ni les chaînes brutes r'…').

final _faute = RegExp(r'« | [»:;?!]');

/// Texte des littéraux de chaîne de [source] (hors interpolations), avec
/// leur numéro de ligne.
List<(int, String)> _litteraux(String source) {
  final resultat = <(int, String)>[];
  var i = 0;

  int ligne(int position) =>
      '\n'.allMatches(source.substring(0, position)).length + 1;

  late void Function({bool finAccolade}) code;

  void chaine(bool brut) {
    final guillemet = source[i];
    final triple = source.startsWith(guillemet * 3, i);
    final fin = triple ? guillemet * 3 : guillemet;
    i += fin.length;
    var debut = i;
    while (i < source.length) {
      if (source.startsWith(fin, i)) {
        if (!brut) resultat.add((ligne(debut), source.substring(debut, i)));
        i += fin.length;
        return;
      }
      if (!brut && source[i] == r'\') {
        i += 2;
      } else if (!brut && source.startsWith(r'${', i)) {
        resultat.add((ligne(debut), source.substring(debut, i)));
        i += 2;
        code(finAccolade: true);
        debut = i;
      } else {
        i++;
      }
    }
  }

  code = ({bool finAccolade = false}) {
    var profondeur = 0;
    while (i < source.length) {
      final c = source[i];
      if (source.startsWith('//', i)) {
        final j = source.indexOf('\n', i);
        i = j < 0 ? source.length : j;
      } else if (source.startsWith('/*', i)) {
        final j = source.indexOf('*/', i + 2);
        i = j < 0 ? source.length : j + 2;
      } else if (c == "'" || c == '"') {
        final brut =
            i > 0 &&
            source[i - 1] == 'r' &&
            (i < 2 || !RegExp(r'[\w$]').hasMatch(source[i - 2]));
        chaine(brut);
      } else if (c == '{') {
        profondeur++;
        i++;
      } else if (c == '}') {
        if (finAccolade && profondeur == 0) {
          i++;
          return;
        }
        profondeur--;
        i++;
      } else {
        i++;
      }
    }
  };

  code();
  return resultat;
}

void main() {
  test('espaces insécables avant « » : ; ? ! » et après « « »', () {
    final fautes = <String>[];
    final fichiers = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart') && !f.path.endsWith('.g.dart'));
    for (final fichier in fichiers) {
      for (final (ligne, texte) in _litteraux(fichier.readAsStringSync())) {
        if (_faute.hasMatch(texte)) fautes.add('${fichier.path}:$ligne $texte');
      }
    }
    expect(fautes, isEmpty, reason: 'Remplacer l\'espace par U+00A0.');
  });
}
