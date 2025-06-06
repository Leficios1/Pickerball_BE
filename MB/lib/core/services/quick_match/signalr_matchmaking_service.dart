import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pickleball_app/core/constants/app_constants.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/models/models.dart';

class SignalRMatchmakingService {
  HubConnection? _hubConnection;
  final StreamController<String> _statusStreamController = StreamController<String>.broadcast();
  final StreamController<Map<String, dynamic>> _matchDetailsStreamController = StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<String> _createdMatchStreamController = StreamController<String>.broadcast();

  // Public streams for consumers to listen to
  Stream<String> get statusStream => _statusStreamController.stream;
  Stream<Map<String, dynamic>> get matchDetailsStream => _matchDetailsStreamController.stream;
  Stream<String> get createdMatchStream => _createdMatchStreamController.stream;

  Future<void> initConnection() async {
    if (_hubConnection != null) {
      return;
    }

    try {
      // Initialize hub connection (replace with your actual hub URL)
      _hubConnection = HubConnectionBuilder()
          .withUrl('${AppConstants.apiBaseUrl}/matchHub')
          .withAutomaticReconnect()
          .build();

      // Set up event handlers
      _hubConnection!.on('MatchFound', _onMatchFound);
      _hubConnection!.on('RoomCreated', _onRoomCreated);
      _hubConnection!.on('RoomCreationFailed', _onRoomCreationFailed);
      _hubConnection!.on('WaitingForMatch', _onWaitingForMatch);

      // Start the connection
      await _hubConnection!.start();
      debugPrint('SignalR connection started');
    } catch (e) {
      debugPrint('Error initializing SignalR connection: $e');
      throw Exception('Failed to initialize matchmaking service: $e');
    }
  }

  Future<void> findMatch(User user, {
    required String city,
    required int matchFormat,
    required int ranking,
  }) async {
    try {
      await initConnection();

      final matchRequest = {
        'UserId': user.id,
        'Gender': user.gender,
        'Ranking': ranking,
        'Level': user.userDetails?.experienceLevel ?? 1,
        'MatchCategory': 1, // Competitive match
        'MatchFormat': matchFormat,
        'City': city,
        'ConnectionId': _hubConnection!.connectionId
      };

      debugPrint('Finding match with request: $matchRequest');
      await _hubConnection!.invoke('FindMatch', args: [matchRequest]);
    } catch (e) {
      debugPrint('Error finding match: $e');
      throw Exception('Failed to find match: $e');
    }
  }

  Future<void> cancelFindMatch(int userId) async {
    try {
      if (_hubConnection != null && _hubConnection!.state == HubConnectionState.connected) {
        await _hubConnection!.invoke('CancelFindMatch', args: [userId]);
        debugPrint('Cancelled match finding for user $userId');
      }
    } catch (e) {
      debugPrint('Error cancelling match finding: $e');
      throw Exception('Failed to cancel match finding: $e');
    }
  }

  Future<void> notifyPlayerOfMatch(String playerId, String matchId) async {
    try {
      if (_hubConnection != null && _hubConnection!.state == HubConnectionState.connected) {
        await _hubConnection!.invoke('NotifyPlayerOfMatch', args: [playerId, matchId]);
        debugPrint('Notified player $playerId about match $matchId');
      }
    } catch (e) {
      debugPrint('Error notifying player of match: $e');
      throw Exception('Failed to notify player of match: $e');
    }
  }

  void _onMatchFound(List<Object?>? parameters) {
    if (parameters != null && parameters.isNotEmpty) {
      debugPrint('Match found: ${parameters[0]}');
      try {
        final matchDetails = Map<String, dynamic>.from(parameters[0] as Map);
        _matchDetailsStreamController.add(matchDetails);
        _statusStreamController.add("matched");
      } catch (e) {
        debugPrint('Error parsing match details: $e');
      }
    }
  }

  void _onRoomCreated(List<Object?>? parameters) {
    if (parameters != null && parameters.isNotEmpty) {
      debugPrint('Room created: ${parameters[0]}');
      try {
        final roomData = parameters[0];
        final matchId = roomData.toString();
        if (matchId != null) {
          _createdMatchStreamController.add(matchId);
        }
      } catch (e) {
        debugPrint('Error parsing room data: $e');
      }
    }
  }

  void _onRoomCreationFailed(List<Object?>? parameters) {
    if (parameters != null && parameters.isNotEmpty) {
      final message = parameters[0]?.toString() ?? 'Unknown error';
      debugPrint('Room creation failed: $message');
      _statusStreamController.add("error:$message");
    }
  }

  void _onWaitingForMatch(List<Object?>? parameters) {
    debugPrint('Waiting for match...');
    _statusStreamController.add("waiting");
  }

  void dispose() {
    _hubConnection?.stop();
    _statusStreamController.close();
    _matchDetailsStreamController.close();
    _createdMatchStreamController.close();
  }
}
