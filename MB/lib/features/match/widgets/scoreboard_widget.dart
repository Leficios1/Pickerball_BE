import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pickleball_app/core/blocs/app_bloc.dart';
import 'package:pickleball_app/core/blocs/app_state.dart';
import 'dart:math' as Math;
import 'package:pickleball_app/core/constants/app_enums.dart';
import 'package:pickleball_app/core/models/match_submission.dart';
import 'package:pickleball_app/core/services/match/dto/get_match_response.dart';
import 'package:pickleball_app/core/services/match_log/dto/log_entry.dart';
import 'package:pickleball_app/core/services/match_log/service.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/themes/app_theme.dart';
import 'package:pickleball_app/core/utils/extensions.dart';
import 'package:provider/provider.dart';

import '../../../core/services/match_submission/service.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../router/router.gr.dart';

class ScoreboardWidget extends StatefulWidget {
  final MatchData match;
  final TextEditingController team1Controller;
  final TextEditingController team2Controller;
  final Function(String, int, int) onScoreChanged;
  final String? teamError;

  const ScoreboardWidget({
    super.key,
    required this.match,
    required this.team1Controller,
    required this.team2Controller,
    required this.onScoreChanged,
    this.teamError,
  });

  @override
  State<ScoreboardWidget> createState() => _ScoreboardWidgetState();
}

class _ScoreboardWidgetState extends State<ScoreboardWidget> {
  int _currentRound = 1;
  int _totalRounds = 3;
  int _team1Wins = 0;
  int _team2Wins = 0;
  bool _isFirebaseInitialized = false;
  MatchSubmission? _matchSubmission;
  StreamSubscription? _matchSubscription;
  final MatchSubmissionService _submissionService = MatchSubmissionService();
  bool _isOwner = false;
  bool _isTeam1 = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _calculateWins();
    _checkFirebaseInitialization();

    if (_isFirebaseInitialized &&
        widget.match.matchCategory == MatchCategory.competitive.value) {
      _setupMatchSubmission();
      _checkUserTeam();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkFirebaseInitialization();
  }

  @override
  void dispose() {
    _matchSubscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _setupMatchSubmission() {
    _submissionService.createDefaultRecord(widget.match.id);
    _matchSubscription =
        _submissionService.getMatchStream(widget.match.id).listen((submission) {
      if (submission != null && mounted) {
        setState(() {
          _matchSubmission = submission;

          // Update controllers if scores are submitted
          if (submission.isSend) {
            final team1Score = submission.submissions['team1score'] ?? 0;
            final team2Score = submission.submissions['team2score'] ?? 0;

            if (widget.team1Controller.text != team1Score.toString()) {
              widget.team1Controller.text = team1Score.toString();
            }
            if (widget.team2Controller.text != team2Score.toString()) {
              widget.team2Controller.text = team2Score.toString();
            }
          }
        });
      }
    });
  }

  void _checkUserTeam() {
    final appState = context.read<AppBloc>().state;
    if (appState is AppAuthenticatedPlayer) {
      setState(() {
        _isOwner = appState.userInfo.id == widget.match.roomOwner;

        // Determine if user is in team 1 or team 2
        for (var team in widget.match.teams) {
          if (team.id == 1 &&
              team.members.any((m) => m.id == appState.userInfo.id)) {
            _isTeam1 = true;
            break;
          }
        }
      });
    }
  }

  Future<void> _submitScore() async {
    if (!_isFirebaseInitialized) return;

    final team1Score = int.tryParse(widget.team1Controller.text) ?? 0;
    final team2Score = int.tryParse(widget.team2Controller.text) ?? 0;

    await _submissionService.submitScore(
      widget.match.id,
      team1Score,
      team2Score,
    );
  }

  Future<void> _acceptScore(bool isTeam1) async {
    if (!_isFirebaseInitialized) return;

    await _submissionService.acceptScore(
      widget.match.id,
      isTeam1,
    );
  }

  Future<void> _resetMatchSubmission() async {
    if (!_isFirebaseInitialized) return;

    await _submissionService.resetMatch(widget.match.id);
  }

  Future<void> _checkFirebaseInitialization() async {
    try {
      _isFirebaseInitialized = Firebase.apps.isNotEmpty;
      if (mounted) setState(() {});
    } catch (e) {
      print('Error checking Firebase initialization: $e');
      _isFirebaseInitialized = false;
      if (mounted) setState(() {});
    }
  }

  void _calculateWins() {
    setState(() {
      _team1Wins = widget.match.team1Score ?? 0;
      _team2Wins = widget.match.team2Score ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isReadOnly = true;
    if (widget.match.matchCategory == 3) {
      isReadOnly = true;
    } else {
      if (widget.match.status == 2) {
        if (widget.match.matchCategory == 2) {
          isReadOnly = false;
        } else if (widget.match.matchCategory == 1 &&
            widget.match.status == 2) {
          final appState = context.read<AppBloc>().state;
          if (appState is AppAuthenticatedPlayer) {
            if (appState.userInfo.id == widget.match.roomOwner) {
              isReadOnly = false;
            } else {
              isReadOnly = true;
            }
          }
        }
      }
    }

    if (widget.match.matchCategory == MatchCategory.tournament.value) {
      return _buildTournamentScoreboard();
    } else if (widget.match.matchCategory == MatchCategory.custom.value) {
      return _buildRegularScoreboard(isReadOnly);
    } else {
      return _buildCompetitiveScoreboard(isReadOnly);
    }
  }

  Widget _buildTournamentScoreboard() {
    if (!_isFirebaseInitialized) {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildRoundWinsHeader(),
              const SizedBox(height: 16),
              _buildRoundSelection(),
              const SizedBox(height: 16),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          size: 48, color: Colors.orange),
                      SizedBox(height: 16),
                      Text(
                        'Firebase not initialized',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Real-time scoring is unavailable',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => MatchLogsViewModel(
        matchId: widget.match.id,
        round: _currentRound,
        matchWinScore: MatchWinScore.fromValue(widget.match.winScore)!.value,
      ),
      child: Builder(
        builder: (context) {
          final viewModel = Provider.of<MatchLogsViewModel>(context);
          _totalRounds = viewModel.logCount;
          _team1Wins = viewModel.team1Wins;
          _team2Wins = viewModel.team2Wins;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  _buildRoundWinsHeader(),
                  const SizedBox(height: 16),
                  _buildRoundSelection(),
                  const SizedBox(height: 16),
                  _buildRoundCardsList(),
                  // Add space at bottom for better scrolling
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRoundWinsHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      width: 150,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTeamWinCounter(_team1Wins),
          Container(
            height: 40,
            width: 2,
            color: Colors.white.withOpacity(0.5),
          ),
          _buildTeamWinCounter(_team2Wins),
        ],
      ),
    );
  }

  Widget _buildTeamWinCounter(int wins) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Center(
            child: Text(
              wins.toString(),
              style: TextStyle(
                fontSize: 18,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoundSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Rounds',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildRoundCardsList() {
    if (!_isFirebaseInitialized) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('Firebase not initialized. Realtime scoring unavailable.'),
      );
    }

    return Consumer<MatchLogsViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.logCount == 0) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.sports_score, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No rounds data available',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          );
        }

        // Always ensure we at least show round 1 even if logCount is wrong
        final roundsToShow = Math.max(viewModel.logCount, 1);

        // Use ListView.builder instead of Column for better scrolling behavior
        return ListView.builder(
          // These physics settings are crucial - they tell this ListView
          // to scroll with the parent ScrollView instead of independently
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: roundsToShow,
          itemBuilder: (context, index) {
            final roundNumber = index + 1;

            return ChangeNotifierProvider.value(
              // Use .value constructor to prevent unnecessary rebuilds
              value: MatchLogsViewModel(
                matchId: widget.match.id,
                round: roundNumber,
                matchWinScore:
                    MatchWinScore.fromValue(widget.match.winScore)!.value,
              ),
              child: _RoundScoreCard(
                roundNumber: roundNumber,
                team1Name: 'Home Team',
                team2Name: 'Away Team',
                onTap: () => _showRoundDetailPopup(roundNumber),
              ),
            );
          },
        );
      },
    );
  }

  void _showRoundDetailPopup(int roundNumber) {
    if (!_isFirebaseInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Firebase not initialized. Cannot show round details.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => _RoundDetailDialog(
        matchId: widget.match.id,
        roundNumber: roundNumber,
        team1Name: 'Home Team',
        team2Name: 'Away Team',
      ),
    );
  }

  Widget _buildRegularScoreboard(bool isReadOnly) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 40,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Home Team',
                      style: TextStyle(
                          fontSize: ResponsiveUtils.getScaledSize(context, 16),
                          color: Colors.white,
                          fontWeight: FontWeight.w700)),
                  Text('Away Team',
                      style: TextStyle(
                          fontSize: ResponsiveUtils.getScaledSize(context, 16),
                          color: Colors.white,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                    width: (MediaQuery.of(context).size.width - 40) / 3 - 20,
                    child: Center(
                      child: TextField(
                          controller: widget.team1Controller,
                          onChanged: (value) {
                            widget.onScoreChanged(
                                value,
                                0,
                                MatchWinScore.fromValue(widget.match.winScore)!
                                    .value);
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                          ),
                          style: TextStyle(
                            fontSize:
                                ResponsiveUtils.getScaledSize(context, 16),
                            color: Colors.black,
                          ),
                          readOnly: isReadOnly,
                          textAlign: TextAlign.center),
                    )),
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 40) / 3 - 20,
                  child: Center(
                    child: TextField(
                      controller: widget.team2Controller,
                      onChanged: (value) {
                        widget.onScoreChanged(
                            value,
                            1,
                            MatchWinScore.fromValue(widget.match.winScore)!
                                .value);
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: ResponsiveUtils.getScaledSize(context, 16),
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                      readOnly: isReadOnly,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            if (widget.teamError != null) ...[
              Text(
                widget.teamError!,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: ResponsiveUtils.getScaledSize(context, 14),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildCompetitiveScoreboard(bool isReadOnly) {
    final bool isCompetitive =
        widget.match.matchCategory == MatchCategory.competitive.value;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 40,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Home Team',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w700)),
                  Text('Away Team',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 40) / 3 - 20,
                  child: TextField(
                      controller: widget.team1Controller,
                      onChanged: (value) {
                        widget.onScoreChanged(
                            value,
                            0,
                            MatchWinScore.fromValue(widget.match.winScore)!
                                .value);
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      style: TextStyle(
                        fontSize: ResponsiveUtils.getScaledSize(context, 16),
                        color: Colors.black,
                      ),
                      readOnly: isReadOnly,
                      textAlign: TextAlign.center),
                ),
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 40) / 3 - 20,
                  child: TextField(
                      controller: widget.team2Controller,
                      onChanged: (value) {
                        widget.onScoreChanged(
                            value,
                            1,
                            MatchWinScore.fromValue(widget.match.winScore)!
                                .value);
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      readOnly: isReadOnly,
                      style: TextStyle(
                        fontSize: ResponsiveUtils.getScaledSize(context, 16),
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center),
                ),
              ],
            ),
            SizedBox(height: 10),
            if (widget.teamError != null) ...[
              Text(
                widget.teamError!,
                style: TextStyle(color: Colors.red),
              ),
            ],

            // Competitive match score verification UI
            if (isCompetitive && _isFirebaseInitialized) ...[
              SizedBox(height: 16),
              Divider(height: 1, color: Colors.grey.shade300),
              SizedBox(height: 16),

              // Room owner UI for submitting scores
              if (_isOwner &&
                  _matchSubmission?.accepted1 == false &&
                  _matchSubmission?.accepted2 == false) ...[
                ElevatedButton(
                  onPressed: _submitScore,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  ),
                  child: Text(
                    'Submit Score for Verification',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              if (_isOwner && _matchSubmission?.isSend == true) ...[
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Score Verification Required',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text('Home',
                                  style: TextStyle(color: Colors.grey)),
                              SizedBox(height: 4),
                              Text(
                                '${_matchSubmission?.submissions['team1score'] ?? 0}',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(width: 40),
                          Column(
                            children: [
                              Text('Away',
                                  style: TextStyle(color: Colors.grey)),
                              SizedBox(height: 4),
                              Text(
                                '${_matchSubmission?.submissions['team2score'] ?? 0}',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'You have approved this score',
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Waiting for team approval:',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildApprovalStatus(
                              'Home', _matchSubmission?.accepted1 ?? false),
                          SizedBox(width: 24),
                          _buildApprovalStatus(
                              'Away', _matchSubmission?.accepted2 ?? false),
                        ],
                      ),
                      SizedBox(height: 12),
                      if (_isOwner &&
                          _matchSubmission?.accepted1 == true &&
                          _matchSubmission?.accepted2 == true &&
                          widget.match.status == MatchStatus.ongoing.value) ...[
                        TextButton.icon(
                          onPressed: _resetMatchSubmission,
                          icon: Icon(Icons.refresh, size: 18),
                          label: Text('Reset Submission'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ],
              // Player UI for verifying scores
              if (!_isOwner && _matchSubmission?.isSend == true) ...[
                _buildScoreVerificationCard(),
              ],

              // Success UI when both teams have verified
              if (_matchSubmission?.accepted1 == true &&
                  _matchSubmission?.accepted2 == true) ...[
                if (_isOwner &&
                    _matchSubmission?.accepted1 == true &&
                    _matchSubmission?.accepted2 == true &&
                    widget.match.status == MatchStatus.ongoing.value) ...[
                  ElevatedButton(
                    onPressed: () {
                      AutoRouter.of(context).push(EndMatchRoute(
                          team1Score:
                              _matchSubmission?.submissions['team1score'] ?? 0,
                          team2Score:
                              _matchSubmission?.submissions['team2score'] ?? 0,
                          matchId: widget.match.id,
                          title: widget.match.title));
                    },
                    child: Text('End Match',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ],
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        'Score verified by both teams',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildApprovalStatus(String teamName, bool isApproved) {
    return Row(
      children: [
        Text(teamName + ': '),
        isApproved
            ? Icon(Icons.check_circle, color: Colors.green, size: 20)
            : Icon(Icons.pending, color: Colors.orange, size: 20),
      ],
    );
  }

  Widget _buildScoreVerificationCard() {
    final bool canAccept =
        (_isTeam1 && !(_matchSubmission?.accepted1 ?? false)) ||
            (!_isTeam1 && !(_matchSubmission?.accepted2 ?? false));

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        children: [
          Text(
            'Score Verification Required',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text('Home', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 4),
                  Text(
                    '${_matchSubmission?.submissions['team1score'] ?? 0}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(width: 40),
              Column(
                children: [
                  Text('Away', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 4),
                  Text(
                    '${_matchSubmission?.submissions['team2score'] ?? 0}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),

          // Accept button
          if (canAccept) ...[
            ElevatedButton(
              onPressed: () => _acceptScore(_isTeam1),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
              ),
              child:
                  Text('Accept Score', style: TextStyle(color: Colors.white)),
            ),
          ] else ...[
            Text(
              'You have approved this score',
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ],

          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildApprovalStatus(
                  'Home', _matchSubmission?.accepted1 ?? false),
              SizedBox(width: 24),
              _buildApprovalStatus(
                  'Away', _matchSubmission?.accepted2 ?? false),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoundScoreCard extends StatelessWidget {
  final int roundNumber;
  final String team1Name;
  final String team2Name;
  final VoidCallback onTap;

  const _RoundScoreCard({
    required this.roundNumber,
    required this.team1Name,
    required this.team2Name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MatchLogsViewModel>(
      builder: (context, viewModel, _) {
        int team1Score = viewModel.team1Points;
        int team2Score = viewModel.team2Points;

        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Round $roundNumber',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      Icon(
                        Icons.info_outline,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildTeamScore(
                          teamName: team1Name,
                          score: team1Score,
                          isWinner: team1Score > team2Score &&
                              (team1Score >= viewModel.matchWinScore &&
                                  (team1Score - team2Score) >= 2)),
                      Container(
                        height: 50,
                        width: 1,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                      _buildTeamScore(
                          teamName: team2Name,
                          score: team2Score,
                          isWinner: team2Score > team1Score &&
                              (team2Score >= viewModel.matchWinScore &&
                                  (team2Score - team1Score) >= 2)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTeamScore(
      {required String teamName, required int score, required bool isWinner}) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              teamName,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            if (isWinner) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.emoji_events,
                color: Colors.amber,
                size: 16,
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Text(
          score.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isWinner ? AppColors.primaryColor : Colors.black,
          ),
        ),
      ],
    );
  }
}

class _RoundDetailDialog extends StatelessWidget {
  final int matchId;
  final int roundNumber;
  final String team1Name;
  final String team2Name;

  const _RoundDetailDialog({
    required this.matchId,
    required this.roundNumber,
    required this.team1Name,
    required this.team2Name,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Round $roundNumber Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: FutureBuilder<List<LogEntry>>(
                future:
                    MatchLogService().getMatchRoundLogs(matchId, roundNumber),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error loading logs: ${snapshot.error}'),
                    );
                  }

                  final logs = snapshot.data ?? [];

                  if (logs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline,
                              size: 48, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('No logs available for Round $roundNumber'),
                          SizedBox(height: 8),
                          Text(
                            'This round has not started yet or has no recorded points',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          )
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      final teamName = log.team == 1 ? team1Name : team2Name;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              AppColors.primaryColor.withOpacity(0.2),
                          child: Text(
                            '${log.team}',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text('$teamName: ${log.points} points'),
                        subtitle: Text('Time: ${log.timestamp}'),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
