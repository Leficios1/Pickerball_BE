import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class RoleEvent extends Equatable {
  const RoleEvent();

  @override
  List<Object?> get props => [];
}

class RegisterRoleRequested extends RoleEvent {
  final int role;
  final int id;
  final String? province;
  final String? city;
  final String? companyURL;
  final String? companyName;
  final String? contactEmail;
  final String? description;
  final String? socialMedia;
  final String? additionalSocialMedia;
  final BuildContext? context;

  const RegisterRoleRequested({
    required this.role,
    required this.id,
    this.province,
    this.city,
    this.companyURL,
    this.companyName,
    this.contactEmail,
    this.description,
    this.socialMedia,
    this.additionalSocialMedia,
    this.context,
  });

  @override
  List<Object?> get props => [
        role,
        id,
        province,
        city,
        companyURL,
        companyName,
        contactEmail,
        description,
        socialMedia,
        additionalSocialMedia,
        context,
      ];
}
