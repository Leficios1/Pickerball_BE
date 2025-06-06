import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickleball_app/core/blocs/app_bloc.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/themes/app_theme.dart';
import 'package:pickleball_app/core/utils/extensions.dart';
import 'package:pickleball_app/core/utils/responsive_utils.dart';
import 'package:pickleball_app/core/widgets/responsive_container.dart';
import 'package:pickleball_app/features/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:pickleball_app/features/authentication/widgets/form_login.dart';
import 'package:pickleball_app/features/authentication/widgets/form_register.dart';
import '../../../core/constants/app_strings.dart';

@RoutePage()
class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  String _selectedOption = 'Option 1';

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final screenWidth = context.width;
    final screenHeight = context.height;
    final padding = ResponsiveUtils.responsivePadding(context);
    
    // Adjust heights based on screen size
    final headerHeightFraction = screenWidth < 360 ? 0.22 : 0.25;
    final contentHeightFraction = isPortrait 
        ? (screenWidth < 360 ? 0.78 : 0.75)
        : (screenWidth < 360 ? 0.8 : 0.85);
    
    // Adjust text sizes
    final headingSize = ResponsiveUtils.getScaledSize(context, screenWidth < 360 ? 24 : 28);
    final subheadingSize = ResponsiveUtils.getScaledSize(context, screenWidth < 360 ? 14 : 16);
    
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ResponsiveContainer(
                      mobileHeight: screenHeight * headerHeightFraction,
                      alignment: const Alignment(0, -0.3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.getStartedNow,
                            style: TextStyle(
                              fontSize: headingSize,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            AppStrings.subTitleStartedNow,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: subheadingSize,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: padding,
                      height: screenHeight * contentHeightFraction,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: screenWidth * (screenWidth < 360 ? 0.8 : 0.7),
                            child: SegmentedButton<String>(
                              segments: [
                                ButtonSegment<String>(
                                  value: 'Option 1',
                                  label: Text(
                                    AppStrings.login,
                                    style: TextStyle(
                                      fontSize: ResponsiveUtils.getScaledSize(context, screenWidth < 360 ? 14 : 16),
                                    ),
                                  ),
                                ),
                                ButtonSegment<String>(
                                  value: 'Option 2',
                                  label: Text(
                                    AppStrings.signUp,
                                    style: TextStyle(
                                      fontSize: ResponsiveUtils.getScaledSize(context, screenWidth < 360 ? 14 : 16),
                                    ),
                                  )
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
                                  vertical: screenWidth < 360 ? 6 : 8,
                                  horizontal: screenWidth < 360 ? 4 : 8,
                                ),
                              ),
                              selected: {_selectedOption},
                              onSelectionChanged: (newSelection) {
                                setState(() {
                                  _selectedOption = newSelection.first;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth < 360 ? 4.w : 8.w,
                              ),
                              child: _selectedOption == 'Option 1'
                                  ? BlocProvider(
                                      create: (context) => AuthenticationBloc(
                                        appBloc: context.read<AppBloc>(),
                                      ),
                                      child: const FormLogin(),
                                    )
                                  : const FormRegister(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
