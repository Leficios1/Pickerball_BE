import 'package:equatable/equatable.dart';
import 'package:pickleball_app/core/services/blog_category/dto/models/rule.dart';

abstract class RuleSelectionState extends Equatable {
  const RuleSelectionState();

  @override
  List<Object> get props => [];
}

class RuleInitial extends RuleSelectionState {}

class RuleLoading extends RuleSelectionState {}

class RuleLoaded extends RuleSelectionState {
  final Rule rule;

  const RuleLoaded(this.rule);

  @override
  List<Object> get props => [rule];
}

class RuleError extends RuleSelectionState {
  final String message;

  const RuleError(this.message);

  @override
  List<Object> get props => [message];
}
