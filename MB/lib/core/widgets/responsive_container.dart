import 'package:flutter/material.dart';
import 'package:pickleball_app/core/utils/responsive_utils.dart';
import 'package:pickleball_app/core/utils/extensions.dart';

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? mobileWidth;
  final double? mobileHeight;
  final double? tabletWidth;
  final double? tabletHeight;
  final double? desktopWidth;
  final double? desktopHeight;
  final EdgeInsetsGeometry? mobilePadding;
  final EdgeInsetsGeometry? tabletPadding;
  final EdgeInsetsGeometry? desktopPadding;
  final Alignment? alignment;
  final Color? color;
  final Decoration? decoration;
  final BoxConstraints? constraints;
  final double? minHeight;
  final EdgeInsetsGeometry? margin;
  
  const ResponsiveContainer({
    Key? key,
    required this.child,
    this.mobileWidth,
    this.mobileHeight,
    this.tabletWidth,
    this.tabletHeight,
    this.desktopWidth,
    this.desktopHeight,
    this.mobilePadding,
    this.tabletPadding,
    this.desktopPadding,
    this.alignment,
    this.color,
    this.decoration,
    this.constraints,
    this.minHeight,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveUtils.getDeviceType(context);
    final screenWidth = context.width;
    
    double? width;
    double? height;
    EdgeInsetsGeometry? padding;
    
    // Apply different sizes based on screen width ranges
    if (screenWidth < 320) {
      // Extra small screens - reduce sizes further
      width = mobileWidth != null ? mobileWidth! * 0.9 : null;
      height = mobileHeight != null ? mobileHeight! * 0.9 : null;
      padding = mobilePadding != null 
          ? EdgeInsets.all((mobilePadding as EdgeInsets).top * 0.75)
          : null;
    } else {
      // Normal responsive sizing
      switch (deviceType) {
        case DeviceScreenType.mobile:
          width = mobileWidth;
          height = mobileHeight;
          padding = mobilePadding;
          break;
        case DeviceScreenType.tablet:
          width = tabletWidth ?? mobileWidth;
          height = tabletHeight ?? mobileHeight;
          padding = tabletPadding ?? mobilePadding;
          break;
        case DeviceScreenType.desktop:
          width = desktopWidth ?? tabletWidth ?? mobileWidth;
          height = desktopHeight ?? tabletHeight ?? mobileHeight;
          padding = desktopPadding ?? tabletPadding ?? mobilePadding;
          break;
      }
    }
    
    // Apply minimum height if specified, respecting screen height
    final calculatedMinHeight = minHeight != null 
        ? minHeight! * (screenWidth < 320 ? 0.85 : 1.0)
        : null;
    
    // Build constraints for the container
    final combinedConstraints = (constraints != null)
        ? constraints!.copyWith(
            minHeight: calculatedMinHeight ?? constraints!.minHeight)
        : (calculatedMinHeight != null)
            ? BoxConstraints(minHeight: calculatedMinHeight)
            : null;
    
    return Container(
      width: width,
      height: height,
      padding: padding,
      alignment: alignment,
      color: color,
      decoration: decoration,
      constraints: combinedConstraints,
      margin: margin,
      child: child,
    );
  }
}
