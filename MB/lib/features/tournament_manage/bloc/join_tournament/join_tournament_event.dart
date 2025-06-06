import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pickleball_app/core/constants/app_enums.dart';

abstract class JoinTournamentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class JoinTournamentRequested extends JoinTournamentEvent {
  final int? partnerId;
  final BuildContext context;
  final PaymentMethod paymentMethod;

  JoinTournamentRequested({
    this.partnerId,
    required this.context,
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [partnerId, context, paymentMethod];
}
