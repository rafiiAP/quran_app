import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/data/datasources/local_storage_service.dart';
import 'package:quran_app/presentation/controller/dashboard/dashboard_cubit/dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final LocalStorageService storageService;

  DashboardCubit({required this.storageService})
      : super(const DashboardState(currentIndex: 0)) {
    _init();
  }

  void _init() {
    storageService.setBool(key: 'cacheStarted', value: true);
  }

  void changeTab(int index) {
    emit(DashboardState(currentIndex: index));
  }
}
