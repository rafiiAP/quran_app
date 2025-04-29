import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quran_app/components/widgets/main_widget.dart';

import 'package:quran_app/presentation/controller/jadwal_sholat/jadwal_sholat_cubit/jadwal_sholat_cubit.dart';
import 'package:quran_app/presentation/controller/jadwal_sholat/jadwal_sholat_getx.dart';
import 'package:quran_app/presentation/view/jadwal_sholat/view/jadwal_sholat_view.dart';
import 'package:quran_app/presentation/view/jadwal_sholat/view/loading_sholat_view.dart';

class JadwalSholatPage extends StatelessWidget {
  const JadwalSholatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(JadwalSholatGetx());
    c.jadwalSholat();

    // LocalNotificationService.scheduleNotification(1, 13, 43, body: 'tes', title: 'tes');
    // LocalNotificationService.checkScheduledNotifications();

    return Scaffold(
      appBar: AppBar(
        title: W.title(text: 'Jadwal Sholat'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        //using cubit
        child: BlocConsumer<JadwalSholatCubit, JadwalSholatState>(
          listener: (context, state) {
            state.maybeMap(
              orElse: () {},
              error: (message) => W.messageInfo(message: message.message),
              success: (value) {
                c.onSuccess(value.data);
              },
            );
          },
          builder: (context, state) {
            return BlocBuilder<JadwalSholatCubit, JadwalSholatState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () {
                    return const LoadingSholatView();
                  },
                  loading: () {
                    return const LoadingSholatView();
                  },
                  success: (data) {
                    return JadwalSholatView(
                      data: data,
                      c: c,
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
