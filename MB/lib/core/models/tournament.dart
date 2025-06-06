import 'package:pickleball_app/core/models/models.dart';
import 'package:pickleball_app/core/models/registration_details.dart';
import 'package:pickleball_app/core/models/tournament_details.dart';

class Tournament {
  final int id;
  final String name;
  final String location;
  final int maxPlayer;
  final String? descreption;
  final String banner;
  final String? note;
  final double totalPrize;
  final DateTime startDate;
  final DateTime endDate;
  final String type;
  final String status;
  final bool isAccept;
  final int organizerId;
  final String? isMinRanking;
  final String? isMaxRanking;
  final String? social;
  final bool isFree;
  final String? entryFee;
  final List<Sponner>? sponerDetails;
  final List<TournamentDetails>? tournamentDetails;
  final List<RegistrationDetails>? registrationDetails;

  Tournament({
    required this.id,
    required this.name,
    required this.location,
    required this.maxPlayer,
    this.descreption,
    required this.banner,
    this.note,
    required this.totalPrize,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.status,
    required this.isAccept,
    required this.organizerId,
    this.isMinRanking,
    this.isMaxRanking,
    this.social,
    this.sponerDetails,
    this.tournamentDetails,
    this.registrationDetails,
    required this.isFree,
    this.entryFee,
  });

  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      location: json['location'] as String? ?? '',
      maxPlayer: json['maxPlayer'] as int? ?? 0,
      descreption: json['descreption'] ?? '',
      banner: json['banner'] as String? ?? '',
      note: json['note'] as String?,
      totalPrize: (json['totalPrize'] as num?)?.toDouble() ?? 0.0,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : DateTime.now(),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'])
          : DateTime.now(),
      type: json['type'],
      status: json['status'] as String? ?? '',
      isAccept: json['isAccept'] as bool? ?? false,
      organizerId: json['organizerId'] as int? ?? 0,
      isMinRanking: json['isMinRanking']?.toString(),
      isMaxRanking: json['isMaxRanking']?.toString(),
      social: json['social'] as String?,
      sponerDetails: (json['sponerDetails'] as List<dynamic>?)
              ?.map((item) => Sponner.fromJson(item))
              .toList() ??
          [],
      tournamentDetails: (json['tournamentDetails'] as List<dynamic>?)
              ?.map((item) => TournamentDetails.fromJson(item))
              .toList() ??
          [],
      registrationDetails: (json['registrationDetails'] as List<dynamic>?)
              ?.map((item) => RegistrationDetails.fromJson(item))
              .toList() ??
          [],
      isFree: json['isFree'] as bool? ?? false,
      entryFee: json['entryFee']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'maxPlayer': maxPlayer,
      'descreption': descreption,
      'banner': banner,
      'note': note,
      'totalPrize': totalPrize,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'type': type,
      'status': status,
      'isAccept': isAccept,
      'organizerId': organizerId,
      'isMinRanking': isMinRanking,
      'isMaxRanking': isMaxRanking,
      'social': social,
      'isFree': isFree,
      'entryFee': entryFee,
      'sponerDetails':
          sponerDetails?.map((item) => item.toJson()).toList() ?? [],
      'tournamentDetails':
          tournamentDetails?.map((item) => item.toJson()).toList() ?? [],
      'registrationDetails':
          registrationDetails?.map((item) => item.toJson()).toList() ?? [],
    };
  }
}
