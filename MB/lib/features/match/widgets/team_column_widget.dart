import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickleball_app/features/match/bloc/match_bloc.dart';
import 'package:pickleball_app/features/match/bloc/match_event.dart';
import 'package:pickleball_app/features/match/widgets/Invite_player.dart';
import 'package:pickleball_app/features/match/widgets/player_card.dart';

class TeamColumnWidget extends StatelessWidget {
  final List<Map<String, String?>>? teamPlayers;
  final int maxPlayers;
  final bool isOwner;
  final int matchId;

  const TeamColumnWidget({
    super.key,
    required this.teamPlayers,
    required this.maxPlayers,
    required this.isOwner,
    required this.matchId,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 25,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (var i = 0; i < maxPlayers; i++)
            if (teamPlayers != null && i < teamPlayers!.length)
              PlayerCard(
                displayName: teamPlayers![i]['displayName'] ?? '',
                imageUrl: teamPlayers![i]['avatar'] ?? '',
              )
            else
              SizedBox(
                height: 100,
                child: IconButton(
                  onPressed: isOwner
                      ? () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AddPlayerPopup(
                              matchId: matchId,
                            ),
                          );
                        }
                      : () {
                          context.read<MatchBloc>().add(JoinMatch(
                                matchId: matchId,
                                context: context,
                              ));
                        },
                  icon: Icon(Icons.add, color: Colors.white),
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(CircleBorder()),
                    side: WidgetStateProperty.all(
                        BorderSide(color: Colors.white)),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
