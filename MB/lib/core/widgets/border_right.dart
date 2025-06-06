import 'package:flutter/material.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';

class BorderRight extends StatelessWidget {
  final double height;

  const BorderRight({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: height,
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
    );
  }
}
