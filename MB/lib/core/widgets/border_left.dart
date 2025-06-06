import 'package:flutter/material.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';

class BorderLeft extends StatelessWidget {
  final double height;

  const BorderLeft({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: height,
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
      ),
    );
  }
}
