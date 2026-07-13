import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/data/constant/color.dart';
import 'package:quran_app/data/constant/image.dart';
import 'package:quran_app/presentation/controller/dashboard/dashboard_cubit/dashboard_cubit.dart';
import 'package:quran_app/presentation/controller/dashboard/dashboard_cubit/dashboard_state.dart';
import 'package:showcaseview/showcaseview.dart';

class DashboardPage extends StatelessWidget {
  final Widget child;

  const DashboardPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: (showcaseContext) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            body: child,
            bottomNavigationBar: BlocBuilder<DashboardCubit, DashboardState>(
              builder: (context, state) {
                final currentIndex = state.currentIndex;
                return BottomNavigationBar(
                  onTap: (index) {
                    context.read<DashboardCubit>().changeTab(index);
                    switch (index) {
                      case 0:
                        context.go('/home');
                        break;
                      case 1:
                        context.go('/bookmark');
                        break;
                      case 2:
                        context.go('/jadwal-sholat');
                        break;
                    }
                  },
                  elevation: 0,
                  currentIndex: currentIndex,
                  selectedItemColor: colorConfig.primary,
                  unselectedItemColor: colorConfig.grey,
                  backgroundColor: C.isDark(context)
                      ? colorConfig.bgBottom
                      : colorConfig.white,
                  items: [
                    BottomNavigationBarItem(
                      label: '',
                      icon: Image.asset(
                        imageConfig.bookNav,
                        color: currentIndex == 0
                            ? colorConfig.primary
                            : colorConfig.grey,
                      ),
                    ),
                    BottomNavigationBarItem(
                      label: '',
                      icon: Image.asset(
                        imageConfig.bookmark,
                        color: currentIndex == 1
                            ? colorConfig.primary
                            : colorConfig.grey,
                      ),
                    ),
                    BottomNavigationBarItem(
                      label: '',
                      icon: Image.asset(
                        imageConfig.shalat,
                        width: 30,
                        color: currentIndex == 2
                            ? colorConfig.primary
                            : colorConfig.grey,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
