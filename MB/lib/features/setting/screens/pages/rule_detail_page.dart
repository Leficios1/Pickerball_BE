import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/widgets/app_bar_widget.dart';
import 'package:pickleball_app/core/widgets/html_context.dart';
import 'package:pickleball_app/features/setting/bloc/blogs_categories/blogs_categories_state.dart';
import 'package:pickleball_app/features/setting/bloc/blogs_categories/rule_selection_bloc.dart';
import 'package:pickleball_app/features/setting/bloc/blogs_categories/rule_selection_state.dart';
import 'package:pickleball_app/features/setting/widgets/blog_category_card.dart';

@RoutePage()
class RuleDetailPage extends StatelessWidget {
  const RuleDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Blog Categories Detail',
      ),
      body: BlocBuilder<RuleSelectionBloc, RuleSelectionState>(
        builder: (context, state) {
          if (state is RuleLoading) {
            return Center(
              child: LoadingAnimationWidget.threeRotatingDots(
                color: AppColors.primaryColor,
                size: 30,
              ),
            );
          } else if (state is RuleLoaded) {
            final rule = state.rule;
            return Container(
              color: Colors.white,
              child: ListView(
                children: [
                  BlogCategoryCard(
                    imageUrls: [rule.image1, rule.image2],
                    title: rule.title,
                  ),
                  HtmlViewWidget(htmlContent: rule.content),
                ],
              ),
            );
          } else if (state is BlogsError) {
            return Center(child: Text('Failed to load rule details: '));
          } else {
            return const Center(child: Text('Select a rule to view details'));
          }
        },
      ),
    );
  }
}
