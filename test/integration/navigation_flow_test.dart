import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/core/constants/color.dart';
import 'package:quran_app/core/constants/config.dart';
import 'package:quran_app/core/constants/image.dart';
import 'package:quran_app/core/di/injection.dart';
import 'package:quran_app/core/router/app_router.dart';
import 'package:quran_app/core/services/crash_reporter.dart';
import 'package:quran_app/core/services/showcase_service.dart';
import 'package:quran_app/core/storage/database_helper.dart';
import 'package:quran_app/core/storage/local_storage_service.dart';
import 'package:quran_app/core/widgets/app_bottomsheet.dart';
import 'package:quran_app/core/widgets/app_button.dart';
import 'package:quran_app/core/widgets/app_input.dart';
import 'package:quran_app/core/widgets/app_padding.dart';
import 'package:quran_app/core/widgets/app_shimmer.dart';
import 'package:quran_app/core/widgets/app_text.dart';
import 'package:quran_app/features/bookmark/presentation/cubits/bookmark_cubit/bookmark_cubit.dart';
import 'package:quran_app/features/bookmark/domain/usecases/delete_bookmark_usecase.dart';
import 'package:quran_app/features/bookmark/domain/usecases/get_bookmarks_usecase.dart';
import 'package:quran_app/features/bookmark/domain/usecases/save_bookmark_usecase.dart';
import 'package:quran_app/features/dashboard/presentation/cubits/dashboard_cubit/dashboard_cubit.dart';
import 'package:quran_app/features/dashboard/presentation/cubits/home_cubit/home_cubit.dart';
import 'package:quran_app/features/detail_surah/domain/entities/detail_entity.dart';
import 'package:quran_app/features/detail_surah/domain/usecases/get_detail_surah_usecase.dart';
import 'package:quran_app/features/search/presentation/cubits/search_cubit/search_cubit.dart';
import 'package:quran_app/features/surah/domain/entities/surah_entity.dart';
import 'package:quran_app/features/surah/domain/usecases/get_surah_usecase.dart';
import 'package:quran_app/features/surah/presentation/cubits/get_surah_cubit/get_surah_cubit.dart';

// --- Mock Cubits ---
class MockGetSurahCubit extends MockCubit<GetSurahState>
    implements GetSurahCubit {}

class MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

class MockDashboardCubit extends MockCubit<DashboardState>
    implements DashboardCubit {}

class MockBookmarkCubit extends MockCubit<BookmarkState>
    implements BookmarkCubit {}

class MockSearchCubit extends MockCubit<SearchState> implements SearchCubit {}

// --- Mock Services ---
class MockLocalStorageService extends Mock implements LocalStorageService {}

class MockCrashReporter extends Mock implements CrashReporter {}

class MockShowcaseService extends Mock implements ShowcaseService {}

class MockDatabaseHelper extends Mock implements DatabaseHelper {}

class MockGetDetailSurahUseCase extends Mock implements GetDetailSurahUseCase {}

class MockGetSurahUseCase extends Mock implements GetSurahUseCase {}

class MockSaveBookmarkUseCase extends Mock implements SaveBookmarkUseCase {}

class MockGetBookmarksUseCase extends Mock implements GetBookmarksUseCase {}

class MockDeleteBookmarkUseCase extends Mock implements DeleteBookmarkUseCase {}

class MockAppBottomsheetFactory extends Mock implements AppBottomsheetFactory {}

// Fallback values for mocktail
class _FakeBuildContext extends Fake implements BuildContext {}

class _FakeStackTrace extends Fake implements StackTrace {}

// --- Test factory implementations ---
class _TestAppTextFactory implements AppTextFactory {
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

class _TestAppShimmerFactory implements AppShimmerFactory {
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

class _TestAppPaddingFactory implements AppPaddingFactory {
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

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeBuildContext());
    registerFallbackValue(_FakeStackTrace());
    registerFallbackValue(<GlobalKey>[]);
  });

  late MockGetSurahCubit mockGetSurahCubit;
  late MockHomeCubit mockHomeCubit;
  late MockDashboardCubit mockDashboardCubit;
  late MockBookmarkCubit mockBookmarkCubit;
  late MockSearchCubit mockSearchCubit;
  late MockLocalStorageService mockLocalStorageService;
  late MockCrashReporter mockCrashReporter;
  late MockShowcaseService mockShowcaseService;
  late MockDatabaseHelper mockDatabaseHelper;
  late MockGetDetailSurahUseCase mockGetDetailSurahUseCase;
  late MockGetSurahUseCase mockGetSurahUseCase;
  late MockAppBottomsheetFactory mockAppBottomsheetFactory;
  late AppRouter appRouter;

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

  const testDetailEntity = DetailEntity(
    nomor: 1,
    nama: 'الفاتحة',
    namaLatin: 'Al-Fatihah',
    jumlahAyat: 7,
    tempatTurun: 'Mekah',
    arti: 'Pembukaan',
    deskripsi: 'Surah pertama',
    audioFull: {'01': 'https://example.com/audio1.mp3'},
    ayat: [
      AyatDetailEntity(
        nomorAyat: 1,
        teksArab: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        teksLatin: 'Bismillaahir rahmaanir rahiim',
        teksIndonesia: 'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang',
        audio: {'01': 'https://example.com/ayat1.mp3'},
      ),
      AyatDetailEntity(
        nomorAyat: 2,
        teksArab: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
        teksLatin: "Al-hamdu lillaahi rabbil 'aalamiin",
        teksIndonesia: 'Segala puji bagi Allah, Tuhan seluruh alam',
        audio: {'01': 'https://example.com/ayat2.mp3'},
      ),
    ],
  );

  setUp(() {
    GetIt.instance.reset();

    mockGetSurahCubit = MockGetSurahCubit();
    mockHomeCubit = MockHomeCubit();
    mockDashboardCubit = MockDashboardCubit();
    mockBookmarkCubit = MockBookmarkCubit();
    mockSearchCubit = MockSearchCubit();

    // Stub async cubit methods called by widget initState
    when(() => mockGetSurahCubit.getSurah()).thenAnswer((_) async {});
    mockLocalStorageService = MockLocalStorageService();
    mockCrashReporter = MockCrashReporter();
    mockShowcaseService = MockShowcaseService();
    mockDatabaseHelper = MockDatabaseHelper();
    mockGetDetailSurahUseCase = MockGetDetailSurahUseCase();
    mockGetSurahUseCase = MockGetSurahUseCase();
    mockAppBottomsheetFactory = MockAppBottomsheetFactory();

    // Stub GetSurahUseCase — return test surah list for HomePage
    when(() => mockGetSurahUseCase.call())
        .thenAnswer((_) async => Right(testSurahList));

    // Stub LocalStorageService — onboarded, so redirect guard allows /home
    when(
      () => mockLocalStorageService.getBool(
        key: any(named: 'key'),
        defaultValue: any(named: 'defaultValue'),
      ),
    ).thenReturn(true);
    when(() => mockLocalStorageService.getString(key: any(named: 'key')))
        .thenReturn('');
    when(() => mockLocalStorageService.getInt(key: any(named: 'key')))
        .thenReturn(0);
    when(
      () => mockLocalStorageService.setBool(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async {});

    // Stub CrashReporter
    when(() => mockCrashReporter.recordError(any(), any()))
        .thenAnswer((_) async {});

    // Stub GetDetailSurahUseCase — return test detail for surah 1
    when(() => mockGetDetailSurahUseCase.call(nomor: any(named: 'nomor')))
        .thenAnswer((_) async => const Right(testDetailEntity));

    // Stub ShowcaseService
    when(
      () => mockShowcaseService.showCase(
        context: any(named: 'context'),
        keys: any(named: 'keys'),
        cacheKey: any(named: 'cacheKey'),
        isShowHelp: any(named: 'isShowHelp'),
      ),
    ).thenReturn(null);

    // Default cubit state stubs
    when(() => mockGetSurahCubit.state)
        .thenReturn(GetSurahState.success(testSurahList));
    when(() => mockHomeCubit.state).thenReturn(
      const HomeState.loaded(
        namaLatin: '',
        nomorSurah: 0,
        nomorAyat: 0,
        surahList: [],
      ),
    );
    when(() => mockDashboardCubit.state)
        .thenReturn(const DashboardState(currentIndex: 0));
    when(() => mockBookmarkCubit.state)
        .thenReturn(const BookmarkState.initial());
    when(() => mockSearchCubit.state).thenReturn(const SearchState.initial());

    // Register DI dependencies
    locator.registerLazySingleton<LocalStorageService>(
      () => mockLocalStorageService,
    );
    locator.registerLazySingleton<CrashReporter>(() => mockCrashReporter);
    locator.registerLazySingleton<ShowcaseService>(() => mockShowcaseService);
    locator.registerLazySingleton<DatabaseHelper>(() => mockDatabaseHelper);
    locator.registerLazySingleton<GetDetailSurahUseCase>(
      () => mockGetDetailSurahUseCase,
    );
    locator.registerLazySingleton<GetSurahUseCase>(() => mockGetSurahUseCase);
    locator.registerLazySingleton<AppTextFactory>(_TestAppTextFactory.new);
    locator
        .registerLazySingleton<AppShimmerFactory>(_TestAppShimmerFactory.new);
    locator
        .registerLazySingleton<AppPaddingFactory>(_TestAppPaddingFactory.new);
    locator.registerLazySingleton<AppButtonFactory>(_TestAppButtonFactory.new);
    locator.registerLazySingleton<AppInputFactory>(_TestAppInputFactory.new);
    locator.registerLazySingleton<AppBottomsheetFactory>(
      () => mockAppBottomsheetFactory,
    );
    locator.registerLazySingleton<AppColorConfig>(AppColorConfig.new);
    locator.registerLazySingleton<AppConfig>(AppConfig.new);
    locator.registerLazySingleton<MyImage>(MyImage.new);

    // Bookmark use case for detail page
    locator.registerLazySingleton<SaveBookmarkUseCase>(
      () => MockSaveBookmarkUseCase(),
    );

    // Bookmark use cases for BookmarkPage
    locator.registerLazySingleton<GetBookmarksUseCase>(
      () => MockGetBookmarksUseCase(),
    );
    locator.registerLazySingleton<DeleteBookmarkUseCase>(
      () => MockDeleteBookmarkUseCase(),
    );

    // Create AppRouter with mock storage service (cacheStarted=true → stays on /home)
    appRouter = AppRouter(storageService: mockLocalStorageService);
  });

  tearDown(() async {
    await GetIt.instance.reset();
  });

  Widget buildApp() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DashboardCubit>.value(value: mockDashboardCubit),
        BlocProvider<HomeCubit>.value(value: mockHomeCubit),
        BlocProvider<SearchCubit>.value(value: mockSearchCubit),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter.router,
      ),
    );
  }

  group('Navigation Flow Integration Test', () {
    testWidgets(
      'navigates from HomePage to DetailSurahPage and back',
      (tester) async {
        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        // --- Verify HomePage content is displayed ---
        // The surah list should show the surah names
        expect(find.text('Al-Fatihah'), findsOneWidget);
        expect(find.text('Al-Baqarah'), findsOneWidget);

        // --- Navigate to DetailSurahPage by tapping the first surah ---
        // HomeCubit.getDetailSurah will emit navigateToDetail, which the
        // BlocListener in HomePage uses to push '/detail-surah/1'.
        // For this integration test, we simulate the navigation by directly
        // navigating with the router, since the HomeCubit is mocked.
        // Instead, we simulate HomeCubit emitting navigateToDetail state
        // after the tap.

        // Tap on Al-Fatihah surah item
        await tester.tap(find.text('Al-Fatihah').first);
        await tester.pump();

        // Verify HomeCubit.getDetailSurah was called
        verify(() => mockHomeCubit.getDetailSurah(testSurahList[0])).called(1);

        // Simulate the navigation by pushing the route via router
        // (since HomeCubit is mocked, it won't actually emit the state)
        appRouter.router.push('/detail-surah/1');
        await tester.pumpAndSettle();

        // --- Verify DetailSurahPage content is displayed ---
        // The DetailSurahCubit will auto-fetch on initState via
        // WidgetsBinding.instance.addPostFrameCallback.
        // Since GetDetailSurahUseCase is mocked to return success,
        // the DetailSurahCubit will emit success with the test detail.
        await tester.pumpAndSettle();

        // After navigation, DetailSurahPage should show the surah title
        // and ayat content. The title is shown in the AppBar.
        expect(find.text('Al-Fatihah'), findsWidgets);

        // Verify ayat Arabic text is displayed
        expect(
          find.text('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ'),
          findsOneWidget,
        );

        // --- Navigate back to HomePage ---
        appRouter.router.go('/home');
        await tester.pumpAndSettle();

        // --- Verify HomePage content is displayed again ---
        expect(find.text('Al-Fatihah'), findsOneWidget);
        expect(find.text('Al-Baqarah'), findsOneWidget);
      },
    );
  });
}
