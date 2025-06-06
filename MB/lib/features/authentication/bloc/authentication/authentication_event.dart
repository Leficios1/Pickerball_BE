import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthenticationEvent {
  final String email;
  final String password;
  final BuildContext context;

  LoginRequested(this.email, this.password, this.context);

  @override
  List<Object?> get props => [email, password];
}

class RegisterRequested extends AuthenticationEvent {
  final String firstName;
  final String lastName;
  final String secondName;
  final String email;
  final String password;
  final String dateOfBirth;
  final String gender;
  final String phoneNumber;
  final BuildContext context;

  RegisterRequested({
    required this.firstName,
    required this.lastName,
    required this.secondName,
    required this.email,
    required this.password,
    required this.dateOfBirth,
    required this.context,
    required this.gender,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        secondName,
        email,
        password,
        dateOfBirth,
        gender,
        context
      ];
}
