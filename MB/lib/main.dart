import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pickleball_app/core/blocs/app_bloc.dart';
import 'package:pickleball_app/core/blocs/app_event.dart';
import 'package:pickleball_app/core/blocs/app_state.dart';
import 'package:pickleball_app/core/blocs/bloc_observer.dart';
import 'package:pickleball_app/core/constants/app_constants.dart';
import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/themes/app_theme.dart';
import 'package:pickleball_app/core/utils/screen_util.dart';
import 'package:pickleball_app/core/utils/snackbar_helper.dart';
import 'package:pickleball_app/core/services/quick_match/quick_match_service.dart';
import 'package:pickleball_app/features/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:pickleball_app/features/authentication/bloc/role/role_bloc.dart';
import 'package:pickleball_app/features/home/bloc/home_bloc.dart';
import 'package:pickleball_app/features/match/bloc/create_match/create_match_bloc.dart';
import 'package:pickleball_app/features/match/bloc/invite_player_bloc/invite_player_bloc.dart';
import 'package:pickleball_app/features/match/bloc/match_bloc.dart';
import 'package:pickleball_app/features/match/bloc/match_event.dart';
import 'package:pickleball_app/features/matches/bloc/matches_bloc.dart';
import 'package:pickleball_app/features/onboarding/screens/app_loading_screen.dart';
import 'package:pickleball_app/features/payment/bloc/payment_bloc.dart';
import 'package:pickleball_app/features/quick_match/bloc/quick_match_bloc.dart';
import 'package:pickleball_app/features/ranks/bloc/ranking_bloc.dart';
import 'package:pickleball_app/features/setting/bloc/blogs_categories/blogs_categories_bloc.dart';
import 'package:pickleball_app/features/setting/bloc/blogs_categories/rule_selection_bloc.dart';
import 'package:pickleball_app/features/setting/bloc/friend/add_friend_bloc.dart';
import 'package:pickleball_app/features/setting/bloc/friend/add_friend_event.dart';
import 'package:pickleball_app/features/setting/bloc/friend/friend_bloc.dart';
import 'package:pickleball_app/features/setting/bloc/friend/friend_event.dart';
import 'package:pickleball_app/features/setting/bloc/profile/profile_bloc.dart';
import 'package:pickleball_app/features/setting/bloc/settings_bloc.dart';
import 'package:pickleball_app/features/setting/bloc/user_profile/user_profile_bloc.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/create_tournament/create_tournament_bloc.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/join_tournament/join_tournament_bloc.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_bloc.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_event.dart';
import 'package:pickleball_app/router/router.dart';
import 'package:pickleball_app/router/router.gr.dart';
import 'firebase_options.dart';

bool isUpdateProfile = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  try {
    await dotenv.load(fileName: 'assets/env/.env');
    print("Env file loaded successfully.");
  } catch (e) {
    print('Error loading .env file: $e');
  }

  final _appRouter = AppRouter();

  runApp(
    MyApp(
      appRouter: _appRouter,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  MyApp({
    super.key,
    required this.appRouter,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppBloc()..add(AppStarted(context: context)),
        ),
        BlocProvider(
          create: (context) => AuthenticationBloc(
            appBloc: BlocProvider.of<AppBloc>(context),
          ),
        ),
        BlocProvider(
            create: (context) =>
                MatchBloc(BlocProvider.of<AppBloc>(context))),
        BlocProvider(
            create: (context) =>
                HomeBloc(appBloc: BlocProvider.of<AppBloc>(context))),
        BlocProvider(
            create: (context) => RoleBloc(
                authenticationBloc:
                    BlocProvider.of<AuthenticationBloc>(context))),
        BlocProvider(
            create: (context) =>
                InvitePlayerBloc(BlocProvider.of<AppBloc>(context))),
        BlocProvider(
            create: (context) =>
            TournamentBloc(appBloc: BlocProvider.of<AppBloc>(context))
              ..add(LoadAllTournaments())),
        BlocProvider(
            create: (context) =>
                SettingsBloc(
                    appBloc: BlocProvider.of<AppBloc>(context),
                    matchBloc: BlocProvider.of<MatchBloc>(context),
                    tournamentBloc: BlocProvider.of<TournamentBloc>(context))
                  ),
        BlocProvider(
            create: (context) => CreateMatchBloc(
                matchBloc: BlocProvider.of<MatchBloc>(context))),
        BlocProvider(
            create: (context) =>
                FriendBloc(appBloc: BlocProvider.of<AppBloc>(context))
                  ..add(LoadFriends())),
        BlocProvider(
            create: (context) =>
                AddFriendBloc(appBloc: BlocProvider.of<AppBloc>(context))
                  ..add(LoadAllPlayers())),
        BlocProvider(
            create: (context) => QuickMatchBloc(
              appBloc: BlocProvider.of<AppBloc>(context),
              quickMatchService: QuickMatchService(),
              createMatchBloc: BlocProvider.of<CreateMatchBloc>(context),
              matchBloc: BlocProvider.of<MatchBloc>(context), // Add MatchBloc
            )),
        BlocProvider(
            create: (context) => JoinTournamentBloc(
                appBloc: BlocProvider.of<AppBloc>(context),
                tournamentBloc: BlocProvider.of<TournamentBloc>(context))),
        BlocProvider(create: (context) => BlogsCategoriesBloc()),
        BlocProvider(create: (context) => RuleSelectionBloc()),
        BlocProvider(
            create: (context) => PaymentBloc(
                appBloc: BlocProvider.of<AppBloc>(context),
                tournamentBloc: BlocProvider.of<TournamentBloc>(context))),
        BlocProvider(
            create: (context) => CreateTournamentBloc(
                appBloc: BlocProvider.of<AppBloc>(context),
                tournamentBloc: BlocProvider.of<TournamentBloc>(context))),
        BlocProvider(
            create: (context) => MatchesBloc(
                  appBloc: BlocProvider.of<AppBloc>(context),
                  matchBloc: BlocProvider.of<MatchBloc>(context),
                )),
        BlocProvider(create: (context) => RankingBloc()),
        BlocProvider(
            create: (context) =>
                ProfileBloc(appBloc: BlocProvider.of<AppBloc>(context))),
        BlocProvider(
          create: (context) => UserProfileBloc(),
        )
      ],
      child: BlocListener<AppBloc, AppState>(
        listener: (context, state) {
          if(isUpdateProfile) return;
          if (state is AppAuthenticatedSponsorPending) {
            appRouter.pushAndPopUntil(SponnerPendingRoute(),
                predicate: (_) => false);
          } else if (state is AppAuthenticatedPlayer ||
              state is AppAuthenticatedSponsor) {

            appRouter.pushAndPopUntil(HomeRoute(), predicate: (_) => false);
          }
        },
        child: ValueListenableBuilder<ThemeMode>(
          valueListenable: globalThemeMode,
          builder: (context, currentThemeMode, child) {
            return MaterialApp.router(
              title: AppConstants.appName,
              debugShowCheckedModeBanner: false,
              routerConfig: appRouter.config(),
              theme: AppTheme.getTheme(context),
              builder: (context, child) {
                ScreenUtil().init(context);
                
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaleFactor: 1.0,
                  ),
                  child: BlocBuilder<AppBloc, AppState>(
                    builder: (context, state) {
                      if (state is AppLoading) {
                        return AppLoadingScreen();
                      }
                      return child!;
                    },
                  ),
                );
              },
              darkTheme: ThemeData.dark(),
              themeMode: currentThemeMode,
              scaffoldMessengerKey: SnackbarHelper.key,
            );
          },
        ),
      ),
    );
  }
}
