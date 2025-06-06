import 'package:flutter/material.dart';

import 'app_text_form_field.dart';

class DatePickerField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTap;
  final String labelText;
  final bool readOnly;

  const DatePickerField(
      {super.key,
      required this.controller,
      required this.onTap,
      required this.labelText,
      this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      controller: controller,
      labelText: labelText,
      keyboardType: TextInputType.none,
      textInputAction: TextInputAction.done,
      suffixIcon: Icon(Icons.calendar_today),
      onTap: onTap,
      readOnly: readOnly,
      showKeyboard: false,
    );
  }
}
