import 'package:get_it/get_it.dart';
import 'package:quran_app/core/widgets/app_bottomsheet.dart';
import 'package:quran_app/core/widgets/app_button.dart';
import 'package:quran_app/core/widgets/app_input.dart';
import 'package:quran_app/core/widgets/app_padding.dart';
import 'package:quran_app/core/widgets/app_shimmer.dart';
import 'package:quran_app/core/widgets/app_text.dart';

/// Registers UI widget factory dependencies.
///
/// These are stateless utilities registered in GetIt so they can be
/// mocked in widget tests via their abstract interfaces.
void registerWidgetDependencies(GetIt locator) {
  locator.registerLazySingleton<AppTextFactory>(AppTextFactoryImpl.new);
  locator.registerLazySingleton<AppButtonFactory>(AppButtonFactoryImpl.new);
  locator.registerLazySingleton<AppInputFactory>(AppInputFactoryImpl.new);
  locator.registerLazySingleton<AppBottomsheetFactory>(
    AppBottomsheetFactoryImpl.new,
  );
  locator.registerLazySingleton<AppShimmerFactory>(AppShimmerFactoryImpl.new);
  locator.registerLazySingleton<AppPaddingFactory>(AppPaddingFactoryImpl.new);
}
