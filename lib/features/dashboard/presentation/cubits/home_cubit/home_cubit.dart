import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quran_app/core/constants/config.dart';
import 'package:quran_app/core/storage/local_storage_service.dart';
import 'package:quran_app/features/surah/domain/entities/surah_entity.dart';

part 'home_state.dart';
part 'home_cubit.freezed.dart';

class HomeCubit extends Cubit<HomeState> {
  final LocalStorageService storageService;

  HomeCubit({required this.storageService}) : super(const HomeState.initial()) {
    _loadLastRead();
  }

  void _loadLastRead() {
    final String namaLatin =
        storageService.getString(key: config.cacheNamaLatin);
    final int nomorSurah = storageService.getInt(key: config.cacheNomorSurah);
    final int nomorAyat = storageService.getInt(key: config.cacheNomorAyat);

    emit(
      HomeState.loaded(
        namaLatin: namaLatin,
        nomorSurah: nomorSurah,
        nomorAyat: nomorAyat,
        surahList: const [],
      ),
    );
  }

  void setSurahList(final List<SurahEntity> data) {
    state.maybeWhen(
      loaded: (
        final String namaLatin,
        final int nomorSurah,
        final int nomorAyat,
        final _,
      ) {
        emit(
          HomeState.loaded(
            namaLatin: namaLatin,
            nomorSurah: nomorSurah,
            nomorAyat: nomorAyat,
            surahList: data,
          ),
        );
      },
      orElse: () {
        emit(
          HomeState.loaded(
            namaLatin: '',
            nomorSurah: 0,
            nomorAyat: 0,
            surahList: data,
          ),
        );
      },
    );
  }

  void refreshLastRead() => _loadLastRead();

  void toLastRead() {
    state.maybeWhen(
      loaded: (final _, final int nomorSurah, final int nomorAyat, final __) {
        if (nomorSurah != 0) {
          emit(
            HomeState.navigateToDetail(
              nomorSurah: nomorSurah,
              indexTandai: nomorAyat,
            ),
          );
          // NOTE: _loadLastRead() is intentionally NOT called here.
          // The caller (HomePage listener) awaits navigation via .then()
          // and calls refreshLastRead() explicitly after returning.
        } else {
          emit(const HomeState.showMessage('Belum ada bacaan terakhir'));
          _loadLastRead();
        }
      },
      orElse: () {},
    );
  }

  void getDetailSurah(final SurahEntity data) {
    emit(
      HomeState.navigateToDetail(
        nomorSurah: data.nomor,
        indexTandai: null,
      ),
    );
    // NOTE: _loadLastRead() is intentionally NOT called here.
    // The caller (HomePage listener) awaits navigation via .then()
    // and calls refreshLastRead() explicitly after returning.
  }
}
