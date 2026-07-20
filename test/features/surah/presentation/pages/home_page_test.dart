import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/core/constants/color.dart';
import 'package:quran_app/core/constants/config.dart';
import 'package:quran_app/core/constants/image.dart';
import 'package:quran_app/core/di/injection.dart';
import 'package:quran_app/core/services/showcase_service.dart';
import 'package:quran_app/core/widgets/app_bottomsheet.dart';
import 'package:quran_app/core/widgets/app_button.dart';
import 'package:quran_app/core/widgets/app_input.dart';
import 'package:quran_app/core/widgets/app_padding.dart';
import 'package:quran_app/core/widgets/app_shimmer.dart';
import 'package:quran_app/core/widgets/app_text.dart';
import 'package:quran_app/features/dashboard/presentation/cubits/home_cubit/home_cubit.dart';
import 'package:quran_app/features/surah/domain/entities/surah_entity.dart';
import 'package:quran_app/features/surah/presentation/cubits/get_surah_cubit/get_surah_cubit.dart';
import 'package:quran_app/features/surah/presentation/pages/home_page.dart';
import 'package:showcaseview/showcaseview.dart';

// Mock Cubits
class MockGetSurahCubit extends MockCubit<GetSurahState>
    implements GetSurahCubit {}

class MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

// Mock services
class MockShowcaseService extends Mock implements ShowcaseService {}

class MockAppBottomsheetFactory extends Mock implements AppBottomsheetFactory {}

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
    return Text(text, key: Key('text_body_$text'));
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
    return Text(text, key: Key('title_$text'));
  }
}

/// A simple AppShimmerFactory that returns a Container for testing.
class TestAppShimmerFactory implements AppShimmerFactory {
  int _counter = 0;

  @override
  Widget shimmer({required double width, required double height}) {
    _counter++;
    return Container(
      key: Key('shimmer_item_$_counter'),
      width: width,
      height: height,
      color: Colors.grey,
    );
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

void main() {
  late MockGetSurahCubit mockGetSurahCubit;
  late MockHomeCubit mockHomeCubit;
  late MockShowcaseService mockShowcaseService;
  late MockAppBottomsheetFactory mockAppBottomsheetFactory;

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
    GetIt.instance.reset();

    mockGetSurahCubit = MockGetSurahCubit();
    mockHomeCubit = MockHomeCubit();
    mockShowcaseService = MockShowcaseService();
    mockAppBottomsheetFactory = MockAppBottomsheetFactory();

    // Stub getSurah() so initState doesn't throw
    when(() => mockGetSurahCubit.getSurah()).thenAnswer((_) async {});

    // Register test dependencies in GetIt
    locator.registerLazySingleton<AppTextFactory>(TestAppTextFactory.new);
    locator.registerLazySingleton<AppShimmerFactory>(TestAppShimmerFactory.new);
    locator.registerLazySingleton<AppPaddingFactory>(TestAppPaddingFactory.new);
    locator.registerLazySingleton<AppBottomsheetFactory>(
      () => mockAppBottomsheetFactory,
    );
    locator.registerLazySingleton<AppButtonFactory>(
      () => _TestAppButtonFactory(),
    );
    locator.registerLazySingleton<AppInputFactory>(
      () => _TestAppInputFactory(),
    );
    locator.registerLazySingleton<AppColorConfig>(AppColorConfig.new);
    locator.registerLazySingleton<AppConfig>(AppConfig.new);
    locator.registerLazySingleton<MyImage>(MyImage.new);
    locator.registerLazySingleton<ShowcaseService>(() => mockShowcaseService);

    // Default state stubs
    when(() => mockHomeCubit.state).thenReturn(
      const HomeState.loaded(
        namaLatin: '',
        nomorSurah: 0,
        nomorAyat: 0,
        surahList: [],
      ),
    );
  });

  tearDown(() async {
    await GetIt.instance.reset();
  });

  Widget buildWidget() {
    return MaterialApp(
      home: ShowCaseWidget(
        builder: (context) => BlocProvider<HomeCubit>.value(
          value: mockHomeCubit,
          child: HomePage(getSurahCubit: mockGetSurahCubit),
        ),
      ),
    );
  }

  group('HomePage Widget Tests', () {
    testWidgets('shows shimmer when GetSurahCubit is in loading state',
        (tester) async {
      when(() => mockGetSurahCubit.state)
          .thenReturn(const GetSurahState.loading());

      await tester.pumpWidget(buildWidget());
      await tester.pump();

      // Shimmer items should be present in the loading state
      // The loading state renders 10 shimmer placeholder items
      final shimmerFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.key != null &&
            widget.key.toString().contains('shimmer_item'),
      );
      expect(shimmerFinder, findsWidgets);
    });

    testWidgets('shows surah list items when GetSurahCubit is in success state',
        (tester) async {
      when(() => mockGetSurahCubit.state)
          .thenReturn(GetSurahState.success(testSurahList));

      await tester.pumpWidget(buildWidget());
      await tester.pump();

      // Verify surah namaLatin text is shown
      expect(find.text('Al-Fatihah'), findsOneWidget);
      expect(find.text('Al-Baqarah'), findsOneWidget);
    });

    testWidgets(
        'shows error message via bottomsheet when GetSurahCubit emits error',
        (tester) async {
      const errorMessage = 'Gagal terhubung ke server';

      when(() => mockGetSurahCubit.state)
          .thenReturn(const GetSurahState.initial());
      when(
        () => mockAppBottomsheetFactory.messageInfo(
          message: any(named: 'message'),
        ),
      ).thenAnswer((_) async {});

      whenListen(
        mockGetSurahCubit,
        Stream<GetSurahState>.fromIterable([
          const GetSurahState.error(errorMessage),
        ]),
        initialState: const GetSurahState.initial(),
      );

      await tester.pumpWidget(buildWidget());
      await tester.pump();

      // Verify bottomsheet messageInfo was called with error message
      verify(
        () => mockAppBottomsheetFactory.messageInfo(message: errorMessage),
      ).called(1);
    });

    testWidgets('tapping surah item calls HomeCubit.getDetailSurah',
        (tester) async {
      when(() => mockGetSurahCubit.state)
          .thenReturn(GetSurahState.success(testSurahList));

      await tester.pumpWidget(buildWidget());
      await tester.pump();

      // Tap on the first surah item text (Al-Fatihah)
      await tester.tap(find.text('Al-Fatihah').first);
      await tester.pump();

      // Verify HomeCubit.getDetailSurah was called with the correct entity
      verify(() => mockHomeCubit.getDetailSurah(testSurahList[0])).called(1);
    });
  });
}

/// Minimal AppButtonFactory for tests.
class _TestAppButtonFactory implements AppButtonFactory {
  @override
  Widget button({
    required void Function()? onPressed,
    required Widget child,
    Color? textColor,
    Color? backgroundColor,
    double? elevation,
    EdgeInsetsGeometry? padding,
  }) {
    return ElevatedButton(onPressed: onPressed, child: child);
  }

  @override
  Widget outlinedButton({
    required void Function()? onPressed,
    required Widget child,
    Color? borderColor,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
  }) {
    return OutlinedButton(onPressed: onPressed, child: child);
  }
}

/// Minimal AppInputFactory for tests.
class _TestAppInputFactory implements AppInputFactory {
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
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(hintText: hintText),
    );
  }
}
