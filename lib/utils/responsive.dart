import 'package:flutter/material.dart';

class Responsive {
  final BuildContext context;
  
  Responsive(this.context);
  
  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static bool isMobile(BuildContext context) {
    return width(context) < 600;
  }

  static bool isTablet(BuildContext context) {
    return width(context) >= 600 && width(context) < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return width(context) >= 1200;
  }

  // Responsive padding
  static double padding(BuildContext context) {
    if (isDesktop(context)) return 24.0;
    if (isTablet(context)) return 20.0;
    return 16.0;
  }

  // Responsive grid columns
  static int gridColumns(BuildContext context) {
    if (isDesktop(context)) return 4;
    if (isTablet(context)) return 3;
    return 2;
  }

  // Responsive font sizes
  static double fontSize(BuildContext context, double baseSize) {
    if (isDesktop(context)) return baseSize * 1.2;
    if (isTablet(context)) return baseSize * 1.1;
    return baseSize;
  }

  // Responsive spacing
  static double spacing(BuildContext context, double baseSpacing) {
    if (isDesktop(context)) return baseSpacing * 1.5;
    if (isTablet(context)) return baseSpacing * 1.2;
    return baseSpacing;
  }
  
  // Instance methods for easier usage
  double get screenWidth => width(context);
  double get screenHeight => height(context);
  
  // Responsive scaling based on screen width
  double sp(double size) {
    final double w = screenWidth;
    // Base width is 360 (typical phone width)
    return (size / 360) * w;
  }
  
  // Responsive height percentage
  double hp(double percentage) {
    return (percentage / 100) * screenHeight;
  }
  
  // Responsive width percentage
  double wp(double percentage) {
    return (percentage / 100) * screenWidth;
  }
}

// Extension on BuildContext for easier access
extension ResponsiveExtension on BuildContext {
  double get width => Responsive.width(this);
  double get height => Responsive.height(this);
  bool get isMobile => Responsive.isMobile(this);
  bool get isTablet => Responsive.isTablet(this);
  bool get isDesktop => Responsive.isDesktop(this);
  double get padding => Responsive.padding(this);
  int get gridColumns => Responsive.gridColumns(this);
}
