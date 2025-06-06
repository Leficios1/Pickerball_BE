import 'package:equatable/equatable.dart';
import 'package:pickleball_app/core/models/models.dart';

abstract class AppState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppInitial extends AppState {}

class AppAuthenticatedPlayer extends AppState {
  final User userInfo;

  AppAuthenticatedPlayer(this.userInfo);

  @override
  List<Object?> get props => [userInfo];
}

class AppAuthenticatedSponsor extends AppState {
  final User userInfo;

  AppAuthenticatedSponsor(this.userInfo);

  @override
  List<Object?> get props => [userInfo];
}

class AppAuthenticatedSponsorPending extends AppState {
  final User userInfo;

  AppAuthenticatedSponsorPending(this.userInfo);

  @override
  List<Object?> get props => [userInfo];
}

class AppUnauthenticated extends AppState {}

class AppLoading extends AppState {}
