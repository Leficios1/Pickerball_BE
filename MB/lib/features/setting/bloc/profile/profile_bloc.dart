import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickleball_app/core/blocs/app_bloc.dart';
import 'package:pickleball_app/core/blocs/app_event.dart';
import 'package:pickleball_app/core/blocs/app_state.dart';
import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/features/setting/bloc/profile/profile_event.dart';
import 'package:pickleball_app/features/setting/bloc/profile/profile_state.dart';
import 'package:pickleball_app/router/router.gr.dart';

import '../../../../main.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> implements StateStreamable<ProfileState> {
  final AppBloc appBloc;

  ProfileBloc({required this.appBloc}) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<EditProfile>(_onEditProfile);
  }

  @override
  ProfileState get state => super.state;

  Future<void> _onLoadProfile(
      LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final appState = appBloc.state;
      if(appState is AppAuthenticatedPlayer) {
        final userInfo = appState.userInfo;
        emit(ProfileLoaded(user: userInfo));

      }
      if(appState is AppAuthenticatedSponsor) {
        final userInfo = appState.userInfo;
        emit(ProfileLoaded(user: userInfo));

      }
    } catch (e) {
      emit(ProfileError(message: 'Failed to load profile.'));
    }
  }

  Future<void> _onEditProfile(
      EditProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final appState = appBloc.state;
      if(appState is AppAuthenticatedPlayer) {
        final userInfo = appState.userInfo;
        await globalUserService.updateUser(event.request, userInfo.id);
        final userUpdate =   await globalUserService.getUserById(userInfo.id);
        emit(ProfileLoaded(user: userUpdate));
        isUpdateProfile = true;
        appBloc.add(UpdateUserInfo(userInfo: userUpdate));
      }
      if(appState is AppAuthenticatedSponsor) {
        final userInfo = appState.userInfo;
        await globalUserService.updateUser(event.request, userInfo.id);
        final userUpdate =   await globalUserService.getUserById(userInfo.id);
        isUpdateProfile = true;
        appBloc.add(UpdateUserInfo(userInfo: userUpdate));
        emit(ProfileLoaded(user: userInfo));
      }
    } catch (e) {
      emit(ProfileError(message: 'Failed to update profile.'));
    }
  }
}

