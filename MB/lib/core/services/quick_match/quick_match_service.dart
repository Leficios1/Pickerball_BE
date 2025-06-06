import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pickleball_app/core/models/models.dart';
import 'package:pickleball_app/core/services/quick_match/signalr_matchmaking_service.dart';

class QuickMatchService {
  final SignalRMatchmakingService _signalRService = SignalRMatchmakingService();

  Future<void> findMatch(User user, {
    required String city,
    required int matchFormat,
    required int ranking,
    required String connectionId,
  }) async {
    try {
      await _signalRService.initConnection();
      await _signalRService.findMatch(
        user,
        city: city,
        matchFormat: matchFormat,
        ranking: ranking,
      );
    } catch (e) {
      debugPrint('Error in findMatch: $e');
      throw Exception('Failed to find match: $e');
    }
  }

  Future<void> cancelFindMatch(String userId) async {
    try {
      await _signalRService.cancelFindMatch(int.parse(userId));
    } catch (e) {
      debugPrint('Error in cancelFindMatch: $e');
      throw Exception('Failed to cancel match finding: $e');
    }
  }

  Stream<String?> listenForMatchStatus(String userId) {
    return _signalRService.statusStream;
  }

  Stream<Map<String, dynamic>?> listenForMatchDetails(String userId) {
    return _signalRService.matchDetailsStream;
  }

  Future<void> notifyPlayerOfMatch(String playerId, String matchId) async {
    try {
      await _signalRService.notifyPlayerOfMatch(playerId, matchId);
    } catch (e) {
      debugPrint('Error in notifyPlayerOfMatch: $e');
      throw Exception('Failed to notify player of match: $e');
    }
  }

  Stream<String?> listenForCreatedMatch(String userId) {
    return _signalRService.createdMatchStream;
  }
}
