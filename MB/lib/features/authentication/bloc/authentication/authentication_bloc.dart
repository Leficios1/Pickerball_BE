import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickleball_app/core/blocs/app_bloc.dart';
import 'package:pickleball_app/core/blocs/app_event.dart';
import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/constants/app_strings.dart';
import 'package:pickleball_app/core/errors/error_handler.dart';
import 'package:pickleball_app/core/services/authentication/dto/login_request.dart';
import 'package:pickleball_app/core/services/authentication/dto/register_request.dart';
import 'package:pickleball_app/core/utils/snackbar_helper.dart';
import 'package:pickleball_app/features/authentication/bloc/authentication/authentication_event.dart';
import 'package:pickleball_app/features/authentication/bloc/authentication/authentication_state.dart';
import 'package:pickleball_app/router/router.gr.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AppBloc appBloc;

  AuthenticationBloc({required this.appBloc}) : super(AuthenticationInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    try {
      final LoginRequest loginRequest = LoginRequest(
        email: event.email,
        password: event.password,
      );
      final userInfo = await globalAuthService.login(loginRequest);
      emit(AuthenticationSuccess(userInfo));
      SnackbarHelper.showSnackBar(AppStrings.loginSuccessful);
      appBloc.add(AppLoggedIn(userInfo, event.context));
      await Future.delayed(const Duration(seconds: 3));
      AutoRouter.of(event.context).replace(const HomeRoute());
    } catch (error) {
      print('Login error: $error');
      emit(AuthenticationFailure('Wrong password or password. Please re-enter.'));
    }
  }

  Future<void> _onRegisterRequested(
      RegisterRequested event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    try {
      final RegisterRequest registerRequest = RegisterRequest(
          firstName: event.firstName,
          lastName: event.lastName,
          secondName: event.secondName,
          email: event.email,
          passwordHash: event.password,
          dateOfBirth: event.dateOfBirth,
          gender: event.gender,
          phoneNumber: event.phoneNumber);
      final userInfo = await globalAuthService.register(registerRequest);
      emit(AuthenticationRegisterSuccess(userInfo));
      SnackbarHelper.showSnackBar(AppStrings.registrationSuccessful);
      await Future.delayed(const Duration(seconds: 3));
      AutoRouter.of(event.context).push(RegisterRoleRoute());
    } catch (error) {
      final errorMessage = ErrorHandler.handleApiError(error, 'en');
      SnackbarHelper.showSnackBar(errorMessage.toString());
      emit(AuthenticationRegisterFailure(errorMessage.toString()));
    }
  }
}
