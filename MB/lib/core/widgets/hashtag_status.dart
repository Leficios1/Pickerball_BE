import 'package:flutter/material.dart';
import 'package:pickleball_app/core/themes/app_theme.dart';

class HashtagStatus extends StatelessWidget {
  final String matchStatus;

  const HashtagStatus({
    Key? key,
    required this.matchStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color getColor() {
      switch (matchStatus) {
        case 'Scheduled':
          return Color(0xFFF59E0B);
        case 'Ongoing':
          return Color(0xFF10B981);
        case 'Completed':
          return Color(0xFF6B7280);
        case 'Disabled':
          return Color(0xFFEF4444);
        default:
          return Colors.black87;
      }
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: getColor().withOpacity(0.1),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
          child: Text(
            matchStatus,
            style: AppTheme.getTheme(context).textTheme.titleMedium?.copyWith(
              color: getColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
