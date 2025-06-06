class Payments {
  int id;
  int userId;
  int tournamentId;
  double amount;
  int status;
  int type;
  DateTime paymentDate;

  Payments({
    required this.id,
    required this.userId,
    required this.tournamentId,
    required this.amount,
    required this.status,
    required this.type,
    required this.paymentDate,
  });

  factory Payments.fromJson(Map<String, dynamic> json) {
    return Payments(
      id: json['id'] as int,
      userId: json['userId'] as int,
      tournamentId: json['tournamentId'] as int,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as int,
      type: json['type'] as int,
      paymentDate: DateTime.parse(json['paymentDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'tournamentId': tournamentId,
      'amount': amount,
      'status': status,
      'type': type,
      'paymentDate': paymentDate.toIso8601String(),
    };
  }
}
