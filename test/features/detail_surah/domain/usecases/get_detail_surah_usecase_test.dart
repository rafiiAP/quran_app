import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/core/error/failure.dart';
import 'package:quran_app/features/detail_surah/domain/entities/detail_entity.dart';
import 'package:quran_app/features/detail_surah/domain/usecases/get_detail_surah_usecase.dart';

import '../../../../mocks.dart';

void main() {
  late MockDetailSurahRepository mockRepository;
  late GetDetailSurahUseCase useCase;

  setUp(() {
    mockRepository = MockDetailSurahRepository();
    useCase = GetDetailSurahUseCase(mockRepository);
  });

  const tDetailEntity = DetailEntity(
    nomor: 1,
    nama: 'الفاتحة',
    namaLatin: 'Al-Fatihah',
    jumlahAyat: 7,
    tempatTurun: 'Mekah',
    arti: 'Pembuka',
    deskripsi: 'Surah pertama',
    audioFull: {'01': 'https://cdn.example.com/1.mp3'},
    ayat: [
      AyatDetailEntity(
        nomorAyat: 1,
        teksArab: 'بِسْمِ اللّٰهِ',
        teksLatin: 'Bismillah',
        teksIndonesia: 'Dengan nama Allah',
        audio: {'01': 'https://cdn.example.com/audio/1.mp3'},
      ),
    ],
  );

  group('GetDetailSurahUseCase', () {
    test(
        'delegates to SurahRepository.getDetailSurah with nomor and returns Right on success',
        () async {
      when(() => mockRepository.getDetailSurah(nomor: 1)).thenAnswer(
        (_) async => const Right(tDetailEntity),
      );

      final result = await useCase.call(1);

      expect(result.isRight(), isTrue);
      final entity = result.match((_) => null, (d) => d);
      expect(entity, tDetailEntity);
      verify(() => mockRepository.getDetailSurah(nomor: 1)).called(1);
    });

    test(
        'delegates to SurahRepository.getDetailSurah and returns Left on failure',
        () async {
      when(() => mockRepository.getDetailSurah(nomor: 5)).thenAnswer(
        (_) async => const Left(ServerFailure('Server error')),
      );

      final result = await useCase.call(5);

      expect(result.isLeft(), isTrue);
      final failure = result.match((f) => f, (_) => null);
      expect(failure, isA<ServerFailure>());
      expect(failure!.message, 'Server error');
      verify(() => mockRepository.getDetailSurah(nomor: 5)).called(1);
    });

    test('passes the correct nomor parameter to repository', () async {
      when(() => mockRepository.getDetailSurah(nomor: 114)).thenAnswer(
        (_) async => const Right(tDetailEntity),
      );

      await useCase.call(114);

      verify(() => mockRepository.getDetailSurah(nomor: 114)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
