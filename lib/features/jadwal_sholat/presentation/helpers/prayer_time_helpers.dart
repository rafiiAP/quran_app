import 'package:flutter/widgets.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:quran_app/data/model/set_notif_model.dart';
import 'package:quran_app/features/jadwal_sholat/domain/entities/jadwal_sholat_entity.dart';

/// Pure helper functions for prayer time calculations.
///
/// Extracted from [JadwalSholatPageCubit] for SRP compliance.
/// All functions are static and fully testable without cubit instance.
class PrayerTimeHelpers {
  const PrayerTimeHelpers._();

  /// Parses [JadwalSholatEntity] into a list of [SetNotifModel].
  /// Uses [int.tryParse] for defensive parsing of time strings.
  static List<SetNotifModel> parseJadwal(final JadwalSholatEntity data) {
    return <SetNotifModel>[
      _buildNotifModel(Iconsax.moon, data.fajr, 'Subuh'),
      _buildNotifModel(Iconsax.sun, data.dhuhr, 'Dzuhur'),
      _buildNotifModel(Iconsax.sun_1, data.asr, 'Ashar'),
      _buildNotifModel(Iconsax.sun_fog, data.maghrib, 'Maghrib'),
      _buildNotifModel(Iconsax.moon, data.isha, 'Isya'),
    ];
  }

  /// Safely parses a time string "HH:mm" into a [SetNotifModel].
  /// Falls back to 0 if parsing fails.
  static SetNotifModel _buildNotifModel(
    final IconData icon,
    final String timeStr,
    final String title,
  ) {
    final parts = timeStr.split(':');
    final hour = parts.isNotEmpty ? (int.tryParse(parts[0]) ?? 0) : 0;
    final minute = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
    return SetNotifModel(
      iconsax: icon,
      hour: hour,
      minute: minute,
      title: title,
      body: 'Waktunya sholat $title',
      isAlarmSet: false,
    );
  }

  /// Calculates countdown text to next prayer.
  static String calculateCountdown(
    final List<SetNotifModel> jadwalList,
    final DateTime now,
  ) {
    for (final SetNotifModel entry in jadwalList) {
      final DateTime waktuSholat = DateTime(
        now.year,
        now.month,
        now.day,
        entry.hour,
        entry.minute,
      );
      if (now.isBefore(waktuSholat)) {
        final Duration remaining = waktuSholat.difference(now);
        return '${entry.title} dalam\n${formatDuration(remaining)}';
      }
    }

    if (jadwalList.isNotEmpty) {
      final DateTime waktuSubuhBesok = DateTime(
        now.year,
        now.month,
        now.day + 1,
        jadwalList.first.hour,
        jadwalList.first.minute,
      );
      final Duration remaining = waktuSubuhBesok.difference(now);
      return 'Subuh dalam\n${formatDuration(remaining)}';
    }

    return '-';
  }

  /// Returns the label of the next upcoming prayer.
  static String getSholatText(
    final List<SetNotifModel> jadwalList,
    final DateTime now,
  ) {
    for (final SetNotifModel entry in jadwalList) {
      final DateTime waktuSholat = DateTime(
        now.year,
        now.month,
        now.day,
        entry.hour,
        entry.minute,
      );
      if (now.isBefore(waktuSholat)) {
        return 'Mendekati waktu ${entry.title}';
      }
    }
    return 'Subuh Besok';
  }

  /// Returns the time string (HH:mm) of the next upcoming prayer.
  static String getTimeText(
    final List<SetNotifModel> jadwalList,
    final DateTime now,
  ) {
    if (jadwalList.isEmpty) return '-';

    for (final SetNotifModel entry in jadwalList) {
      final DateTime waktuSholat = DateTime(
        now.year,
        now.month,
        now.day,
        entry.hour,
        entry.minute,
      );
      if (now.isBefore(waktuSholat)) {
        return '${entry.hour.toString().padLeft(2, '0')}:'
            '${entry.minute.toString().padLeft(2, '0')}';
      }
    }

    // Fallback to first (Subuh tomorrow)
    final SetNotifModel first = jadwalList.first;
    return '${first.hour.toString().padLeft(2, '0')}:'
        '${first.minute.toString().padLeft(2, '0')}';
  }

  /// Formats a [Duration] as "HH:mm:ss".
  static String formatDuration(final Duration duration) {
    String twoDigits(final int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(duration.inHours)}:'
        '${twoDigits(duration.inMinutes.remainder(60))}:'
        '${twoDigits(duration.inSeconds.remainder(60))}';
  }
}
