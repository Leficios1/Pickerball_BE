import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickleball_app/core/constants/app_enums.dart';
import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/services/player/index.dart';
import 'package:pickleball_app/core/services/sponner/dto/sponner_request.dart';
import 'package:pickleball_app/core/utils/snackbar_helper.dart';
import 'package:pickleball_app/features/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:pickleball_app/router/router.gr.dart';

import 'role_event.dart';
import 'role_state.dart';

class RoleBloc extends Bloc<RoleEvent, RoleState> {
  final AuthenticationBloc authenticationBloc;

  RoleBloc({required this.authenticationBloc}) : super(RoleInitial()) {
    on<RegisterRoleRequested>(_onRegisterRoleRequested);
  }

  Future<void> _onRegisterRoleRequested(
      RegisterRoleRequested event, Emitter<RoleState> emit) async {
    emit(RoleRegistering());
    try {
      if (event.role == RoleUser.player.value) {
        CreatePlayerRequest request = CreatePlayerRequest(
          province: event.province!,
          city: event.city!,
          playerId: event.id,
        );
        await globalPlayerService.createPlayer(request);
      } else if (event.role == RoleUser.sponsor.value) {
        SponnerRequest request = SponnerRequest(
          id: event.id,
          companyName: event.companyName!,
          logoUrl: event.companyURL,
          urlSocial: event.socialMedia!,
          contactEmail: event.contactEmail!,
          descreption: event.description!,
          urlSocial1: event.additionalSocialMedia,
        );
        await globalSponnerService.createSponner(request);
      }
      emit(RoleRegisterSuccess());
      SnackbarHelper.showSnackBar('Role registered successfully');
      await Future.delayed(const Duration(seconds: 3));
      AutoRouter.of(event.context!).push(AuthenticationRoute());
    } catch (error) {
      print(error);
      emit(RoleRegisterFailure('An error occurred. Please try again.'));
    }
  }
}
