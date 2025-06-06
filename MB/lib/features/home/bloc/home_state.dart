import 'package:equatable/equatable.dart';
import 'package:pickleball_app/core/models/models.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Tournament> tournaments;
  final List<Map<String, dynamic>> numberPlayer;

  HomeLoaded({required this.tournaments, required this.numberPlayer});

  @override
  List<Object?> get props => [tournaments];
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
