import 'package:get_it/get_it.dart';
import 'package:quran_app/core/di/injection_bookmark.dart';
import 'package:quran_app/core/di/injection_core.dart';
import 'package:quran_app/core/di/injection_dashboard.dart';
import 'package:quran_app/core/di/injection_detail_surah.dart';
import 'package:quran_app/core/di/injection_jadwal_sholat.dart';
import 'package:quran_app/core/di/injection_surah.dart';
import 'package:quran_app/core/di/injection_widgets.dart';

GetIt locator = GetIt.instance;

/// Composes all dependency registration modules.
///
/// Each feature has its own registration file for maintainability:
/// - [registerCoreDependencies] — infrastructure (network, storage, services)
/// - [registerDashboardDependencies] — dashboard & home cubits
/// - [registerSurahDependencies] — surah list feature
/// - [registerDetailSurahDependencies] — surah detail feature
/// - [registerJadwalSholatDependencies] — prayer schedule feature
/// - [registerBookmarkDependencies] — bookmark feature
/// - [registerWidgetDependencies] — UI widget factories
Future<void> setup() async {
  await registerCoreDependencies(locator);
  registerDashboardDependencies(locator);
  registerSurahDependencies(locator);
  registerDetailSurahDependencies(locator);
  registerJadwalSholatDependencies(locator);
  registerBookmarkDependencies(locator);
  registerWidgetDependencies(locator);
}
