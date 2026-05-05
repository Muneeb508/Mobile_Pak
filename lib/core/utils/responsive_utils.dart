import 'package:flutter/material.dart';

class ResponsiveUtils {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  static bool isLargeScreen(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  static int getGridCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 4;
    if (width >= 800) return 3;
    return 2;
  }

  static double getGridChildAspectRatio(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 0.8;
    if (width >= 800) return 0.75;
    return 0.72;
  }

  static double getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 48;
    if (width >= 800) return 32;
    return 16;
  }

  static double getBannerAspectRatio(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 24 / 6;
    if (width >= 800) return 16 / 6;
    return 16 / 7;
  }

  static double getMaxContentWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > 1200 ? 1200 : width;
  }

  static double getGridMaxCrossAxisExtent(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 300;
    if (width >= 800) return 220;
    return 160;
  }

  static double getChildAspectRatioForExtent(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 0.75;
    if (width >= 800) return 0.7;
    return 0.75; // Mobile: slightly taller than wide, but not too tall
  }
}
