class RoomRequest {
  final String player1Id;
  final String title;
  final String location;
  final String notes;
  final bool isDoubles;
  final String matchType;
  final DateTime scheduledAt;
  final String status;

  RoomRequest({
    required this.player1Id,
    required this.title,
    required this.location,
    required this.notes,
    required this.isDoubles,
    required this.matchType,
    required this.scheduledAt,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'player1_id': player1Id,
      'title': title,
      'location': location,
      'notes': notes,
      'is_doubles': isDoubles,
      'match_type': matchType,
      'scheduled_at': scheduledAt.toIso8601String(),
      'status': status,
    };
  }
}
