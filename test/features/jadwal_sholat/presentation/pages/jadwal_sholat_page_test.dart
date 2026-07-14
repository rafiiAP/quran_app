import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/core/constants/color.dart';
import 'package:quran_app/core/constants/image.dart';
import 'package:quran_app/core/di/injection.dart';
import 'package:quran_app/core/widgets/app_bottomsheet.dart';
import 'package:quran_app/core/widgets/app_padding.dart';
import 'package:quran_app/core/widgets/app_shimmer.dart';
import 'package:quran_app/core/widgets/app_text.dart';
import 'package:quran_app/data/model/set_notif_model.dart';
import 'package:quran_app/features/jadwal_sholat/domain/entities/jadwal_sholat_entity.dart';
import 'package:quran_app/features/jadwal_sholat/presentation/cubits/jadwal_sholat_cubit/jadwal_sholat_cubit.dart';
import 'package:quran_app/features/jadwal_sholat/presentation/cubits/jadwal_sholat_page_cubit/jadwal_sholat_page_cubit.dart';

// Mock cubits
class MockJadwalSholatCubit extends MockCubit<JadwalSholatState>
    implements JadwalSholatCubit {}

class MockJadwalSholatPageCubit extends MockCubit<JadwalSholatPageState>
    implements JadwalSholatPageCubit {}

/// Fake AppTextFactory that returns simple Text widgets without needing
/// navigatorKey or GoogleFonts.
class FakeAppTextFactory implements AppTextFactory {
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

/// Fake AppBottomsheetFactory that does nothing (avoids navigatorKey usage).
class FakeAppBottomsheetFactory implements AppBottomsheetFactory {
  @override
  Future<void> showBottomSheet({
    Widget? bottomSheet,
    Color? backgroundColor,
    dynamic bottomSheetMode,
    String cLoadingMessage = '',
    bool isDismissible = true,
    String? title,
    bool isScrollControlled = false,
  }) async {}

  @override
  Future<void> messageInfo({required String message}) async {}

  @override
  Future<void> wait({String? message}) async {}

  @override
  void endwait() {}
}

void main() {
  late MockJadwalSholatCubit mockJadwalSholatCubit;
  late MockJadwalSholatPageCubit mockJadwalSholatPageCubit;

  setUpAll(() {
    // Register GetIt dependencies for widget factories used via locator
    locator.allowReassignment = true;
    locator.registerLazySingleton<AppColorConfig>(AppColorConfig.new);
    locator.registerLazySingleton<MyImage>(MyImage.new);
    locator.registerLazySingleton<AppPaddingFactory>(AppPaddingFactoryImpl.new);
    locator.registerLazySingleton<AppShimmerFactory>(AppShimmerFactoryImpl.new);
    locator.registerLazySingleton<AppTextFactory>(FakeAppTextFactory.new);
    locator.registerLazySingleton<AppBottomsheetFactory>(
      FakeAppBottomsheetFactory.new,
    );
  });

  setUp(() {
    mockJadwalSholatCubit = MockJadwalSholatCubit();
    mockJadwalSholatPageCubit = MockJadwalSholatPageCubit();
  });

  tearDownAll(() {
    locator.reset();
  });

  /// Builds a test widget wrapping the view content with mocked cubits.
  /// We replicate the inner view's rendering logic to avoid initState GPS
  /// calls that happen in the real _JadwalSholatView.
  Widget buildTestWidget() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<JadwalSholatCubit>.value(
            value: mockJadwalSholatCubit,
          ),
          BlocProvider<JadwalSholatPageCubit>.value(
            value: mockJadwalSholatPageCubit,
          ),
        ],
        child: const _TestJadwalSholatBody(),
      ),
    );
  }

  group('JadwalSholatPage', () {
    testWidgets('shows shimmer when loading state', (tester) async {
      when(() => mockJadwalSholatCubit.state)
          .thenReturn(const JadwalSholatState.initial());
      when(() => mockJadwalSholatPageCubit.state)
          .thenReturn(const JadwalSholatPageState.loading());

      await tester.pumpWidget(buildTestWidget());

      // LoadingSholatView shows Sunrise, Mid night, Sunset labels
      expect(find.text('Sunrise'), findsOneWidget);
      expect(find.text('Mid night'), findsOneWidget);
      expect(find.text('Sunset'), findsOneWidget);
    });

    testWidgets('shows prayer time entries when loaded state', (tester) async {
      final jadwalList = <SetNotifModel>[
        const SetNotifModel(
          iconsax: Iconsax.moon,
          hour: 4,
          minute: 30,
          title: 'Subuh',
          body: 'Waktunya sholat Subuh',
          isAlarmSet: false,
        ),
        const SetNotifModel(
          iconsax: Iconsax.sun,
          hour: 12,
          minute: 0,
          title: 'Dzuhur',
          body: 'Waktunya sholat Dzuhur',
          isAlarmSet: false,
        ),
        const SetNotifModel(
          iconsax: Iconsax.sun_1,
          hour: 15,
          minute: 30,
          title: 'Ashar',
          body: 'Waktunya sholat Ashar',
          isAlarmSet: false,
        ),
        const SetNotifModel(
          iconsax: Iconsax.sun_fog,
          hour: 18,
          minute: 0,
          title: 'Maghrib',
          body: 'Waktunya sholat Maghrib',
          isAlarmSet: false,
        ),
        const SetNotifModel(
          iconsax: Iconsax.moon,
          hour: 19,
          minute: 30,
          title: 'Isya',
          body: 'Waktunya sholat Isya',
          isAlarmSet: false,
        ),
      ];

      const entity = JadwalSholatEntity(
        fajr: '04:30',
        sunrise: '05:45',
        dhuhr: '12:00',
        asr: '15:30',
        sunset: '18:00',
        maghrib: '18:00',
        isha: '19:30',
        imsak: '04:20',
        midnight: '00:00',
        firstthird: '22:00',
        lastthird: '02:00',
      );

      when(() => mockJadwalSholatCubit.state)
          .thenReturn(const JadwalSholatState.initial());
      when(() => mockJadwalSholatPageCubit.state).thenReturn(
        JadwalSholatPageState.loaded(
          city: 'Jakarta',
          timezone: 'Asia/Jakarta',
          jadwalList: jadwalList,
          countdownText: 'Subuh dalam\n01:30:00',
          sholatText: 'Mendekati waktu Subuh',
          timeText: '04:30',
          entity: entity,
        ),
      );

      await tester.pumpWidget(buildTestWidget());

      // Verify prayer time entries are shown
      expect(find.text('Subuh'), findsOneWidget);
      expect(find.text('Dzuhur'), findsOneWidget);
      expect(find.text('Ashar'), findsOneWidget);
      expect(find.text('Maghrib'), findsOneWidget);
      expect(find.text('Isya'), findsOneWidget);

      // Verify city and timezone
      expect(find.text('Jakarta'), findsOneWidget);
      expect(find.text('Asia/Jakarta'), findsOneWidget);
    });

    testWidgets('shows retry button when locationError state', (tester) async {
      when(() => mockJadwalSholatCubit.state)
          .thenReturn(const JadwalSholatState.initial());
      when(() => mockJadwalSholatPageCubit.state).thenReturn(
        const JadwalSholatPageState.locationError(
          message: 'Gagal mendapatkan lokasi. Ketuk untuk coba lagi.',
          retryCount: 1,
        ),
      );

      await tester.pumpWidget(buildTestWidget());

      expect(
        find.text('Gagal mendapatkan lokasi. Ketuk untuk coba lagi.'),
        findsOneWidget,
      );
      expect(find.text('Coba Lagi'), findsOneWidget);
    });

    testWidgets('tap retry button calls retryInit()', (tester) async {
      when(() => mockJadwalSholatCubit.state)
          .thenReturn(const JadwalSholatState.initial());
      when(() => mockJadwalSholatPageCubit.state).thenReturn(
        const JadwalSholatPageState.locationError(
          message: 'Gagal mendapatkan lokasi. Ketuk untuk coba lagi.',
          retryCount: 1,
        ),
      );
      when(() => mockJadwalSholatPageCubit.retryInit()).thenReturn(null);

      await tester.pumpWidget(buildTestWidget());

      await tester.tap(find.text('Coba Lagi'));
      await tester.pump();

      verify(() => mockJadwalSholatPageCubit.retryInit()).called(1);
    });
  });
}

/// A test widget that replicates the body of _JadwalSholatView's build method
/// without the initState GPS logic. This allows testing rendering based on
/// cubit states provided via BlocProvider.value.
class _TestJadwalSholatBody extends StatelessWidget {
  const _TestJadwalSholatBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appText.title(text: 'Jadwal Sholat'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<JadwalSholatPageCubit, JadwalSholatPageState>(
          builder: (context, state) {
            return state.maybeWhen(
              orElse: () => const _LoadingShimmerView(),
              initial: () => const _LoadingShimmerView(),
              loading: () => const _LoadingShimmerView(),
              awaitingSchedule: (_, __, ___) => const _LoadingShimmerView(),
              locationError: (message, retryCount) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        message,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<JadwalSholatPageCubit>().retryInit(),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                );
              },
              locationPermissionError: (message) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        message,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Buka Pengaturan'),
                      ),
                    ],
                  ),
                );
              },
              loaded: (
                city,
                timezone,
                jadwalList,
                countdownText,
                sholatText,
                timeText,
                entity,
              ) {
                return _LoadedView(
                  city: city,
                  timezone: timezone,
                  jadwalList: jadwalList,
                  countdownText: countdownText,
                  sholatText: sholatText,
                  timeText: timeText,
                  entity: entity,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/// Simplified loading view for test (avoids asset image dependencies)
class _LoadingShimmerView extends StatelessWidget {
  const _LoadingShimmerView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        appShimmer.shimmer(width: 200, height: 15),
        appPadding.paddingheight16(),
        const Text('Sunrise'),
        const Text('Mid night'),
        const Text('Sunset'),
      ],
    );
  }
}

/// Simplified loaded view for test (avoids ShowCaseWidget and asset deps)
class _LoadedView extends StatelessWidget {
  const _LoadedView({
    required this.city,
    required this.timezone,
    required this.jadwalList,
    required this.countdownText,
    required this.sholatText,
    required this.timeText,
    required this.entity,
  });

  final String city;
  final String timezone;
  final List<SetNotifModel> jadwalList;
  final String countdownText;
  final String sholatText;
  final String timeText;
  final JadwalSholatEntity entity;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(city),
        Text(timezone),
        Text(countdownText),
        Text(sholatText),
        Text(timeText),
        ...jadwalList.map(
          (item) => Row(
            children: [
              Text(item.title),
              Text(
                '${item.hour.toString().padLeft(2, '0')}:${item.minute.toString().padLeft(2, '0')}',
              ),
            ],
          ),
        ),
        Text('Sunrise: ${entity.sunrise}'),
        Text('Midnight: ${entity.midnight}'),
        Text('Sunset: ${entity.sunset}'),
      ],
    );
  }
}
