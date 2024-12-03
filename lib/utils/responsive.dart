import 'package:flutter/material.dart';

class Responsive {
  // Width of the screen
  static double getWidth(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    print('Screen Width: $screenWidth');

    if (screenWidth < 600) {
      return screenWidth * 0.83; // For Mobile Devices
    } else if (screenWidth < 1200) {
      return screenWidth * 0.7; // For Tablets
    } else {
      return 600; // For Desktop Devices
    }
  }

  // Height of the screen
  static double getHeight(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    if (screenHeight < 800) {
      return screenHeight * 0.08;
    } else {
      return 60; // Max height
    }
  }
}
