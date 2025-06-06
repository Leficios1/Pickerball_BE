import 'package:equatable/equatable.dart';
import 'package:pickleball_app/core/models/models.dart';

abstract class AuthenticationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  final User user;

  AuthenticationSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthenticationFailure extends AuthenticationState {
  final String message;

  AuthenticationFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthenticationRegisterSuccess extends AuthenticationState {
  final int userId;

  AuthenticationRegisterSuccess(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AuthenticationRegisterFailure extends AuthenticationState {
  final String message;

  AuthenticationRegisterFailure(this.message);

  @override
  List<Object?> get props => [message];
}
