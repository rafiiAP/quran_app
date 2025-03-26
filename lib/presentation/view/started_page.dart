import 'package:flutter/material.dart';
import 'package:quran_app/components/function/main_function.dart';
import 'package:quran_app/components/widgets/main_widget.dart';
import 'package:quran_app/data/constant/color.dart';
import 'package:quran_app/data/constant/image.dart';
import 'package:quran_app/presentation/view/dashboard/dashboard_page.dart';

class StartedPage extends StatelessWidget {
  const StartedPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              height: C.getHeight() * 0.05,
            ),
            Container(
              clipBehavior: Clip.none,
              height: C.getHeight() * 0.5,
              width: C.getWidth(),
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
                    top: C.getHeight() * 0.13,
                    child: Image.asset(
                      imageConfig.quran,
                      width: C.getWidth() * 0.7,
                    ),
                  ),
                  Positioned(
                    bottom: -20,
                    child: W.outlinedButton(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      backgroundColor: colorConfig.white,
                      onPressed: () {
                        C.offAll(() => DashboardPage());
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
