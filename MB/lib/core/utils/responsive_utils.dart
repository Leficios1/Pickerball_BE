import 'package:flutter/material.dart';

enum DeviceScreenType {
  mobile,
  tablet,
  desktop,
}

class ResponsiveUtils {
  static DeviceScreenType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < 600) {
      return DeviceScreenType.mobile;
    } else if (width < 1200) {
      return DeviceScreenType.tablet;
    } else {
      return DeviceScreenType.desktop;
    }
  }

  static bool isMobile(BuildContext context) => 
      getDeviceType(context) == DeviceScreenType.mobile;
      
  static bool isTablet(BuildContext context) => 
      getDeviceType(context) == DeviceScreenType.tablet;
      
  static bool isDesktop(BuildContext context) => 
      getDeviceType(context) == DeviceScreenType.desktop;
  
  static double getResponsiveWidth(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * (percentage / 100);
  }

  static double getResponsiveHeight(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * (percentage / 100);
  }
  
  static double fontSizeScaleFactor(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // More granular font scaling for different screen sizes
    if (width < 320) return 0.75;
    if (width < 360) return 0.85;
    if (width < 400) return 0.95;
    if (width < 600) return 1.0;
    if (width < 900) return 1.1;
    return 1.2;
  }
  
  static double getScaledSize(BuildContext context, double size) {
    return size * fontSizeScaleFactor(context);
  }

  static EdgeInsets responsivePadding(BuildContext context) {
    final deviceType = getDeviceType(context);
    final width = MediaQuery.of(context).size.width;
    
    // Even more specific padding based on exact screen width
    if (width < 320) {
      return const EdgeInsets.all(12.0);
    }
    
    switch (deviceType) {
      case DeviceScreenType.mobile:
        return const EdgeInsets.all(16.0);
      case DeviceScreenType.tablet:
        return const EdgeInsets.all(24.0);
      case DeviceScreenType.desktop:
        return const EdgeInsets.all(32.0);
    }
  }
  
  static double getResponsiveButtonHeight(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 320) return 44.0;
    if (width < 400) return 48.0;
    return 52.0;
  }
  
  static double getResponsiveIconSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 320) return 18.0;
    if (width < 400) return 22.0;
    return 24.0;
  }
}
