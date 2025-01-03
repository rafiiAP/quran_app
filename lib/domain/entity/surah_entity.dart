import 'package:equatable/equatable.dart';

class SurahEntity extends Equatable {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  final Map<String, String> audioFull;

  const SurahEntity({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.audioFull,
  });

  @override
  List<Object?> get props => [nomor, nama, namaLatin, jumlahAyat, tempatTurun, arti, deskripsi, audioFull];
}
