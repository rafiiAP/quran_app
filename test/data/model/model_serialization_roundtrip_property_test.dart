import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/features/detail_surah/data/models/detail_model.dart';
import 'package:quran_app/features/jadwal_sholat/data/models/jadwal_sholat_model.dart';
import 'package:quran_app/features/surah/data/models/surah_model.dart';

import '../../helpers/generators.dart';

/// **Validates: Requirements 7.4**
///
/// Property 1: Model Serialization Round-Trip
/// For any randomly generated valid model instance m,
/// Model.fromMap(m.toMap()) == m
void main() {
  group('Property 1: Model Serialization Round-Trip', () {
    test('SurahModel round-trip property for 100 random instances', () {
      // **Validates: Requirements 7.4**
      for (int i = 0; i < 100; i++) {
        final model = generateRandomSurahModel();
        final roundTripped = SurahModel.fromMap(model.toMap());
        expect(
          roundTripped,
          equals(model),
          reason: 'SurahModel round-trip failed at iteration $i',
        );
      }
    });

    test('DetailModel round-trip property for 100 random instances', () {
      // **Validates: Requirements 7.4**
      for (int i = 0; i < 100; i++) {
        final model = generateRandomDetailModel();
        final roundTripped = DetailModel.fromMap(model.toMap());
        expect(
          roundTripped,
          equals(model),
          reason: 'DetailModel round-trip failed at iteration $i',
        );
      }
    });

    test('AyatDetailModel round-trip property for 100 random instances', () {
      // **Validates: Requirements 7.4**
      for (int i = 0; i < 100; i++) {
        final model = generateRandomDetailModel();
        for (int j = 0; j < model.ayat.length; j++) {
          final ayat = model.ayat[j];
          final roundTripped = AyatDetailModel.fromMap(ayat.toMap());
          expect(
            roundTripped,
            equals(ayat),
            reason:
                'AyatDetailModel round-trip failed at iteration $i, ayat $j',
          );
        }
      }
    });

    test('JadwalSholatModel round-trip property for 100 random instances', () {
      // **Validates: Requirements 7.4**
      for (int i = 0; i < 100; i++) {
        final model = generateRandomJadwalSholatModel();
        final roundTripped = JadwalSholatModel.fromMap(model.toMap());
        expect(
          roundTripped,
          equals(model),
          reason: 'JadwalSholatModel round-trip failed at iteration $i',
        );
      }
    });
  });
}
