import 'package:pickleball_app/core/models/models.dart';

abstract class RankingState {}

class RankingInitial extends RankingState {}

class RankingLoading extends RankingState {}

class RankingLoaded extends RankingState {
  final List<Rankings> rankings;

  RankingLoaded(this.rankings);
}

class RankingError extends RankingState {
  final String message;

  RankingError(this.message);
}