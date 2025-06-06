import 'package:equatable/equatable.dart';
import 'package:pickleball_app/core/services/tournament/dto/create_tournament_request.dart';

abstract class CreateTournamentEvent extends Equatable {
  const CreateTournamentEvent();

  @override
  List<Object> get props => [];
}

class CreateTournamentRequestEvent extends CreateTournamentEvent {
  final CreateTournamentRequest createTournamentRequest;

  const CreateTournamentRequestEvent(this.createTournamentRequest);

  @override
  List<Object> get props => [createTournamentRequest];
}
