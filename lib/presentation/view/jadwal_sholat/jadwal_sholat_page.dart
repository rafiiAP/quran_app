import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_app/components/widgets/main_widget.dart';
import 'package:quran_app/presentation/controller/jadwal_sholat/jadwal_sholat_getx.dart';

class JadwalSholatPage extends StatelessWidget {
  JadwalSholatPage({super.key});

  final c = Get.put(JadwalSholatGetx());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: W.title(text: 'Jadwal Sholat'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
    );
  }
}
