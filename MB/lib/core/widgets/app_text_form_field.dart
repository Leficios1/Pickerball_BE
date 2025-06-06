import 'package:flutter/material.dart';
import 'package:pickleball_app/core/utils/extensions.dart';
import 'package:pickleball_app/core/utils/responsive_utils.dart';

class AppTextFormField extends StatefulWidget {
  AppTextFormField({
    required this.textInputAction,
    required this.labelText,
    required this.keyboardType,
    required this.controller,
    super.key,
    this.onChanged,
    this.validator,
    this.obscureText,
    this.suffixIcon,
    this.onEditingComplete,
    this.autofocus,
    this.focusNode,
    this.onTap,
    this.errorText,
    this.readOnly,
    this.showKeyboard,
    this.maxLines,
    this.inputTextStyle,
  });

  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool? obscureText;
  final Widget? suffixIcon;
  final String labelText;
  final bool? autofocus;
  final FocusNode? focusNode;
  final void Function()? onEditingComplete;
  final void Function()? onTap;
  String? errorText;
  final bool? readOnly;
  bool? showKeyboard = true;
  final int? maxLines;
  final TextStyle? inputTextStyle;

  @override
  _AppTextFormFieldState createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      setState(() {
        widget.errorText = widget.validator?.call(widget.controller.text);
      });
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get responsive padding and font size based on screen size
    final responsivePadding = context.width < 360 
        ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12) 
        : const EdgeInsets.symmetric(horizontal: 24, vertical: 14);
    
    final fontSize = ResponsiveUtils.getScaledSize(context, 14);
    final labelSize = ResponsiveUtils.getScaledSize(context, 15);
    
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            textInputAction: widget.textInputAction,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText ?? false,
            autofocus: widget.autofocus ?? false,
            readOnly: widget.readOnly ?? false,
            maxLines: widget.maxLines ?? 1,
            onChanged: widget.onChanged,
            onEditingComplete: widget.onEditingComplete,
            onTap: widget.onTap,
            style: widget.inputTextStyle ?? TextStyle(fontSize: fontSize),
            decoration: InputDecoration(
              labelText: widget.labelText,
              errorText: widget.errorText,
              suffixIcon: widget.suffixIcon,
              contentPadding: responsivePadding,
              labelStyle: TextStyle(
                fontSize: labelSize,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              errorStyle: TextStyle(fontSize: fontSize * 0.85),
            ),
            validator: widget.validator,
          ),
        ],
      ),
    );
  }
}
