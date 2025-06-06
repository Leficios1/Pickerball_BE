import 'package:equatable/equatable.dart';

abstract class RuleSelectionEvent extends Equatable {
  const RuleSelectionEvent();

  @override
  List<Object> get props => [];
}

class SelectRule extends RuleSelectionEvent {
  final int ruleId;

  const SelectRule({required this.ruleId});

  @override
  List<Object> get props => [ruleId];
}
