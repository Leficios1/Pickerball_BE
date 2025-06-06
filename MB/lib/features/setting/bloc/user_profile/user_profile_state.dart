import 'package:equatable/equatable.dart';
import 'package:pickleball_app/core/models/models.dart';

abstract class UserProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final User user;

  UserProfileLoaded({required this.user});

  @override
  List<Object?> get props => [user];
}

class UserProfileError extends UserProfileState {
  final String message;

  UserProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}
