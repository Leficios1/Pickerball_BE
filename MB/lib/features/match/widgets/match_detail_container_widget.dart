import 'package:flutter/material.dart';
import 'package:pickleball_app/core/constants/app_enums.dart';
import 'package:pickleball_app/core/services/match/dto/get_match_response.dart';
import 'package:pickleball_app/core/services/user/dto/user_response.dart';
import 'package:pickleball_app/core/services/venue/dto/venues_response.dart';
import 'package:pickleball_app/core/utils/extensions.dart';
import 'package:pickleball_app/features/match/widgets/match_detail_widget.dart';
import 'package:pickleball_app/features/match/widgets/player_detail_widget.dart';
import 'package:pickleball_app/features/match/widgets/scoreboard_widget.dart';
import 'package:pickleball_app/features/match/widgets/segmented_control_widget.dart';

class MatchDetailContainerWidget extends StatefulWidget {
  final bool isOwner;
  final MatchData match;
  final List<Map<String, String?>> players;
  final UserResponse referees;
  final List<VenuesResponse> venues;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController dateController;
  final TextEditingController team1Controller;
  final TextEditingController team2Controller;
  final String? teamError;
  final Function(String?) onTitleChanged;
  final Function(String?) onDescriptionChanged;
  final Function(DateTime?) onMatchDateChanged;
  final Function(int?) onVenueChanged;
  final Function(int?) onRefereeChanged;
  final Function(MatchCategory?) onMatchCategoryChanged;
  final Function(TournamentFormant?) onMatchFormatChanged;
  final Function(MatchWinScore?) onWinScoreChanged;
  final Function(String, int, int) onScoreChanged;

  const MatchDetailContainerWidget({
    super.key,
    required this.isOwner,
    required this.match,
    required this.players,
    required this.referees,
    required this.venues,
    required this.titleController,
    required this.descriptionController,
    required this.dateController,
    required this.team1Controller,
    required this.team2Controller,
    this.teamError,
    required this.onTitleChanged,
    required this.onDescriptionChanged,
    required this.onMatchDateChanged,
    required this.onVenueChanged,
    required this.onRefereeChanged,
    required this.onMatchCategoryChanged,
    required this.onMatchFormatChanged,
    required this.onWinScoreChanged,
    required this.onScoreChanged,
  });

  @override
  State<MatchDetailContainerWidget> createState() => _MatchDetailContainerWidgetState();
}

class _MatchDetailContainerWidgetState extends State<MatchDetailContainerWidget> {
  String _selectedOption = 'Option 1';

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 8.h),
            SegmentedControlWidget(
              match: widget.match,
              selectedOption: _selectedOption,
              onSelectionChanged: (newSelection) {
                setState(() {
                  _selectedOption = newSelection.first;
                });
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: _buildSelectedContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedContent() {
    if (_selectedOption == 'Option 1') {
      return MatchDetailWidget(
        match: widget.match,
        isOwner: widget.isOwner,
        venues: widget.venues,
        referees: widget.referees,
        titleController: widget.titleController,
        onTitleChanged: widget.onTitleChanged,
        onDescriptionChanged: widget.onDescriptionChanged,
        onMatchDateChanged: widget.onMatchDateChanged,
        descriptionController: widget.descriptionController,
        matchDateController: widget.dateController,
        onVenueChanged: widget.onVenueChanged,
        onRefereeChanged: widget.onRefereeChanged,
        onMatchCategoryChanged: widget.onMatchCategoryChanged,
        onMatchFormatChanged: widget.onMatchFormatChanged,
        onWinScoreChanged: widget.onWinScoreChanged,
      );
    } else if (_selectedOption == 'Option 2') {
      return PlayerDetailWidget(match: widget.match, players: widget.players);
    } else {
      TextEditingController team1Controller = TextEditingController();
      TextEditingController team2Controller = TextEditingController();
      if(widget.match.status == MatchStatus.completed.value){
        team1Controller.text = widget.match.team1Score.toString();
        team2Controller.text = widget.match.team2Score.toString();
      }else{
        team1Controller = widget.team1Controller;
        team2Controller = widget.team2Controller;
      }
      return ScoreboardWidget(
        match: widget.match,
        team1Controller: team1Controller,
        team2Controller: team2Controller,
        onScoreChanged: widget.onScoreChanged,
        teamError: widget.teamError,
      );
    }
  }
}
