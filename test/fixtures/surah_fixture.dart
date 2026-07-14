import 'package:quran_app/features/surah/data/models/surah_model.dart';
import 'package:quran_app/features/surah/domain/entities/surah_entity.dart';

const Map<String, dynamic> kSurahMap = {
  'nomor': 1,
  'nama': 'سُورَةُ الْفَاتِحَةِ',
  'namaLatin': 'Al-Fatihah',
  'jumlahAyat': 7,
  'tempatTurun': 'Mekah',
  'arti': 'Pembuka',
  'deskripsi': 'Surah pembuka Al-Quran',
  'audioFull': {
    '01': 'https://cdn.islamic.network/quran/audio/1/ar.alafasy/1.mp3',
  },
};

const SurahModel kSurahModel = SurahModel(
  nomor: 1,
  nama: 'سُورَةُ الْفَاتِحَةِ',
  namaLatin: 'Al-Fatihah',
  jumlahAyat: 7,
  tempatTurun: 'Mekah',
  arti: 'Pembuka',
  deskripsi: 'Surah pembuka Al-Quran',
  audioFull: {
    '01': 'https://cdn.islamic.network/quran/audio/1/ar.alafasy/1.mp3',
  },
);

const SurahEntity kSurahEntity = SurahEntity(
  nomor: 1,
  nama: 'سُورَةُ الْفَاتِحَةِ',
  namaLatin: 'Al-Fatihah',
  jumlahAyat: 7,
  tempatTurun: 'Mekah',
  arti: 'Pembuka',
  deskripsi: 'Surah pembuka Al-Quran',
  audioFull: {
    '01': 'https://cdn.islamic.network/quran/audio/1/ar.alafasy/1.mp3',
  },
);
