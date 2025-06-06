import 'package:equatable/equatable.dart';

class PlayerDetails extends Equatable {
  final String firstName;
  final String lastName;
  final String? secondName;
  final String email;
  final int ranking;
  final String avatarUrl;

  const PlayerDetails({
    required this.firstName,
    required this.lastName,
    this.secondName,
    required this.email,
    required this.ranking,
    required this.avatarUrl,
  });

  factory PlayerDetails.fromJson(Map<String, dynamic> json) {
    return PlayerDetails(
      firstName: json['firstName'],
      lastName: json['lastName'],
      secondName: json['secondName'],
      email: json['email'],
      ranking: json['ranking'],
      avatarUrl: json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'secondName': secondName,
      'email': email,
      'ranking': ranking,
      'avatarUrl': avatarUrl,
    };
  }

  @override
  List<Object?> get props =>
      [firstName, lastName, secondName, email, ranking, avatarUrl];
}
