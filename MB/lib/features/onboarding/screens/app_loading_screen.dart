import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/utils/extensions.dart';
import 'package:pickleball_app/core/utils/responsive_utils.dart';

class AppLoadingScreen extends StatelessWidget {
  const AppLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Adjust loading indicator size based on screen width
    final screenWidth = context.width;
    final loadingSize = screenWidth < 320 ? 40.0 : 
                        screenWidth < 360 ? 45.0 :
                        screenWidth < 600 ? 50.0 : 60.0;
                        
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingAnimationWidget.threeRotatingDots(
              color: AppColors.primaryColor,
              size: loadingSize,
            ),
            SizedBox(height: 24.h),
            Text(
              'Loading...',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: ResponsiveUtils.getScaledSize(context, 16),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
