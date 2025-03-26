part of 'main_function.dart';

mixin NavigationCom {
  Future<T?> to<T>(
    final dynamic page, {
    final Transition? transition,
    final String? routeName,
    final bool fullscreenDialog = false,
    final Object? arguments,
  }) async {
    return Get.to<T>(
      page,
      transition: transition,
      routeName: routeName,
      fullscreenDialog: fullscreenDialog,
      arguments: arguments,
    );
  }

  Future<T?>? toNamed<T>(
    final String page, {
    final dynamic arguments,
    final Map<String, String>? parameters,
  }) {
    return Get.toNamed<T>(
      page,
      arguments: arguments,
      parameters: parameters,
    );
  }

  void back<T>({
    final Object? result,
  }) {
    return Get.back(
      result: result,
    );
  }

  void close({
    final int times = 1,
  }) {
    return Get.close(times);
  }

  Future<T?>? off<T>(
    final dynamic page, {
    final Transition? transition,
    final String? routeName,
    final bool fullscreenDialog = false,
    final dynamic arguments,
  }) {
    return Get.off<T>(
      page,
      transition: transition,
      routeName: routeName,
      fullscreenDialog: fullscreenDialog,
      arguments: arguments,
    );
  }

  Future<dynamic>? offAll(
    final dynamic page, {
    final Transition? transition,
    final String? routeName,
    final bool fullscreenDialog = false,
    final dynamic arguments,
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
