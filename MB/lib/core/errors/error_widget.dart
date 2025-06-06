import 'package:flutter/material.dart';

import 'error_model.dart';

class ErrorDisplayWidget extends StatelessWidget {
  final ErrorModel error;

  const ErrorDisplayWidget({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        error.message,
        style: const TextStyle(color: Colors.red, fontSize: 16),
      ),
    );
  }
}
