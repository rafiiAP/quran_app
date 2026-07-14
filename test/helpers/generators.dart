import 'dart:math';

import 'package:quran_app/data/model/bookmark_model.dart';
import 'package:quran_app/features/detail_surah/data/models/detail_model.dart';
import 'package:quran_app/features/jadwal_sholat/data/models/jadwal_sholat_model.dart';
import 'package:quran_app/features/surah/data/models/surah_model.dart';

final Random _rng = Random(42); // seed untuk reprodusibilitas

String _randomString([int length = 10]) {
  const chars = 'abcdefghijklmnopqrstuvwxyz';
  return List.generate(length, (_) => chars[_rng.nextInt(chars.length)]).join();
}

int _randomInt({int min = 1, int max = 114}) {
  return min + _rng.nextInt(max - min + 1);
}

Map<String, String> _randomAudioMap() {
  final int n = _rng.nextInt(5) + 1;
  return {
    for (int i = 1; i <= n; i++)
      i.toString().padLeft(2, '0'): 'https://cdn.example.com/$i.mp3',
  };
}

String _randomTimeString() {
  final hour = _rng.nextInt(24);
  final minute = _rng.nextInt(60);
  return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}

SurahModel generateRandomSurahModel() {
  return SurahModel(
    nomor: _randomInt(min: 1, max: 114),
    nama: _randomString(8),
    namaLatin: _randomString(10),
    jumlahAyat: _randomInt(min: 3, max: 286),
    tempatTurun: _rng.nextBool() ? 'Mekah' : 'Madinah',
    arti: _randomString(12),
    deskripsi: _randomString(40),
    audioFull: _randomAudioMap(),
  );
}

AyatDetailModel _generateRandomAyatDetailModel() {
  return AyatDetailModel(
    nomorAyat: _randomInt(min: 1, max: 286),
    teksArab: _randomString(20),
    teksLatin: _randomString(25),
    teksIndonesia: _randomString(30),
    audio: _randomAudioMap(),
  );
}

DetailModel generateRandomDetailModel() {
  final int ayatCount = _randomInt(min: 1, max: 10);
  return DetailModel(
    nomor: _randomInt(min: 1, max: 114),
    nama: _randomString(8),
    namaLatin: _randomString(10),
    jumlahAyat: ayatCount,
    tempatTurun: _rng.nextBool() ? 'Mekah' : 'Madinah',
    arti: _randomString(12),
    deskripsi: _randomString(40),
    audioFull: _randomAudioMap(),
    ayat: List.generate(ayatCount, (_) => _generateRandomAyatDetailModel()),
  );
}

BookmarkModel generateRandomBookmarkModel() {
  return BookmarkModel(
    nomorSurah: _randomInt(min: 1, max: 114),
    namaLatin: _randomString(10),
    nomorAyat: _randomInt(min: 1, max: 286),
    teksArab: _randomString(20),
    teksIndonesia: _randomString(30),
    teksLatin: _randomString(25),
  );
}

List<BookmarkModel> generateRandomBookmarkList(int size) {
  return List.generate(size, (_) => generateRandomBookmarkModel());
}

JadwalSholatModel generateRandomJadwalSholatModel() {
  return JadwalSholatModel(
    fajr: _randomTimeString(),
    sunrise: _randomTimeString(),
    dhuhr: _randomTimeString(),
    asr: _randomTimeString(),
    sunset: _randomTimeString(),
    maghrib: _randomTimeString(),
    isha: _randomTimeString(),
    imsak: _randomTimeString(),
    midnight: _randomTimeString(),
    firstthird: _randomTimeString(),
    lastthird: _randomTimeString(),
  );
}
