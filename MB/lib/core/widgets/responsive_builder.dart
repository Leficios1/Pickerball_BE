import 'package:flutter/material.dart';
import 'package:pickleball_app/core/utils/responsive_utils.dart';

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext, DeviceScreenType) builder;

  const ResponsiveBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = ResponsiveUtils.getDeviceType(context);
        return builder(context, deviceType);
      },
    );
  }
}

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveWidget({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        switch (deviceType) {
          case DeviceScreenType.mobile:
            return mobile;
          case DeviceScreenType.tablet:
            return tablet ?? mobile;
          case DeviceScreenType.desktop:
            return desktop ?? tablet ?? mobile;
          default:
            return mobile;
        }
      },
    );
  }
}
