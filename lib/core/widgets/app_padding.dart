import 'package:flutter/material.dart';

import 'package:quran_app/core/di/injection.dart';

/// Convenience getter for the [AppPaddingFactory] singleton.
AppPaddingFactory get appPadding => locator<AppPaddingFactory>();

/// Abstract interface for padding widget utilities.
/// Can be mocked independently in widget tests.
abstract class AppPaddingFactory {
  Widget paddingheight16();
  Widget paddingheight8();
  Widget paddingheight5();
  Widget paddingWidtht16();
  Widget paddingWidtht8();
  Widget paddingWidtht5();
}

/// Standalone padding utility registered in GetIt.
class AppPaddingFactoryImpl implements AppPaddingFactory {
  @override
  Widget paddingheight16() => const SizedBox(height: 16);

  @override
  Widget paddingheight8() => const SizedBox(height: 8);

  @override
  Widget paddingheight5() => const SizedBox(height: 5);

  @override
  Widget paddingWidtht16() => const SizedBox(width: 16);

  @override
  Widget paddingWidtht8() => const SizedBox(width: 8);

  @override
  Widget paddingWidtht5() => const SizedBox(width: 5);
}
