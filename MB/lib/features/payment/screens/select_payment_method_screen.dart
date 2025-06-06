import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/utils/extensions.dart';
import 'package:pickleball_app/core/utils/responsive_utils.dart';
import 'package:pickleball_app/core/widgets/app_bar_widget.dart';

import '../../../core/constants/app_enums.dart';
import '../../../generated/assets.dart';

@RoutePage()
class SelectPaymentMethodScreen extends StatefulWidget {
  final int? amount;
  final int? registrationId;
  final int? tournamentId;
  final Function(PaymentMethod) onPaymentSelected;

  const SelectPaymentMethodScreen({
    super.key,
    this.amount,
    this.registrationId,
    this.tournamentId,
    required this.onPaymentSelected,
  });

  @override
  State<SelectPaymentMethodScreen> createState() => _SelectPaymentMethodScreenState();
}

class _SelectPaymentMethodScreenState extends State<SelectPaymentMethodScreen> {
  PaymentMethod? _selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    // Get responsive values
    final screenWidth = context.width;
    final paddingValue = screenWidth < 360 ? 12.0 : 16.0;
    final titleFontSize = ResponsiveUtils.getScaledSize(context, screenWidth < 360 ? 15 : 16);
    final iconSize = screenWidth < 360 ? 44.0 : 50.0;
    final optionTitleSize = ResponsiveUtils.getScaledSize(context, screenWidth < 360 ? 15 : 16);
    final optionSubtitleSize = ResponsiveUtils.getScaledSize(context, screenWidth < 360 ? 12 : 14);
    final buttonHeight = screenWidth < 360 ? 46.0 : 52.0;
    final buttonFontSize = ResponsiveUtils.getScaledSize(context, screenWidth < 360 ? 14 : 16);
    
    return Scaffold(
      appBar: AppBarWidget(title: 'Select Payment Method'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(paddingValue),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16.h),
              Text(
                'Choose your payment method:',
                style: TextStyle(
                  fontSize: titleFontSize, 
                  fontWeight: FontWeight.w500
                ),
              ),
              SizedBox(height: 12.h),
              
              // VNPay option
              _buildPaymentOption(
                icon: Assets.imagesImgVnPay,
                title: 'VNPay',
                subtitle: 'Pay with VNPay wallet',
                paymentMethod: PaymentMethod.vnpay,
                iconSize: iconSize,
                titleSize: optionTitleSize,
                subtitleSize: optionSubtitleSize,
              ),
              
              SizedBox(height: 12.h),
              
              // PayOS option
              _buildPaymentOption(
                icon: Assets.imagesImgPayos,
                title: 'PayOS',
                subtitle: 'Quick payment with PayOS',
                paymentMethod: PaymentMethod.payos,
                iconSize: iconSize,
                titleSize: optionTitleSize,
                subtitleSize: optionSubtitleSize,
              ),
              
              const Spacer(),
              
              // Confirm button
              SizedBox(
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: _selectedPaymentMethod != null
                      ? () => widget.onPaymentSelected(_selectedPaymentMethod!)
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    backgroundColor: AppColors.primaryColor,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Confirm Payment Method',
                    style: TextStyle(
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.bold,
                      color: _selectedPaymentMethod != null ? Colors.white : Colors.grey.shade500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String icon,
    required String title,
    required String subtitle,
    required PaymentMethod paymentMethod,
    required double iconSize,
    required double titleSize,
    required double subtitleSize,
  }) {
    final bool isSelected = _selectedPaymentMethod == paymentMethod;
    final screenWidth = context.width;
    final borderRadius = screenWidth < 360 ? 8.0 : 12.0;
    final padding = screenWidth < 360 ? 12.0 : 16.0;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = paymentMethod;
        });
      },
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          children: [
            Container(
              width: iconSize,
              height: iconSize,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                icon,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.payment,
                  color: Colors.grey.shade700,
                  size: iconSize * 0.6,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: subtitleSize,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primaryColor,
                size: iconSize * 0.48,
              ),
          ],
        ),
      ),
    );
  }
}
