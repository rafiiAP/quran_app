part of 'main_function.dart';

mixin NavigationCom {
  Future? to(
    dynamic page, {
    Transition? transition,
    String? routeName,
    bool fullscreenDialog = false,
    dynamic arguments,
  }) {
    return Get.to(
      page,
      transition: transition,
      routeName: routeName,
      fullscreenDialog: fullscreenDialog,
      arguments: arguments,
    );
  }

  Future? toNamed(
    String page, {
    dynamic arguments,
    Map<String, String>? parameters,
  }) {
    return Get.toNamed(
      page,
      arguments: arguments,
      parameters: parameters,
    );
  }

  void back({
    Object? result,
  }) {
    return Get.back(
      result: result,
    );
  }

  void close({
    int times = 1,
  }) {
    return Get.close(times);
  }

  Future? off(
    dynamic page, {
    Transition? transition,
    String? routeName,
    bool fullscreenDialog = false,
    dynamic arguments,
  }) {
    return Get.off(
      page,
      transition: transition,
      routeName: routeName,
      fullscreenDialog: fullscreenDialog,
      arguments: arguments,
    );
  }

  Future? offAll(
    dynamic page, {
    Transition? transition,
    String? routeName,
    bool fullscreenDialog = false,
    dynamic arguments,
  }) {
    return Get.offAll(
      page,
      transition: transition,
      routeName: routeName,
      fullscreenDialog: fullscreenDialog,
      arguments: arguments,
    );
  }
}
