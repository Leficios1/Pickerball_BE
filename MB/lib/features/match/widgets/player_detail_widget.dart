import 'package:flutter/material.dart';
import 'package:pickleball_app/core/services/match/dto/get_match_response.dart';
import 'package:pickleball_app/features/setting/widgets/user_info.dart';

class PlayerDetailWidget extends StatefulWidget {
  final MatchData match;
  final List<Map<String, String?>> players;

  const PlayerDetailWidget(
      {Key? key, required this.match, required this.players})
      : super(key: key);

  @override
  _PlayerDetailWidgetState createState() => _PlayerDetailWidgetState();
}

class _PlayerDetailWidgetState extends State<PlayerDetailWidget> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String?>> team1Players =
        widget.players.where((player) => player['name'] == 'Team 1').toList();
    final List<Map<String, String?>> team2Players =
        widget.players.where((player) => player['name'] == 'Team 2').toList();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Home Team',
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold)),
          _buildTeamHeaders(team1Players),
          const Divider(height: 20, thickness: 1),
          Text('Away Team',
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold)),
          _buildTeamHeaders(team2Players),
        ],
      ),
    );
  }

  Widget _buildTeamHeaders(List<Map<String, String?>> teamPlayers) {
    return Column(
      children: [
        for (int i = 0; i < teamPlayers.length; i++)
          UserInfo(
              displayNamePlayer1: teamPlayers[i]['displayName'] ?? '',
              avatarUrlPlayer1: teamPlayers[i]['avatar'] ?? '',
              emailPlayer1: teamPlayers[i]['email'] ?? ''
          )
      ],
    );
  }
}
