import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickleball_app/core/services/blog_category/dto/models/rule.dart';
import 'package:pickleball_app/features/setting/bloc/blogs_categories/rule_selection_bloc.dart';
import 'package:pickleball_app/features/setting/bloc/blogs_categories/rule_selection_event.dart';
import 'package:pickleball_app/features/setting/widgets/blog_category_card.dart';
import 'package:pickleball_app/router/router.gr.dart';

class RulesWidget extends StatelessWidget {
  final List<Rule> rules;

  const RulesWidget({super.key, required this.rules});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: rules.length,
      itemBuilder: (context, index) {
        final rule = rules[index];
        return InkWell(
          onTap: () {
            context.read<RuleSelectionBloc>().add(SelectRule(ruleId: rule.id));
            AutoRouter.of(context).push(RuleDetailRoute());
          },
          child: BlogCategoryCard(
            imageUrls: [rule.image1, rule.image2],
            title: rule.title,
          ),
        );
      },
    );
  }
}
