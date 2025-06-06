class NotificationDto {
  final int id;
  final String message;
  final DateTime createdAt;
  final bool isRead;
  final int type;
  final int referenceId;
  final int? bonusId;
  final String? redirectUrl;
  final String? extraInfo;

  NotificationDto({
    required this.id,
    required this.message,
    required this.createdAt,
    required this.isRead,
    required this.type,
    required this.referenceId,
    this.bonusId,
     this.redirectUrl,
     this.extraInfo,
  });

  factory NotificationDto.fromJson(Map<String, dynamic> json) {
    return NotificationDto(
      id: json['id'] as int,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool,
      type: json['type'] as int,
      referenceId: json['referenceId'] as int,
      bonusId: json['bonusId'] as int?,
      redirectUrl: json['redirectUrl'] as String?,
      extraInfo: json['extraInfo'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'message': message,
    'createdAt': createdAt.toIso8601String(),
    'isRead': isRead,
    'type': type,
    'referenceId': referenceId,
    'bonusId': bonusId,
    'redirectUrl': redirectUrl,
    'extraInfo': extraInfo,
  };
}