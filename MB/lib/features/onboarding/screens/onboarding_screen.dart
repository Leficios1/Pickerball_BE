import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/utils/animation.dart';
import 'package:pickleball_app/core/utils/extensions.dart';
import 'package:pickleball_app/core/utils/responsive_utils.dart';
import 'package:pickleball_app/features/onboarding/widgets/body_started_widget.dart';
import 'package:pickleball_app/features/onboarding/widgets/img_started_widget.dart';
import 'package:pickleball_app/router/router.gr.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/constants/app_strings.dart';

@RoutePage()
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final ValueNotifier<double> _pageNotifier = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      _pageNotifier.value = _pageController.page ?? 0;
    });
  }

  void navigateToMainPage(BuildContext context) {
    context.router.replace(const HomeRoute());
  }

  void handleNextBtn(BuildContext context) {
    if (_pageNotifier.value == 2) {
      navigateToMainPage(context);
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.linear,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get responsive values
    final screenWidth = context.width;
    final skipButtonHeight = screenWidth < 360 ? 36.h : 40.h;
    final skipButtonWidth = screenWidth < 360 ? 70.w : 80.w;
    final skipButtonFontSize = ResponsiveUtils.getScaledSize(context, screenWidth < 360 ? 13 : 14);
    final dotHeight = screenWidth < 360 ? 6.h : 8.h;
    final dotWidth = screenWidth < 360 ? 6.w : 8.w;
    final nextIconSize = screenWidth < 360 ? 25.sp : 30.sp;
    
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          ValueListenableBuilder<double>(
            valueListenable: _pageNotifier,
            builder: (context, page, child) {
              return Padding(
                padding: EdgeInsets.only(top: 50.h, right: 30.w),
                child: Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    height: skipButtonHeight,
                    width: skipButtonWidth,
                    child: Opacity(
                      opacity: (page >= 1) ? 1.0 : 0.0,
                      child: TextButton(
                        onPressed: () {
                          navigateToMainPage(context);
                        },
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            fontSize: skipButtonFontSize,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          ValueListenableBuilder<double>(
            valueListenable: _pageNotifier,
            builder: (context, page, child) {
              if (page == 1) {
                return ScaleAnimationWidget(
                    child: ImgStartedWidget(
                  isViewedTab2: false,
                  isViewedTab1: true,
                ));
              } else if (page == 2) {
                return ScaleAnimationWidget(
                  child: ImgStartedWidget(
                    isViewedTab2: true,
                    isViewedTab1: true,
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: context.height * (screenWidth < 360 ? 0.38 : 0.4),
              width: context.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      children: const [
                        BodyStartedWidget(
                          title: 'Discover',
                          subTitle: AppStrings.appName,
                          description:
                              'Experience a professional tournament management and ranking system for Pickleball.',
                        ),
                        BodyStartedWidget(
                          title: 'Compete & Rank Up',
                          description:
                              'Track your progress, improve your skills, and climb the leaderboard.',
                        ),
                        BodyStartedWidget(
                          title: 'Connect with the\nCommunity',
                          description:
                              'Join tournaments, engage with players & coaches worldwide.',
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 30.w),
                        child: SmoothPageIndicator(
                          controller: _pageController,
                          count: 3,
                          effect: ExpandingDotsEffect(
                            dotColor: Colors.grey,
                            activeDotColor: AppColors.primaryColor,
                            dotHeight: dotHeight,
                            dotWidth: dotWidth,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          handleNextBtn(context);
                        },
                        iconSize: screenWidth < 360 ? 50 : 60,
                        icon: Container(
                          width: screenWidth < 360 ? 50.w : 60.w,
                          height: screenWidth < 360 ? 50.h : 60.h,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.navigate_next,
                            color: Colors.white,
                            size: nextIconSize,
                          ),
                        ),
                      ),
                      SizedBox(width: 30.w),
                    ],
                  ),
                  SizedBox(height: screenWidth < 360 ? 40.h : 50.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
