import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pickleball_app/core/services/user/dto/update_user_request.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {

  LoadProfile();

  @override
  List<Object?> get props => [];
}

class EditProfile extends ProfileEvent {
  final UpdateUserRequest request;
  final BuildContext context;

  EditProfile({
    required this.request,
    required this.context,
  });

  @override
  List<Object?> get props => [request, context];
}
