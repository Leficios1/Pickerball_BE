import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickleball_app/core/blocs/app_event.dart';
import 'package:pickleball_app/core/blocs/app_state.dart';
import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/router/router.gr.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppInitial()) {
    on<AppStarted>(_onAppStarted);
    on<AppLoggedIn>(_onAppLoggedIn);
    on<AppLoggedOut>(_onAppLoggedOut);
    on<AppUserTypeChecked>(_onAppUserTypeChecked);
    on<UpdateTabIndex>(_onUpdateTabIndex);
    on<UpdateUserInfo>(_onUpdateUserInfo);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AppState> emit) async {
    emit(AppLoading());
    try {
      final accessToken = await globalTokenService.getAccessToken();
      final expirationString = await globalTokenService.getExpiration();
      if (accessToken != null && expirationString != null) {
        final expiration = DateTime.parse(expirationString);
        if (expiration.isAfter(DateTime.now())) {
          final userInfo =
              await globalAuthService.getUserByToken(accessToken, 'en');
          add(AppUserTypeChecked(userInfo: userInfo, context: event.context));
        } else {
          emit(AppUnauthenticated());
        }
      } else {
        emit(AppUnauthenticated());
      }
    } catch (error) {
      emit(AppUnauthenticated());
    }
  }

  Future<void> _onAppLoggedIn(AppLoggedIn event, Emitter<AppState> emit) async {
    try {
      add(AppUserTypeChecked(userInfo: event.userInfo, context: event.context));
    } catch (error) {
      emit(AppUnauthenticated());
    }
  }

  Future<void> _onAppLoggedOut(
      AppLoggedOut event, Emitter<AppState> emit) async {
    await globalTokenService.deleteAccessToken();
    await globalTokenService.deleteRefreshToken();
    emit(AppUnauthenticated());
    add(UpdateTabIndex(index: 0, context: event.context));
    AutoRouter.of(event.context).push(HomeRoute());
  }

  Future<void> _onUpdateTabIndex(
      UpdateTabIndex event, Emitter<AppState> emit) async {
    final tabsRouter = AutoTabsRouter.of(event.context);
    if (event.index < tabsRouter.pageCount) {
      tabsRouter.setActiveIndex(event.index);
    }
  }

  Future<void> _onAppUserTypeChecked(
      AppUserTypeChecked event, Emitter<AppState> emit) async {
    try {
      final userInfo = await globalUserService.getUserById(event.userInfo.id);
      if (userInfo.roleId == 1) {
        emit(AppAuthenticatedPlayer(userInfo));
      } else if (userInfo.roleId == 3) {
        final sponsor = await globalSponnerService.getSponnerById(userInfo.id);
        if (sponsor.isAccept == false) {
          emit(AppAuthenticatedSponsorPending(userInfo));
        } else {
          emit(AppAuthenticatedSponsor(userInfo));
        }
      } else {
        emit(AppUnauthenticated());
      }
    } catch (error) {
      print('Error in _onAppUserTypeChecked: $error');
      emit(AppUnauthenticated());
    }
  }

  Future<void> _onUpdateUserInfo(
      UpdateUserInfo event, Emitter<AppState> emit) async {
    try {
      final appState = state;
      if (appState is AppAuthenticatedPlayer) {
        final userInfo = event.userInfo;
        emit(AppAuthenticatedPlayer(userInfo));
      }
      if (appState is AppAuthenticatedSponsor) {
        final userInfo = event.userInfo;
        emit(AppAuthenticatedSponsor(userInfo));
      }
    } catch (error) {
      print('Error in _onUpdateUserInfo: $error');
    }
  }
}
