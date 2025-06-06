class CreateTournamentRequest {
  final String name;
  final String location;
  final int maxPlayer;
  final String description;
  final String banner;
  final String note;
  final int? isMinRanking;
  final int? isMaxRanking;
  final String social;
  final int totalPrize;
  final DateTime startDate;
  final DateTime endDate;
  final bool isFree;
  final double? entryFee;
  final int type;
  final int? organizerId;

  CreateTournamentRequest({
    required this.name,
    required this.location,
    required this.maxPlayer,
    required this.description,
    required this.banner,
    required this.note,
    this.isMinRanking,
    this.isMaxRanking,
    required this.social,
    required this.totalPrize,
    required this.startDate,
    required this.endDate,
    required this.isFree,
    this.entryFee,
    required this.type,
    this.organizerId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'maxPlayer': maxPlayer,
      'description': description,
      'banner': banner,
      'note': note,
      'isMinRanking': isMinRanking,
      'isMaxRanking': isMaxRanking,
      'social': social,
      'totalPrize': totalPrize,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isFree': isFree,
      'entryFee': entryFee,
      'type': type,
      'organizerId': organizerId,
    };
  }

  factory CreateTournamentRequest.fromJson(Map<String, dynamic> json) {
    return CreateTournamentRequest(
      name: json['name'],
      location: json['location'],
      maxPlayer: json['maxPlayer'],
      description: json['description'],
      banner: json['banner'],
      note: json['note'],
      isMinRanking: json['isMinRanking'],
      isMaxRanking: json['isMaxRanking'],
      social: json['social'],
      totalPrize: json['totalPrize'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      isFree: json['entryFee'] == null,
      entryFee: json['entryFee'],
      type: json['type'],
      organizerId: json['organizerId'],
    );
  }
}
