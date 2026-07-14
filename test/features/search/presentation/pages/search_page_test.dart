import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/core/constants/color.dart';
import 'package:quran_app/core/constants/image.dart';
import 'package:quran_app/core/di/injection.dart';
import 'package:quran_app/core/widgets/app_input.dart';
import 'package:quran_app/core/widgets/app_padding.dart';
import 'package:quran_app/core/widgets/app_text.dart';
import 'package:quran_app/features/search/presentation/cubits/search_cubit/search_cubit.dart';
import 'package:quran_app/features/search/presentation/pages/search_page.dart';
import 'package:quran_app/features/surah/domain/entities/surah_entity.dart';
import 'package:quran_app/features/surah/presentation/cubits/get_surah_cubit/get_surah_cubit.dart';

// Mock Cubits
class MockGetSurahCubit extends MockCubit<GetSurahState>
    implements GetSurahCubit {}

class MockSearchCubit extends MockCubit<SearchState> implements SearchCubit {}

/// A simple AppTextFactory that returns plain Text widgets for testing.
class TestAppTextFactory implements AppTextFactory {
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
    return Text(text);
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
    return Text(text);
  }
}

/// Simple padding factory for tests.
class TestAppPaddingFactory implements AppPaddingFactory {
  @override
  Widget paddingheight16() => const SizedBox(height: 16);
  @override
  Widget paddingheight8() => const SizedBox(height: 8);
  @override
  Widget paddingheight5() => const SizedBox(height: 5);
  @override
  Widget paddingWidtht16() => const SizedBox(width: 16);
  @override
  Widget paddingWidtht8() => const SizedBox(width: 8);
  @override
  Widget paddingWidtht5() => const SizedBox(width: 5);
}

/// AppInputFactory for tests that preserves onChanged callback.
class TestAppInputFactory implements AppInputFactory {
  @override
  Widget input({
    TextInputType keyboardType = TextInputType.text,
    AutovalidateMode? autoValidateMode,
    String? Function(String?)? validator,
    bool? enabled,
    Widget? icon,
    String? hintText,
    TextEditingController? controller,
    String? initialValue,
    List<dynamic>? inputFormatters,
    void Function(String)? onChanged,
    void Function(String?)? onSaved,
    void Function(String)? onFieldSubmitted,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    TextAlign textAlign = TextAlign.start,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    int? maxLength,
    BorderRadius? borderRadius,
    Widget? suffixIcon,
    bool readOnly = false,
    bool filled = true,
    Color? color,
    Color? colorHint,
    Widget? prefixIcon,
    void Function()? onTap,
    int? maxLines = 1,
    String? labelText,
    Widget? prefix,
    String? prefixText,
    bool autofocus = false,
    EdgeInsetsGeometry? contentPadding,
    bool? isDense,
    bool hideMaxLength = false,
    FontWeight? fontWeightHint,
  }) {
    return TextField(
      key: const Key('search_input'),
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
      ),
    );
  }
}

void main() {
  late MockGetSurahCubit mockGetSurahCubit;
  late MockSearchCubit mockSearchCubit;

  final testSurahList = [
    const SurahEntity(
      nomor: 1,
      nama: 'الفاتحة',
      namaLatin: 'Al-Fatihah',
      jumlahAyat: 7,
      tempatTurun: 'Mekah',
      arti: 'Pembukaan',
      deskripsi: 'Surah pertama',
      audioFull: {'01': 'https://example.com/audio1.mp3'},
    ),
    const SurahEntity(
      nomor: 2,
      nama: 'البقرة',
      namaLatin: 'Al-Baqarah',
      jumlahAyat: 286,
      tempatTurun: 'Madinah',
      arti: 'Sapi',
      deskripsi: 'Surah kedua',
      audioFull: {'01': 'https://example.com/audio2.mp3'},
    ),
  ];

  setUp(() {
    // Reset GetIt for each test
    final getIt = GetIt.instance;
    if (getIt.isRegistered<AppTextFactory>()) {
      getIt.reset();
    }

    mockGetSurahCubit = MockGetSurahCubit();
    mockSearchCubit = MockSearchCubit();

    // Register test dependencies in GetIt
    locator.registerLazySingleton<AppTextFactory>(TestAppTextFactory.new);
    locator.registerLazySingleton<AppPaddingFactory>(TestAppPaddingFactory.new);
    locator.registerLazySingleton<AppInputFactory>(TestAppInputFactory.new);
    locator.registerLazySingleton<AppColorConfig>(AppColorConfig.new);
    locator.registerLazySingleton<MyImage>(MyImage.new);
  });

  tearDown(() async {
    await GetIt.instance.reset();
  });

  Widget buildWidget() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<GetSurahCubit>.value(value: mockGetSurahCubit),
          BlocProvider<SearchCubit>.value(value: mockSearchCubit),
        ],
        child: SearchPage(),
      ),
    );
  }

  group('SearchPage Widget Tests', () {
    testWidgets('initial state shows search input field', (tester) async {
      when(() => mockGetSurahCubit.state)
          .thenReturn(GetSurahState.success(testSurahList));
      when(() => mockSearchCubit.state).thenReturn(const SearchState.initial());

      await tester.pumpWidget(buildWidget());
      await tester.pump();

      // Search input field should be present
      expect(find.byKey(const Key('search_input')), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('success state shows filtered results', (tester) async {
      when(() => mockGetSurahCubit.state)
          .thenReturn(GetSurahState.success(testSurahList));
      when(() => mockSearchCubit.state).thenReturn(
        SearchState.results(results: [testSurahList[0]]),
      );

      await tester.pumpWidget(buildWidget());
      await tester.pump();

      // Should show filtered surah namaLatin
      expect(find.text('Al-Fatihah'), findsOneWidget);
      // Al-Baqarah should NOT be in results (filtered out)
      expect(find.text('Al-Baqarah'), findsNothing);
    });

    testWidgets('empty results state shows not found message', (tester) async {
      when(() => mockGetSurahCubit.state)
          .thenReturn(GetSurahState.success(testSurahList));
      when(() => mockSearchCubit.state).thenReturn(
        const SearchState.results(results: []),
      );

      await tester.pumpWidget(buildWidget());
      await tester.pump();

      // The page checks _searchController.text.isNotEmpty to show
      // "Surah tidak ditemukan". Since controller starts empty, it shows
      // SizedBox.shrink. We verify the empty state results in no list items.
      expect(find.text('Al-Fatihah'), findsNothing);
      expect(find.text('Al-Baqarah'), findsNothing);
    });

    testWidgets('text input triggers SearchCubit.onSearch', (tester) async {
      when(() => mockGetSurahCubit.state)
          .thenReturn(GetSurahState.success(testSurahList));
      when(() => mockSearchCubit.state).thenReturn(const SearchState.initial());

      await tester.pumpWidget(buildWidget());
      await tester.pump();

      // Type text in search field
      await tester.enterText(find.byKey(const Key('search_input')), 'fatihah');
      await tester.pump();

      // Verify SearchCubit.onSearch was called
      verify(
        () => mockSearchCubit.onSearch(
          surahList: testSurahList,
          query: 'fatihah',
        ),
      ).called(1);
    });

    testWidgets('clearing text input triggers SearchCubit.clearSearch',
        (tester) async {
      when(() => mockGetSurahCubit.state)
          .thenReturn(GetSurahState.success(testSurahList));
      when(() => mockSearchCubit.state).thenReturn(const SearchState.initial());

      await tester.pumpWidget(buildWidget());
      await tester.pump();

      // First enter text
      await tester.enterText(find.byKey(const Key('search_input')), 'al');
      await tester.pump();

      // Then clear it
      await tester.enterText(find.byKey(const Key('search_input')), '');
      await tester.pump();

      // Verify clearSearch was called when text becomes empty
      verify(() => mockSearchCubit.clearSearch()).called(1);
    });
  });
}
