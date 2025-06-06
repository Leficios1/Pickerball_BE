import 'package:flutter/material.dart';
import 'package:pickleball_app/core/utils/screen_util.dart';

extension ContextExtension on BuildContext {
  double heightFraction({double sizeFraction = 1}) =>
      MediaQuery.sizeOf(this).height * sizeFraction;

  double widthFraction({double sizeFraction = 1}) =>
      MediaQuery.sizeOf(this).width * sizeFraction;
      
  /// Get MediaQuery data
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  
  /// Get screen width
  double get width => mediaQuery.size.width;
  
  /// Get screen height
  double get height => mediaQuery.size.height;
  
  /// Get screen orientation
  Orientation get orientation => mediaQuery.orientation;
  
  /// Check if device is in portrait mode
  bool get isPortrait => orientation == Orientation.portrait;
  
  /// Check if device is in landscape mode
  bool get isLandscape => orientation == Orientation.landscape;
  
  /// Get safe area padding
  EdgeInsets get padding => mediaQuery.padding;
  
  /// Get device pixel ratio
  double get pixelRatio => mediaQuery.devicePixelRatio;
  
  /// Get status bar height
  double get statusBarHeight => padding.top;
  
  /// Get bottom bar height (bottom safe area)
  double get bottomBarHeight => padding.bottom;
  
  /// Responsive padding based on screen size
  EdgeInsets get screenPadding => EdgeInsets.symmetric(
    horizontal: width * 0.05, 
    vertical: height * 0.01
  );
  
  /// Adapt value for width dimension
  double adaptiveWidth(double val) => width * val / 100;
  
  /// Adapt value for height dimension
  double adaptiveHeight(double val) => height * val / 100;
  
  /// Return smaller dimension (width or height)
  double get smallerDimension => width < height ? width : height;
  
  /// Return larger dimension (width or height)
  double get largerDimension => width > height ? width : height;
}

/// Extension on double to make it easier to create responsive sizes
extension ResponsiveDoubleExtension on double {
  /// Get scaled width
  double get w => ScreenUtil().setWidth(this);
  
  /// Get scaled height
  double get h => ScreenUtil().setHeight(this);
  
  /// Get scaled text size
  double get sp => ScreenUtil().setSp(this);
  
  /// Get value based on screen width
  double get sw => this * ScreenUtil().screenWidth / 100;
  
  /// Get value based on screen height
  double get sh => this * ScreenUtil().screenHeight / 100;
}

/// Extension on int to use the same responsive functions as double
extension ResponsiveIntExtension on int {
  /// Get scaled width
  double get w => ScreenUtil().setWidth(toDouble());
  
  /// Get scaled height
  double get h => ScreenUtil().setHeight(toDouble());

  //get scaled radius
  double get r => ScreenUtil().setRadius(toDouble());
  /// Get scaled text size
  double get sp => ScreenUtil().setSp(toDouble());
  
  /// Get value based on screen width percentage
  double get sw => toDouble() * ScreenUtil().screenWidth / 100;
  
  /// Get value based on screen height percentage
  double get sh => toDouble() * ScreenUtil().screenHeight / 100;
}

/// Extension on Widget to add responsive padding
extension ResponsiveWidgetExtension on Widget {
  /// Add padding scaled by width
  Widget paddingAllW(double value) => Padding(
    padding: EdgeInsets.all(value.w),
    child: this,
  );
  
  /// Add symmetric horizontal padding scaled by width
  Widget paddingSymmetricH(double horizontal) => Padding(
    padding: EdgeInsets.symmetric(horizontal: horizontal.w),
    child: this,
  );
  
  /// Add symmetric vertical padding scaled by height
  Widget paddingSymmetricV(double vertical) => Padding(
    padding: EdgeInsets.symmetric(vertical: vertical.h),
    child: this,
  );
  
  /// Add symmetric padding scaled by respective dimensions
  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) => Padding(
    padding: EdgeInsets.symmetric(
      horizontal: horizontal.w,
      vertical: vertical.h,
    ),
    child: this,
  );
}
