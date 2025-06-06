import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pickleball_app/core/constants/app_enums.dart';
import 'package:pickleball_app/core/constants/app_strings.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/themes/app_theme.dart';
import 'package:pickleball_app/core/utils/extensions.dart';
import 'package:pickleball_app/core/utils/snackbar_helper.dart';
import 'package:pickleball_app/generated/assets.dart';
import 'package:pickleball_app/router/router.gr.dart';

class ContainerPlay extends StatefulWidget {
  final bool isLogin;

  ContainerPlay({super.key, required this.isLogin});

  @override
  State<ContainerPlay> createState() => _ContainerPlayState();
}

class _ContainerPlayState extends State<ContainerPlay> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: 200,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF032778),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Player Online Status
          Positioned(
            top: 10,
            left: 10,
            child: Row(
              children: [
                Icon(Icons.circle, color: Colors.greenAccent, size: 14)
                    .animate()
                    .scale(duration: 500.ms, curve: Curves.easeInOut),
                const SizedBox(width: 8),
                Text(
                  'Online',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ).animate().fadeIn(duration: 500.ms, curve: Curves.easeInOut),
              ],
            ),
          ),

          // Play Now Text
          Positioned(
            top: 40,
            left: 10,
            child:  Text(
              AppStrings.appName,
              style: AppTheme.getTheme(context).textTheme.displayLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,

              ),
            ).animate().fadeIn(duration: 500.ms, curve: Curves.easeInOut),
          ),

          // Buttons (1 vs 1 & 2 vs 2)
          Positioned(
            bottom: 10,
            left: 10,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Row(
                children: [
                  _buildPlayButton(AppStrings.singleRoom, Icons.sports_tennis,
                          () {
                        if (widget.isLogin) {
                          AutoRouter.of(context).push(
                              CreateMatchRoute(type: TournamentFormant.single.value));
                        } else {
                          SnackbarHelper.showSnackBar(AppStrings.plsLoginToFeature);
                        }
                      }).animate().slideX(duration: 500.ms, curve: Curves.easeInOut),
                      Spacer(),
                  _buildPlayButton(AppStrings.doubleRoom, Icons.sports, () {
                    if (widget.isLogin) {
                      AutoRouter.of(context).push(CreateMatchRoute(
                          type: TournamentFormant.doubles.value));
                    } else {
                      SnackbarHelper.showSnackBar(AppStrings.plsLoginToFeature);
                    }
                  }).animate().slideX(duration: 500.ms, curve: Curves.easeInOut),
                  SizedBox(
                    width: 10,
                  )
                ],
              
              ),
            )
          ),

          // Background Circle Decoration
          Positioned(
            top: -70.h,
            right: 10.h,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.width * 0.35,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(156, 190, 215, 0.92),
                shape: BoxShape.circle,
              ),
            ).animate().scale(duration: 500.ms, curve: Curves.easeInOut),
          ),

          // Player Image
          Positioned(
            top: -60.h,
            right: 20.h,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.width * 0.3,
              child: Image.asset(
                Assets.imagesPickerball,
                fit: BoxFit.cover,
              ),
            ).animate().scale(duration: 500.ms, curve: Curves.easeInOut),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayButton(String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      ),
      icon: Icon(icon, size: 18, color: AppColors.primaryColor),
      label: Text(
        text,
        style: AppTheme.getTheme(context).textTheme.titleSmall?.copyWith(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
