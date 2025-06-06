import 'package:equatable/equatable.dart';
import 'package:pickleball_app/core/models/player_details.dart';

class RegistrationDetails extends Equatable {
  final int id;
  final int playerId;
  final int paymentId;
  final DateTime registeredAt;
  final int? partnerId;
  final int isApproved;
  final PlayerDetails playerDetails;
  final PlayerDetails? partnerDetails;

  const RegistrationDetails({
    required this.id,
    required this.playerId,
    required this.paymentId,
    required this.registeredAt,
    this.partnerId,
    required this.isApproved,
    required this.playerDetails,
    this.partnerDetails,
  });

  factory RegistrationDetails.fromJson(Map<String, dynamic> json) {
    return RegistrationDetails(
      id: json['id'],
      playerId: json['playerId'],
      paymentId: json['paymentId'],
      registeredAt: DateTime.parse(json['registeredAt']),
      partnerId: json['partnerId'],
      isApproved: json['isApproved'],
      playerDetails: PlayerDetails.fromJson(json['playerDetails']),
      partnerDetails: json['partnerDetails'] != null
          ? PlayerDetails.fromJson(json['partnerDetails'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playerId': playerId,
      'paymentId': paymentId,
      'registeredAt': registeredAt.toIso8601String(),
      'partnerId': partnerId,
      'isApproved': isApproved,
      'playerDetails': playerDetails.toJson(),
      'partnerDetails': partnerDetails?.toJson(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        playerId,
        paymentId,
        registeredAt,
        partnerId,
        isApproved,
        playerDetails,
        partnerDetails,
      ];
}
