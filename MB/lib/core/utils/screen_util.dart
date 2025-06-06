import 'package:flutter/material.dart';

/// Singleton class to manage screen dimensions and scaling factors
class ScreenUtil {
  /// Design size for base dimensions (based on typical phone size - adjust as needed)
  static const Size _designSize = Size(375, 812); // iPhone X dimensions as reference
  
  /// Singleton instance
  static final ScreenUtil _instance = ScreenUtil._();
  
  /// Screen width and height
  late double _screenWidth;
  late double _screenHeight;
  
  /// Screen density for pixel calculations
  late double _pixelRatio;
  
  /// Status bar height
  late double _statusBarHeight;
  
  /// Bottom safe area (notches, home indicators)
  late double _bottomBarHeight;
  
  /// Text scaling factor for accessibility
  late double _textScaleFactor;
  
  /// Scale factors for width and height based on design size
  late double _scaleWidth;
  late double _scaleHeight;
  
  /// Private constructor
  ScreenUtil._();
  
  /// Factory constructor to return instance
  factory ScreenUtil() => _instance;
  
  /// Initialize with MediaQueryData
  void init(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;
    _pixelRatio = mediaQuery.devicePixelRatio;
    _statusBarHeight = mediaQuery.padding.top;
    _bottomBarHeight = mediaQuery.padding.bottom;
    _textScaleFactor = mediaQuery.textScaleFactor;
    _scaleWidth = _screenWidth / _designSize.width;
    _scaleHeight = _screenHeight / _designSize.height;
  }
  
  /// Get scaled width dimension with extra scaling for small screens
  double setWidth(double width) {
    // Additional scaling for very small screens
    if (_screenWidth < 320) {
      return width * _scaleWidth * 0.95;
    }
    return width * _scaleWidth;
  }
  
  /// Get scaled height dimension with extra scaling for small screens
  double setHeight(double height) {
    // Additional scaling for very small screens
    if (_screenHeight < 600) {
      return height * _scaleHeight * 0.95;
    }
    return height * _scaleHeight;
  }
  
  /// Set font size that scales with screen with additional handling for small devices
  double setSp(double fontSize) {
    // More granular font scaling for different sizes
    if (_screenWidth < 320) {
      return fontSize * _scaleWidth * 0.85;
    } else if (_screenWidth < 360) {
      return fontSize * _scaleWidth * 0.90;
    }
    return fontSize * _scaleWidth;
  }

  /// Set radius for rounded corners
  double setRadius(double radius) {
    // Additional scaling for very small screens
    if (_screenWidth < 320) {
      return radius * _scaleWidth * 0.95;
    }
    return radius * _scaleWidth;
  }

  ///Get radius



  /// Get screen width
  double get screenWidth => _screenWidth;
  
  /// Get screen height
  double get screenHeight => _screenHeight;
  
  /// Get status bar height
  double get statusBarHeight => _statusBarHeight;
  
  /// Get bottom bar height
  double get bottomBarHeight => _bottomBarHeight;
  
  /// Get pixel ratio
  double get pixelRatio => _pixelRatio;
  
  /// Get scale width
  double get scaleWidth => _scaleWidth;
  
  /// Get scale height
  double get scaleHeight => _scaleHeight;

  
  /// Get scale factor considering both dimensions
  double get scaleText => (_scaleWidth + _scaleHeight) / 2;


  
  /// Get adaptive padding based on screen size
  EdgeInsets getAdaptivePadding({
    double small = 8.0,
    double normal = 16.0,
    double large = 24.0,
  }) {
    if (_screenWidth < 320) {
      return EdgeInsets.all(small);
    } else if (_screenWidth < 600) {
      return EdgeInsets.all(normal);
    } else {
      return EdgeInsets.all(large);
    }
  }

}
