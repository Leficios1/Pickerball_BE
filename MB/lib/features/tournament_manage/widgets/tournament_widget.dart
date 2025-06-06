import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pickleball_app/core/constants/app_enums.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/themes/app_theme.dart';
import 'package:pickleball_app/core/utils/format_vnd.dart';
import 'package:pickleball_app/core/utils/limited_text_widget.dart';
import 'package:pickleball_app/core/widgets/hashtag_match_format.dart';
import 'package:pickleball_app/core/widgets/hashtag_status.dart';

class TournamentWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String location;
  final String maxPlayers;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final String type;
  final String status;
  final String? note;
  final String? banner;
  final String? isMaxRanking;
  final String? isMinRanking;
  final bool isFree;
  final String? entryFee;
  final double totalPrize;

  const TournamentWidget(
      {super.key,
      required this.onTap,
      required this.title,
      required this.location,
      required this.maxPlayers,
      this.description,
      required this.startDate,
      required this.endDate,
      required this.type,
      required this.status,
      this.note,
      this.banner,
      this.isMaxRanking,
      this.isMinRanking,
      this.isFree = false,
      this.entryFee,
      required this.totalPrize});

  @override
  Widget build(BuildContext context) {
    final String countdown = _getCountdown();

    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
      child: _buildCard(context, countdown),
    );
  }

  String _getCountdown() {
    final now = DateTime.now();
    Duration difference;
    if (status == 'Scheduled') {
      difference = startDate.difference(now);
    } else if (status == 'Ongoing') {
      difference = endDate.difference(now);
    } else {
      return '0day 0hour';
    }

    final int days = difference.inDays;
    final int hours = difference.inHours % 24;

    return '${days}day ${hours}hour';
  }

  Widget _buildCard(BuildContext context, String countdown) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm');
    final String formattedStartDate = formatter.format(startDate);
    final String formattedEndDate = formatter.format(endDate);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xFFF3F1F1),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                children: [
                  HashtagStatus(matchStatus: status),
                  const SizedBox(width: 10),
                  HashtagMatchFormat(
                    matchFormat: MatchFormat.fromString(type)!,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (banner != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.network(
                          banner!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.only(left: 15, top: 8),
                      child: LimitedTextWidget(
                        content: title,
                        maxLines: 2,
                        style: AppTheme.getTheme(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 1,
                              color: Colors.black,
                              offset: Offset(0.5, 0.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15, top: 8, bottom: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on,
                              color: Colors.white, size: 18),
                          const SizedBox(width: 4),
                          Expanded(
                            child: LimitedTextWidget(
                              content: location,
                              style: AppTheme.getTheme(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    blurRadius: 1,
                                    color: Colors.black,
                                    offset: Offset(0.5, 0.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.people,
                                  color: AppColors.primaryColor, size: 20),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Players',
                                  style: AppTheme.getTheme(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: Colors.grey,
                                      ),
                                ),
                                Text(
                                  maxPlayers,
                                  style: AppTheme.getTheme(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (isMaxRanking != null && isMinRanking != null)
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primaryColor.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.bar_chart,
                                    color: AppColors.primaryColor, size: 20),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ranking',
                                    style: AppTheme.getTheme(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          color: Colors.grey,
                                        ),
                                  ),
                                  Text(
                                    '${RankLevel.fromValue(int.parse(isMinRanking!))!.subLabel} - ${RankLevel.fromValue(int.parse(isMaxRanking!))!.subLabel}',
                                    style: AppTheme.getTheme(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.attach_money,
                                  color: Colors.green, size: 20),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Entry Fee',
                                  style: AppTheme.getTheme(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: Colors.grey,
                                      ),
                                ),
                                Text(
                                  isFree == false
                                      ? 'Free'
                                      : formatVND(double.parse(entryFee!)),
                                  style: AppTheme.getTheme(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.card_giftcard,
                                  color: Colors.amber, size: 20),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Prize Pool',
                                  style: AppTheme.getTheme(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: Colors.grey,
                                      ),
                                ),
                                Text(
                                  formatVND(
                                      double.parse(totalPrize.toString())),
                                  style: AppTheme.getTheme(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.amber),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryColor,
                            width: 3,
                          ),
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 18,
                        color: AppColors.primaryColor.withOpacity(0.6),
                      ),
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryColor,
                            width: 3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.event_available,
                                size: 16, color: AppColors.primaryColor),
                            const SizedBox(width: 6),
                            Text(
                              formattedStartDate,
                              style: AppTheme.getTheme(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.event_busy,
                                size: 16, color: AppColors.primaryColor),
                            const SizedBox(width: 6),
                            Text(
                              formattedEndDate,
                              style: AppTheme.getTheme(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        status == 'Scheduled'
                            ? 'Start after'
                            : status == 'Ongoing'
                                ? 'Finish later'
                                : status == 'Completed'
                                    ? 'Finished'
                                    : 'Canceled',
                        style: AppTheme.getTheme(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        countdown,
                        style: AppTheme.getTheme(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(BuildContext context) {
    return Container(
      width: 5,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

