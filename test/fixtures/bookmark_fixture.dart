import 'package:quran_app/data/model/bookmark_model.dart';

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
