import 'package:equatable/equatable.dart';

abstract class UserProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUserProfile extends UserProfileEvent {
  final int userId;

  LoadUserProfile({required this.userId});

  @override
  List<Object?> get props => [userId];
}
