// ignore_for_file: invalid_use_of_protected_member

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/features/bookmark/domain/entities/bookmark_entity.dart';
import 'package:quran_app/features/bookmark/presentation/cubits/bookmark_cubit/bookmark_cubit.dart';

import '../../mocks.dart';

BookmarkEntity _generateRandomBookmarkEntity(Random rng, int i) {
  const chars = 'abcdefghijklmnopqrstuvwxyz';
  String randomString([int length = 10]) {
    return List.generate(length, (_) => chars[rng.nextInt(chars.length)])
        .join();
  }

  return BookmarkEntity(
    id: i + 1,
    nomorSurah: (i % 114) + 1,
    namaLatin: randomString(10),
    nomorAyat: (i % 286) + 1,
    teksArab: randomString(20),
    teksIndonesia: randomString(30),
    teksLatin: randomString(25),
  );
}

List<BookmarkEntity> _generateRandomBookmarkEntityList(Random rng, int size) {
  return List.generate(size, (i) => _generateRandomBookmarkEntity(rng, i));
}

void main() {
  late MockGetBookmarksUseCase mockGetBookmarksUseCase;
  late MockDeleteBookmarkUseCase mockDeleteBookmarkUseCase;

  setUp(() {
    mockGetBookmarksUseCase = MockGetBookmarksUseCase();
    mockDeleteBookmarkUseCase = MockDeleteBookmarkUseCase();
  });

  group('Property Tests — BookmarkCubit', () {
    // **Validates: Requirements 5.3**
    test(
        'Property 7: BookmarkCubit Delete Reduces List — deleting an item '
        'reduces list length by 1 and removes target item', () async {
      final rng = Random(42);

      for (int i = 0; i < 100; i++) {
        final int n = rng.nextInt(10) + 1;
        final List<BookmarkEntity> initialList =
            _generateRandomBookmarkEntityList(rng, n);

        final int targetIndex = rng.nextInt(n);
        final BookmarkEntity targetItem = initialList[targetIndex];

        final List<BookmarkEntity> listAfterDeletion =
            List<BookmarkEntity>.from(
          initialList.where(
            (b) => b.id != targetItem.id,
          ),
        );

        int getAllCallCount = 0;
        when(() => mockGetBookmarksUseCase()).thenAnswer((_) async {
          getAllCallCount++;
          if (getAllCallCount == 1) return Right(initialList);
          return Right(listAfterDeletion);
        });
        when(
          () => mockDeleteBookmarkUseCase(
            any(),
          ),
        ).thenAnswer((_) async => const Right(null));

        final cubit = BookmarkCubit(
          getBookmarksUseCase: mockGetBookmarksUseCase,
          deleteBookmarkUseCase: mockDeleteBookmarkUseCase,
        );
        // Explicitly load bookmarks (no longer auto-loads in constructor)
        await cubit.loadBookmarks();
        await Future<void>.delayed(Duration.zero);

        await cubit.deleteBookmark(targetItem);
        // Wait for async loadBookmarks() to complete
        await Future<void>.delayed(Duration.zero);

        final state = cubit.state;
        state.maybeWhen(
          loaded: (bookmarks) {
            expect(
              bookmarks.length,
              equals(listAfterDeletion.length),
              reason: 'After deleting 1 item from a list of $n, '
                  'loaded state must have ${listAfterDeletion.length} items',
            );
          },
          orElse: () => fail('Expected BookmarkState.loaded but got $state'),
        );

        verify(
          () => mockDeleteBookmarkUseCase(
            targetItem.id!,
          ),
        ).called(1);

        await cubit.close();
        reset(mockGetBookmarksUseCase);
        reset(mockDeleteBookmarkUseCase);
      }
    });

    // **Validates: Requirements 5.4**
    test(
        'Property 8: BookmarkCubit Copy Format Completeness — '
        'formatCopyText() output must contain namaLatin, nomorSurah, '
        'teksArab, teksIndonesia', () async {
      when(() => mockGetBookmarksUseCase())
          .thenAnswer((_) async => const Right(<BookmarkEntity>[]));

      final cubit = BookmarkCubit(
        getBookmarksUseCase: mockGetBookmarksUseCase,
        deleteBookmarkUseCase: mockDeleteBookmarkUseCase,
      );

      final rng = Random(42);
      for (int i = 0; i < 100; i++) {
        final BookmarkEntity bookmark = _generateRandomBookmarkEntity(rng, i);

        final String result = cubit.formatCopyText(bookmark);

        expect(
          result.contains(bookmark.namaLatin),
          isTrue,
          reason: 'formatCopyText output must contain namaLatin '
              '"${bookmark.namaLatin}"',
        );
        expect(
          result.contains(bookmark.nomorSurah.toString()),
          isTrue,
          reason: 'formatCopyText output must contain nomorSurah '
              '"${bookmark.nomorSurah}"',
        );
        expect(
          result.contains(bookmark.teksArab),
          isTrue,
          reason: 'formatCopyText output must contain teksArab '
              '"${bookmark.teksArab}"',
        );
        expect(
          result.contains(bookmark.teksIndonesia),
          isTrue,
          reason: 'formatCopyText output must contain teksIndonesia '
              '"${bookmark.teksIndonesia}"',
        );
      }

      await cubit.close();
    });
  });
}
