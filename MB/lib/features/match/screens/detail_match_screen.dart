import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pickleball_app/core/constants/app_enums.dart';
import 'package:pickleball_app/core/services/match/dto/get_match_response.dart';
import 'package:pickleball_app/core/services/match/dto/update_match_request.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/utils/extensions.dart';
import 'package:pickleball_app/core/utils/responsive_utils.dart';
import 'package:pickleball_app/core/widgets/app_bar_widget.dart';
import 'package:pickleball_app/features/match/bloc/match_bloc.dart';
import 'package:pickleball_app/features/match/bloc/match_event.dart';
import 'package:pickleball_app/features/match/bloc/match_state.dart';
import 'package:pickleball_app/features/match/widgets/match_detail_container_widget.dart';
import 'package:pickleball_app/features/match/widgets/team_info_widget.dart';
import 'package:pickleball_app/router/router.gr.dart';
import 'dart:async';
import 'package:pickleball_app/core/widgets/emptyStateCard.dart';

@RoutePage()
class DetailMatchScreen extends StatefulWidget {
  const DetailMatchScreen({super.key});

  @override
  _DetailMatchScreenState createState() => _DetailMatchScreenState();
}

class _DetailMatchScreenState extends State<DetailMatchScreen> {
  late TextEditingController _team1Controller;
  late TextEditingController _team2Controller;
  int? _team1Score;
  int? _team2Score;
  late MatchData? _match;
  String? _teamError;
  final ValueNotifier<bool> valueListenable = ValueNotifier(false);
  final ValueNotifier<bool> _isEditableNotifier = ValueNotifier<bool>(false);
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;
  String? _initialTitle;
  String? _initialDescription;
  DateTime? _initialDate;
  String? _changeTitle;
  String? _changeDescription;
  DateTime? _changeDate;
  int? _initialRefereeId;
  int? _initialVenueId;
  int? _changeRefereeId;
  int? _changeVenueId;

  MatchCategory? _initialMatchCategory;
  MatchWinScore? _initialWinScore;
  MatchCategory? _changeMatchCategory;
  MatchWinScore? _changeWinScore;

  TournamentFormant? _initialMatchFormat;
  TournamentFormant? _changeMatchFormat;

  MatchCategory? _selectedMatchCategory;
  MatchPrivate? _selectedMatchPrivate;
  MatchWinScore? _selectedWinScore;
  int? _selectedRefereeId;
  int? _selectedVenueId;
  TournamentFormant? _selectedMatchFormat;

  Timer? _refreshTimer;
  int? _lastKnownMatchStatus;

  @override
  void initState() {
    super.initState();
    _team1Controller = TextEditingController(text: '0')
      ..addListener(controllerListener);
    _team2Controller = TextEditingController(text: '0')
      ..addListener(controllerListener);
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _dateController = TextEditingController();
    final matchBloc = context.read<MatchBloc>();
    final matchState = matchBloc.state;
    if (matchState is MatchDetailLoaded) {
      _match = matchState.match;
      _lastKnownMatchStatus = matchState.match.status;
      _team1Controller.text =
          matchState.match.status == 3 ? '${matchState.match.team1Score}' : '0';
      _team2Controller.text =
          matchState.match.status == 3 ? '${matchState.match.team2Score}' : '0';
      _team1Score =
          matchState.match.status == 3 ? matchState.match.team1Score : 0;
      _team2Score =
          matchState.match.status == 3 ? matchState.match.team2Score : 0;

      // Start periodic refresh for non-owners
      if (!matchState.isOwner) {
        _startPeriodicRefresh(matchState.match.id);
      }
    } else {
      _match = null;
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    
    // Remove listeners before disposing controllers
    _team1Controller.removeListener(controllerListener);
    _team2Controller.removeListener(controllerListener);
    
    _team1Controller.dispose();
    _team2Controller.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _startPeriodicRefresh(int matchId) {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      _checkMatchStatusUpdate(matchId);
    });
  }

  void _checkMatchStatusUpdate(int matchId) async {
    try {
      final matchBloc = context.read<MatchBloc>();
      matchBloc.add(RefreshMatchStatus(
          matchId: matchId, lastKnownStatus: _lastKnownMatchStatus));
    } catch (e) {
      // Silently handle errors during background refresh
      print('Error refreshing match status: $e');
    }
  }

  void controllerListener() {
    final t1 = int.tryParse(_team1Controller.text) ?? 0;
    final t2 = int.tryParse(_team2Controller.text) ?? 0;
    final winScore = MatchWinScore.fromValue(_match?.winScore ?? 0)?.value ?? 0;

    final isTeam1Win = t1 == winScore;
    final isTeam2Win = t2 == winScore;
    final onlyOneTeamWins = isTeam1Win ^ isTeam2Win;

    final isValid = t1 >= 0 &&
        t1 <= winScore &&
        t2 >= 0 &&
        t2 <= winScore &&
        (!isTeam1Win || !isTeam2Win) &&
        onlyOneTeamWins;

    valueListenable.value = isValid;
  }

  void _onScoreChanged(String value, int teamIndex, int winScore) {
    final score = int.tryParse(value) ?? 0;

    setState(() {
      if (teamIndex == 0) {
        _team1Score = score;
      } else {
        _team2Score = score;
      }

      final isTeam1ValidMin = (_team1Score ?? 0) >= 0;
      final isTeam1ValidMax = (_team1Score ?? 0) <= winScore;
      final isTeam2ValidMin = (_team2Score ?? 0) >= 0;
      final isTeam2ValidMax = (_team2Score ?? 0) <= winScore;

      if (!isTeam1ValidMin) {
        _teamError = 'Home team score must be >= 0';
        return;
      }
      if (!isTeam1ValidMax) {
        _teamError = 'Home team score must be <= $winScore';
        return;
      }
      if (!isTeam2ValidMin) {
        _teamError = 'Away team score must be >= 0';
        return;
      }
      if (!isTeam2ValidMax) {
        _teamError = 'Away team score must be <= $winScore';
        return;
      }

      final isTeam1Win = _team1Score == winScore;
      final isTeam2Win = _team2Score == winScore;

      if (isTeam1Win && isTeam2Win) {
        _teamError = 'Only one team can reach $winScore to win';
      } else {
        _teamError = null;
      }
    });
  }

  bool isEndedMatch(MatchData match) {
    return (_team1Score == match.winScore || _team2Score == match.winScore) &&
        (_teamError == null) &&
        match.status == 2;
  }

  void _checkForChanges() {
    bool hasChanges = false;

    if (_changeTitle != null && _changeTitle != _initialTitle) {
      hasChanges = true;
    }
    if (_changeDescription != null &&
        _changeDescription != _initialDescription) {
      hasChanges = true;
    }
    if (_changeDate != null && _changeDate != _initialDate) {
      hasChanges = true;
    }
    if (_changeRefereeId != null && _changeRefereeId != _initialRefereeId) {
      hasChanges = true;
    }
    if (_changeVenueId != null && _changeVenueId != _initialVenueId) {
      hasChanges = true;
    }
    if (_changeMatchCategory != null &&
        _changeMatchCategory != _initialMatchCategory) {
      hasChanges = true;
    }
    if (_changeWinScore != null && _changeWinScore != _initialWinScore) {
      hasChanges = true;
    }
    if (_changeMatchFormat != null &&
        _changeMatchFormat != _initialMatchFormat) {
      hasChanges = true;
    }

    _isEditableNotifier.value = hasChanges;
  }

  void _initializeMatchDetails(MatchData match) {
    _initialTitle = match.title;
    _initialDescription = match.description;
    _initialDate = match.matchDate;
    _initialRefereeId = match.refereeId;
    _initialVenueId = match.venueId;
    _initialMatchCategory = MatchCategory.fromValue(match.matchCategory);
    _initialMatchFormat = TournamentFormant.fromValue(match.matchFormat);
    _initialWinScore = MatchWinScore.fromValue(match.winScore);

    _titleController.text = _changeTitle ?? _initialTitle!;
    _descriptionController.text = _changeDescription ?? _initialDescription!;
    _dateController.text = (_changeDate ?? _initialDate!).toString();
    _selectedMatchCategory = _changeMatchCategory ?? _initialMatchCategory;
    _selectedMatchFormat = _changeMatchFormat ?? _initialMatchFormat;
    _selectedWinScore = _changeWinScore ?? _initialWinScore;
    _selectedRefereeId = _changeRefereeId ?? _initialRefereeId;
    _selectedVenueId = _changeVenueId ?? _initialVenueId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Match Detail',
      ),
      body: BlocBuilder<MatchBloc, MatchState>(
        builder: (context, state) {
          if (state is MatchInitial) {
            return EmptyStateCard(
            icon: Icons.sports_baseball,
            title: "No Match Selected",
            description: "Waiting start...",
            iconColor: AppColors.primaryColor,
            iconSize: ResponsiveUtils.getScaledSize(context, 50),
          );
          } else if (state is MatchDetailLoading || state is MatchJoining) {
            return Container(
              color: Colors.white,
              child: Center(
                child: LoadingAnimationWidget.threeRotatingDots(
                  color: AppColors.primaryColor,
                  size: ResponsiveUtils.getScaledSize(context, 30),
                ),
              ),
            );
          } else if (state is MatchDetailLoaded) {
            final players = state.players;
            final match = state.match;
            final isOwner = state.isOwner;
            final referees = state.referees;
            final venues = state.venues;

            // Update the last known status and restart timer if needed
            if (_lastKnownMatchStatus != match.status) {
              _lastKnownMatchStatus = match.status;
            }

            // Start or stop the timer based on ownership status
            if (!isOwner && _refreshTimer == null) {
              _startPeriodicRefresh(match.id);
            } else if (isOwner && _refreshTimer != null) {
              _refreshTimer?.cancel();
              _refreshTimer = null;
            }

            _initializeMatchDetails(match);

            int totalMembers = 0;
            for (var team in match.teams) {
              totalMembers += team.membersCount;
            }
            bool hasEnoughPlayers =
                totalMembers >= (match.matchFormat == 1 ? 2 : 4);

            return Container(
              color: AppColors.primaryColor,
              child: Column(
                children: [
                  TeamInfoWidget(
                    match: match,
                    players: players,
                    isOwner: isOwner,
                  ),
                  SizedBox(height: 12.h),
                  MatchDetailContainerWidget(
                    isOwner: isOwner,
                    match: match,
                    players: players,
                    referees: referees,
                    venues: venues,
                    titleController: _titleController,
                    descriptionController: _descriptionController,
                    dateController: _dateController,
                    team1Controller: _team1Controller,
                    team2Controller: _team2Controller,
                    teamError: _teamError,
                    onTitleChanged: (value) {
                      setState(() {
                        _changeTitle = value;
                        _checkForChanges();
                      });
                    },
                    onDescriptionChanged: (value) {
                      setState(() {
                        _changeDescription = value;
                        _checkForChanges();
                      });
                    },
                    onMatchDateChanged: (value) {
                      setState(() {
                        _changeDate = value;
                        _checkForChanges();
                      });
                    },
                    onVenueChanged: (value) {
                      setState(() {
                        _changeVenueId = value;
                        _checkForChanges();
                      });
                    },
                    onRefereeChanged: (value) {
                      setState(() {
                        _changeRefereeId = value;
                        _checkForChanges();
                      });
                    },
                    onMatchCategoryChanged: (value) {
                      setState(() {
                        _changeMatchCategory = value;
                        _checkForChanges();
                      });
                    },
                    onMatchFormatChanged: (value) {
                      setState(() {
                        _changeMatchFormat = value;
                        _checkForChanges();
                      });
                    },
                    onWinScoreChanged: (value) {
                      setState(() {
                        _changeWinScore = value;
                        _checkForChanges();
                      });
                    },
                    onScoreChanged: _onScoreChanged,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: Row(
                      children: [
                        if (isOwner) ...[
                          if (match.status == 1) ...[
                            Expanded(
                              child: ValueListenableBuilder<bool>(
                                valueListenable: _isEditableNotifier,
                                builder: (context, isEditable, _) {
                                  return ElevatedButton(
                                    onPressed: isEditable
                                        ? () {
                                            context
                                                .read<MatchBloc>()
                                                .add(UpdateMatch(
                                                    matchId: match.id,
                                                    request: UpdateMatchRequest(
                                                      title: _changeTitle,
                                                      description:
                                                          _changeDescription,
                                                      matchDate: _changeDate,
                                                      matchFormat:
                                                          _changeMatchFormat
                                                              ?.value,
                                                      matchCategory:
                                                          _changeMatchCategory
                                                              ?.value,
                                                      winScore: _changeWinScore
                                                          ?.value,
                                                      refereeId:
                                                          _changeRefereeId,
                                                      venueId: _changeVenueId,
                                                    )));
                                          }
                                        : null,
                                    child: Text(
                                      'Edit Match',
                                      style: TextStyle(
                                        color: isEditable
                                            ? AppColors.primaryColor
                                            : Colors.grey,
                                        fontSize: ResponsiveUtils.getScaledSize(context, 16),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: hasEnoughPlayers &&(DateTime.now().isBefore(match.matchDate))
                                    ? () {
                                        context.read<MatchBloc>().add(
                                              StartMatch(matchId: match.id),
                                            );
                                      }
                                    : null,
                                child: Text(
                                  'Start Match',
                                  style: TextStyle(
                                    color: hasEnoughPlayers
                                        ? AppColors.primaryColor
                                        : Colors.grey,
                                    fontSize: ResponsiveUtils.getScaledSize(context, 16),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                          if (match.status == 2 &&
                              match.matchCategory !=
                                  MatchCategory.competitive.value) ...[
                            Expanded(
                                child: ValueListenableBuilder<bool>(
                              valueListenable: valueListenable,
                              builder: (context, isEndedMatch, child) {
                                return ElevatedButton(
                                  onPressed: isEndedMatch
                                      ? () {
                                          AutoRouter.of(context).push(
                                              EndMatchRoute(
                                                  team1Score: _team1Score ?? 0,
                                                  team2Score: _team2Score ?? 0,
                                                  matchId: match.id,
                                                  title: match.title));
                                        }
                                      : null,
                                  child: Text('End Match',
                                      style: TextStyle(
                                        color: isEndedMatch
                                            ? AppColors.primaryColor
                                            : Colors.grey,
                                        fontSize: ResponsiveUtils.getScaledSize(context, 16),
                                        fontWeight: FontWeight.bold,
                                      )),
                                );
                              },
                            )),
                          ],
                        ]
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
            );
          } else if (state is MatchError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }
}
