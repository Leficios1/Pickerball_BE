import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/themes/app_theme.dart';
import 'package:pickleball_app/core/widgets/app_bar_widget.dart';
import 'package:pickleball_app/core/widgets/app_text_form_field.dart';
import 'package:pickleball_app/core/widgets/select_button_widget.dart';
import 'package:pickleball_app/features/payment/bloc/payment_bloc.dart';
import 'package:pickleball_app/features/payment/bloc/payment_event.dart';
import 'package:pickleball_app/features/payment/bloc/payment_state.dart';
import 'package:pickleball_app/features/payment/widgets/payment_web_view.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_bloc.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_state.dart';
import 'package:pickleball_app/router/router.gr.dart';

@RoutePage()
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<StatefulWidget> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final ValueNotifier<int?> _selectedValueNotifier = ValueNotifier<int?>(null);
  final ValueNotifier<bool> _isAmountValidNotifier = ValueNotifier(false);
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final FocusNode _amountFocusNode;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController()
      ..addListener(() {
        final amount = int.tryParse(_amountController.text);
        if (amount != null && amount >= 10000) {
          _isAmountValidNotifier.value = true;
        } else {
          _isAmountValidNotifier.value = false;
        }
        setState(() {
          _selectedValueNotifier.value = null;
        });
      });

    _amountFocusNode = FocusNode();
    _amountFocusNode.addListener(() {
      if (!_amountFocusNode.hasFocus) {
        setState(() {
          _selectedValueNotifier.value = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _selectedValueNotifier.dispose();
    _isAmountValidNotifier.dispose();
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Payment',
        automaticallyImplyLeading: true,
      ),
      backgroundColor: AppColors.primaryColor,
      body: BlocListener<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is CheckPaymentSuccess) {
            AutoRouter.of(context).replace(PaymentSuccessRoute());
          } else if (state is PaymentFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: BlocBuilder<PaymentBloc, PaymentState>(
          builder: (context, state) {
            if (state is OpenPaymentUrlState) {
              WebUri url = WebUri(state.url);
              return PaymentWebView(
                  initialUrl: url, tournamentId: state.tournamentId, paymentMethod: state.paymentMethod);
            } else if (state is DonateInProgress) {
              return Container(
                color: Colors.white,
                child: Center(
                  child: LoadingAnimationWidget.threeRotatingDots(
                    color: AppColors.primaryColor,
                    size: 50,
                  ),
                ),
              );
            } else {
              return BlocBuilder<TournamentBloc, TournamentState>(
                builder: (context, tournamentState) {
                  if (tournamentState is DonateForTournamentLoaded) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Image.network(
                              tournamentState.tournament.banner,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10, left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                Column(
                                  children: [
                                    Center(
                                      child: Text(
                                        '🏆 SUPPORT THE TOURNAMENT 🏆',
                                        style: AppTheme.getTheme(context).textTheme.displayMedium?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      tournamentState.tournament.name,
                                      style: AppTheme.getTheme(context).textTheme.displayMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '✨ Help make the PickerBall tournament even more exciting with your support!',
                                  style: AppTheme.getTheme(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '✨ Your donation will help:\n'
                                  '  ✅ Improve the tournament quality\n'
                                  '  ✅ Support athlete expenses\n'
                                  '  ✅ Create a professional and fair playing field',
                                  style: AppTheme.getTheme(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: SelectableButtonList(
                              labels: [
                                '100.000.000đ',
                                '50.000.000đ',
                                '10.000.000đ'
                              ],
                              values: [100000000, 50000000, 10000000],
                              onSelected: (value) {
                                _selectedValueNotifier.value = value;
                                _amountController.clear();
                              },
                              selectedValue: _selectedValueNotifier.value,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10, left: 10),
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Center(
                                  child: Text(
                                    'Or',
                                    style: AppTheme.getTheme(context).textTheme.titleLarge?.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Form(
                                    key: _formKey,
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: AppTextFormField(
                                          textInputAction: TextInputAction.done,
                                          labelText: 'Enter amount',
                                          keyboardType: TextInputType.number,
                                          controller: _amountController,
                                          focusNode: _amountFocusNode,
                                          inputTextStyle: TextStyle(
                                            color: _isAmountValidNotifier.value
                                                ? Colors.white
                                                : Colors.red,
                                          ),
                                          onChanged: (_) =>
                                              _formKey.currentState?.validate(),
                                          validator: (value) {
                                            final amount =
                                                int.tryParse(value ?? '');
                                            if (amount != null &&
                                                amount < 10000) {
                                              return 'Amount must be at least 10000đ';
                                            }
                                            return null;
                                          },
                                        ))),
                                const SizedBox(height: 20),
                                ValueListenableBuilder<int?>(
                                  valueListenable: _selectedValueNotifier,
                                  builder: (context, selectedValue, child) {
                                    final amount = selectedValue ??
                                        int.tryParse(_amountController.text);
                                    return Center(
                                      child: FilledButton(
                                        onPressed: amount != null
                                            ? () {
                                          context.router.push(SelectPaymentMethodRoute(
                                            amount: amount,
                                            onPaymentSelected: (selectedPaymentMethod) {
                                              context
                                                  .read<PaymentBloc>()
                                                  .add(InitiatePayment(
                                                    tournamentId: tournamentState
                                                        .tournament.id,
                                                    amount: amount,
                                                    paymentMethod:
                                                        selectedPaymentMethod,
                                                  ));
                                            },
                                          ));
                                              }
                                            : null,
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 40, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          backgroundColor: amount != null
                                              ? Colors.white
                                              : Colors.grey,
                                        ),
                                        child: Text(
                                          'Donate',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: amount != null
                                                ? AppColors.primaryColor
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '✨ Every contribution is motivation for the athletes to give their best! 🙌',
                                  style: AppTheme.getTheme(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
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
                },
              );
            }
          },
        ),
      ),
    );
  }
}
