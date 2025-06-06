import 'package:flutter/material.dart';
import 'package:pickleball_app/core/constants/app_enums.dart';
import 'package:pickleball_app/core/themes/app_theme.dart';

class HashtagMatchFormat extends StatelessWidget {
  final MatchFormat matchFormat;

  const HashtagMatchFormat({
    super.key,
    required this.matchFormat,
  });

  @override
  Widget build(BuildContext context) {
    Color getColor() {
      switch (matchFormat) {
        case MatchFormat.singleMale:
          return const Color(0xFF3B82F6);
        case MatchFormat.singleFemale:
          return const Color(0xFFA855F7);
        case MatchFormat.doubleMale:
          return const Color(0xFF2563EB);
        case MatchFormat.doubleFemale:
          return const Color(0xFFF472B6);
        case MatchFormat.doubleMix:
          return const Color(0xFF9333EA);
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
            matchFormat.subLabel,
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
