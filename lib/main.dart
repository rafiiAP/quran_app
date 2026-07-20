import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/bootstrap.dart';
import 'package:quran_app/core/style.dart';
import 'package:quran_app/core/di/injection.dart';
import 'package:quran_app/core/router/app_router.dart';
import 'package:quran_app/features/dashboard/presentation/cubits/dashboard_cubit/dashboard_cubit.dart';
import 'package:quran_app/features/dashboard/presentation/cubits/home_cubit/home_cubit.dart';

Future<void> main() async {
  await AppBootstrap.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider>[
        BlocProvider<DashboardCubit>(
          create: (final BuildContext context) =>
              DashboardCubit(storageService: locator()),
        ),
        BlocProvider<HomeCubit>(
          create: (final BuildContext context) =>
              HomeCubit(storageService: locator()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Quran App',
        theme: style.light,
        darkTheme: style.dark,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        routerConfig: locator<AppRouter>().router,
      ),
    );
  }
}
