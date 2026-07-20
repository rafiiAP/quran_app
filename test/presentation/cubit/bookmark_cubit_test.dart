import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_app/features/bookmark/domain/entities/bookmark_entity.dart';
import 'package:quran_app/features/bookmark/presentation/cubits/bookmark_cubit/bookmark_cubit.dart';

import '../../mocks.dart';
import '../../fixtures/bookmark_fixture.dart';

void main() {
  late MockGetBookmarksUseCase mockGetBookmarksUseCase;
  late MockDeleteBookmarkUseCase mockDeleteBookmarkUseCase;

  setUp(() {
    mockGetBookmarksUseCase = MockGetBookmarksUseCase();
    mockDeleteBookmarkUseCase = MockDeleteBookmarkUseCase();
    // Default stub for loadBookmarks
    when(() => mockGetBookmarksUseCase())
        .thenAnswer((_) async => const Right([kBookmarkEntity]));
  });

  BookmarkCubit buildCubit() => BookmarkCubit(
        getBookmarksUseCase: mockGetBookmarksUseCase,
        deleteBookmarkUseCase: mockDeleteBookmarkUseCase,
      );

  // Requirements: 5.1 — BookmarkCubit loads bookmarks and exposes them
  group('loadBookmarks', () {
    blocTest<BookmarkCubit, BookmarkState>(
      'emits [loading, loaded] with bookmarks from database',
      setUp: () {
        when(() => mockGetBookmarksUseCase())
            .thenAnswer((_) async => const Right([kBookmarkEntity]));
      },
      build: buildCubit,
      act: (cubit) => cubit.loadBookmarks(),
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
        when(() => mockGetBookmarksUseCase())
            .thenAnswer((_) async => const Right(<BookmarkEntity>[]));
      },
      build: buildCubit,
      act: (cubit) => cubit.loadBookmarks(),
      verify: (cubit) {
        cubit.state.maybeWhen(
          loaded: (bookmarks) => expect(bookmarks.length, 0),
          orElse: () => fail('Expected loaded state'),
        );
      },
    );

    test(
        'initial state is BookmarkState.initial before loadBookmarks is called',
        () {
      final cubit = buildCubit();

      cubit.state.maybeWhen(
        initial: () => expect(true, isTrue),
        orElse: () => fail('Expected initial state'),
      );

      cubit.close();
    });
  });

  // Requirements: 5.2 — deleteBookmark removes the item and reloads the list
  group('deleteBookmark', () {
    blocTest<BookmarkCubit, BookmarkState>(
      'calls deleteBookmarkUseCase then reloads — final state is loaded without deleted item',
      setUp: () {
        when(
          () => mockDeleteBookmarkUseCase(
            id: kBookmarkEntity.id!,
          ),
        ).thenAnswer((_) async => const Right(null));
        when(() => mockGetBookmarksUseCase())
            .thenAnswer((_) async => const Right(<BookmarkEntity>[]));
      },
      build: buildCubit,
      act: (cubit) => cubit.deleteBookmark(kBookmarkEntity),
      verify: (cubit) {
        cubit.state.maybeWhen(
          loaded: (bookmarks) => expect(bookmarks.length, 0),
          orElse: () => fail('Expected loaded state'),
        );
        verify(
          () => mockDeleteBookmarkUseCase(
            id: kBookmarkEntity.id!,
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
      final cubit = buildCubit();

      final result = cubit.formatCopyText(kBookmarkEntity);

      final expected =
          '${kBookmarkEntity.namaLatin} : ${kBookmarkEntity.nomorSurah}\n'
          '${kBookmarkEntity.teksArab}\n'
          '${kBookmarkEntity.teksIndonesia}';
      expect(result, expected);
    });

    test('format string has exactly two newlines separating three parts', () {
      final cubit = buildCubit();

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

  // Requirements: 5.4 — navigateToDetail emits event via stream (not state)
  group('navigateToDetail', () {
    test(
        'emits BookmarkNavigationEvent on navigationEvents stream and does not change state',
        () async {
      final cubit = buildCubit();

      final events = <BookmarkNavigationEvent>[];
      final sub = cubit.navigationEvents.listen(events.add);

      cubit.navigateToDetail(kBookmarkEntity);
      await Future<void>.delayed(Duration.zero);

      expect(events.length, 1);
      expect(events.first.nomorSurah, kBookmarkEntity.nomorSurah);
      expect(events.first.nomorAyat, kBookmarkEntity.nomorAyat);

      // State should remain initial (not overwritten)
      expect(cubit.state, const BookmarkState.initial());

      await sub.cancel();
      await cubit.close();
    });

    test('multiple navigateToDetail calls emit multiple events', () async {
      final cubit = buildCubit();

      final events = <BookmarkNavigationEvent>[];
      final sub = cubit.navigationEvents.listen(events.add);

      cubit.navigateToDetail(kBookmarkEntity);
      cubit.navigateToDetail(kBookmarkEntity);
      await Future<void>.delayed(Duration.zero);

      expect(events.length, 2);

      await sub.cancel();
      await cubit.close();
    });
  });
}
