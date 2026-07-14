import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quran_app/core/storage/local_storage_service.dart';
import 'package:showcaseview/showcaseview.dart';

/// Abstract interface for showcase tour functionality.
///
/// Can be mocked independently in unit tests.
abstract class ShowcaseService {
  /// Shows a showcase tour for the given [keys] if it hasn't been shown before
  /// (tracked by [cacheKey]).
  ///
  /// If [isShowHelp] is true, the showcase is always shown regardless of cache.
  void showCase({
    required BuildContext context,
    required List<GlobalKey> keys,
    required String cacheKey,
    bool isShowHelp = false,
  });
}

/// Implementation using the `showcaseview` package and [LocalStorageService].
class ShowcaseServiceImpl implements ShowcaseService {
  ShowcaseServiceImpl({required this.storageService});

  final LocalStorageService storageService;

  @override
  void showCase({
    required BuildContext context,
    required List<GlobalKey> keys,
    required String cacheKey,
    bool isShowHelp = false,
  }) {
    final alreadyShown = storageService.getBool(key: cacheKey);

    if (!alreadyShown) {
      storageService.setBool(key: cacheKey, value: true);
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!context.mounted) return;
        ShowCaseWidget.of(context).startShowCase(keys);
      });
    }

    if (isShowHelp) {
      ShowCaseWidget.of(context).startShowCase(keys);
    }
  }
}
