import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quran_app/core/di/injection.dart';
import 'package:quran_app/core/services/location_service.dart';
import 'package:quran_app/core/services/notification_service.dart';
import 'package:quran_app/core/storage/local_storage_service.dart';
import 'package:quran_app/core/widgets/app_text.dart';
import 'package:quran_app/core/widgets/app_bottomsheet.dart';
import 'package:quran_app/features/jadwal_sholat/domain/entities/jadwal_sholat_entity.dart';
import 'package:quran_app/features/jadwal_sholat/domain/usecases/get_jadwal_sholat_usecase.dart';
import 'package:quran_app/features/jadwal_sholat/presentation/cubits/jadwal_sholat_cubit/jadwal_sholat_cubit.dart';
import 'package:quran_app/features/jadwal_sholat/presentation/cubits/jadwal_sholat_page_cubit/jadwal_sholat_page_cubit.dart';
import 'package:quran_app/features/jadwal_sholat/presentation/pages/view/jadwal_sholat_view.dart';
import 'package:quran_app/features/jadwal_sholat/presentation/pages/view/loading_sholat_view.dart';

/// Top-level widget that provides scoped BlocProviders for jadwal sholat.
/// These providers persist while the tab is active (ShellRoute child)
/// and are disposed when the parent ShellRoute is disposed.
class JadwalSholatPage extends StatelessWidget {
  const JadwalSholatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<JadwalSholatCubit>(
          create: (_) =>
              JadwalSholatCubit(usecase: locator<GetJadwalSholatUseCase>()),
        ),
        BlocProvider<JadwalSholatPageCubit>(
          create: (_) => JadwalSholatPageCubit(
            storageService: locator<LocalStorageService>(),
            notificationService: locator<NotificationService>(),
            locationService: locator<LocationService>(),
          ),
        ),
      ],
      child: const _JadwalSholatView(),
    );
  }
}

class _JadwalSholatView extends StatefulWidget {
  const _JadwalSholatView();

  @override
  State<_JadwalSholatView> createState() => _JadwalSholatViewState();
}

class _JadwalSholatViewState extends State<_JadwalSholatView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      if (!mounted) return;
      final pageCubit = context.read<JadwalSholatPageCubit>();
      final currentState = pageCubit.state;

      currentState.maybeWhen(
        awaitingSchedule: (city, latitude, longitude) {
          _triggerFetch(context, latitude, longitude);
        },
        orElse: () {
          pageCubit.init();
        },
      );

      _handleExactAlarmPermission();
    });
  }

  Future<void> _handleExactAlarmPermission() async {
    if (!Platform.isAndroid) return;
    if (await Permission.scheduleExactAlarm.isDenied) {
      if (!mounted) return;
      await appBottomsheet.messageInfo(
        message:
            'Permission alarm dibutuhkan untuk mengaktifkan pengingat sholat',
      );
      await Permission.scheduleExactAlarm.request();
    }
  }

  void _onJadwalSholatCubitSuccess(
    final BuildContext context,
    final JadwalSholatEntity data,
  ) {
    context.read<JadwalSholatPageCubit>().onScheduleReceived(data);
  }

  void _triggerFetch(
    final BuildContext context,
    double latitude,
    double longitude,
  ) {
    final String date = DateFormat('dd-MM-yyyy').format(DateTime.now());
    context.read<JadwalSholatCubit>().getPosts(
          latitude: latitude,
          longitude: longitude,
          date: date,
        );
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appText.title(text: 'Jadwal Sholat'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: MultiBlocListener(
          listeners: [
            // When page cubit reaches awaitingSchedule, fetch prayer data
            BlocListener<JadwalSholatPageCubit, JadwalSholatPageState>(
              listener: (
                final BuildContext context,
                final JadwalSholatPageState state,
              ) {
                state.maybeWhen(
                  orElse: () {},
                  awaitingSchedule:
                      (final String _, final double lat, final double lng) {
                    _triggerFetch(context, lat, lng);
                  },
                );
              },
            ),
            // When data cubit succeeds, forward to page cubit
            BlocListener<JadwalSholatCubit, JadwalSholatState>(
              listener: (
                final BuildContext context,
                final JadwalSholatState state,
              ) {
                state.maybeWhen(
                  orElse: () {},
                  error: (final String message) {
                    appBottomsheet.messageInfo(message: message);
                  },
                  success: (final JadwalSholatEntity data) {
                    _onJadwalSholatCubitSuccess(context, data);
                  },
                );
              },
            ),
          ],
          child: BlocConsumer<JadwalSholatPageCubit, JadwalSholatPageState>(
            listener: (
              final BuildContext context,
              final JadwalSholatPageState state,
            ) {},
            builder: (
              final BuildContext context,
              final JadwalSholatPageState state,
            ) {
              return state.maybeWhen(
                orElse: () => const LoadingSholatView(jadwalList: []),
                initial: () => const LoadingSholatView(jadwalList: []),
                loading: () => const LoadingSholatView(jadwalList: []),
                awaitingSchedule:
                    (final String _, final double __, final double ___) =>
                        const LoadingSholatView(jadwalList: []),
                locationError: (final String message, final int retryCount) {
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
                locationPermissionError: (final String message) {
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
                          onPressed: () => openAppSettings(),
                          child: const Text('Buka Pengaturan'),
                        ),
                      ],
                    ),
                  );
                },
                loaded: (
                  final String city,
                  final String timezone,
                  final jadwalList,
                  final String countdownText,
                  final String sholatText,
                  final String timeText,
                  final JadwalSholatEntity entity,
                ) {
                  return JadwalSholatView(
                    city: city,
                    timezone: timezone,
                    countdownText: countdownText,
                    sholatText: sholatText,
                    timeText: timeText,
                    jadwalList: jadwalList,
                    data: entity,
                    onToggleNotif: (final int index, final model) async {
                      await context
                          .read<JadwalSholatPageCubit>()
                          .toggleNotification(index, model);
                      if (context.mounted) {
                        final message = model.isAlarmSet
                            ? 'Alarm ${model.title} dinonaktifkan'
                            : 'Alarm ${model.title} berhasil diaktifkan';
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(message)),
                        );
                      }
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
