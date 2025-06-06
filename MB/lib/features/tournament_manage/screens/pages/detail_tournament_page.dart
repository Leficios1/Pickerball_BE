import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pickleball_app/core/constants/app_enums.dart';
import 'package:pickleball_app/core/constants/app_strings.dart';
import 'package:pickleball_app/core/constants/router_path.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/themes/app_theme.dart';
import 'package:pickleball_app/core/utils/limited_text_widget.dart';
import 'package:pickleball_app/core/utils/responsive_utils.dart';
import 'package:pickleball_app/core/utils/snackbar_helper.dart';
import 'package:pickleball_app/core/widgets/app_bar_widget.dart';
import 'package:pickleball_app/features/match/bloc/match_bloc.dart';
import 'package:pickleball_app/features/match/bloc/match_event.dart';
import 'package:pickleball_app/features/payment/bloc/payment_bloc.dart';
import 'package:pickleball_app/features/payment/bloc/payment_event.dart';
import 'package:pickleball_app/features/payment/bloc/payment_state.dart';
import 'package:pickleball_app/features/ranks/widgets/card_user_info.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_bloc.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_event.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_state.dart';
import 'package:pickleball_app/features/tournament_manage/widgets/detail_tournament_widget.dart';
import 'package:pickleball_app/features/tournament_manage/widgets/list_history_widget.dart';
import 'package:pickleball_app/features/tournament_manage/widgets/list_match_widget.dart';
import 'package:pickleball_app/features/tournament_manage/widgets/list_member_widget.dart';
import 'package:pickleball_app/features/tournament_manage/widgets/popup_request_join_tournament.dart';
import 'package:pickleball_app/router/router.gr.dart';
import 'package:pickleball_app/core/utils/extensions.dart';
import 'package:pickleball_app/core/widgets/emptyStateCard.dart';
import '../../../../core/utils/screen_util.dart';

@RoutePage()
class DetailTournamentPage extends StatefulWidget {
  const DetailTournamentPage({super.key});

  @override
  _DetailTournamentPageState createState() => _DetailTournamentPageState();
}

class _DetailTournamentPageState extends State<DetailTournamentPage>
    with RouteAware, SingleTickerProviderStateMixin {
  late TabController _tabController;
  late BuildContext _ancestorContext;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 4, vsync: this); // Ensure length matches the number of tabs

    // Initialize ScreenUtil if it's not already initialized
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ancestorContext = context;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Future<bool> _onWillPop() async {
    if (!mounted) return false; // Ensure the widget is still mounted
    final router = AutoRouter.of(_ancestorContext);

    if (router.canPop()) {
      context.router.back();
      return false;
    }

    final previousRoute = ModalRoute.of(_ancestorContext)?.settings.name;

    if (previousRoute == RouterPath.homeScreen) {
      router.replace(HomeRoute());
    } else if (previousRoute == RouterPath.tournamentManageScreen) {
      router.replace(TournamentManageRoute());
    } else {
      router.replace(TournamentManageRoute());
    }

    return false;
  }

  @override
  void didPopNext() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Tournament Detail',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
          ),
          backgroundColor: AppColors.primaryColor,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              AutoRouter.of(context).popAndPush(TournamentManageRoute());
            },
          ),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<PaymentBloc, PaymentState>(listener: (context, state) {
              if (state is PaymentInProgress) {
                AutoRouter.of(context).popAndPush(PaymentRoute());
              }
              if (state is DonateForTournamentState) {
                AutoRouter.of(context).push(PaymentRoute());
              }
            }),
            BlocListener<TournamentBloc, TournamentState>(
                listener: (context, state) {
              if (state is DonateForTournamentLoading) {
                AutoRouter.of(context).push(PaymentRoute());
              }
            }),
          ],
          child: SingleChildScrollView(
            child: BlocBuilder<TournamentBloc, TournamentState>(
              builder: (context, state) {
                if (state is TournamentInitial) {
                  return const Center(child: Text('No tournament selected'));
                } else if (state is TournamentDetailLoading) {
                  return _buildLoadingWidget();
                } else if (state is TournamentDetailLoaded) {
                  return _buildTournamentDetail(state);
                } else {
                  return const Center(child: Text('Error'));
                }
              },
            ),
          ),
        ),
      bottomNavigationBar: BlocBuilder<TournamentBloc, TournamentState>(
        builder: (context, state) {
          if (state is TournamentDetailLoaded) {
            return _ActionButton(userRole: state.userRole, state: state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Center(
        child: LoadingAnimationWidget.threeRotatingDots(
          color: AppColors.primaryColor,
          size: ResponsiveUtils.getScaledSize(context, 30),
        ),
      ),
    );
  }

  Widget _buildTournamentDetail(TournamentDetailLoaded state) {
    final tournament = state.tournament;
    final userRole = state.userRole;
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildTournamentBanner(
              tournament.banner, tournament.name, tournament.location),
          _buildTabBar(),
          SizedBox(
            height: screenHeight * 0.6,
            child: _buildTabBarView(state),
          ),
        ],
      ),
    );
  }

  Widget _buildTournamentBanner(String banner, String title, String address) {
    bool isWebsite = Uri.tryParse(banner)?.hasAbsolutePath ?? false;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius:
            BorderRadius.all(Radius.circular(25)), // Remove .r extension
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height *
                0.25, // Use MediaQuery instead of .sh extension
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(isWebsite ? banner : AppStrings.bannerUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.w, top: 8.h),
            child: LimitedTextWidget(
              content: title,
              maxLines: 2,
              style:
                  AppTheme.getTheme(context).textTheme.displaySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveUtils.getScaledSize(context, 24),
                shadows: [
                  Shadow(
                    blurRadius: 1,
                    color: Colors.black,
                    offset: Offset(0.5, 0.5),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.w, top: 6.h, bottom: 12.h),
            child: Row(
              children: [
                Icon(Icons.location_on,
                    color: Colors.white,
                    size: ResponsiveUtils.getScaledSize(context, 18)),
                SizedBox(width: 4.w),
                Expanded(
                  child: LimitedTextWidget(
                    content: address,
                    style: AppTheme.getTheme(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveUtils.getScaledSize(context, 16),
                      shadows: [
                        Shadow(
                          blurRadius: 1,
                          color: Colors.black,
                          offset: Offset(0.5, 0.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      tabs: const [
        Tab(text: 'Detail'),
        Tab(text: 'Members'),
        Tab(text: 'Matches'),
        Tab(text: 'Ranking'),
      ],
      labelColor: AppColors.primaryColor,
      unselectedLabelColor: Colors.grey,
      indicatorColor: AppColors.primaryColor,
      indicatorWeight: 4,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: AppTheme.getTheme(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: ResponsiveUtils.getScaledSize(context, 14),
          ),
      physics: const BouncingScrollPhysics(),
      isScrollable: true,
    );
  }

  Widget _buildTabBarView(TournamentDetailLoaded state) {
    return TabBarView(
      controller: _tabController,
      children: [
        DetailTournamentWidget(
          matchStatus: state.tournament.status,
          userRole: state.userRole,
          name: state.tournament.name,
          descreption: state.tournament.descreption,
          startDate: state.tournament.startDate,
          endDate: state.tournament.endDate,
          location: state.tournament.location,
          maxPlayer: '${state.numberOfPlayers}/${state.tournament.maxPlayer}',
          note: state.tournament.note,
          totalPrize: state.tournament.totalPrize,
          type: state.tournament.type,
          isMaxRanking: state.tournament.isMaxRanking,
          isMinRanking: state.tournament.isMinRanking,
          isFree: state.tournament.isFree,
          entryFee: state.tournament.entryFee,
        ),
        ListMemberWidget(
          players: state.players!,
          referees: state.referees!,
          sponsors: state.sponsors!,
        ),
        ListMatchWidget(
          matches: state.matches!,
          isOnTap: state.isOnTap,
          onTap: (match) {
            context.read<MatchBloc>().add(SelectMatch(match.id));
          },
        ),
        _buildRankingTab(state),
      ],
    );
  }

  Widget _buildRankingTab(TournamentDetailLoaded state) {
    final rankings = state.rankings;
    if (rankings == null || rankings.isEmpty) {
      return EmptyStateCard(
        icon: Icons.leaderboard_outlined,
        title: "No Rankings Available",
        description:
            "Rankings will appear here once players have participated in matches.",
        iconColor: AppColors.primaryColor,
        iconSize: ResponsiveUtils.getScaledSize(context, 50),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: rankings.length,
      itemBuilder: (context, index) {
        final ranking = rankings[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(10),
          child: CardUserInfo(
            position: index + 1,
            name: ranking.fullName,
            avatarUrl: ranking.avatar,
            score: ranking.rankingPoint,
            winTotal: '${ranking.totalWins}',
            total: '${ranking.totalMatch}',
          ),
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final UserRole userRole;
  final TournamentDetailLoaded state;

  const _ActionButton({required this.userRole, required this.state});

  String _getButtonText() {
    switch (userRole) {
      case UserRole.sponsor:
        return 'Donate';
      case UserRole.playerWaiting:
        return 'Waiting';
      case UserRole.playerPayment:
        return 'Payment';
      case UserRole.playerRejected:
        return 'Rejected';
      case UserRole.playerEliminated:
        return 'Eliminated';
      case UserRole.invitedPlayer:
        return 'Accept';
      case UserRole.player:
        return 'Play';
      case UserRole.waitingPayment:
        return 'Waiting Payment';
      case UserRole.playerParticipated:
        return 'Participated';
      default:
        return '';
    }
  }

  IconData _getButtonIcon() {
    switch (userRole) {
      case UserRole.sponsor:
        return Icons.monetization_on;
      case UserRole.player:
        return Icons.sports_esports;
      case UserRole.playerPayment:
        return Icons.payment;
      case UserRole.playerWaiting:
        return Icons.access_time;
      case UserRole.playerRejected:
        return Icons.cancel;
      case UserRole.playerEliminated:
        return Icons.block;
      case UserRole.invitedPlayer:
        return Icons.check;
      case UserRole.waitingPayment:
        return Icons.hourglass_empty;
      case UserRole.playerParticipated:
        return Icons.check_circle;
      case UserRole.player:
        return Icons.play_arrow;
      default:
        return Icons.help_outline;
    }
  }

  VoidCallback _onPressed(BuildContext context) {
    switch (userRole) {
      case UserRole.sponsor:
        return () {
          context.read<TournamentBloc>().add(DonateForTournament(
              tournament: state.tournament, context: context));
        };
      case UserRole.player:
        return () {
          if (state.isJoin == true) {
            AutoRouter.of(context).push(JoinTournamentRoute());
          } else {
            SnackbarHelper.showSnackBar(
                'You are not eligible to join the tournament.');
          }
        };
      case UserRole.playerPayment:
        return () {
          if (state.registrationId != null) {
            context.router.push(SelectPaymentMethodRoute(
              onPaymentSelected: (PaymentMethod paymentMethod) {
                context.read<PaymentBloc>().add(InitiatePayment(
                    registrationId: state.registrationId!,
                    tournamentId: state.tournament.id,
                    paymentMethod: paymentMethod));
              },
            ));
          }
        };
      case UserRole.invitedPlayer:
        return () {
          showDialog(
            context: context,
            builder: (context) {
              return RequestJoinTournamentPopup(
                registrationDetails: state.registrationDetails!,
                tournamentId: state.tournament.id,
              );
            },
          );
        };
      case UserRole.waitingPayment:
        return () {
          SnackbarHelper.showSnackBar(
              'Please wait for your partner to pay the participation fee');
        };
      case UserRole.playerWaiting:
        return () {
          SnackbarHelper.showSnackBar(
              'Please wait for your partner to accept the invitation');
        };
      default:
        return () {};
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userRole == UserRole.sponsorOwner) {
      return const SizedBox();
    }

    final text = _getButtonText();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: Colors.white,
      child: SizedBox(
        height: 35.h,
        width: double.infinity,
        child: FilledButton(
          onPressed: _onPressed(context),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(AppColors.primaryColor),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.h),
                side: BorderSide(
                  color: AppColors.primaryColor,
                  width: 2.w,
                ),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveUtils.getScaledSize(context, 18),
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                _getButtonIcon(),
                color: Colors.white,
                size: ResponsiveUtils.getResponsiveIconSize(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
