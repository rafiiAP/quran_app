part of 'main_widget.dart';

mixin BottomsheetWidget {
  Future<void> showBottomSheet({
    final Widget? bottomSheet,
    final Color? backgroundColor,
    final BottomSheetMode bottomSheetMode = BottomSheetMode.defaultSheet,
    final String cLoadingMessage = "",
    final bool isDismissible = true,
    final String? title,
    final bool isScrollControlled = false,
  }) {
    final BuildContext ctx = navigatorKey.currentContext!;

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
                  W.textBody(
                    text: title ?? config.cAppName,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color:
                        C.isDark(ctx) ? colorConfig.white : colorConfig.black,
                  ),
                  W.textBody(
                    text:
                        "${C.datetime()} VAP: ${config.cAppVersion} (${config.nAppVersion})",
                    color:
                        C.isDark(ctx) ? colorConfig.white : colorConfig.black,
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
                W.textBody(
                  text: config.cAppName,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                W.textBody(
                  text:
                      "DT: ${C.datetime()} VAP: ${config.cAppVersion} (${config.nAppVersion})",
                  color: C.isDark(ctx) ? colorConfig.white : colorConfig.black,
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
                        child: W.textBody(
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

  Future<void> messageInfo({
    required final String message,
  }) {
    final BuildContext ctx = navigatorKey.currentContext!;
    return showBottomSheet(
      isScrollControlled: true,
      backgroundColor:
          C.isDark(ctx) ? colorConfig.background : colorConfig.white,
      bottomSheetMode: BottomSheetMode.message,
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: W.textBody(
              text: message,
              fontSize: 16,
              color: C.isDark(ctx) ? colorConfig.white : colorConfig.black,
            ),
          ),
          const Divider(),
          SizedBox(
            width: double.infinity,
            child: W.button(
              onPressed: () {
                Navigator.of(navigatorKey.currentContext!).pop();
              },
              child: W.textBody(
                text: "OKE",
                fontWeight: FontWeight.w600,
                color: colorConfig.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> wait({
    final String? message,
  }) {
    final BuildContext ctx = navigatorKey.currentContext!;
    return showBottomSheet(
      backgroundColor:
          C.isDark(ctx) ? colorConfig.background : colorConfig.white,
      bottomSheetMode: BottomSheetMode.loading,
      cLoadingMessage: message ?? "Mohon tunggu...",
      isDismissible: false,
      isScrollControlled: true,
    );
  }

  void endwait() => Navigator.of(navigatorKey.currentContext!).pop();
}
