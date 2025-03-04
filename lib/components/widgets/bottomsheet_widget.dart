part of 'main_widget.dart';

mixin BottomsheetWidget {
  Future showBottomSheet({
    Widget? bottomSheet,
    Color? backgroundColor,
    BottomSheetMode bottomSheetMode = BottomSheetMode.defaultSheet,
    String cLoadingMessage = "",
    bool isDismissible = true,
    String? title,
    bool isScrollControlled = false,
  }) {
    title ??= AppConfig.cAppName;
    switch (bottomSheetMode) {
      case BottomSheetMode.message:
        return Get.bottomSheet(
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                W.textBody(
                  text: title,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: C.isDark(Get.context!) ? AppColorConfig.white : AppColorConfig.black,
                ),
                W.textBody(
                  text: "${C.datetime()} VAP: ${AppConfig.cAppVersion} (${AppConfig.nAppVersion})",
                  color: C.isDark(Get.context!) ? AppColorConfig.white : AppColorConfig.black,
                  fontSize: 14,
                ),
                const Divider(
                  color: AppColorConfig.grey,
                ),
                bottomSheet ?? Container(),
              ],
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          ),
          backgroundColor: backgroundColor,
          isDismissible: isDismissible,
          isScrollControlled: isScrollControlled,
        );
      case BottomSheetMode.loading:
        return Get.bottomSheet(
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                W.textBody(
                  text: AppConfig.cAppName,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                W.textBody(
                  text: "DT: ${C.datetime()} VAP: ${AppConfig.cAppVersion} (${AppConfig.nAppVersion})",
                  color: C.isDark(Get.context!) ? AppColorConfig.white : AppColorConfig.black,
                  fontSize: 14,
                ),
                const Divider(),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        color: AppColorConfig.primary,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                        ),
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
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          ),
          backgroundColor: backgroundColor,
          isDismissible: isDismissible,
          isScrollControlled: isScrollControlled,
        );
      case BottomSheetMode.defaultSheet:
        return Get.bottomSheet(
          bottomSheet ?? Container(),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          ),
          backgroundColor: backgroundColor,
          isDismissible: isDismissible,
          isScrollControlled: isScrollControlled,
        );
    }
  }

  messageInfo({
    required String message,
  }) {
    return showBottomSheet(
      backgroundColor: C.isDark(Get.context!) ? AppColorConfig.background : AppColorConfig.white,
      bottomSheetMode: BottomSheetMode.message,
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
            ),
            child: W.textBody(
              text: message,
              fontSize: 16,
              color: C.isDark(Get.context!) ? AppColorConfig.white : AppColorConfig.black,
            ),
          ),
          const Divider(),
          SizedBox(
            width: double.infinity,
            child: W.button(
              onPressed: () {
                C.back();
              },
              child: W.textBody(
                text: "OKE",
                fontWeight: FontWeight.w600,
                color: AppColorConfig.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future wait({
    String? message,
  }) {
    message ??= "Mohon tunggu";
    return showBottomSheet(
      backgroundColor: C.isDark(Get.context!) ? AppColorConfig.background : AppColorConfig.white,
      bottomSheetMode: BottomSheetMode.loading,
      cLoadingMessage: message,
      isDismissible: false,
    );
  }

  void endwait() {
    return C.back();
  }
}
