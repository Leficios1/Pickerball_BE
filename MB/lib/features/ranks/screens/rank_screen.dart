import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/models/models.dart';
import 'package:pickleball_app/core/models/simple_data.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/widgets/app_bar_widget.dart';
import 'package:pickleball_app/features/ranks/bloc/ranking_bloc.dart';
import 'package:pickleball_app/features/ranks/bloc/ranking_event.dart';
import 'package:pickleball_app/features/ranks/bloc/ranking_state.dart';
import 'package:pickleball_app/features/ranks/widgets/card_user_info.dart';

import '../../../core/themes/app_theme.dart';

@RoutePage()
class RankScreen extends StatefulWidget {
  const RankScreen({super.key});

  @override
  State<RankScreen> createState() => _RankScreenState();
}

class _RankScreenState extends State<RankScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RankingBloc()..add(LoadRankings()),
      child: const RankScreenView(),
    );
  }
}

class RankScreenView extends StatelessWidget {
  const RankScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Rankings'),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.grey.shade100,
            ],
          ),
        ),
        child: BlocBuilder<RankingBloc, RankingState>(
          builder: (context, state) {
            if (state is RankingLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoadingAnimationWidget.fourRotatingDots(
                      color: AppColors.primaryColor,
                      size: 50,
                    ),
                  ],
                ),
              );
            }

            if (state is RankingError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red[400],
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load rankings',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: TextStyle(color: Colors.red[400]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<RankingBloc>().add(LoadRankings());
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is RankingLoaded) {
              final userRanks = state.rankings;
              if (userRanks.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.emoji_events_outlined,
                        color: Colors.grey[400],
                        size: 70,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No rankings available',
                        style: AppTheme.getTheme(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Rankings will appear once matches are played',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  _buildPodiumSection(userRanks, context),
                  const SizedBox(height: 16),
                  _buildLeaderboardHeader(context),
                  Expanded(
                    child: userRanks.length > 3
                        ? _buildLeaderboardList(userRanks, context)
                        : _buildNoMorePlayersMessage(context),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildLeaderboardHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.emoji_events_outlined,
              color: AppColors.primaryColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Leaderboard',
              style: AppTheme.getTheme(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.grey[800],
                  ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.people_alt_outlined,
                    size: 14,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Other Players',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoMorePlayersMessage(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.group_off,
              color: Colors.grey[400],
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'No more players in the rankings',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'The top 3 players are shown on the podium',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardList(List<Rankings> userRanks, BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      itemCount: userRanks.length > 3 ? userRanks.length - 3 : 0,
      itemBuilder: (context, index) {
        final user = userRanks[index + 3];
        return CardUserInfo(
          position: index + 4,
          name: user.fullName,
          avatarUrl: user.avatar,
          score: user.rankingPoint,
          winTotal: user.totalWins.toString(),
          total: user.totalMatch.toString(),
        );
      },
    );
  }

  Widget _buildPodiumSection(List<Rankings> userRanks, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withOpacity(0.9),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Podium title
          // Podium row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (userRanks.length > 1)
                _buildPodium(userRanks[1], 2, Colors.amber[300]!, context),
              if (userRanks.isNotEmpty)
                _buildPodium(userRanks[0], 1, Colors.orange[600]!, context),
              if (userRanks.length > 2)
                _buildPodium(userRanks[2], 3, Colors.grey[400]!, context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPodium(
      Rankings user, int position, Color color, BuildContext context) {
    // Calculate the width based on position to make the first place larger
    final double width = MediaQuery.of(context).size.width / 3.2;
    final double widthAdjustment = position == 1 ? 16.0 : 0.0;

    return SizedBox(
      width: width + widthAdjustment,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Trophy icon for first place
            if (position == 1)
              Icon(
                Icons.emoji_events,
                color: Colors.amber,
                size: 24,
              ),

            // Avatar with border for better visibility
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: position == 1 ? 3 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: position == 1 ? 38 : 30,
                backgroundImage: NetworkImage(user.avatar),
                backgroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            // Name with clear styling
            Text(
              user.fullName.length > 12
                  ? '${user.fullName.substring(0, 12)}...'
                  : user.fullName,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.getTheme(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: position == 1 ? 16 : 14,
                  ),
            ),

            const SizedBox(height: 4),

            // Win/Total ratio with icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sports_score_outlined,
                  color: Colors.white70,
                  size: 14,
                ),
                const SizedBox(width: 2),
                Text(
                  '${user.totalWins}/${user.totalMatch}',
                  style:
                      AppTheme.getTheme(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                ),
              ],
            ),

            // Score with clear styling
            Text(
              '${user.rankingPoint} pts',
              style: AppTheme.getTheme(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: position == 1 ? 15 : 14,
                  ),
            ),

            // Podium with improved design
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: position == 1 ? 60 : 50,
              height: position == 1 ? 85 : (position == 2 ? 65 : 55),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.6),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  position.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: position == 1 ? 24 : 20,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 2,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
