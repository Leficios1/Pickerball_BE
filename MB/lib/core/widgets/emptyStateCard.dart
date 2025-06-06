import 'package:flutter/material.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/themes/app_theme.dart';

class EmptyStateCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color? iconColor;
  final double? iconSize;

  const EmptyStateCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    this.iconColor,
    this.iconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(
                icon,
                color: iconColor ?? AppColors.primaryColor,
                size: iconSize ?? 40,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: AppTheme.getTheme(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: AppTheme.getTheme(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
