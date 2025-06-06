import 'package:flutter/material.dart';
import 'package:pickleball_app/core/constants/app_enums.dart';
import 'package:pickleball_app/core/constants/app_strings.dart';
import 'package:pickleball_app/core/services/match/dto/get_match_response.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';

class SegmentedControlWidget extends StatelessWidget {
  final MatchData match;
  final String selectedOption;
  final Function(Set<String>) onSelectionChanged;

  const SegmentedControlWidget({
    super.key,
    required this.match,
    required this.selectedOption,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: SegmentedButton<String>(
          segments: [
            ButtonSegment<String>(
              value: 'Option 1',
              label: Text(AppStrings.matchDetail),
            ),
            ButtonSegment<String>(
              value: 'Option 2',
              label: Text(AppStrings.playerDetail),
            ),
            if (MatchCategory.fromValue(match.matchCategory)!.label ==
                'Tournament') ...[
              ButtonSegment<String>(
                value: 'Option 3',
                label: Text('Score'),
              ),
            ],
            if (MatchCategory.fromValue(match.matchCategory)!.label !=
                'Tournament') ...[
              if (match.status == 2 || match.status == 3) ...[
                ButtonSegment<String>(
                  value: 'Option 3',
                  label: Text('Score'),
                ),
              ]
            ],
          ],
          showSelectedIcon: false,
          style: SegmentedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primaryColor,
            selectedForegroundColor: Colors.white,
            selectedBackgroundColor: AppColors.primaryColor,
            side: BorderSide.none,
          ),
          selected: {selectedOption},
          onSelectionChanged: onSelectionChanged,
        ),
      ),
    );
  }
}
