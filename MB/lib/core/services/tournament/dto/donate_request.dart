class DonateRequest {
  final int sponnerId;
  final int touramentId;
  final int amount;
  final String note;

  DonateRequest({
    required this.sponnerId,
    required this.touramentId,
    required this.amount,
    required this.note,
  });

  factory DonateRequest.fromJson(Map<String, dynamic> json) {
    return DonateRequest(
      sponnerId: json['sponnerId'],
      touramentId: json['touramentId'],
      amount: json['amount'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sponnerId': sponnerId,
      'touramentId': touramentId,
      'amount': amount,
      'note': note,
    };
  }
}
