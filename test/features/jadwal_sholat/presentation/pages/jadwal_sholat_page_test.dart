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
import 'package:quran_app/features/jadwal_sholat/presentation/models/set_notif_model.dart';
import 'package:quran_app/features/jadwal_sholat/domain/entities/jadwal_sholat_entity.dart';
import 'package:quran_app/features/jadwal_sholat/presentation/cubits/jadwal_sholat_cubit/jadwal_sholat_cubit.dart';
import 'package:quran_app/features/jadwal_sholat/presentation/cubits/jadwal_sholat_location_cubit/jadwal_sholat_location_cubit.dart';
import 'package:quran_app/features/jadwal_sholat/presentation/cubits/jadwal_sholat_page_cubit/jadwal_sholat_page_cubit.dart';

// Mock cubits
class MockJadwalSholatCubit extends MockCubit<JadwalSholatState>
    implements JadwalSholatCubit {}

class MockJadwalSholatLocationCubit extends MockCubit<JadwalSholatLocationState>
    implements JadwalSholatLocationCubit {}

class MockJadwalSholatPageCubit extends MockCubit<JadwalSholatPageState>
    implements JadwalSholatPageCubit {}

/// Fake AppTextFactory for tests.
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

/// Fake AppBottomsheetFactory for tests.
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
  late MockJadwalSholatLocationCubit mockLocationCubit;
  late MockJadwalSholatPageCubit mockPageCubit;

  setUpAll(() {
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
    mockLocationCubit = MockJadwalSholatLocationCubit();
    mockPageCubit = MockJadwalSholatPageCubit();
  });

  tearDownAll(() {
    locator.reset();
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<JadwalSholatCubit>.value(value: mockJadwalSholatCubit),
          BlocProvider<JadwalSholatLocationCubit>.value(
            value: mockLocationCubit,
          ),
          BlocProvider<JadwalSholatPageCubit>.value(value: mockPageCubit),
        ],
        child: const _TestBody(),
      ),
    );
  }

  group('JadwalSholatPage', () {
    testWidgets('shows shimmer when location is loading', (tester) async {
      when(() => mockJadwalSholatCubit.state)
          .thenReturn(const JadwalSholatState.initial());
      when(() => mockLocationCubit.state)
          .thenReturn(const JadwalSholatLocationState.loading());
      when(() => mockPageCubit.state)
          .thenReturn(const JadwalSholatPageState.initial());

      await tester.pumpWidget(buildTestWidget());

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
      when(() => mockLocationCubit.state).thenReturn(
        const JadwalSholatLocationState.located(
          city: 'Jakarta',
          timezone: 'Asia/Jakarta',
          latitude: -6.2,
          longitude: 106.8,
        ),
      );
      when(() => mockPageCubit.state).thenReturn(
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

      expect(find.text('Subuh'), findsOneWidget);
      expect(find.text('Dzuhur'), findsOneWidget);
      expect(find.text('Ashar'), findsOneWidget);
      expect(find.text('Maghrib'), findsOneWidget);
      expect(find.text('Isya'), findsOneWidget);
      expect(find.text('Jakarta'), findsOneWidget);
      expect(find.text('Asia/Jakarta'), findsOneWidget);
    });

    testWidgets('shows retry button when location error', (tester) async {
      when(() => mockJadwalSholatCubit.state)
          .thenReturn(const JadwalSholatState.initial());
      when(() => mockLocationCubit.state).thenReturn(
        const JadwalSholatLocationState.error(
          message: 'Gagal mendapatkan lokasi. Ketuk untuk coba lagi.',
          retryCount: 1,
        ),
      );
      when(() => mockPageCubit.state)
          .thenReturn(const JadwalSholatPageState.initial());

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
      when(() => mockLocationCubit.state).thenReturn(
        const JadwalSholatLocationState.error(
          message: 'Gagal mendapatkan lokasi. Ketuk untuk coba lagi.',
          retryCount: 1,
        ),
      );
      when(() => mockPageCubit.state)
          .thenReturn(const JadwalSholatPageState.initial());
      when(() => mockLocationCubit.retryInit()).thenReturn(null);

      await tester.pumpWidget(buildTestWidget());

      await tester.tap(find.text('Coba Lagi'));
      await tester.pump();

      verify(() => mockLocationCubit.retryInit()).called(1);
    });
  });
}

/// Test body that mirrors the new page structure using both cubits.
class _TestBody extends StatelessWidget {
  const _TestBody();

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
        child:
            BlocBuilder<JadwalSholatLocationCubit, JadwalSholatLocationState>(
          builder: (context, locationState) {
            return locationState.maybeWhen(
              orElse: () => const _LoadingShimmerView(),
              error: (String message, int retryCount) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<JadwalSholatLocationCubit>().retryInit(),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
              permissionError: (String message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Buka Pengaturan'),
                    ),
                  ],
                ),
              ),
              located: (city, timezone, latitude, longitude) {
                return BlocBuilder<JadwalSholatPageCubit,
                    JadwalSholatPageState>(
                  builder: (context, pageState) {
                    return pageState.maybeWhen(
                      orElse: () => const _LoadingShimmerView(),
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
                );
              },
            );
          },
        ),
      ),
    );
  }
}

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
