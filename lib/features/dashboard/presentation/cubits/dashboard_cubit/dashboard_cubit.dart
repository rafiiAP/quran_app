import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quran_app/core/constants/cache_keys.dart';
import 'package:quran_app/core/storage/local_storage_service.dart';

part 'dashboard_state.dart';
part 'dashboard_cubit.freezed.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final LocalStorageService storageService;

  DashboardCubit({required this.storageService})
      : super(const DashboardState(currentIndex: 0));

  void changeTab(int index) {
    emit(DashboardState(currentIndex: index));
  }

  /// Persists the onboarding-complete flag. Called from [StartedPage] before
  /// navigating away so we don't need a raw locator<> call in a widget.
  void markStarted() {
    storageService.setBool(key: CacheKeys.started, value: true);
  }
}
