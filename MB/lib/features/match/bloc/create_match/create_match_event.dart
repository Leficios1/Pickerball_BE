import 'package:pickleball_app/core/services/match/dto/match_request.dart';

abstract class CreateMatchEvent {}

class CreateMatch extends CreateMatchEvent {
  final CreateMatchRequest match;

  CreateMatch({required this.match});
}
