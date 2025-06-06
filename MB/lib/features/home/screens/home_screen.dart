import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:pickleball_app/core/blocs/app_bloc.dart';
import 'package:pickleball_app/core/blocs/app_state.dart';
import 'package:pickleball_app/core/constants/app_strings.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/themes/app_theme.dart';
import 'package:pickleball_app/core/utils/snackbar_helper.dart';
import 'package:pickleball_app/features/home/bloc/home_bloc.dart';
import 'package:pickleball_app/features/home/bloc/home_event.dart';
import 'package:pickleball_app/features/home/bloc/home_state.dart';
import 'package:pickleball_app/features/home/widgets/widget_create_rom.dart';
import 'package:pickleball_app/features/home/widgets/widget_our_service.dart';
import 'package:pickleball_app/features/home/widgets/widget_profile.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_bloc.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_event.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_state.dart';
import 'package:pickleball_app/features/tournament_manage/widgets/tournament_widget.dart';
import 'package:pickleball_app/router/router.gr.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StackRouter? _stackRouter;

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadTournaments());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _stackRouter = AutoRouter.of(context);
    _stackRouter?.addListener(_onRouteChanged);
  }

  void _onRouteChanged() {
    if (_stackRouter?.current.name == MatchesRoute.name) {
      context.read<HomeBloc>().add(LoadTournaments());
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLogin = false;
    String fullName = '';

    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: MultiBlocListener(
          listeners: [
            BlocListener<TournamentBloc, TournamentState>(
              listener: (context, state) {
                if (state is TournamentDetailLoading) {
                  AutoRouter.of(context).push(DetailTournamentRoute());
                }
              },
            ),
          ],
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.defaultGradient,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: BlocBuilder<AppBloc, AppState>(
              builder: (context, state) {
                if (state is AppAuthenticatedPlayer ||
                    state is AppAuthenticatedSponsor) {
                  isLogin = true;
                  final userInfo = (state as dynamic).userInfo;
                  fullName =
                      '${userInfo.firstName} ${userInfo.lastName} ${userInfo.secondName ?? ''}';
                  return _buildContent(
                    isLogin: true,
                    image: userInfo.avatarUrl ?? '',
                    fullName: fullName,
                  );
                } else {
                  return _buildContent(
                    isLogin: false,
                    fullName: AppStrings.guest,
                    image: '',
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent({
    required bool isLogin,
    required String image,
    required String fullName,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        CardProfileBtn(
          isLogin: isLogin,
          title: AppStrings.welcome,
          image: image,
          fullName: fullName,
          onTap: () {
            isLogin
                ? AutoRouter.of(context).push(ProfileRoute())
                : SnackbarHelper.showSnackBar(AppStrings.plsLoginToFeature);
          },
        ),
        const SizedBox(height: 20),
        ContainerPlay(isLogin: isLogin),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(45),
                topRight: Radius.circular(45),
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              ContainerOurService(),
              Center(
                child: Text(
                  'My Tournaments',
                  style: AppTheme.getTheme(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),

              // Login notification card for guests
              if (!isLogin)
                Center(
                  child:Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 0, // Removed shadow
                      color: Colors.white, // White background
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppColors.primaryColor,
                              size: 40,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "You're not logged in",
                              style: AppTheme.getTheme(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Please log in to register for the latest tournaments",
                              textAlign: TextAlign.center,
                              style:
                              AppTheme.getTheme(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context.router.push(AuthenticationRoute());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 12),
                              ),
                              child: const Text("Login Now"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoaded) {
                    final dataList = state.tournaments;
                    final numberPlayers = state.numberPlayer;
                    
                    if (dataList.isEmpty && isLogin) {
                      // Empty tournaments message for logged-in users
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          elevation: 0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.sports_tennis_outlined,
                                  color: AppColors.primaryColor,
                                  size: 40,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "No Tournaments Yet",
                                  style: AppTheme.getTheme(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "You haven't registered for any tournaments yet. Join a tournament to get started!",
                                  textAlign: TextAlign.center,
                                  style: AppTheme.getTheme(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    // Navigate to tournaments list or registration page
                                    // Modify this as needed
                                    SnackbarHelper.showSnackBar("Check available tournaments");
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32, vertical: 12),
                                  ),
                                  child: const Text("Browse Tournaments"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    
                    return Column(
                      children: dataList.map((data) {
                        bool isWebsite =
                            Uri.tryParse(data.banner)?.hasAbsolutePath ?? false;

                        final playerEntry = numberPlayers.firstWhere(
                          (element) => element['tournamentId'] == data.id,
                          orElse: () =>
                              {'tournamentId': data.id, 'numberPlayer': 0},
                        );
                        final playerCount = playerEntry['numberPlayer'] as int;
                        return TournamentWidget(
                          onTap: () {
                            isLogin
                                ? context
                                    .read<TournamentBloc>()
                                    .add(SelectTournament(data.id))
                                : SnackbarHelper.showSnackBar(
                                    AppStrings.plsLoginToFeature);
                          },
                          title: data.name,
                          location: data.location,
                          maxPlayers: '$playerCount/${data.maxPlayer}',
                          description: null,
                          startDate: data.startDate,
                          endDate: data.endDate,
                          type: data.type,
                          status: data.status,
                          note: data.note,
                          banner:
                              isWebsite ? data.banner : AppStrings.bannerUrl,
                          isMaxRanking: data.isMaxRanking,
                          isMinRanking: data.isMinRanking,
                          isFree: data.isFree,
                          entryFee: data.entryFee,
                          totalPrize: data.totalPrize,
                        );
                      }).toList(),
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.hourglass_empty,
                            size: 80,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        )
      ],
    );
  }
}
