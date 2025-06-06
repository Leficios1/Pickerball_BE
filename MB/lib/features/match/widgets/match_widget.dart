import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pickleball_app/core/blocs/app_bloc.dart';
import 'package:pickleball_app/core/blocs/app_state.dart';
import 'package:pickleball_app/core/constants/app_enums.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/themes/app_theme.dart';
import 'package:pickleball_app/core/utils/limited_text_widget.dart';
import 'package:pickleball_app/core/utils/snackbar_helper.dart';

class MatchWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String description;
  final DateTime matchDate;
  final int matchFormat;
  final String? matchCategory;
  final String venue;
  final String address;
  final String status;
  final String? refereeName;
  final bool? isOnTap;

  const MatchWidget({
    super.key,
    required this.onTap,
    required this.title,
    required this.description,
    required this.matchDate,
    required this.matchFormat,
    this.matchCategory,
    required this.venue,
    required this.address,
    required this.status,
    this.refereeName,
    this.isOnTap = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: InfoCard(
              onTap: onTap,
              isOnTap: isOnTap,
              title: title,
              description: description,
              matchDate: matchDate,
              matchFormat: matchFormat,
              matchCategory: matchCategory,
              venue: venue,
              address: address,
              status: status,
              refereeName: refereeName,
            ),
          ),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final VoidCallback onTap;
  final bool? isOnTap;
  final String title;
  final String description;
  final DateTime matchDate;
  final int matchFormat;
  final String? matchCategory;
  final String venue;
  final String address;
  final String status;
  final String? refereeName;

  const InfoCard({
    super.key,
    required this.onTap,
    required this.title,
    required this.description,
    required this.matchDate,
    required this.matchFormat,
    this.matchCategory,
    required this.venue,
    required this.address,
    required this.status,
    this.refereeName,
    this.isOnTap=false,
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formattedDate = formatter.format(matchDate);
    final String matchFormatTM = MatchCategory.tournament.label == matchCategory
        ? MatchFormat.fromValue(matchFormat)!.subLabel
        : TournamentFormant.fromValue(matchFormat)!.subLabel;
    return GestureDetector(
      onTap: (){
        if(matchCategory == 'Tournament'){
          if(isOnTap == true){
            onTap();
          } else {
            debugPrint('MatchWidget: $isOnTap');
            SnackbarHelper.showSnackBar('You are not allowed to tap this match');
          }
        } else {
          onTap();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFFF3F1F1),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title - Primary information (largest)
            Row(
              children: [
                Icon(Icons.sports_cricket, color: AppColors.primaryColor, size: 22),
                SizedBox(width: 8),
                Expanded(
                  child: LimitedTextWidget(
                    content: title,
                    maxLines: 1,
                    style: AppTheme.getTheme(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 8),
            
            // Status and Date - Secondary information
            Row(
              children: [
                Container(
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: AppColors.primaryColor.withOpacity(0.1),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      child: Text(
                        status.toString(),
                        style: AppTheme.getTheme(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                ),
                SizedBox(width: 10),
                Text(
                  formattedDate,
                  style: AppTheme.getTheme(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                )
              ],
            ),
            
            SizedBox(height: 10),
            
            // Match category and format - Important context information
            Row(
              children: [
                Icon(Icons.category, color: AppColors.primaryColor, size: 18),
                SizedBox(width: 4),
                Text(
                  matchCategory ?? 'No category available',
                  style: AppTheme.getTheme(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  width: 1,
                  height: 16,
                  color: AppColors.primaryColor,
                ),
                SizedBox(width: 8),
                if (matchFormat != null)
                  Text(
                    matchFormatTM,
                    style: AppTheme.getTheme(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
              ],
            ),
            
            // Referee information - Tertiary information
            if(refereeName != null)...[
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.person_4, color: AppColors.primaryColor, size: 16),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      refereeName!,
                      style: AppTheme.getTheme(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            
            // Location - Supporting information (smallest)
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, color: AppColors.primaryColor, size: 16),
                SizedBox(width: 4),
                Expanded(
                  child: LimitedTextWidget(
                    content: venue.isNotEmpty
                        ? '$venue, $address'
                        : 'No address available',
                    style: AppTheme.getTheme(context).textTheme.bodySmall?.copyWith(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
