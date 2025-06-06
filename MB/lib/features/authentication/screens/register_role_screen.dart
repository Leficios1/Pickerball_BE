import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/utils/extensions.dart';
import 'package:pickleball_app/core/utils/responsive_utils.dart';
import 'package:pickleball_app/features/authentication/widgets/form_register_player.dart';
import 'package:pickleball_app/features/authentication/widgets/form_register_sponsor.dart';

import '../../../core/constants/app_strings.dart';

@RoutePage()
class RegisterRoleScreen extends StatefulWidget {
  const RegisterRoleScreen({super.key});

  @override
  _RegisterRoleScreenState createState() => _RegisterRoleScreenState();
}

class _RegisterRoleScreenState extends State<RegisterRoleScreen> {
  String _selectedRole = 'Player';

  @override
  Widget build(BuildContext context) {
    // Get responsive values based on screen size
    final screenWidth = context.width;
    final headerHeight = MediaQuery.of(context).size.height * (screenWidth < 360 ? 0.22 : 0.25);
    final fontSize = ResponsiveUtils.getScaledSize(context, screenWidth < 360 ? 26 : 30);
    final subtitleSize = ResponsiveUtils.getScaledSize(context, screenWidth < 360 ? 13 : 15);
    final contentPadding = screenWidth < 360 ? 12.0 : 16.0;
    final segmentButtonWidth = MediaQuery.of(context).size.width * (screenWidth < 360 ? 0.8 : 0.7);
    
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: headerHeight,
            alignment: const Alignment(0, -0.3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppStrings.chooseRole,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  AppStrings.subTitleChooseRole,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: subtitleSize,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(contentPadding),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: segmentButtonWidth,
                      child: SegmentedButton<String>(
                        segments: [
                          ButtonSegment<String>(
                            value: 'Player',
                            label: Text(
                              AppStrings.registerAsPlayer,
                              style: TextStyle(
                                fontSize: ResponsiveUtils.getScaledSize(context, screenWidth < 360 ? 12 : 14),
                              ),
                            ),
                          ),
                          ButtonSegment<String>(
                            value: 'Sponsor',
                            label: Text(
                              AppStrings.registerAsSponsor,
                              style: TextStyle(
                                fontSize: ResponsiveUtils.getScaledSize(context, screenWidth < 360 ? 12 : 14),
                              ),
                            ),
                          )
                        ],
                        showSelectedIcon: false,
                        style: SegmentedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primaryColor,
                          selectedForegroundColor: Colors.white,
                          selectedBackgroundColor: AppColors.primaryColor,
                          side: BorderSide.none,
                          padding: EdgeInsets.symmetric(
                            vertical: screenWidth < 360 ? 6 : 8
                          ),
                        ),
                        selected: {_selectedRole},
                        onSelectionChanged: (newSelection) {
                          setState(() {
                            _selectedRole = newSelection.first;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: screenWidth < 360 ? 8.w : 10.w,
                      ),
                      child: _selectedRole == 'Player'
                          ? FormRegisterPlayer()
                          : FormRegisterSponsor(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
