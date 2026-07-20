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
import 'package:quran_app/features/jadwal_sholat/presentation/cubits/jadwal_sholat_location_cubit/jadwal_sholat_location_cubit.dart';
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
        BlocProvider<JadwalSholatLocationCubit>(
          create: (_) => JadwalSholatLocationCubit(
            locationService: locator<LocationService>(),
          ),
        ),
        BlocProvider<JadwalSholatPageCubit>(
          create: (_) => JadwalSholatPageCubit(
            storageService: locator<LocalStorageService>(),
            notificationService: locator<NotificationService>(),
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
      context.read<JadwalSholatLocationCubit>().init();
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

  void _onLocationAcquired(
    BuildContext context,
    String city,
    String timezone,
    double latitude,
    double longitude,
  ) {
    context.read<JadwalSholatPageCubit>().setLocationContext(
          city: city,
          timezone: timezone,
        );
    final String date = DateFormat('dd-MM-yyyy').format(DateTime.now());
    context.read<JadwalSholatCubit>().getPosts(
          latitude: latitude,
          longitude: longitude,
          date: date,
        );
  }

  void _onJadwalSholatCubitSuccess(
    final BuildContext context,
    final JadwalSholatEntity data,
  ) {
    context.read<JadwalSholatPageCubit>().onScheduleReceived(data);
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
            // When location cubit acquires position, trigger schedule fetch
            BlocListener<JadwalSholatLocationCubit, JadwalSholatLocationState>(
              listener: (context, state) {
                state.maybeWhen(
                  orElse: () {},
                  located: (city, timezone, latitude, longitude) {
                    _onLocationAcquired(
                      context,
                      city,
                      timezone,
                      latitude,
                      longitude,
                    );
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
          child: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<JadwalSholatLocationCubit, JadwalSholatLocationState>(
      builder: (context, locationState) {
        return locationState.maybeWhen(
          orElse: () => const LoadingSholatView(jadwalList: []),
          error: (message, retryCount) => Center(
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
          permissionError: (message) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(message, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => openAppSettings(),
                  child: const Text('Buka Pengaturan'),
                ),
              ],
            ),
          ),
          located: (city, timezone, latitude, longitude) {
            return BlocBuilder<JadwalSholatPageCubit, JadwalSholatPageState>(
              builder: (context, pageState) {
                return pageState.maybeWhen(
                  orElse: () => const LoadingSholatView(jadwalList: []),
                  loaded: (
                    city,
                    timezone,
                    jadwalList,
                    countdownText,
                    sholatText,
                    timeText,
                    entity,
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
            );
          },
        );
      },
    );
  }
}
