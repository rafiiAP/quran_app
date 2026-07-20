import 'package:get_it/get_it.dart';
import 'package:quran_app/features/dashboard/presentation/cubits/dashboard_cubit/dashboard_cubit.dart';
import 'package:quran_app/features/dashboard/presentation/cubits/home_cubit/home_cubit.dart';

/// Registers dashboard feature dependencies.
///
/// Uses [registerFactory] for cubits since they are UI-scoped
/// (new instance per widget lifecycle).
void registerDashboardDependencies(GetIt locator) {
  locator.registerFactory<DashboardCubit>(
    () => DashboardCubit(storageService: locator()),
  );
  locator.registerFactory<HomeCubit>(
    () => HomeCubit(storageService: locator()),
  );
}
