class GetStatusJoin {
  final int? tournamentId;
  final int? status;

  GetStatusJoin({
    this.tournamentId,
    this.status,
  });

  factory GetStatusJoin.fromJson(Map<String, dynamic> json) {
    return GetStatusJoin(
      tournamentId: json['tournamentId'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tournamentId': tournamentId,
      'status': status,
    };
  }
}
