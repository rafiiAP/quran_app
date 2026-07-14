import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:quran_app/core/navigator_key.dart';
import 'package:quran_app/core/constants/config.dart';
import 'package:quran_app/core/constants/color.dart';
import 'package:quran_app/core/constants/enum.dart';
import 'package:quran_app/core/di/injection.dart';
import 'package:quran_app/core/widgets/app_text.dart';
import 'package:quran_app/core/widgets/app_button.dart';

/// Convenience getter for the [AppBottomsheetFactory] singleton.
AppBottomsheetFactory get appBottomsheet => locator<AppBottomsheetFactory>();

/// Abstract interface for bottomsheet widget utilities.
/// Can be mocked independently in widget tests.
abstract class AppBottomsheetFactory {
  Future<void> showBottomSheet({
    Widget? bottomSheet,
    Color? backgroundColor,
    BottomSheetMode bottomSheetMode,
    String cLoadingMessage,
    bool isDismissible,
    String? title,
    bool isScrollControlled,
  });

  Future<void> messageInfo({required String message});

  Future<void> wait({String? message});

  void endwait();
}

/// Standalone bottomsheet utility registered in GetIt.
class AppBottomsheetFactoryImpl implements AppBottomsheetFactory {
  @override
  Future<void> showBottomSheet({
    final Widget? bottomSheet,
    final Color? backgroundColor,
    final BottomSheetMode bottomSheetMode = BottomSheetMode.defaultSheet,
    final String cLoadingMessage = '',
    final bool isDismissible = true,
    final String? title,
    final bool isScrollControlled = false,
  }) {
    final BuildContext ctx = navigatorKey.currentContext!;
    final bool isDark = Theme.of(ctx).brightness == Brightness.dark;
    final appTextFactory = locator<AppTextFactory>();

    switch (bottomSheetMode) {
      case BottomSheetMode.message:
        return showModalBottomSheet(
          context: ctx,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          backgroundColor: backgroundColor,
          isDismissible: isDismissible,
          isScrollControlled: isScrollControlled,
          builder: (_) => SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  appTextFactory.textBody(
                    text: title ?? config.cAppName,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: isDark ? colorConfig.white : colorConfig.black,
                  ),
                  appTextFactory.textBody(
                    text:
                        '${_datetimeNow()} VAP: ${config.cAppVersion} (${config.nAppVersion})',
                    color: isDark ? colorConfig.white : colorConfig.black,
                    fontSize: 14,
                  ),
                  Divider(color: colorConfig.grey),
                  bottomSheet ?? Container(),
                ],
              ),
            ),
          ),
        );
      case BottomSheetMode.loading:
        return showModalBottomSheet(
          context: ctx,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          backgroundColor: backgroundColor,
          isDismissible: isDismissible,
          isScrollControlled: isScrollControlled,
          builder: (_) => Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                appTextFactory.textBody(
                  text: config.cAppName,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                appTextFactory.textBody(
                  text:
                      'DT: ${_datetimeNow()} VAP: ${config.cAppVersion} (${config.nAppVersion})',
                  color: isDark ? colorConfig.white : colorConfig.black,
                  fontSize: 14,
                ),
                const Divider(),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CircularProgressIndicator(color: colorConfig.primary),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: appTextFactory.textBody(
                          text: cLoadingMessage,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      case BottomSheetMode.defaultSheet:
        return showModalBottomSheet(
          context: ctx,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          backgroundColor: backgroundColor,
          isDismissible: isDismissible,
          isScrollControlled: isScrollControlled,
          builder: (_) => bottomSheet ?? Container(),
        );
    }
  }

  @override
  Future<void> messageInfo({
    required final String message,
  }) {
    final BuildContext ctx = navigatorKey.currentContext!;
    final bool isDark = Theme.of(ctx).brightness == Brightness.dark;
    final appTextFactory = locator<AppTextFactory>();
    final appButtonFactory = locator<AppButtonFactory>();

    return showBottomSheet(
      isScrollControlled: true,
      backgroundColor: isDark ? colorConfig.background : colorConfig.white,
      bottomSheetMode: BottomSheetMode.message,
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: appTextFactory.textBody(
              text: message,
              fontSize: 16,
              color: isDark ? colorConfig.white : colorConfig.black,
            ),
          ),
          const Divider(),
          SizedBox(
            width: double.infinity,
            child: appButtonFactory.button(
              onPressed: () {
                Navigator.of(navigatorKey.currentContext!).pop();
              },
              child: appTextFactory.textBody(
                text: 'OKE',
                fontWeight: FontWeight.w600,
                color: colorConfig.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Future<void> wait({
    final String? message,
  }) {
    final BuildContext ctx = navigatorKey.currentContext!;
    final bool isDark = Theme.of(ctx).brightness == Brightness.dark;
    return showBottomSheet(
      backgroundColor: isDark ? colorConfig.background : colorConfig.white,
      bottomSheetMode: BottomSheetMode.loading,
      cLoadingMessage: message ?? 'Mohon tunggu...',
      isDismissible: false,
      isScrollControlled: true,
    );
  }

  @override
  void endwait() => Navigator.of(navigatorKey.currentContext!).pop();

  /// Helper to get current datetime string.
  String _datetimeNow() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  }
}
