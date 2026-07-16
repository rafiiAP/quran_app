part of 'dashboard_cubit.dart';

@freezed
class DashboardState with _$DashboardState {
  const factory DashboardState({
    @Default(0) int currentIndex,
  }) = _DashboardState;
}
