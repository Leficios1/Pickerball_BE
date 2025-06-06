class VnPayResponse {
  final String bankTranNo;
  final String payDate;
  final String orderInfo;
  final String responseCode;
  final String transactionId;
  final String transactionStatus;
  final String cardType;
  final String txnRef;
  final int amount;
  final String bankCode;
  final String? note;

  VnPayResponse({
    required this.bankTranNo,
    required this.payDate,
    required this.orderInfo,
    required this.responseCode,
    required this.transactionId,
    required this.transactionStatus,
    required this.cardType,
    required this.txnRef,
    required this.amount,
    required this.bankCode,
    this.note,
  });

  factory VnPayResponse.fromJson(Map<String, dynamic> json) {
    return VnPayResponse(
      bankTranNo: json['bankTranNo'],
      payDate: json['payDate'],
      orderInfo: json['orderInfo'],
      responseCode: json['responseCode'],
      transactionId: json['transactionId'],
      transactionStatus: json['transactionStatus'],
      cardType: json['cardType'],
      txnRef: json['txnRef'],
      amount: json['amount'],
      bankCode: json['bankCode'],
      note: json['note'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'bankTranNo': bankTranNo,
      'payDate': payDate,
      'orderInfo': orderInfo,
      'responseCode': responseCode,
      'transactionId': transactionId,
      'transactionStatus': transactionStatus,
      'cardType': cardType,
      'txnRef': txnRef,
      'amount': amount,
      'bankCode': bankCode,
    };
    if (note != null) {
      data['note'] = note;
    }
    return data;
  }
}
