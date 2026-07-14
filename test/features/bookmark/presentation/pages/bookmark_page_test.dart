import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/core/constants/color.dart';
import 'package:quran_app/core/widgets/app_padding.dart';
import 'package:quran_app/core/widgets/app_shimmer.dart';
import 'package:quran_app/core/widgets/app_text.dart';
import 'package:quran_app/data/model/bookmark_model.dart';
import 'package:quran_app/features/bookmark/presentation/cubits/bookmark_cubit/bookmark_cubit.dart';
import 'package:quran_app/features/bookmark/presentation/pages/bookmark_page.dart';

class MockBookmarkCubit extends MockCubit<BookmarkState>
    implements BookmarkCubit {}

class _FakeBookmarkModel extends Fake implements BookmarkModel {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeBookmarkModel());
  });

  late MockBookmarkCubit mockBookmarkCubit;
  final locator = GetIt.instance;

  final testBookmarks = [
    const BookmarkModel(
      nomorSurah: 1,
      namaLatin: 'Al-Fatihah',
      nomorAyat: 1,
      teksArab: 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
      teksIndonesia: 'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang',
      teksLatin: 'Bismillāhir-raḥmānir-raḥīm(i).',
    ),
    const BookmarkModel(
      nomorSurah: 2,
      namaLatin: 'Al-Baqarah',
      nomorAyat: 255,
      teksArab: 'اللّٰهُ لَآ اِلٰهَ اِلَّا هُوَۚ',
      teksIndonesia: 'Allah, tidak ada tuhan selain Dia',
      teksLatin: 'Allāhu lā ilāha illā huw',
    ),
  ];

  setUp(() {
    mockBookmarkCubit = MockBookmarkCubit();

    // Reset and register GetIt dependencies needed by the page widgets
    locator.reset();
    locator.registerLazySingleton<AppColorConfig>(AppColorConfig.new);
    locator.registerLazySingleton<AppTextFactory>(
      () => _FakeAppTextFactory(),
    );
    locator.registerLazySingleton<AppShimmerFactory>(
      () => _FakeAppShimmerFactory(),
    );
    locator.registerLazySingleton<AppPaddingFactory>(AppPaddingFactoryImpl.new);

    // Default stub for loadBookmarks (called in initState)
    when(() => mockBookmarkCubit.loadBookmarks()).thenAnswer((_) async {});
  });

  tearDown(() {
    locator.reset();
  });

  Widget buildWidget() {
    return MaterialApp(
      home: BlocProvider<BookmarkCubit>.value(
        value: mockBookmarkCubit,
        child: const BookmarkPage(),
      ),
    );
  }

  group('BookmarkPage Widget Tests', () {
    // Requirements: 5.1 - Test loading state rendering
    testWidgets('shows shimmer loading when in loading state', (tester) async {
      when(() => mockBookmarkCubit.state)
          .thenReturn(const BookmarkState.loading());

      await tester.pumpWidget(buildWidget());

      // Loading state renders a ListView with shimmer placeholders
      expect(find.byType(ListView), findsOneWidget);
      // The shimmer items use Container with specific decoration
      expect(find.byKey(const Key('shimmer_placeholder')), findsWidgets);
    });

    // Requirements: 5.2 - Test success state shows bookmark cards
    testWidgets('shows bookmark cards when loaded with data', (tester) async {
      when(() => mockBookmarkCubit.state)
          .thenReturn(BookmarkState.loaded(bookmarks: testBookmarks));

      await tester.pumpWidget(buildWidget());

      // Verify bookmark data is displayed
      expect(find.text('Al-Fatihah : 1'), findsOneWidget);
      expect(find.text('Al-Baqarah : 2'), findsOneWidget);
      // Verify Arabic text is present
      expect(
        find.text('بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ'),
        findsOneWidget,
      );
      // Verify delete icons are present (one per bookmark)
      expect(find.byIcon(Icons.delete_outline), findsNWidgets(2));
    });

    // Requirements: 5.2 - Test empty state shows placeholder
    testWidgets('shows empty placeholder when loaded with empty list',
        (tester) async {
      when(() => mockBookmarkCubit.state)
          .thenReturn(const BookmarkState.loaded(bookmarks: []));

      await tester.pumpWidget(buildWidget());

      // Verify empty state placeholder is shown
      expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
      expect(find.text('Belum ada bookmark'), findsOneWidget);
    });

    // Requirements: 5.3 - Test tap delete icon calls Cubit method
    testWidgets('tapping delete icon calls deleteBookmark on Cubit',
        (tester) async {
      when(() => mockBookmarkCubit.state)
          .thenReturn(BookmarkState.loaded(bookmarks: testBookmarks));
      when(() => mockBookmarkCubit.deleteBookmark(any()))
          .thenAnswer((_) async {});

      await tester.pumpWidget(buildWidget());

      // Tap the first delete icon
      await tester.tap(find.byIcon(Icons.delete_outline).first);
      await tester.pump();

      // Verify deleteBookmark was called with the first bookmark
      verify(() => mockBookmarkCubit.deleteBookmark(testBookmarks[0]))
          .called(1);
    });
  });
}

/// A fake AppTextFactory that returns simple Text widgets without needing
/// navigatorKey or Google Fonts — suitable for widget tests.
class _FakeAppTextFactory implements AppTextFactory {
  @override
  Widget textBody({
    required String text,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    List<Shadow>? shadows,
    double? textHeight,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    double? letterSpacing,
    TextDecoration textDecoration = TextDecoration.none,
    Color? underlineColor,
    FontStyle? fontStyle,
  }) {
    return Text(text, style: TextStyle(fontSize: fontSize));
  }

  @override
  Widget title({
    required String text,
    Color? color,
    List<Shadow>? shadows,
    double? textHeight,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    double? letterSpacing,
    TextDecoration textDecoration = TextDecoration.none,
    Color? underlineColor,
    FontStyle? fontStyle,
  }) {
    return Text(
      text,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}

/// A fake AppShimmerFactory that returns simple containers with a key
/// for easy identification in tests (no shimmer animation dependency).
class _FakeAppShimmerFactory implements AppShimmerFactory {
  @override
  Widget shimmer({required double width, required double height}) {
    return Container(
      key: const Key('shimmer_placeholder'),
      width: width,
      height: height,
      color: Colors.grey,
    );
  }
}
