import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_app/core/widgets/app_text.dart';
import 'package:quran_app/core/widgets/app_button.dart';
import 'package:quran_app/core/widgets/app_padding.dart';
import 'package:quran_app/core/constants/color.dart';
import 'package:quran_app/core/constants/route_names.dart';
import 'package:quran_app/core/constants/image.dart';
import 'package:quran_app/features/dashboard/presentation/cubits/dashboard_cubit/dashboard_cubit.dart';

class StartedPage extends StatelessWidget {
  const StartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            appText.textBody(
              text: 'Quran App',
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            appPadding.paddingheight16(),
            appText.textBody(
              text: 'Learn Quran and Recite once everyday',
              fontSize: 18,
              color: colorConfig.grey,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            Container(
              clipBehavior: Clip.none,
              height: screenHeight * 0.5,
              width: screenWidth,
              decoration: BoxDecoration(
                color: colorConfig.primary,
                borderRadius: BorderRadius.circular(30),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(imageConfig.bgSplash),
                ),
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    bottom: 0,
                    top: screenHeight * 0.13,
                    child: Image.asset(
                      imageConfig.quran,
                      width: screenWidth * 0.7,
                    ),
                  ),
                  Positioned(
                    bottom: -20,
                    child: appButton.outlinedButton(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      backgroundColor: colorConfig.white,
                      onPressed: () {
                        // DashboardCubit._init() already persists cacheStarted = true
                        // when the DashboardCubit is first created. We only need to
                        // navigate here; no direct locator<> call needed.
                        context.read<DashboardCubit>().markStarted();
                        context.go(RouteNames.home);
                      },
                      child: appText.textBody(
                        text: 'Get Started',
                        fontSize: 18,
                        color: colorConfig.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
