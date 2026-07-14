import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/constants/config.dart';
import 'package:quran_app/core/storage/local_storage_service.dart';
import 'package:quran_app/features/dashboard/presentation/cubits/dashboard_cubit/dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final LocalStorageService storageService;

  DashboardCubit({required this.storageService})
      : super(const DashboardState(currentIndex: 0)) {
    _init();
  }

  void _init() {
    storageService.setBool(key: config.cacheStarted, value: true);
  }

  void changeTab(int index) {
    emit(DashboardState(currentIndex: index));
  }
}
