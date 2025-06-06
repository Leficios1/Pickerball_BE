import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/utils/extensions.dart';
import 'package:pickleball_app/core/utils/responsive_utils.dart';
import 'package:pickleball_app/core/widgets/app_bar_widget.dart';
import 'package:pickleball_app/features/payment/bloc/payment_bloc.dart';
import 'package:pickleball_app/features/payment/bloc/payment_state.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_bloc.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_event.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_state.dart';
import 'package:pickleball_app/router/router.gr.dart';

@RoutePage()
class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    // Get responsive values
    final screenWidth = context.width;
    final iconSize = screenWidth < 360 ? 70.0 : 80.0;
    final titleFontSize = ResponsiveUtils.getScaledSize(context, screenWidth < 360 ? 18 : 20);
    final messagePadding = EdgeInsets.symmetric(
      horizontal: screenWidth < 360 ? 8.w : 10.w,
      vertical: 12.h
    );
    final buttonHeight = screenWidth < 360 ? 48.0 : 52.0;
    
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Bill Payment', 
        automaticallyImplyLeading: false
      ),
      body: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          if (state is CheckPaymentSuccess) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle, 
                    color: Colors.green, 
                    size: iconSize
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Payment Successful!",
                    style: TextStyle(
                      fontSize: titleFontSize, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: messagePadding,
                    child: Text(
                      "Thank you for your payment. Your tournament registration is complete.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: ResponsiveUtils.getScaledSize(context, 14),
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: SizedBox(
                      height: buttonHeight,
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          context.read<TournamentBloc>().add(
                            SelectTournament(state.tournamentId)
                          );
                          BlocListener<TournamentBloc, TournamentState>(
                            listener: (context, state) {
                              if (state is TournamentDetailLoading) {
                                context.router.replace(DetailTournamentRoute());
                              }
                            },
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                        ),
                        child: Text(
                          'Back to Tournament Details',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveUtils.getScaledSize(context, 15),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }

          // Processing state
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: AppColors.primaryColor),
                SizedBox(height: 24.h),
                Text(
                  "Processing Payment...",
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getScaledSize(context, 16),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
