import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:quran_app/core/constants/color.dart';
import 'package:quran_app/core/di/injection.dart';

/// Convenience getter for the [AppShimmerFactory] singleton.
AppShimmerFactory get appShimmer => locator<AppShimmerFactory>();

/// Abstract interface for shimmer widget utilities.
/// Can be mocked independently in widget tests.
abstract class AppShimmerFactory {
  Widget shimmer({required double width, required double height});
}

/// Standalone shimmer widget utility registered in GetIt.
class AppShimmerFactoryImpl implements AppShimmerFactory {
  @override
  Widget shimmer({required final double width, required final double height}) {
    return Shimmer.fromColors(
      baseColor: colorConfig.lightGrey,
      highlightColor: colorConfig.white,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: colorConfig.lightGrey,
        ),
      ),
    );
  }
}
