import 'package:bidi/bidi.dart' as bidi;
import 'package:flutter_test/flutter_test.dart';
import 'package:we_care/core/global/Helpers/functions.dart';

/// `package:pdf` runs every string through `package:bidi` when shaping RTL
/// text. bidi throws `RangeError (length)` on characters whose compatibility
/// decomposition expands to more than one code point, which aborts the whole
/// medical-report export. [sanitizeTextForPdf] must neutralize all of them.
bool bidiCrashes(String text) {
  try {
    bidi.logicalToVisual(text);
    return false;
  } catch (_) {
    return true;
  }
}

void main() {
  group('sanitizeTextForPdf', () {
    test('clears every bidi-crashing code point in the ranges we can receive',
        () {
      const ranges = [
        [0x0020, 0x07FF], // latin, punctuation, Arabic
        [0x2000, 0x2BFF], // general punctuation, letterlike, number forms
        [0x3000, 0x33FF], // CJK compatibility (℃-style squared forms)
        [0xFB00, 0xFFFF], // Arabic presentation forms, fullwidth forms
      ];

      var crashingBefore = 0;
      final stillCrashing = <String>[];

      for (final range in ranges) {
        for (var cp = range[0]; cp <= range[1]; cp++) {
          if (cp >= 0xD800 && cp <= 0xDFFF) continue; // surrogates
          final ch = String.fromCharCode(cp);
          for (final probe in ['ابت$ch', ch, '$ch ابت', '$ch حبة', 'x${ch}y']) {
            if (!bidiCrashes(probe)) continue;
            crashingBefore++;
            if (bidiCrashes(sanitizeTextForPdf(probe))) {
              stillCrashing.add('U+${cp.toRadixString(16).toUpperCase()}');
            }
            break;
          }
        }
      }

      expect(crashingBefore, greaterThan(900),
          reason: 'sanity check: the probe should still find the bad range');
      expect(stillCrashing, isEmpty);
    });

    test('expands the characters that broke report export', () {
      expect(sanitizeTextForPdf('½ حبة'), ' 1/2 حبة');
      expect(sanitizeTextForPdf('¼ قرص'), ' 1/4 قرص');
      expect(sanitizeTextForPdf('ﻻ يوجد'), 'لا يوجد');
      expect(sanitizeTextForPdf('37℃'), '37°C');
      expect(sanitizeTextForPdf('مرحبا…'), 'مرحبا...');
    });

    test('leaves ordinary Arabic and Latin text untouched', () {
      for (final text in const [
        'باراسيتامول 500 مجم',
        'آلام الظهر', // canonical decomposition, recomposes fine in bidi
        '٣ مرات يوميا',
        'Café résumé',
        'mg/dL 12.5',
        'لا يوجد',
      ]) {
        expect(sanitizeTextForPdf(text), text);
      }
    });

    test('handles null and empty input', () {
      expect(sanitizeTextForPdf(null), '');
      expect(sanitizeTextForPdf(''), '');
    });

    // `package:pdf` cuts a text span at every rune the font cannot draw
    // (`_preProcessSpans`) and bidi-shapes each fragment on its own, so a
    // string that only survives as a whole still aborts the export. U+0344,
    // U+0385, U+1FCD… were safe inside 'ابتدXدواء' yet crashed the moment the
    // string was cut just before them.
    test('output stays safe when cut at any point, as pdf cuts spans', () {
      final decomposable = <int>[
        for (var cp = 0x20; cp <= 0xFFFF; cp++)
          if (cp < 0xD800 || cp > 0xDFFF)
            if ((bidi.getDecompositionMapping(cp)?.length ?? 0) > 1) cp,
      ];
      expect(decomposable.length, greaterThan(2000),
          reason: 'sanity check: the probe should still find the bad range');

      final crashingCuts = <String>[];
      for (final cp in decomposable) {
        final text = sanitizeTextForPdf('ابتد${String.fromCharCode(cp)}دواء');
        for (var cut = 1; cut < text.length; cut++) {
          if (bidiCrashes(text.substring(0, cut)) ||
              bidiCrashes(text.substring(cut))) {
            crashingCuts.add('U+${cp.toRadixString(16).toUpperCase()}@$cut');
            break;
          }
        }
      }

      expect(crashingCuts, isEmpty);
    });

    test('keeps Arabic diacritics, which are safe at a fragment edge', () {
      for (final text in const [
        'مُسَكِّن',
        'دَواء',
        'الْقَلْب',
      ]) {
        expect(sanitizeTextForPdf(text), text);
      }
    });
  });

  group('sanitizeDosageForPdf', () {
    test('keeps its existing behaviour on top of the new expansion', () {
      expect(sanitizeDosageForPdf('½ حبة'), '1/2 حبة');
      expect(sanitizeDosageForPdf('2½ حبة'), '2 1/2 حبة');
      expect(sanitizeDosageForPdf('٣ حبات'), '3 حبات');
      expect(sanitizeDosageForPdf('   '), 'لا يوجد');
      expect(sanitizeDosageForPdf(null), 'لا يوجد');
    });
  });
}
