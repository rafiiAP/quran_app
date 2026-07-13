import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_app/components/widgets/main_widget.dart';
import 'package:quran_app/data/constant/color.dart';
import 'package:quran_app/data/constant/config.dart';
import 'package:quran_app/data/constant/image.dart';
import 'package:quran_app/data/datasources/local_storage_service.dart';
import 'package:quran_app/injection.dart';

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
            W.textBody(
              text: 'Quran App',
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            W.paddingheight16(),
            W.textBody(
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
                    child: W.outlinedButton(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      backgroundColor: colorConfig.white,
                      onPressed: () {
                        locator<LocalStorageService>().setBool(
                          key: config.cacheStarted,
                          value: true,
                        );
                        context.go('/home');
                      },
                      child: W.textBody(
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
