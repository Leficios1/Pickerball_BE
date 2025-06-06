import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickleball_app/core/constants/app_global.dart';

import 'rule_selection_event.dart';
import 'rule_selection_state.dart';

class RuleSelectionBloc extends Bloc<RuleSelectionEvent, RuleSelectionState> {
  RuleSelectionBloc() : super(RuleInitial()) {
    on<SelectRule>(_onSelectRule);
  }

  Future<void> _onSelectRule(
      SelectRule event, Emitter<RuleSelectionState> emit) async {
    emit(RuleLoading());
    try {
      final rule = await globalBlogCategoryService.getRuleById(event.ruleId);
      emit(RuleLoaded(rule));
    } catch (e) {
      emit(RuleError('Failed to load rule details'));
    }
  }
}
