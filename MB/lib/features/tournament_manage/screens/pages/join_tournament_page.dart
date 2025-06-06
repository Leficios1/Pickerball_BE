import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pickleball_app/core/constants/app_enums.dart';
import 'package:pickleball_app/core/models/models.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/themes/app_theme.dart';
import 'package:pickleball_app/core/widgets/app_bar_widget.dart';
import 'package:pickleball_app/core/widgets/html_context.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/join_tournament/join_tournament_bloc.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/join_tournament/join_tournament_event.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/join_tournament/join_tournament_state.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_bloc.dart';
import 'package:pickleball_app/features/tournament_manage/bloc/tournaments_state.dart';
import 'package:pickleball_app/features/tournament_manage/widgets/friend_list_popup.dart';
import 'package:pickleball_app/router/router.gr.dart';

@RoutePage()
class JoinTournamentPage extends StatefulWidget {
  const JoinTournamentPage({super.key});

  @override
  _JoinTournamentPageState createState() => _JoinTournamentPageState();
}

class _JoinTournamentPageState extends State<JoinTournamentPage> {
  late ValueNotifier<bool> hasReadRulesNotifier;
  int? selectedFriendId;
  String? selectedFriendAvatar;
  String? selectedFriendDisplayName;

  @override
  void initState() {
    super.initState();
    hasReadRulesNotifier = ValueNotifier(false);
  }

  @override
  void dispose() {
    hasReadRulesNotifier.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  bool isSinglePlayer = true;
  Tournament tournament;
  return Scaffold(
    appBar: AppBarWidget(
      title: 'Join Tournament',
    ),
    body: BlocListener<JoinTournamentBloc, JoinTournamentState>(
      listener: (context, joinTournamentState) {
        if (joinTournamentState is TournamentJoined) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(joinTournamentState.message)),
          );
          AutoRouter.of(context).popAndPush(DetailTournamentRoute());
        } else if (joinTournamentState is JoinTournamentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${joinTournamentState.message}')),
          );
        }
      },
      child: BlocBuilder<JoinTournamentBloc, JoinTournamentState>(
        builder: (context, joinTournamentState) {
          return BlocBuilder<TournamentBloc, TournamentState>(
            builder: (context, tournamentState) {
              if (tournamentState is TournamentJoining) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.threeRotatingDots(
                        color: AppColors.primaryColor,
                        size: 40,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Preparing tournament...',
                        style: AppTheme.getTheme(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                );
              } else if (tournamentState is TournamentDetailLoaded) {
                tournament = tournamentState.tournament;
                isSinglePlayer =
                    tournament.type == MatchFormat.singleMale.label ||
                    tournament.type == MatchFormat.singleFemale.label;

                return SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildTitleHeader(context, tournament),
                          const SizedBox(height: 24),
                          if (isSinglePlayer)
                            _buildSinglePlayerSection(context, tournament)
                          else
                            _buildDoublePlayerSection(context, tournament),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.primaryColor,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                      'No tournament selected or error occurred',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                );
              }
            },
          );
        },
      ),
    ),
  );
}

Widget _buildTitleHeader(BuildContext context, Tournament tournament) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryColor, AppColors.primaryColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tournament.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                '${MatchFormat.fromString(tournament.type)?.subLabel ?? "Tournament"}',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildSinglePlayerSection(BuildContext context, Tournament tournament) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primaryColor.withOpacity(0.2),
                  radius: 24,
                  child: Icon(
                    Icons.person,
                    color: AppColors.primaryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'You are joining as a singles player',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            _buildRulesSection(context, tournament),
            const SizedBox(height: 24),
            _buildJoinButton(context),
          ],
        ),
      ),
    ],
  );
}

Widget _buildDoublePlayerSection(BuildContext context, Tournament tournament) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primaryColor.withOpacity(0.2),
                  radius: 24,
                  child: Icon(
                    Icons.people,
                    color: AppColors.primaryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: selectedFriendDisplayName != null
                      ? Text(
                          'Playing with $selectedFriendDisplayName',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        )
                      : Text(
                          'Select a partner to play with',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                showFriendListPopup(
                  context, 
                  tournament,
                  (friendId, avatarUrl, displayName) {
                    setState(() {
                      selectedFriendId = friendId;
                      selectedFriendAvatar = avatarUrl;
                      selectedFriendDisplayName = displayName;
                    });
                  }
                );
              },
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: selectedFriendId != null
                    ? Row(
                        children: [
                          const SizedBox(width: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              selectedFriendAvatar!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedFriendDisplayName!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Your tournament partner',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: AppColors.primaryColor,
                            ),
                            onPressed: () {
                              showFriendListPopup(
                                context, 
                                tournament,
                                (friendId, avatarUrl, displayName) {
                                  setState(() {
                                    selectedFriendId = friendId;
                                    selectedFriendAvatar = avatarUrl;
                                    selectedFriendDisplayName = displayName;
                                  });
                                }
                              );
                            },
                          ),
                        ],
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_add,
                              size: 36,
                              color: AppColors.primaryColor,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap to select partner',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            _buildRulesSection(context, tournament),
            const SizedBox(height: 24),
            _buildJoinButton(context),
          ],
        ),
      ),
    ],
  );
}

Widget _buildRulesSection(BuildContext context, Tournament tournament) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.amber[700],
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Tournament Rules',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: hasReadRulesNotifier,
              builder: (context, hasReadRules, child) {
                return Checkbox(
                  value: hasReadRules,
                  activeColor: AppColors.primaryColor,
                  onChanged: null,
                );
              },
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      title: Row(
                        children: [
                          Icon(
                            Icons.rule,
                            color: AppColors.primaryColor,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text('Tournament Rules'),
                        ],
                      ),
                      content: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: HtmlViewWidget(
                          htmlContent: tournament.note ?? '',
                          title: 'Tournament Rules',
                        ),
                      ),
                      actions: [
                        FilledButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            hasReadRulesNotifier.value = true;
                          },
                          child: Text(
                            'I have read the rules',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(
                  'Please read tournament rules',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    decoration: hasReadRulesNotifier.value 
                        ? TextDecoration.lineThrough 
                        : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildJoinButton(BuildContext context) {
  bool isSinglePlayer = true;
  return ValueListenableBuilder<bool>(
    valueListenable: hasReadRulesNotifier,
    builder: (context, hasReadRules, child) {
      bool canJoin = (hasReadRules && isSinglePlayer) ||
          (!isSinglePlayer && selectedFriendId != null && hasReadRules);
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: canJoin ? AppColors.primaryColor : Colors.grey.shade400,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: canJoin ? 2 : 0,
        ),
        onPressed: canJoin
          ? () {
              context.router.push(
                SelectPaymentMethodRoute(
                  onPaymentSelected: (paymentMethod) {
                    BlocProvider.of<JoinTournamentBloc>(context)
                      .add(
                        JoinTournamentRequested(
                          partnerId: selectedFriendId,
                          context: context,
                          paymentMethod: paymentMethod,
                        ),
                      );
                  },
                )
              );
            }
          : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_tennis,
              size: 24,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Text(
              'Join Tournament',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    },
  );
}
}
