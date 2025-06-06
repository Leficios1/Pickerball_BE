import 'package:firebase_database/firebase_database.dart';
import 'package:pickleball_app/core/models/match_submission.dart';

class MatchSubmissionService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  DatabaseReference _getMatchRef(int matchId) {
    return _database.ref('/competitive/$matchId');
  }

  Stream<MatchSubmission?> getMatchStream(int matchId) {
    return _getMatchRef(matchId).onValue.map((event) {
      if (event.snapshot.exists) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        return MatchSubmission.fromJson(data);
      }
      return null;
    });
  }

  Future<void> createDefaultRecord(int matchId) async {
    final ref = _getMatchRef(matchId);
    final snapshot = await ref.get();
    if (!snapshot.exists) {
      await ref.set({
        'submissions': {
          'team1score': 0,
          'team2score': 0,
        },
        'accepted_1': false,
        'accepted_2': false,
        'isSend': false,
        'note': '',
      });
    }
  }

  Future<void> submitScore(int matchId, int team1score, int team2score) async {
    await _getMatchRef(matchId).update({
      'submissions': {
        'team1score': team1score,
        'team2score': team2score,
      },
      'accepted_1': true,
      'isSend': true,
    });
  }

  Future<void> acceptScore(int matchId, bool isTeam1) async {
    final field = isTeam1 ? 'accepted_1' : 'accepted_2';
    await _getMatchRef(matchId).update({
      field: true,
    });
  }

  Future<void> resetMatch(int matchId) async {
    await _getMatchRef(matchId).update({
      'submissions': {
        'team1score': 0,
        'team2score': 0,
      },
      'accepted_1': false,
      'accepted_2': false,
      'isSend': false,
      'note': '',
    });
  }
}