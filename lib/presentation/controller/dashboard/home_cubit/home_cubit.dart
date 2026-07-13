import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quran_app/data/datasources/local_storage_service.dart';
import 'package:quran_app/domain/entity/surah_entity.dart';

part 'home_state.dart';
part 'home_cubit.freezed.dart';

class HomeCubit extends Cubit<HomeState> {
  final LocalStorageService storageService;

  HomeCubit({required this.storageService}) : super(const HomeState.initial()) {
    _loadLastRead();
  }

  void _loadLastRead() {
    final String namaLatin = storageService.getString(key: 'cacheNamaLatin');
    final int nomorSurah = storageService.getInt(key: 'cacheNomorSurah');
    final int nomorAyat = storageService.getInt(key: 'cacheNomorAyat');

    emit(HomeState.loaded(
      namaLatin: namaLatin,
      nomorSurah: nomorSurah,
      nomorAyat: nomorAyat,
      surahList: const [],
    ));
  }

  void setSurahList(final List<SurahEntity> data) {
    state.maybeWhen(
      loaded: (final String namaLatin, final int nomorSurah,
          final int nomorAyat, final _) {
        emit(HomeState.loaded(
          namaLatin: namaLatin,
          nomorSurah: nomorSurah,
          nomorAyat: nomorAyat,
          surahList: data,
        ));
      },
      orElse: () {
        emit(HomeState.loaded(
          namaLatin: '',
          nomorSurah: 0,
          nomorAyat: 0,
          surahList: data,
        ));
      },
    );
  }

  void refreshLastRead() => _loadLastRead();

  void toLastRead() {
    state.maybeWhen(
      loaded: (final _, final int nomorSurah, final int nomorAyat, final __) {
        if (nomorSurah != 0) {
          emit(HomeState.navigateToDetail(
            nomorSurah: nomorSurah,
            indexTandai: nomorAyat,
          ));
          _loadLastRead();
        } else {
          emit(const HomeState.showMessage('Belum ada bacaan terakhir'));
          _loadLastRead();
        }
      },
      orElse: () {},
    );
  }

  void getDetailSurah(final SurahEntity data) {
    emit(HomeState.navigateToDetail(
      nomorSurah: data.nomor,
      indexTandai: null,
    ));
    _loadLastRead();
  }
}
