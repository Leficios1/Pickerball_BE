import 'package:flutter/material.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/themes/app_theme.dart';
import 'package:pickleball_app/core/utils/limited_text_widget.dart';

class CardUserInfo extends StatelessWidget {
  final int position;
  final String name;
  final String? avatarUrl;
  final int score;
  final String winTotal;
  final String total;

  const CardUserInfo({
    Key? key,
    required this.position,
    required this.name,
    this.avatarUrl,
    required this.score,
    required this.winTotal,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0, // No shadow
      margin: const EdgeInsets.symmetric(vertical: 2),
      color: Colors.white, // Simple white background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.white), // Subtle border
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            // Position indicator - simplified
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
              
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                    '#${position.toString()}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Avatar
            CircleAvatar(
              radius: 18,
              backgroundImage: 
                  avatarUrl != null && avatarUrl!.isNotEmpty
                      ? NetworkImage(avatarUrl!)
                      : null,
              backgroundColor: Colors.grey[200],
              child: avatarUrl == null || avatarUrl!.isEmpty
                  ? const Icon(Icons.person, color: Colors.grey)
                  : null,
            ),
            
            const SizedBox(width: 12),
            
            // Player information with improved text hierarchy
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name with appropriate size
                  LimitedTextWidget(
                    content: name,
                    style: AppTheme.getTheme(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                  ),
                  
                  const SizedBox(height: 2),
                  
                  // Win/Total ratio with icon
                  Row(
                    children: [
                      Icon(
                        Icons.sports_score_outlined, 
                        color: Colors.grey[600],
                        size: 12,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '$winTotal/$total',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Score display - simplified
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.stars_rounded,
                    color: AppColors.primaryColor,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$score pts',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
