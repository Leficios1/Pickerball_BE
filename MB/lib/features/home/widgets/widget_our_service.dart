import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/themes/app_theme.dart';
import 'package:pickleball_app/router/router.gr.dart';

class ContainerOurService extends StatelessWidget {
  const ContainerOurService({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Expanded(
              child: _buildServiceButton("Matches", Icons.stadium_outlined, () {
                AutoRouter.of(context).push(MatchesRoute());
              }, const Color(0xFFDEAA79), context),
            ),
            //
            Expanded(
              child: _buildServiceButton("Information", Icons.bookmark_outline, () {
                AutoRouter.of(context).push(BlogCategoriesRoute());
              }, const Color(0xFFB1C29E), context),
            ),
            Expanded(
              child: _buildServiceButton("Rank", Icons.bar_chart_outlined, () {
                AutoRouter.of(context).push(RankRoute());
              }, const Color(0xFF659287), context),
            ),
          ],
        ));
  }
  Widget _buildServiceButton(
      String text, IconData icon, VoidCallback onTap, Color backgroundColor, BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 24, color: AppColors.primaryColor),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              text,
              textAlign: TextAlign.center,
              style: AppTheme.getTheme(context).textTheme.displaySmall?.copyWith(
                color: AppColors.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
