import 'package:flutter/material.dart';
import 'package:pickleball_app/core/services/match/dto/get_match_response.dart';
import 'package:pickleball_app/features/match/widgets/team_column_widget.dart';
import 'package:pickleball_app/features/match/widgets/team_headers_widget.dart';

class TeamInfoWidget extends StatelessWidget {
  final MatchData match;
  final List<Map<String, String?>> players;
  final bool isOwner;

  const TeamInfoWidget({
    super.key,
    required this.match,
    required this.players,
    required this.isOwner,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          const TeamHeadersWidget(),
          _buildPlayerCards(match, players, isOwner, context),
        ],
      ),
    );
  }

  Widget _buildPlayerCards(
      MatchData match, List<Map<String, String?>> players, bool isOwner, BuildContext context) {
    final Widget verticalDivider = Container(
      width: 1,
      height: 100,
      color: Colors.white54,
    );
    
    final List<Map<String, String?>> team1Players =
        players.where((player) => player['name'] == 'Team 1').toList();
    final List<Map<String, String?>> team2Players =
        players.where((player) => player['name'] == 'Team 2').toList();
        
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.22,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Team 1
            TeamColumnWidget(
              teamPlayers: team1Players,
              maxPlayers: match.matchFormat == 1 ? 1 : 2, // Single: 1, Double: 2
              isOwner: isOwner,
              matchId: match.id,
            ),
            const SizedBox(width: 20),
            verticalDivider,
            const SizedBox(width: 20),
            // Team 2
            TeamColumnWidget(
              teamPlayers: team2Players,
              maxPlayers: match.matchFormat == 1 ? 1 : 2,
              isOwner: isOwner,
              matchId: match.id,
            ),
          ],
        ),
      ),
    );
  }
}
