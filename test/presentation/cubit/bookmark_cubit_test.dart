import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/features/bookmark/domain/entities/bookmark_entity.dart';
import 'package:quran_app/features/bookmark/presentation/cubits/bookmark_cubit/bookmark_cubit.dart';

import '../../mocks.dart';
import '../../fixtures/bookmark_fixture.dart';

void main() {
  late MockBookmarkRepository mockBookmarkRepository;

  setUp(() {
    mockBookmarkRepository = MockBookmarkRepository();
    // Default: constructor's loadBookmarks() returns kBookmarkEntity
    when(() => mockBookmarkRepository.getAllBookmarks())
        .thenAnswer((_) async => const Right([kBookmarkEntity]));
  });

  // Requirements: 5.1 — BookmarkCubit loads bookmarks on construction and exposes them
  group('loadBookmarks', () {
    blocTest<BookmarkCubit, BookmarkState>(
      'emits [loading, loaded] with bookmarks from database',
      setUp: () {
        when(() => mockBookmarkRepository.getAllBookmarks())
            .thenAnswer((_) async => const Right([kBookmarkEntity]));
      },
      build: () => BookmarkCubit(bookmarkRepository: mockBookmarkRepository),
      act: (cubit) => cubit.loadBookmarks(),
      skip: 2,
      verify: (cubit) {
        cubit.state.maybeWhen(
          loaded: (bookmarks) {
            expect(bookmarks.length, 1);
            expect(bookmarks.first, kBookmarkEntity);
          },
          orElse: () => fail('Expected loaded state'),
        );
      },
    );

    blocTest<BookmarkCubit, BookmarkState>(
      'emits [loading, loaded([])] when database returns empty list',
      setUp: () {
        int callCount = 0;
        when(() => mockBookmarkRepository.getAllBookmarks())
            .thenAnswer((_) async {
          callCount++;
          if (callCount <= 1) return const Right([kBookmarkEntity]);
          return const Right(<BookmarkEntity>[]);
        });
      },
      build: () => BookmarkCubit(bookmarkRepository: mockBookmarkRepository),
      act: (cubit) => cubit.loadBookmarks(),
      skip: 2,
      verify: (cubit) {
        cubit.state.maybeWhen(
          loaded: (bookmarks) => expect(bookmarks.length, 0),
          orElse: () => fail('Expected loaded state'),
        );
      },
    );

    test('constructor automatically calls loadBookmarks and emits loaded state',
        () async {
      when(() => mockBookmarkRepository.getAllBookmarks())
          .thenAnswer((_) async => const Right([kBookmarkEntity]));

      final cubit = BookmarkCubit(bookmarkRepository: mockBookmarkRepository);
      await Future<void>.delayed(Duration.zero);

      cubit.state.maybeWhen(
        loaded: (bookmarks) {
          expect(bookmarks.length, 1);
          expect(bookmarks.first, kBookmarkEntity);
        },
        orElse: () => fail('Expected loaded state'),
      );

      await cubit.close();
    });
  });

  // Requirements: 5.2 — deleteBookmark removes the item and reloads the list
  group('deleteBookmark', () {
    blocTest<BookmarkCubit, BookmarkState>(
      'calls repo.deleteBookmark then reloads — final state is loaded without deleted item',
      setUp: () {
        when(
          () => mockBookmarkRepository.deleteBookmark(
            kBookmarkEntity.teksIndonesia,
          ),
        ).thenAnswer((_) async => const Right(null));
        int callCount = 0;
        when(() => mockBookmarkRepository.getAllBookmarks())
            .thenAnswer((_) async {
          callCount++;
          if (callCount <= 1) return const Right([kBookmarkEntity]);
          return const Right(<BookmarkEntity>[]);
        });
      },
      build: () => BookmarkCubit(bookmarkRepository: mockBookmarkRepository),
      act: (cubit) => cubit.deleteBookmark(kBookmarkEntity),
      skip: 2,
      verify: (cubit) {
        cubit.state.maybeWhen(
          loaded: (bookmarks) => expect(bookmarks.length, 0),
          orElse: () => fail('Expected loaded state'),
        );
        verify(
          () => mockBookmarkRepository.deleteBookmark(
            kBookmarkEntity.teksIndonesia,
          ),
        ).called(1);
      },
    );
  });

  // Requirements: 5.3 — formatCopyText returns correct format string
  group('formatCopyText', () {
    test(
        'returns "namaLatin : nomorSurah\\nteksArab\\nteksIndonesia" for kBookmarkEntity',
        () {
      final cubit = BookmarkCubit(bookmarkRepository: mockBookmarkRepository);

      final result = cubit.formatCopyText(kBookmarkEntity);

      final expected =
          '${kBookmarkEntity.namaLatin} : ${kBookmarkEntity.nomorSurah}\n'
          '${kBookmarkEntity.teksArab}\n'
          '${kBookmarkEntity.teksIndonesia}';
      expect(result, expected);
    });

    test('format string has exactly two newlines separating three parts', () {
      final cubit = BookmarkCubit(bookmarkRepository: mockBookmarkRepository);

      final result = cubit.formatCopyText(kBookmarkEntity);
      final parts = result.split('\n');

      expect(parts.length, 3);
      expect(
        parts[0],
        '${kBookmarkEntity.namaLatin} : ${kBookmarkEntity.nomorSurah}',
      );
      expect(parts[1], kBookmarkEntity.teksArab);
      expect(parts[2], kBookmarkEntity.teksIndonesia);
    });
  });

  // Requirements: 5.4 — navigateToDetail emits navigation state then reloads
  group('navigateToDetail', () {
    blocTest<BookmarkCubit, BookmarkState>(
      'emits [navigateToDetail, loading, loaded] after constructor states',
      setUp: () {
        when(() => mockBookmarkRepository.getAllBookmarks())
            .thenAnswer((_) async => const Right([kBookmarkEntity]));
      },
      build: () => BookmarkCubit(bookmarkRepository: mockBookmarkRepository),
      act: (cubit) => cubit.navigateToDetail(kBookmarkEntity),
      expect: () => [
        BookmarkState.navigateToDetail(
          nomorSurah: kBookmarkEntity.nomorSurah,
          nomorAyat: kBookmarkEntity.nomorAyat,
        ),
        const BookmarkState.loading(),
        isA<BookmarkState>(),
      ],
      verify: (cubit) {
        cubit.state.maybeWhen(
          loaded: (bookmarks) {
            expect(bookmarks.length, 1);
            expect(bookmarks.first, kBookmarkEntity);
          },
          orElse: () => fail('Expected loaded state'),
        );
      },
    );
  });
}
