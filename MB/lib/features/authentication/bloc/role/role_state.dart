import 'package:equatable/equatable.dart';

abstract class RoleState extends Equatable {
  const RoleState();

  @override
  List<Object> get props => [];
}

class RoleInitial extends RoleState {}

class RoleRegistering extends RoleState {}

class RoleRegisterSuccess extends RoleState {}

class RoleRegisterFailure extends RoleState {
  final String message;

  const RoleRegisterFailure(this.message);

  @override
  List<Object> get props => [message];
}
