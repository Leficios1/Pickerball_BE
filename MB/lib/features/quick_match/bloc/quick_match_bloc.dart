import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:pickleball_app/core/blocs/app_bloc.dart';
import 'package:pickleball_app/core/blocs/app_state.dart';
import 'package:pickleball_app/core/constants/app_enums.dart';
import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/services/match/dto/match_request.dart';
import 'package:pickleball_app/core/services/quick_match/quick_match_service.dart';
import 'package:pickleball_app/core/utils/snackbar_helper.dart';
import 'package:pickleball_app/features/match/bloc/create_match/create_match_bloc.dart';
import 'package:pickleball_app/features/match/bloc/create_match/create_match_event.dart';
import 'package:pickleball_app/features/match/bloc/create_match/create_match_state.dart';
import 'package:pickleball_app/features/match/bloc/match_bloc.dart';
import 'package:pickleball_app/features/match/bloc/match_event.dart';
import 'package:pickleball_app/features/quick_match/bloc/quick_match_event.dart';
import 'package:pickleball_app/features/quick_match/bloc/quick_match_state.dart';
import 'package:pickleball_app/router/router.gr.dart';

import '../../../core/models/user.dart';

class QuickMatchBloc extends Bloc<QuickMatchEvent, QuickMatchState> {
  final AppBloc appBloc;
  final QuickMatchService quickMatchService;
  final CreateMatchBloc createMatchBloc;
  final MatchBloc matchBloc;
  StreamSubscription? _statusSubscription;
  StreamSubscription? _matchDetailsSubscription;
  StreamSubscription? _createdMatchSubscription;
  String? _userId;
  String? _matchOpponentId;
  StreamSubscription? _createMatchSubscription;

  QuickMatchBloc({
    required this.appBloc,
    required this.quickMatchService,
    required this.createMatchBloc,
    required this.matchBloc,
  }) : super(QuickMatchInitial()) {
    on<StartQuickMatch>(_onStartQuickMatch);
    on<CancelQuickMatch>(_onCancelQuickMatch);
    on<QuickMatchStatusUpdated>(_onStatusUpdated);
    on<QuickMatchDetailsReceived>(_onMatchDetailsReceived);
    on<LoadUserInfoEvent>(_onLoadUserInfo);

    // Subscribe to CreateMatchBloc events
    _createMatchSubscription = createMatchBloc.stream.listen((state) {
      if (state is CreateMatchSuccess) {
        SnackbarHelper.showSnackBar('Match created successfully!');
        // Notify opponent about the created match
        if (_matchOpponentId != null) {
          quickMatchService.notifyPlayerOfMatch(_matchOpponentId!, state.match.id.toString());
        }
      } else if (state is CreateMatchError) {
        SnackbarHelper.showSnackBar('Error creating match: ${state.message}');
      }
    });
  }

  Future<void> _onStartQuickMatch(
    StartQuickMatch event,
    Emitter<QuickMatchState> emit
  ) async {
    try {
      final appState = appBloc.state;

      // Extract user information regardless of authentication type
      int? userId;
      User userData;

      if (appState is AppAuthenticatedPlayer) {
        userId = appState.userInfo.id;
        userData = appState.userInfo;
      } else {
        emit(const QuickMatchError('You need to be logged in to find matches'));
        return;
      }

      if (userId == null) {
        emit(const QuickMatchError('User ID not found'));
        return;
      }

      _userId = userId.toString();

      emit(QuickMatchSearching());

      // Generate a unique connection ID for backward compatibility
      final connectionId = DateTime.now().millisecondsSinceEpoch.toString();

      // Start listening for status changes
      _statusSubscription?.cancel();
      _statusSubscription = quickMatchService
          .listenForMatchStatus(_userId!)
          .listen((status) {
        if (status == "matched") {
          add(const QuickMatchStatusUpdated("matched"));
        } else if (status != null && status.startsWith("error:")) {
          emit(QuickMatchError(status.substring(6)));
        }
      });

      // Start listening for match details
      _matchDetailsSubscription?.cancel();
      _matchDetailsSubscription = quickMatchService
          .listenForMatchDetails(_userId!)
          .listen((matchDetails) {
        if (matchDetails != null) {
          add(QuickMatchDetailsReceived(matchDetails));
        }
      });

      // Start listening for created matches (for player2)
      _createdMatchSubscription?.cancel();
      _createdMatchSubscription = quickMatchService
          .listenForCreatedMatch(_userId!)
          .listen((matchId) {
        if (matchId != null) {
          // Select the match, which will navigate to the match screen
          matchBloc.add(SelectMatch(int.parse(matchId)));

          // Cleanup subscriptions since we've found a match
          _cleanupSubscriptions();
        }
      });

      // Find a match using SignalR
      await quickMatchService.findMatch(
        userData,
        city: event.city,
        matchFormat: event.matchFormat,
        ranking: event.ranking,
        connectionId: connectionId, // Kept for backward compatibility
      );

    } catch (e) {
      emit(QuickMatchError("Failed to find match: ${e.toString()}"));
      _cleanupSubscriptions();
    }
  }

  Future<void> _onCancelQuickMatch(
    CancelQuickMatch event,
    Emitter<QuickMatchState> emit
  ) async {
    if (_userId == null) return;

    try {
      emit(QuickMatchCancelled());
      _cleanupSubscriptions();
    } catch (e) {
      emit(QuickMatchError(e.toString()));
    }
  }

  void _onStatusUpdated(
    QuickMatchStatusUpdated event,
    Emitter<QuickMatchState> emit
  ) {
    if (event.status == "matched") {
      // The match details will be delivered via the match details stream
    }
  }

  void _onMatchDetailsReceived(
      QuickMatchDetailsReceived event,
      Emitter<QuickMatchState> emit,
      ) async {
    try {
      final matchDetails = event.matchDetails;
      debugPrint('Received match details: $matchDetails');

      emit(QuickMatchFound(matchDetails));
      SnackbarHelper.showSnackBar('Opponent found! Waiting for room...');

      // Save opponent ID
      if (matchDetails.containsKey('rival')) {
        final rival = matchDetails['rival'];
        if (rival != null && rival['userId'] != null) {
          _matchOpponentId = rival['userId'].toString();
        }
      }

      // DON'T navigate yet, just wait for createdMatchSubscription to trigger

    } catch (e) {
      debugPrint('Error handling match details: $e');
      emit(QuickMatchError("Failed to process match details: ${e.toString()}"));
      _cleanupSubscriptions();
    }
  }


  Future<void> _onLoadUserInfo(
    LoadUserInfoEvent event, 
    Emitter<QuickMatchState> emit
  ) async {
    try {
      final appState = appBloc.state;
      
      String userName = "";
      String city = "New York"; // Default city
      int matchFormat = 1; // Default to singles
      int ranking = 5; // Default ranking
      
      if (appState is AppAuthenticatedPlayer) {
        userName = "${appState.userInfo.firstName} ${appState.userInfo.lastName}";
        
        // Retrieve player-specific info if available
        if (appState.userInfo.userDetails != null) {
          city = appState.userInfo.userDetails!.city ?? city;
          ranking = appState.userInfo.userDetails!.experienceLevel ?? ranking;
        }
      }
      
      emit(LoadUserInfo(
        city: city,
        matchFormat: matchFormat,
        ranking: ranking,
        userName: userName,
      ));
    } catch (e) {
      emit(QuickMatchError(e.toString()));
    }
  }

  void _cleanupSubscriptions() {
    _statusSubscription?.cancel();
    _statusSubscription = null;
    _matchDetailsSubscription?.cancel();
    _matchDetailsSubscription = null;
    _createdMatchSubscription?.cancel();
    _createdMatchSubscription = null;
  }

  @override
  Future<void> close() {
    _cleanupSubscriptions();
    _createMatchSubscription?.cancel();
    return super.close();
  }
}
