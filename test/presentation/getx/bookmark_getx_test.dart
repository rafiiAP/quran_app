import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/data/db/database_helper.dart';
import 'package:quran_app/data/model/bookmark_model.dart';
import 'package:quran_app/injection.dart';
import 'package:quran_app/presentation/controller/dashboard/bookmark_getx.dart';

import '../../fixtures/bookmark_fixture.dart';
import '../../mocks.dart';

void main() {
  late BookmarkGetx controller;
  late MockDatabaseHelper mockDbHelper;

  setUp(() {
    mockDbHelper = MockDatabaseHelper();

    // Register MockDatabaseHelper in GetIt
    if (locator.isRegistered<DatabaseHelper>()) {
      locator.unregister<DatabaseHelper>();
    }
    locator.registerLazySingleton<DatabaseHelper>(() => mockDbHelper);

    // Stub getAllBookmarks for init() called during onTapDelete
    when(() => mockDbHelper.getAllBookmarks()).thenAnswer((_) async => []);

    controller = BookmarkGetx();
  });

  tearDown(() {
    if (locator.isRegistered<DatabaseHelper>()) {
      locator.unregister<DatabaseHelper>();
    }
    Get.reset();
  });

  group('onTapDelete()', () {
    test('calls deleteBookmark with teksIndonesia argument', () {
      // Requirement 13.1: onTapDelete calls databaseHelper.deleteBookmark()
      // with bookmarkModel.teksIndonesia as argument
      when(() => mockDbHelper.deleteBookmark(any())).thenReturn(null);

      controller.onTapDelete(kBookmarkModel);

      verify(() => mockDbHelper.deleteBookmark(kBookmarkModel.teksIndonesia))
          .called(1);
    });

    test('calls init() after delete to reload list', () {
      // Requirement 13.2: onTapDelete calls init() to reload bookmark list
      when(() => mockDbHelper.deleteBookmark(any())).thenReturn(null);

      controller.onTapDelete(kBookmarkModel);

      // init() calls getAllBookmarks, so verify it was called
      verify(() => mockDbHelper.getAllBookmarks())
          .called(greaterThanOrEqualTo(1));
    });
  });

  group('getDetailSurah()', () {
    test('sets nNomorAyat.value to bookmarkModel.nomorAyat', () {
      // Requirement 13.3: getDetailSurah sets nNomorAyat.value to
      // bookmarkModel.nomorAyat before accessing Get.context! (which throws
      // FlutterError because WidgetsBinding is not initialized in unit tests)
      expect(
        () => controller.getDetailSurah(kBookmarkModel),
        throwsA(isA<FlutterError>()),
      );
      expect(controller.nNomorAyat.value, kBookmarkModel.nomorAyat);
    });
  });

  group('Property Tests', () {
    test('Property 18: nNomorAyat updates for any BookmarkModel.nomorAyat',
        () async {
      // Feature: unit-testing, Property 18: BookmarkGetx nNomorAyat Update
      // **Validates: Requirements 13.3**
      for (int i = 0; i < 100; i++) {
        final model = BookmarkModel(
          nomorSurah: (i % 114) + 1,
          namaLatin: 'Surah-$i',
          nomorAyat: i + 1, // any positive value
          teksArab: 'Arab-$i',
          teksIndonesia: 'Indonesia-$i',
          teksLatin: 'Latin-$i',
        );

        expect(
          () => controller.getDetailSurah(model),
          throwsA(isA<FlutterError>()),
        );

        expect(controller.nNomorAyat.value, model.nomorAyat);
      }
    });
  });
}
