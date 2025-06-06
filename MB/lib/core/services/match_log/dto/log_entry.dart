class LogEntry {
  final int team;
  final int points;
  final String timestamp;

  LogEntry({
    required this.team,
    required this.points,
    required this.timestamp,
  });

  factory LogEntry.fromMap(Map<dynamic, dynamic> map) {
    return LogEntry(
      team: map['team'],
      points: map['points'],
      timestamp: map['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'team': team,
      'points': points,
      'timestamp': timestamp,
    };
  }
}
