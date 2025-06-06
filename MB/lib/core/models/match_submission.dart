class MatchSubmission {
  final Map<String, dynamic> submissions;
  final bool accepted1;
  final bool accepted2;
  final bool isSend;
  final String? note;

  MatchSubmission({
    required this.submissions,
    required this.accepted1,
    required this.accepted2,
    required this.isSend,
    this.note,
  });

  factory MatchSubmission.fromJson(Map<dynamic, dynamic> json) {
    return MatchSubmission(
      submissions: json['submissions'] != null
          ? Map<String, dynamic>.from(json['submissions'] as Map)
          : {'team1score': 0, 'team2score': 0},
      accepted1: json['accepted_1'] ?? false,
      accepted2: json['accepted_2'] ?? false,
      isSend: json['isSend'] ?? false,
      note: json['note'],
    );
  }
}
