import 'package:quran_app/features/bookmark/data/models/bookmark_model.dart';
import 'package:quran_app/features/bookmark/domain/entities/bookmark_entity.dart';

const Map<String, dynamic> kBookmarkMap = {
  'id': null,
  'nomor_surah': 1,
  'nama_latin': 'Al-Fatihah',
  'nomor_ayat': 1,
  'teks_arab': 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
  'teks_indonesia': 'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang',
  'teks_latin': 'Bismillāhir-raḥmānir-raḥīm(i).',
};

final BookmarkModel kBookmarkModel = BookmarkModel.fromMap(kBookmarkMap);

const BookmarkEntity kBookmarkEntity = BookmarkEntity(
  nomorSurah: 1,
  namaLatin: 'Al-Fatihah',
  nomorAyat: 1,
  teksArab: 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
  teksIndonesia: 'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang',
  teksLatin: 'Bismillāhir-raḥmānir-raḥīm(i).',
);
