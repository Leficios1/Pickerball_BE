class CheckPaymentResponsePayOS {
  final String id;
  final int orderCode;
  final int amount;
  final int amountPaid;
  final int amountRemaining;
  final String status;
  final DateTime createdAt;
  final List<Transaction> transactions;
  final DateTime? canceledAt;
  final String? cancellationReason;

  CheckPaymentResponsePayOS({
    required this.id,
    required this.orderCode,
    required this.amount,
    required this.amountPaid,
    required this.amountRemaining,
    required this.status,
    required this.createdAt,
    required this.transactions,
    this.canceledAt,
    this.cancellationReason,
  });

  factory CheckPaymentResponsePayOS.fromJson(Map<String, dynamic> json) {
    return CheckPaymentResponsePayOS(
      id: json['id'],
      orderCode: json['orderCode'],
      amount: json['amount'],
      amountPaid: json['amountPaid'],
      amountRemaining: json['amountRemaining'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      transactions: (json['transactions'] as List)
          .map((e) => Transaction.fromJson(e))
          .toList(),
      canceledAt: json['canceledAt'] != null
          ? DateTime.parse(json['canceledAt'])
          : null,
      cancellationReason: json['cancellationReason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderCode': orderCode,
      'amount': amount,
      'amountPaid': amountPaid,
      'amountRemaining': amountRemaining,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'transactions': transactions.map((e) => e.toJson()).toList(),
      'canceledAt': canceledAt?.toIso8601String(),
      'cancellationReason': cancellationReason,
    };
  }
}

class Transaction {
  final String reference;
  final int amount;
  final String accountNumber;
  final String description;
  final DateTime transactionDateTime;
  final String? virtualAccountName;
  final String? virtualAccountNumber;
  final String counterAccountBankId;
  final String? counterAccountBankName;
  final String counterAccountName;
  final String counterAccountNumber;

  Transaction({
    required this.reference,
    required this.amount,
    required this.accountNumber,
    required this.description,
    required this.transactionDateTime,
    this.virtualAccountName,
    this.virtualAccountNumber,
    required this.counterAccountBankId,
    this.counterAccountBankName,
    required this.counterAccountName,
    required this.counterAccountNumber,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      reference: json['reference'],
      amount: json['amount'],
      accountNumber: json['accountNumber'],
      description: json['description'],
      transactionDateTime: DateTime.parse(json['transactionDateTime']),
      virtualAccountName: json['virtualAccountName'],
      virtualAccountNumber: json['virtualAccountNumber'],
      counterAccountBankId: json['counterAccountBankId'],
      counterAccountBankName: json['counterAccountBankName'],
      counterAccountName: json['counterAccountName'],
      counterAccountNumber: json['counterAccountNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reference': reference,
      'amount': amount,
      'accountNumber': accountNumber,
      'description': description,
      'transactionDateTime': transactionDateTime.toIso8601String(),
      'virtualAccountName': virtualAccountName,
      'virtualAccountNumber': virtualAccountNumber,
      'counterAccountBankId': counterAccountBankId,
      'counterAccountBankName': counterAccountBankName,
      'counterAccountName': counterAccountName,
      'counterAccountNumber': counterAccountNumber,
    };
  }
}