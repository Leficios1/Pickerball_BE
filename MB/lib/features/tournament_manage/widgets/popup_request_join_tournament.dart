import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickleball_app/core/models/registration_details.dart';
import 'package:pickleball_app/features/setting/widgets/user_info.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_bloc.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_event.dart';

class RequestJoinTournamentPopup extends StatelessWidget {
  final int tournamentId;
  final RegistrationDetails registrationDetails;

  const RequestJoinTournamentPopup({
    Key? key,
    required this.registrationDetails,
    required this.tournamentId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Tournament participation requirements:'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserInfo(
            displayNamePlayer1:
                '${registrationDetails.playerDetails.firstName}, ${registrationDetails.playerDetails..lastName} ${registrationDetails.playerDetails..secondName}',
            avatarUrlPlayer1: registrationDetails.playerDetails.avatarUrl,
            emailPlayer1: registrationDetails.playerDetails.email,
            onPressed: () {},
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
            context.read<TournamentBloc>().add(RequestJoinTournament(
                status: false, tournamentId: tournamentId));
          },
          child: Text(
            'Reject',
            style: TextStyle(color: Colors.red),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            context.read<TournamentBloc>().add(RequestJoinTournament(
                status: true, tournamentId: tournamentId));
          },
          child: Text('Accept'),
        ),
      ],
    );
  }
}
