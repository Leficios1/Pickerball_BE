import 'package:pickleball_app/core/models/models.dart';

abstract class MatchesState {}

class MatchesInitial extends MatchesState {}

class MatchesLoading extends MatchesState {}

class MatchesLoaded extends MatchesState {
  final List<Match> matches;

  MatchesLoaded(this.matches);
}

class MyMatchesLoaded extends MatchesState {
  final List<Match> matches;

  MyMatchesLoaded(this.matches);
}

class MatchesError extends MatchesState {
  final String message;

  MatchesError(this.message);
}