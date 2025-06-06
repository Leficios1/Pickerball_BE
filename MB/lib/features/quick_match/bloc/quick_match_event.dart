import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class QuickMatchEvent extends Equatable {
  const QuickMatchEvent();
  
  @override
  List<Object?> get props => [];
}

class StartQuickMatch extends QuickMatchEvent {
  final String city;
  final int matchFormat;
  final int ranking;
  final BuildContext context;
  
  const StartQuickMatch({
    required this.city,
    required this.matchFormat,
    required this.ranking,
    required this.context,
  });
  
  @override
  List<Object?> get props => [city, matchFormat, ranking, context];
}

class CancelQuickMatch extends QuickMatchEvent {}

class QuickMatchStatusUpdated extends QuickMatchEvent {
  final String status;
  
  const QuickMatchStatusUpdated(this.status);
  
  @override
  List<Object> get props => [status];
}

class QuickMatchDetailsReceived extends QuickMatchEvent {
  final Map<String, dynamic> matchDetails;
  
  const QuickMatchDetailsReceived(this.matchDetails);
  
  @override
  List<Object> get props => [matchDetails];
}

class LoadUserInfoEvent extends QuickMatchEvent {}
