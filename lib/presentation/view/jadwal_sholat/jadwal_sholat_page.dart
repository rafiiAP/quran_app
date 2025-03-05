import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quran_app/components/widgets/main_widget.dart';
import 'package:quran_app/presentation/controller/jadwal_sholat/bloc/jadwal_sholat_bloc.dart';
import 'package:quran_app/presentation/controller/jadwal_sholat/jadwal_sholat_getx.dart';
import 'package:quran_app/presentation/view/jadwal_sholat/view/jadwal_sholat_view.dart';
import 'package:quran_app/presentation/view/jadwal_sholat/view/loading_sholat_view.dart';

class JadwalSholatPage extends StatelessWidget {
  const JadwalSholatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(JadwalSholatGetx());
    c.getLoacationName();
    // C.showLog(log: '--${c.timezone.value}');

    return Scaffold(
      appBar: AppBar(
        title: W.title(text: 'Jadwal Sholat'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          W.messageInfo(message: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
        },
        child: const Icon(Icons.refresh),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<JadwalSholatBloc, JadwalSholatState>(
          builder: (context, state) {
            return state.maybeWhen(
              orElse: () {
                return const LoadingSholatView();
              },
              loading: () {
                return const LoadingSholatView();
              },
              error: (message) => W.messageInfo(message: message),
              success: (data) {
                c.startTimer(data);
                // c.updateCountdown(data);
                c.updateSholat(data);
                return JadwalSholatView(
                  data: data,
                  c: c,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
