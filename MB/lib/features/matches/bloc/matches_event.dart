abstract class MatchesEvent {}

class LoadAllMatches extends MatchesEvent {}

class LoadMyMatches extends MatchesEvent {
  final int userId;

  LoadMyMatches(this.userId);
}