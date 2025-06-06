import 'package:equatable/equatable.dart';

class TournamentDetails extends Equatable {
  final int id;
  final int playerId1;
  final int? playerId2;
  final int? playerId3;
  final int? playerId4;
  final DateTime scheduledTime;
  final String score;
  final String result;

  const TournamentDetails({
    required this.id,
    required this.playerId1,
    this.playerId2,
    this.playerId3,
    this.playerId4,
    required this.scheduledTime,
    required this.score,
    required this.result,
  });

  factory TournamentDetails.fromJson(Map<String, dynamic> json) {
    return TournamentDetails(
      id: json['id'],
      playerId1: json['playerId1'],
      playerId2: json['playerId2'] != null ? json['playerId2'] as int : null,
      playerId3: json['playerId3'] != null ? json['playerId3'] as int : null,
      playerId4: json['playerId4'] != null ? json['playerId4'] as int : null,
      scheduledTime: DateTime.parse(json['scheduledTime']),
      score: json['score'],
      result: json['result'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playerId1': playerId1,
      'playerId2': playerId2,
      'playerId3': playerId3,
      'playerId4': playerId4,
      'scheduledTime': scheduledTime.toIso8601String(),
      'score': score,
      'result': result,
    };
  }

  @override
  List<Object?> get props => [
        id,
        playerId1,
        playerId2,
        playerId3,
        playerId4,
        scheduledTime,
        score,
        result
      ];
}
