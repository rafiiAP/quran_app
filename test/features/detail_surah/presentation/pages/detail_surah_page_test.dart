import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/core/constants/color.dart';
import 'package:quran_app/core/constants/config.dart';
import 'package:quran_app/core/di/injection.dart';
import 'package:quran_app/core/navigator_key.dart';
import 'package:quran_app/core/services/showcase_service.dart';
import 'package:quran_app/core/widgets/app_button.dart';
import 'package:quran_app/core/widgets/app_padding.dart';
import 'package:quran_app/core/widgets/app_text.dart';
import 'package:quran_app/features/detail_surah/domain/entities/detail_entity.dart';
import 'package:quran_app/features/detail_surah/presentation/cubits/detail_surah_cubit/detail_surah_cubit.dart';
import 'package:quran_app/features/detail_surah/presentation/cubits/detail_surah_page_cubit/detail_surah_page_cubit.dart';
import 'package:quran_app/features/detail_surah/presentation/pages/detail_surah_page.dart';

import '../../../../mocks.dart';

class MockDetailSurahCubit extends MockCubit<DetailSurahState>
    implements DetailSurahCubit {}

class MockDetailSurahPageCubit extends MockCubit<DetailSurahPageState>
    implements DetailSurahPageCubit {}

class FakeBuildContext extends Fake implements BuildContext {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeBuildContext());
    registerFallbackValue(<GlobalKey>[]);
  });
  late MockDetailSurahCubit mockDetailSurahCubit;
  late MockDetailSurahPageCubit mockDetailSurahPageCubit;
  late MockShowcaseService mockShowcaseService;

  const testDetail = DetailEntity(
    nomor: 1,
    nama: 'الفاتحة',
    namaLatin: 'Al-Fatihah',
    jumlahAyat: 7,
    tempatTurun: 'Mekah',
    arti: 'Pembukaan',
    deskripsi: 'Surah Al-Fatihah',
    audioFull: {'01': 'https://example.com/audio.mp3'},
    ayat: [
      AyatDetailEntity(
        nomorAyat: 1,
        teksArab: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        teksLatin: 'Bismillāhir-raḥmānir-raḥīm',
        teksIndonesia: 'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.',
        audio: {'01': 'https://example.com/ayat1.mp3'},
      ),
      AyatDetailEntity(
        nomorAyat: 2,
        teksArab: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
        teksLatin: 'Al-ḥamdu lillāhi rabbil-ʿālamīn',
        teksIndonesia: 'Segala puji bagi Allah, Tuhan seluruh alam.',
        audio: {'01': 'https://example.com/ayat2.mp3'},
      ),
    ],
  );

  setUp(() {
    mockDetailSurahCubit = MockDetailSurahCubit();
    mockDetailSurahPageCubit = MockDetailSurahPageCubit();
    mockShowcaseService = MockShowcaseService();

    // Reset locator for each test
    if (locator.isRegistered<AppTextFactory>()) {
      locator.reset();
    }

    // Register real widget factories (they produce real widgets for the test)
    locator.registerLazySingleton<AppColorConfig>(AppColorConfig.new);
    locator.registerLazySingleton<AppConfig>(AppConfig.new);
    locator.registerLazySingleton<AppTextFactory>(AppTextFactoryImpl.new);
    locator.registerLazySingleton<AppButtonFactory>(AppButtonFactoryImpl.new);
    locator.registerLazySingleton<AppPaddingFactory>(AppPaddingFactoryImpl.new);
    locator.registerLazySingleton<ShowcaseService>(() => mockShowcaseService);

    // Stub showcase service to be a no-op
    when(
      () => mockShowcaseService.showCase(
        context: any(named: 'context'),
        keys: any(named: 'keys'),
        cacheKey: any(named: 'cacheKey'),
        isShowHelp: any(named: 'isShowHelp'),
      ),
    ).thenReturn(null);

    // Default state stubs
    when(() => mockDetailSurahPageCubit.state)
        .thenReturn(const DetailSurahPageState.idle());
    when(() => mockDetailSurahPageCubit.stream)
        .thenAnswer((_) => const Stream.empty());

    // Stub getPosts called in initState postFrameCallback
    when(() => mockDetailSurahCubit.getPosts(number: any(named: 'number')))
        .thenAnswer((_) async {});
  });

  tearDown(() {
    locator.reset();
  });

  Widget buildWidget({int nomor = 1, int? indexTandai}) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<DetailSurahCubit>.value(value: mockDetailSurahCubit),
          BlocProvider<DetailSurahPageCubit>.value(
            value: mockDetailSurahPageCubit,
          ),
        ],
        child: DetailSurahPage(nomor: nomor, indexTandai: indexTandai),
      ),
    );
  }

  group('DetailSurahPage', () {
    testWidgets('shows CircularProgressIndicator when loading state',
        (tester) async {
      when(() => mockDetailSurahCubit.state)
          .thenReturn(const DetailSurahState.loading());
      when(() => mockDetailSurahCubit.stream)
          .thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(buildWidget());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows ayat text content when success state', (tester) async {
      when(() => mockDetailSurahCubit.state)
          .thenReturn(const DetailSurahState.success(testDetail));
      when(() => mockDetailSurahCubit.stream).thenAnswer(
          (_) => Stream.value(const DetailSurahState.success(testDetail)),);

      await tester.pumpWidget(buildWidget());
      await tester.pump();

      // Verify Arabic text is displayed
      expect(
        find.text('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ'),
        findsOneWidget,
      );
      // Verify Latin text is displayed (with index)
      expect(find.text('Bismillāhir-raḥmānir-raḥīm (1)'), findsOneWidget);
      // Verify Indonesian translation is displayed
      expect(
        find.textContaining(
          'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.',
        ),
        findsOneWidget,
      );
      // Verify surah name in AppBar title
      expect(find.text('Al-Fatihah'), findsOneWidget);
    });

    testWidgets('shows error message when error state', (tester) async {
      when(() => mockDetailSurahCubit.state)
          .thenReturn(const DetailSurahState.error('Gagal memuat data'));
      when(() => mockDetailSurahCubit.stream)
          .thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(buildWidget());
      await tester.pump();

      // Verify error message is displayed
      expect(find.textContaining('Gagal memuat data'), findsOneWidget);
      // Verify retry button is displayed
      expect(find.textContaining('Coba lagi'), findsOneWidget);
    });
  });
}
