import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pickleball_app/core/models/models.dart';

abstract class AppEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppStarted extends AppEvent {
  final BuildContext context;

  AppStarted({required this.context});

  @override
  List<Object?> get props => [];
}

class AppLoggedIn extends AppEvent {
  final User userInfo;
  final BuildContext context;

  AppLoggedIn(this.userInfo, this.context);

  @override
  List<Object?> get props => [];
}

class AppLoggedOut extends AppEvent {
  final BuildContext context;

  AppLoggedOut({required this.context});

  @override
  List<Object?> get props => [];
}

class AppUserTypeChecked extends AppEvent {
  final User userInfo;
  final BuildContext context;

  AppUserTypeChecked({required this.userInfo, required this.context});

  @override
  List<Object?> get props => [userInfo];
}

class UpdateTabIndex extends AppEvent {
  final int index;
  final BuildContext context;

  UpdateTabIndex({required this.index, required this.context});

  @override
  List<Object?> get props => [index, context];
}

class UpdateUserInfo extends AppEvent {
  final User userInfo;

  UpdateUserInfo({required this.userInfo});

  @override
  List<Object?> get props => [userInfo];
}
