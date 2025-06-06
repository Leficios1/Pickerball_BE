import 'package:pickleball_app/core/models/models.dart';

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String? secondName;
  final String email;
  final String? passwordHash;
  final DateTime? dateOfBirth;
  final String? avatarUrl;
  final String? gender;
  final bool status;
  final int roleId;
  final String phoneNumber;
  final String refreshToken;
  final DateTime? createAt;
  final DateTime refreshTokenExpiryTime;
  final Player? userDetails;
  final Sponner? sponsorDetails;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.secondName,
    required this.email,
    this.passwordHash,
    this.dateOfBirth,
    this.avatarUrl,
    this.gender,
    required this.status,
    required this.roleId,
    required this.refreshToken,
    this.createAt,
    required this.refreshTokenExpiryTime,
    required this.phoneNumber,
    this.userDetails,
    this.sponsorDetails,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      secondName: json['secondName'] as String?,
      email: json['email'] as String,
      passwordHash: json['passwordHash'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      avatarUrl: json['avatarUrl'] as String?,
      gender: json['gender'] as String?,
      status: json['status'] as bool,
      roleId: json['roleId'] as int,
      refreshToken: json['refreshToken'] as String,
      createAt: json['createAt'] != null
          ? DateTime.parse(json['createAt'] as String)
          : null,
      refreshTokenExpiryTime:
          DateTime.parse(json['refreshTokenExpiryTime'] as String),
      phoneNumber: json['phoneNumber'] as String,
      userDetails: json['userDetails'] != null
          ? Player.fromJson(json['userDetails'] as Map<String, dynamic>)
          : null,
      sponsorDetails: json['sponsorDetails'] != null
          ? Sponner.fromJson(json['sponsorDetails'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'secondName': secondName,
      'email': email,
      'passwordHash': passwordHash,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'avatarUrl': avatarUrl,
      'gender': gender,
      'status': status,
      'roleId': roleId,
      'refreshToken': refreshToken,
      'createAt': createAt?.toIso8601String(),
      'refreshTokenExpiryTime': refreshTokenExpiryTime.toIso8601String(),
      'phoneNumber': phoneNumber,
      'userDetails': userDetails?.toJson(),
      'sponsorDetails': sponsorDetails?.toJson(),
    };
  }
}
