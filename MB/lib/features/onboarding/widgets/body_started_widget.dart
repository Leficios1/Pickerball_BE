import 'package:flutter/material.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/themes/app_theme.dart';

class BodyStartedWidget extends StatelessWidget {
  final String title;
  final String? subTitle;
  final String description;

  const BodyStartedWidget(
      {super.key,
      required this.title,
      this.subTitle,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 35),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title,
                  style: AppTheme.getTheme(context).textTheme.displaySmall),
              SizedBox(
                width: 10,
              ),
              if (subTitle != null)
                Text(subTitle!,
                    style: AppTheme.getTheme(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor
                    )),
            ],
          ),
          Text(
            description,
            style: AppTheme.getTheme(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
