import 'package:equatable/equatable.dart';

abstract class QuickMatchState extends Equatable {
  const QuickMatchState();
  
  @override
  List<Object> get props => [];
}

class QuickMatchInitial extends QuickMatchState {}

class LoadUserInfo extends QuickMatchState {
  final String city;
  final int matchFormat;
  final int ranking;
  final String userName;
  
  const LoadUserInfo({
    required this.city,
    required this.matchFormat,
    required this.ranking,
    required this.userName,
  });
  
  @override
  List<Object> get props => [city, matchFormat, ranking, userName];
}

class QuickMatchSearching extends QuickMatchState {}

class QuickMatchFound extends QuickMatchState {
  final Map<String, dynamic> matchDetails;
  
  const QuickMatchFound(this.matchDetails);
  
  @override
  List<Object> get props => [matchDetails];
}

class QuickMatchCancelled extends QuickMatchState {}

class QuickMatchError extends QuickMatchState {
  final String message;
  
  const QuickMatchError(this.message);
  
  @override
  List<Object> get props => [message];
}
