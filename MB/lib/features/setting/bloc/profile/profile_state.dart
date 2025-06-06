import 'package:equatable/equatable.dart';
import 'package:pickleball_app/core/models/user.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;

  ProfileLoaded({required this.user});

  @override
  List<Object?> get props => [user];
}

class ProfileUpdated extends ProfileState {
  final User user;

  ProfileUpdated({required this.user});

  @override
  List<Object?> get props => [user];
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}
