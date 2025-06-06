import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickleball_app/core/constants/app_enums.dart';
import 'package:pickleball_app/core/models/match.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/utils/responsive_utils.dart';
import 'package:pickleball_app/core/widgets/emptyStateCard.dart';
import 'package:pickleball_app/features/match/bloc/match_bloc.dart';
import 'package:pickleball_app/features/match/bloc/match_event.dart';
import 'package:pickleball_app/features/match/bloc/match_state.dart';
import 'package:pickleball_app/features/match/widgets/match_widget.dart';
import 'package:pickleball_app/router/router.gr.dart';

class ListMatchWidget extends StatefulWidget {
  final List<Match> matches;
  final Function(Match) onTap;
  final bool isOnTap;

  const ListMatchWidget(
      {super.key,
      required this.matches,
      required this.isOnTap,
      required this.onTap});

  @override
  State<ListMatchWidget> createState() => _ListMatchWidgetState();
}

class _ListMatchWidgetState extends State<ListMatchWidget> {

  @override
  Widget build(BuildContext context) {
    return BlocListener<MatchBloc, MatchState>(
      listener: (context, state) {
        if (state is MatchDetailLoading) {
          AutoRouter.of(context).push(DetailMatchRoute());
        }
      },
      child: widget.matches.isEmpty
          ? EmptyStateCard(
              icon: Icons.sports_tennis_outlined,
              title: "No Matches Yet",
              description:
                  "This tournament doesn't have any matches scheduled yet.",
              iconColor: AppColors.primaryColor,
              iconSize: ResponsiveUtils.getScaledSize(context, 50),
            )
          : SingleChildScrollView(
              child: ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: widget.matches.length,
                itemBuilder: (context, index) {
                  final match = widget.matches[index];
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: MatchWidget(
                      onTap: () => widget.onTap(match),
                      isOnTap: widget.isOnTap,
                      title: match.title,
                      matchCategory:
                          MatchCategory.fromValue(match.matchCategory)!.label,
                      matchFormat: match.matchFormat,
                      description: match.description,
                      matchDate: match.matchDate,
                      venue: match.venue ?? '',
                      address: match.venueId?.toString() ?? '',
                      status: MatchStatus.fromValue(match.status)!.label,
                      refereeName: match.refereeName ?? 'No Referee',
                    ),
                  );
                },
              ),
            ),
    );
  }
}
