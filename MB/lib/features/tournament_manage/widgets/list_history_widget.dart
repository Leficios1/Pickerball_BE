import 'package:flutter/material.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/utils/responsive_utils.dart';
import 'package:pickleball_app/core/widgets/emptyStateCard.dart';

class ListHistoryWidget extends StatelessWidget {
  final List<Map<String, dynamic>>? history;

  ListHistoryWidget({required this.history});

  @override
  Widget build(BuildContext context) {
    if (history == null || history!.isEmpty) {
      return EmptyStateCard(
        icon: Icons.history,
        title: "No History Available",
        description: "There is no match history for this tournament yet.",
        iconColor: AppColors.primaryColor,
        iconSize: ResponsiveUtils.getScaledSize(context, 50),
      );
    }
    
    return SingleChildScrollView(
      child: Column(
        children: [
          // Display your history items here
          ...history!.map((item) => _buildHistoryItem(context, item)).toList(),
        ],
      ),
    );
  }
  
  Widget _buildHistoryItem(BuildContext context, Map<String, dynamic> item) {
    // Implement how each history item should be displayed
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.history,
            color: AppColors.primaryColor,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['action'] ?? 'Action',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  item['date'] ?? 'Date',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
