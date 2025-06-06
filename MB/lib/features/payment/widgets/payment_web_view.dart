import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pickleball_app/core/constants/app_enums.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/features/payment/bloc/payment_bloc.dart';
import 'package:pickleball_app/features/payment/bloc/payment_event.dart';
import 'package:pickleball_app/features/payment/bloc/payment_state.dart';
import 'package:pickleball_app/router/router.gr.dart';

class PaymentWebView extends StatefulWidget {
  final WebUri initialUrl;
  final int tournamentId;
  final PaymentMethod paymentMethod;

  const PaymentWebView(
      {super.key, required this.initialUrl, required this.tournamentId, required this.paymentMethod});

  @override
  _PaymentWebViewState createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late InAppWebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state is CheckPaymentSuccess) {
          AutoRouter.of(context).replace(PaymentSuccessRoute());
        } else if (state is PaymentFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        if (state is DonateInProgress) {
          return Container(
            color: Colors.white,
            child: Center(
              child: LoadingAnimationWidget.threeRotatingDots(
                color: AppColors.primaryColor,
                size: 50,
              ),
            ),
          );
        }
        return InAppWebView(
          initialUrlRequest: URLRequest(url: widget.initialUrl),
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          onLoadStart: (controller, url) {
            debugPrint("Loading URL: $url");
          },
          onLoadStop: (controller, url) async {
            debugPrint("Loaded URL: $url");
            if (url != null && (url.toString().contains("vnp_ResponseCode=00") ||
                url.toString().contains("status=PAID"))) {
              context.read<PaymentBloc>().add(
                    ReturnUrlPaymentSuccess(
                        url: url.toString(), tournamentId: widget.tournamentId, paymentMethod: widget.paymentMethod),
                  );
            }
          },
          onReceivedError: (controller, request, error) {
            debugPrint("Error: $error");
          },
        );
      },
    );
  }
}
