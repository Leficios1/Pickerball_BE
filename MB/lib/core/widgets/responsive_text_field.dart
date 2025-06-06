import 'package:flutter/material.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/utils/responsive_utils.dart';

class ResponsiveTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? minLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final bool autofocus;
  final TextInputAction? textInputAction;
  final bool enabled;

  const ResponsiveTextField({
    Key? key,
    this.controller,
    this.labelText,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.minLines,
    this.readOnly = false,
    this.onTap,
    this.focusNode,
    this.contentPadding,
    this.autofocus = false,
    this.textInputAction,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveUtils.getDeviceType(context);
    
    // Adjust style based on screen size
    final fontSize = (deviceType == DeviceScreenType.mobile)
        ? 14.0
        : (deviceType == DeviceScreenType.tablet)
            ? 16.0
            : 18.0;
            
    final defaultPadding = (deviceType == DeviceScreenType.mobile)
        ? const EdgeInsets.symmetric(vertical: 12, horizontal: 16)
        : (deviceType == DeviceScreenType.tablet)
            ? const EdgeInsets.symmetric(vertical: 16, horizontal: 20)
            : const EdgeInsets.symmetric(vertical: 20, horizontal: 24);
    
    return LayoutBuilder(
      builder: (context, constraints) {
        // Constrain max width on larger screens
        final maxWidth = (deviceType == DeviceScreenType.desktop)
            ? 500.0
            : constraints.maxWidth;
            
        return Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            onChanged: onChanged,
            validator: validator,
            maxLines: maxLines,
            minLines: minLines,
            readOnly: readOnly,
            onTap: onTap,
            focusNode: focusNode,
            autofocus: autofocus,
            textInputAction: textInputAction,
            enabled: enabled,
            style: TextStyle(fontSize: fontSize),
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              contentPadding: contentPadding ?? defaultPadding,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.gray),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.gray),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
            ),
          ),
        );
      }
    );
  }
}
