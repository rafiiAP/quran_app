import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quran_app/core/constants/config.dart';
import 'package:quran_app/core/storage/local_storage_service.dart';
import 'package:quran_app/core/services/notification_service.dart';
import 'package:quran_app/features/jadwal_sholat/presentation/models/set_notif_model.dart';
import 'package:quran_app/features/jadwal_sholat/domain/entities/jadwal_sholat_entity.dart';
import 'package:quran_app/features/jadwal_sholat/presentation/helpers/prayer_time_helpers.dart';

part 'jadwal_sholat_page_state.dart';
part 'jadwal_sholat_page_cubit.freezed.dart';

/// Cubit responsible for prayer schedule presentation: countdown timer,
/// notification toggling, and schedule display.
///
/// Location logic is handled by [JadwalSholatLocationCubit].
/// This cubit receives schedule data via [onScheduleReceived] and
/// location context via [setLocationContext].
class JadwalSholatPageCubit extends Cubit<JadwalSholatPageState> {
  JadwalSholatPageCubit({
    required this.storageService,
    required this.notificationService,
  }) : super(const JadwalSholatPageState.initial());

  final LocalStorageService storageService;
  final NotificationService notificationService;
  Timer? _countdownTimer;
  String _city = '';
  String _timezone = '';
  JadwalSholatEntity? _cachedEntity;

  /// Sets location context from [JadwalSholatLocationCubit].
  void setLocationContext({
    required String city,
    required String timezone,
  }) {
    _city = city;
    _timezone = timezone;
  }

  /// Called when [JadwalSholatCubit] emits a success state with new data.
  void onScheduleReceived(final JadwalSholatEntity data) {
    _cachedEntity = data;
    final List<SetNotifModel> jadwalList = PrayerTimeHelpers.parseJadwal(data);
    _applyAlarmStatusAndEmit(jadwalList);
  }

  /// Toggles notification for a prayer entry at [index].
  Future<void> toggleNotification(
    final int index,
    final SetNotifModel model,
  ) async {
    if (model.isAlarmSet) {
      await notificationService.cancelNotification(index);
      await storageService.setBool(
        key: config.alarmKey(model.title),
        value: false,
      );
    } else {
      await notificationService.scheduleNotification(
        index,
        model.hour,
        model.minute,
        title: model.title,
        body: model.body,
      );
      await storageService.setBool(
        key: config.alarmKey(model.title),
        value: true,
      );
    }

    state.maybeWhen(
      loaded: (
        final String _,
        final String __,
        final List<SetNotifModel> jadwalList,
        final String ___,
        final String ____,
        final String _____,
        final JadwalSholatEntity ______,
      ) =>
          _applyAlarmStatusAndEmit(jadwalList),
      orElse: () {},
    );
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  void _applyAlarmStatusAndEmit(final List<SetNotifModel> jadwalList) {
    final List<SetNotifModel> updatedList = jadwalList.map(
      (final SetNotifModel item) {
        final bool isAlarmSet = storageService.getBool(
          key: config.alarmKey(item.title),
          defaultValue: false,
        );
        return item.copyWith(isAlarmSet: isAlarmSet);
      },
    ).toList();

    final DateTime now = DateTime.now();

    emit(
      JadwalSholatPageState.loaded(
        city: _city,
        timezone: _timezone,
        jadwalList: updatedList,
        countdownText: PrayerTimeHelpers.calculateCountdown(updatedList, now),
        sholatText: PrayerTimeHelpers.getSholatText(updatedList, now),
        timeText: PrayerTimeHelpers.getTimeText(updatedList, now),
        entity: _cachedEntity ?? _emptyEntity,
      ),
    );

    _startCountdownTimer(updatedList);
  }

  void _startCountdownTimer(final List<SetNotifModel> jadwalList) {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (final Timer _) {
        final DateTime now = DateTime.now();
        emit(
          JadwalSholatPageState.loaded(
            city: _city,
            timezone: _timezone,
            jadwalList: jadwalList,
            countdownText:
                PrayerTimeHelpers.calculateCountdown(jadwalList, now),
            sholatText: PrayerTimeHelpers.getSholatText(jadwalList, now),
            timeText: PrayerTimeHelpers.getTimeText(jadwalList, now),
            entity: _cachedEntity ?? _emptyEntity,
          ),
        );
      },
    );
  }

  static const _emptyEntity = JadwalSholatEntity(
    fajr: '-',
    sunrise: '-',
    dhuhr: '-',
    asr: '-',
    sunset: '-',
    maghrib: '-',
    isha: '-',
    imsak: '-',
    midnight: '-',
    firstthird: '-',
    lastthird: '-',
  );

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    return super.close();
  }
}
