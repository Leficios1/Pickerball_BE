import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pickleball_app/core/services/match_log/dto/log_entry.dart';
import 'package:pickleball_app/core/services/match_log/dto/round_score.dart';
import 'dart:async';

class MatchLogsViewModel extends ChangeNotifier {
  final int matchId;
  final int round;
  final int matchWinScore;
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  StreamSubscription<DatabaseEvent>? _subscription;
  StreamSubscription<DatabaseEvent>? _allRoundsSubscription;
  StreamSubscription<DatabaseEvent>? _logCountSubscription;

  final List<LogEntry> _logs = [];
  final Map<int, RoundScore> _roundScores = {};

  int _logCount = 0;
  int _team1Points = 0;
  int _team2Points = 0;
  int _team1wins = 0;
  int _team2wins = 0;
  int _currentRound = 1;
  final int _rounds;
  int _extendedWinScore = 0;
  bool _isHistoricalDataLoaded = false;
  bool _isDisposed = false;

  MatchLogsViewModel({
    required this.matchId,
    required this.round,
    required this.matchWinScore,
    int? roundsCount,
  }) : _rounds = roundsCount ?? 3 {
    _extendedWinScore = matchWinScore;
    _getLogCount();
    _listenToLogs();
    _loadHistoricalRoundScores();
  }

  String get _path => 'match_logs/match_$matchId/round_$round';
  String get _pathRound => 'match_logs/match_$matchId/';

  List<LogEntry> get logs => _logs;
  Map<int, RoundScore> get roundScores => _roundScores;
  int get logCount => _logCount;
  int get team1Points => _isHistoricalDataLoaded && _roundScores.containsKey(round)
      ? _roundScores[round]!.team1Points
      : _team1Points;
  int get team2Points => _isHistoricalDataLoaded && _roundScores.containsKey(round)
      ? _roundScores[round]!.team2Points
      : _team2Points;
  int get team1Wins => _team1wins;
  int get team2Wins => _team2wins;
  int get currentRound => _currentRound;

  // Load historical round scores for completed rounds
  Future<void> _loadHistoricalRoundScores() async {
    try {
      final ref = _db.ref(_pathRound);
      
      _allRoundsSubscription = ref.onValue.listen((event) {
        if (_isDisposed) return;
        final data = event.snapshot.value as Map<dynamic, dynamic>?;
        
        if (data != null) {
          // Process all round data
          _processAllRoundsData(data);
        }
        
        _isHistoricalDataLoaded = true;
        _notifyListenersSafely();
      });
    } catch (e) {
      print('Error loading historical round scores: $e');
    }
  }
  
  // Process all round data to extract scores for each round
  void _processAllRoundsData(Map<dynamic, dynamic> data) {
    int wins1 = 0;
    int wins2 = 0;
    
    // For each round in the data
    data.forEach((key, value) {
      if (key is String && key.startsWith('round_')) {
        final roundNum = int.tryParse(key.split('_')[1]);
        if (roundNum != null) {
          // Extract scores for this round
          final roundData = value as Map<dynamic, dynamic>;
          int team1Score = 0;
          int team2Score = 0;
          
          roundData.forEach((_, entry) {
            if (entry is Map<dynamic, dynamic>) {
              final teamId = entry['team'] as int?;
              final points = entry['points'] as int?;
              
              if (teamId == 1 && points != null) {
                team1Score += points;
              } else if (teamId == 2 && points != null) {
                team2Score += points;
              }
            }
          });
          
          // Store the calculated score
          _roundScores[roundNum] = RoundScore(
            roundNumber: roundNum,
            team1Points: team1Score,
            team2Points: team2Score,
          );
          
          // Calculate which team won this round
          if (team1Score >= matchWinScore && team1Score - team2Score >= 2) {
            wins1++;
          } else if (team2Score >= matchWinScore && team2Score - team1Score >= 2) {
            wins2++;
          }
        }
      }
    });
    
    // Update win counts
    _team1wins = wins1;
    _team2wins = wins2;
    
    // Figure out current round (highest round number + 1)
    if (_roundScores.isNotEmpty) {
      _currentRound = _roundScores.keys.reduce((a, b) => a > b ? a : b) + 1;
      _currentRound = _currentRound > _rounds ? _rounds : _currentRound;
    }
    
    print('Loaded historical data: ${_roundScores.length} rounds, T1: $_team1wins wins, T2: $_team2wins wins');
  }

  void _getLogCount() async {
    final refRound = _db.ref(_pathRound);
    _logCountSubscription = refRound.onValue.listen((event) {
      if (_isDisposed) return;
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        _logCount = data.length;
        print('Match $matchId - Log count: $_logCount');
        
        // Ensure we always have at least round 1
        if (_logCount < 1) {
          _logCount = 1;
        }
        
        _notifyListenersSafely();
      } else {
        // If no data, assume we're at least on round 1
        _logCount = 1;
        _notifyListenersSafely();
      }
    });
  }

  void _listenToLogs() {
    final ref = _db.ref(_path);

    _subscription = ref.onValue.listen((event) {
      if (_isDisposed) return;
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      _logs.clear();
      _team1Points = 0;
      _team2Points = 0;

      if (data != null) {
        final entries = data.values.map((item) {
          return LogEntry.fromMap(Map<dynamic, dynamic>.from(item));
        }).toList();

        entries.sort((a, b) => a.timestamp.compareTo(b.timestamp));

        for (var log in entries) {
          if (log.team == 1) {
            _team1Points += log.points;
          } else {
            _team2Points += log.points;
          }

          _logs.add(log);
        }
        
        // Only check for winner if this is the current round
        if (round == _currentRound) {
          _processCurrentRoundWinner();
        }
      }

      _notifyListenersSafely();
    });
  }
  
  void _processCurrentRoundWinner() {
    final pointDiff = (_team1Points - _team2Points).abs();
    final reachedMatchScore = _team1Points >= matchWinScore || _team2Points >= matchWinScore;

    if (reachedMatchScore && pointDiff >= 2) {
      if (_team1Points > _team2Points) {
        _team1wins++;
        _currentRound++;
      } else {
        _team2wins++;
        _currentRound++;
      }
      
      // Add to round scores if a team won this round
      _roundScores[_team1wins + _team2wins] = RoundScore(
        roundNumber: _team1wins + _team2wins,
        team1Points: _team1Points,
        team2Points: _team2Points,
      );
      
      print('✅ Round completed: $_currentRound');
      print('🏆 Team1 wins: $_team1wins, Team2 wins: $_team2wins');
      
      // Reset for next round
      _team1Points = 0;
      _team2Points = 0;
      _extendedWinScore = matchWinScore;
    }
  }

  void _notifyListenersSafely() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _subscription?.cancel();
    _allRoundsSubscription?.cancel();
    _logCountSubscription?.cancel();
    super.dispose();
  }
}

// New service to get logs for a specific match round
class MatchLogService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;
  
  Future<List<LogEntry>> getMatchRoundLogs(int matchId, int roundNumber) async {
    try {
      print('Getting logs for match $matchId round $roundNumber');
      final ref = _db.ref('match_logs/match_$matchId/round_$roundNumber');
      final snapshot = await ref.get();
      
      if (snapshot.exists && snapshot.value != null) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        final entries = data.values.map((item) {
          return LogEntry.fromMap(Map<dynamic, dynamic>.from(item));
        }).toList();
        
        entries.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        print('Found ${entries.length} logs for match $matchId round $roundNumber');
        return entries;
      }
      
      print('No logs found for match $matchId round $roundNumber');
      return [];
    } catch (e) {
      print('Error getting match logs for match $matchId round $roundNumber: $e');
      return [];
    }
  }
  
  // Add a method to ensure round 1 exists
  Future<void> ensureRoundExists(int matchId, int roundNumber) async {
    try {
      final ref = _db.ref('match_logs/match_$matchId/round_$roundNumber');
      final snapshot = await ref.get();
      
      if (!snapshot.exists || snapshot.value == null) {
        // Create an empty node for the round if it doesn't exist
        await ref.set({
          'initialized': {
            'team': 0,
            'points': 0,
            'timestamp': DateTime.now().toIso8601String()
          }
        });
        print('Created empty node for match $matchId round $roundNumber');
      }
    } catch (e) {
      print('Error ensuring round exists for match $matchId round $roundNumber: $e');
    }
  }
}
