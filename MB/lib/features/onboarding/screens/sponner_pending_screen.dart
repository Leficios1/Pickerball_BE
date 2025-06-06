import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickleball_app/core/blocs/app_bloc.dart';
import 'package:pickleball_app/core/blocs/app_event.dart';
import 'package:pickleball_app/core/blocs/app_state.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/utils/extensions.dart';
import 'package:pickleball_app/core/utils/responsive_utils.dart';
import 'package:pickleball_app/core/widgets/app_bar_widget.dart';

@RoutePage()
class SponnerPendingScreen extends StatefulWidget {
  const SponnerPendingScreen({super.key});

  @override
  _SponnerPendingScreenState createState() => _SponnerPendingScreenState();
}

class _SponnerPendingScreenState extends State<SponnerPendingScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      final state = context.read<AppBloc>().state;
      if (state is AppAuthenticatedSponsorPending) {
        context.read<AppBloc>().add(AppUserTypeChecked(
              userInfo: state.userInfo,
              context: context,
            ));
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get responsive values based on screen size
    final screenWidth = context.width;
    final paddingValue = screenWidth < 360 ? 12.0 : 16.0;
    final iconSize = screenWidth < 360 ? 60.0 : 70.0;
    final headingSize = ResponsiveUtils.getScaledSize(context, screenWidth < 360 ? 18 : 20);
    final textSize = ResponsiveUtils.getScaledSize(context, screenWidth < 360 ? 14 : 16);
    
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Sponsor Pending',
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(paddingValue),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.hourglass_top,
              size: iconSize,
              color: AppColors.primaryColor,
            ),
            SizedBox(height: 20.h),
            Text(
              'Your sponsor application is being reviewed',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: headingSize,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Please wait while our team reviews your application. This process may take up to 48 hours.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: textSize,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 40.h),
            ElevatedButton(
              onPressed: () {
                context.read<AppBloc>().add(AppLoggedOut(context: context));
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth < 360 ? 20.w : 24.w, 
                  vertical: screenWidth < 360 ? 10.h : 12.h
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: AppColors.primaryColor,
              ),
              child: Text(
                'Go Back',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: textSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
