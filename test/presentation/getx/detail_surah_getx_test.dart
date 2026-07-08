import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:quran_app/presentation/controller/detail_surah/detail_surah_getx.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Mock path_provider channel (required by GetStorage which MainFunction
    // depends on indirectly — safer to have it in place).
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'getApplicationDocumentsDirectory') {
          return '.';
        }
        return null;
      },
    );
  });

  tearDown(() {
    Get.reset();
  });

  // ──────────────────────────────────────────────────────────────────
  // Constructor tests
  // ──────────────────────────────────────────────────────────────────

  group('Constructor', () {
    test('DetailSurahGetx() instantiates without error (index: null)', () {
      final controller = DetailSurahGetx();
      expect(controller, isNotNull);
      expect(controller.index, isNull);
    });

    test('DetailSurahGetx(index: 5) instantiates without error', () {
      final controller = DetailSurahGetx(index: 5);
      expect(controller, isNotNull);
      expect(controller.index, 5);
    });

    test('itemScrollController is initialised on construction', () {
      final controller = DetailSurahGetx();
      expect(controller.itemScrollController, isNotNull);
    });

    test('GlobalKeys are initialised on construction', () {
      final controller = DetailSurahGetx();
      expect(controller.menuKey, isNotNull);
      expect(controller.btnTandaiKey, isNotNull);
      expect(controller.btnBookmarkKey, isNotNull);
      expect(controller.btnShareKey, isNotNull);
    });
  });

  // ──────────────────────────────────────────────────────────────────
  // toScrollIndex tests
  // ──────────────────────────────────────────────────────────────────

  group('toScrollIndex()', () {
    test('toScrollIndex(null) — null guard path — does NOT throw', () {
      final controller = DetailSurahGetx();
      // null index → early return, nothing else happens
      expect(() => controller.toScrollIndex(null), returnsNormally);
    });

    test('toScrollIndex(1) with isAttached == false does NOT throw', () {
      final controller = DetailSurahGetx();
      // In unit tests no ScrollablePositionedList is mounted, so
      // itemScrollController.isAttached is always false → jumpTo is never
      // called → no exception is raised.
      expect(() => controller.toScrollIndex(1), returnsNormally);
    });

    test('toScrollIndex(n) for various n > 0 does NOT throw', () {
      final controller = DetailSurahGetx();
      for (int n = 1; n <= 114; n++) {
        expect(
          () => controller.toScrollIndex(n),
          returnsNormally,
          reason: 'toScrollIndex($n) should not throw when isAttached==false',
        );
      }
    });

    test(
        'toScrollIndex(0) does NOT throw (index is not null, isAttached false)',
        () {
      final controller = DetailSurahGetx();
      // index == 0 is non-null, enters the outer if-branch, but isAttached is
      // false so the inner block (jumpTo) is skipped — no throw.
      expect(() => controller.toScrollIndex(0), returnsNormally);
    });
  });
}
