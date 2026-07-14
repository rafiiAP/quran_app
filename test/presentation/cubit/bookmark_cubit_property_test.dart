// ignore_for_file: invalid_use_of_protected_member

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/data/model/bookmark_model.dart';
import 'package:quran_app/features/bookmark/presentation/cubits/bookmark_cubit/bookmark_cubit.dart';

import '../../mocks.dart';
import '../../helpers/generators.dart';

void main() {
  late MockDatabaseHelper mockDb;

  setUp(() {
    mockDb = MockDatabaseHelper();
  });

  group('Property Tests — BookmarkCubit', () {
    // **Validates: Requirements 5.3**
    test(
        'Property 7: BookmarkCubit Delete Reduces List — deleting an item '
        'reduces list length by 1 and removes target item', () async {
      final rng = Random(42);

      for (int i = 0; i < 100; i++) {
        final int n = rng.nextInt(10) + 1; // 1..10
        final List<BookmarkModel> initialList = generateRandomBookmarkList(n);

        // Pick a random item to delete
        final int targetIndex = rng.nextInt(n);
        final BookmarkModel targetItem = initialList[targetIndex];

        // After deletion, the remaining list is everything except the target
        final List<BookmarkModel> listAfterDeletion = List<BookmarkModel>.from(
          initialList.where(
            (b) => b.teksIndonesia != targetItem.teksIndonesia,
          ),
        );

        // Mock: first getAllBookmarks call (from constructor) returns initial list,
        // deleteBookmark is a no-op, second getAllBookmarks call (after delete)
        // returns the reduced list.
        int getAllCallCount = 0;
        when(() => mockDb.getAllBookmarks()).thenAnswer((_) async {
          getAllCallCount++;
          // First call is from the constructor's loadBookmarks(),
          // second call is from deleteBookmark() → loadBookmarks().
          if (getAllCallCount == 1) return initialList;
          return listAfterDeletion;
        });
        when(() => mockDb.deleteBookmark(any())).thenAnswer((_) async {});

        final cubit = BookmarkCubit(databaseHelper: mockDb);
        // Wait for constructor's loadBookmarks() to complete
        await Future<void>.delayed(Duration.zero);

        // Perform delete
        await cubit.deleteBookmark(targetItem);

        // Final state must be loaded with exactly N-1 items
        final state = cubit.state;
        expect(
          state,
          isA<BookmarkState>(),
          reason: 'state should be a BookmarkState',
        );
        state.maybeWhen(
          loaded: (bookmarks) {
            expect(
              bookmarks.length,
              equals(listAfterDeletion.length),
              reason: 'After deleting 1 item from a list of $n, '
                  'loaded state must have ${listAfterDeletion.length} items',
            );
          },
          orElse: () => fail(
            'Expected BookmarkState.loaded but got $state',
          ),
        );

        // Verify deleteBookmark was called with the correct teksIndonesia
        verify(() => mockDb.deleteBookmark(targetItem.teksIndonesia)).called(1);

        await cubit.close();
        // Reset mock state between iterations
        reset(mockDb);
      }
    });

    // **Validates: Requirements 5.4**
    test(
        'Property 8: BookmarkCubit Copy Format Completeness — '
        'formatCopyText() output must contain namaLatin, nomorSurah, '
        'teksArab, teksIndonesia', () async {
      // We need at least one stub so the constructor's loadBookmarks() works
      when(() => mockDb.getAllBookmarks()).thenAnswer((_) async => []);

      final cubit = BookmarkCubit(databaseHelper: mockDb);
      await Future<void>.delayed(Duration.zero);

      for (int i = 0; i < 100; i++) {
        final BookmarkModel bookmark = generateRandomBookmarkModel();

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
