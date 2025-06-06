import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/features/setting/bloc/user_profile/user_profile_event.dart';
import 'package:pickleball_app/features/setting/bloc/user_profile/user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc() : super(UserProfileInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
  }

  Future<void> _onLoadUserProfile(
    LoadUserProfile event, 
    Emitter<UserProfileState> emit
  ) async {
    emit(UserProfileLoading());
    try {
      final user = await globalUserService.getUserById(event.userId);
      emit(UserProfileLoaded(user: user));
    } catch (e) {
      emit(UserProfileError(message: 'Failed to load user profile: ${e.toString()}'));
    }
  }
}
