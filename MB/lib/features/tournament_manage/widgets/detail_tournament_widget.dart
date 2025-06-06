import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pickleball_app/core/constants/app_enums.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/themes/app_theme.dart';
import 'package:pickleball_app/core/utils/format_vnd.dart';
import 'package:pickleball_app/core/utils/limited_text_widget.dart';
import 'package:pickleball_app/core/widgets/hashtag_match_format.dart';
import 'package:pickleball_app/core/widgets/hashtag_status.dart';
import 'package:pickleball_app/core/widgets/html_context.dart';

class DetailTournamentWidget extends StatelessWidget {
  final String name;
  final String location;
  final String maxPlayer;
  final String? descreption;
  final String? note;
  final double totalPrize;
  final DateTime startDate;
  final DateTime endDate;
  final String type;
  final UserRole userRole;
  final String matchStatus;
  final String? isMaxRanking;
  final String? isMinRanking;
  final bool isFree;
  final String? entryFee;

  const DetailTournamentWidget({
    super.key,
    required this.name,
    required this.location,
    required this.maxPlayer,
    this.descreption,
    this.note,
    required this.totalPrize,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.userRole,
    required this.matchStatus,
    this.isMaxRanking,
    this.isMinRanking,
    this.isFree = false,
    this.entryFee,
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm'); // Fixed date format
    final String formattedStartDate = formatter.format(startDate);
    final String formattedEndDate = formatter.format(endDate);
    final String countdown = _getCountdown();

    return Padding(
      padding: const EdgeInsets.all(10),
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: HashtagStatus(matchStatus: matchStatus)),
              const SizedBox(width: 10),
              Expanded(child: HashtagMatchFormat(
                matchFormat: MatchFormat.fromString(type)!,
              )),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  context,
                  icon: Icons.people,
                  title: 'Players',
                  value: maxPlayer,
                ),
              ),
              const SizedBox(width: 8),
              if (isMaxRanking != null && isMinRanking != null)
                Expanded(
                  child: _buildInfoCard(
                    context,
                    icon: Icons.bar_chart,
                    title: 'Ranking',
                    value:
                    '${RankLevel.fromValue(int.parse(isMinRanking!))!.label} - ${RankLevel.fromValue(int.parse(isMaxRanking!))!.label}',
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
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
              const SizedBox(width: 8),
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
          const SizedBox(height: 16),
          _buildDateSection(
            context,
            formattedStartDate: formattedStartDate,
            formattedEndDate: formattedEndDate,
            countdown: countdown,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.rule, color: AppColors.primaryColor, size: 20),
              ),
              if(note!=null)...[
                const SizedBox(width: 8),
                TextButton(onPressed: (){
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.8, // Set a specific width
                        height: MediaQuery.of(context).size.height *
                            0.6, // Set a specific height
                        child: HtmlViewWidget(
                          htmlContent: note ?? '',
                          title: 'Tournament Rules',
                        ),
                      ),
                      actions: [
                        FilledButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Close',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  );
                }, child: Text('Read official rules')),
              ]
            ],
          ),
          if(descreption!=null)...[
            const SizedBox(height: 16),
            Text(descreption!)
          ]
        ],
      ));
  }

  String _getCountdown() {
    final now = DateTime.now();
    Duration difference;
    if (matchStatus == 'Scheduled') {
      difference = startDate.difference(now);
    } else if (matchStatus == 'Ongoing') {
      difference = endDate.difference(now);
    } else {
      return '0day 0hour';
    }

    final int days = difference.inDays;
    final int hours = difference.inHours % 24;

    return '${days}day ${hours}hour';
  }

  Widget _buildInfoCard(BuildContext context,
      {required IconData icon, required String title, required String value}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primaryColor, size: 20),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTheme.getTheme(context).textTheme.titleSmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            Text(
              value,
              style: AppTheme.getTheme(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateSection(BuildContext context,
      {required String formattedStartDate,
      required String formattedEndDate,
      required String countdown}) {
    return Container(
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
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
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
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
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
                matchStatus == 'Scheduled'
                    ? 'Start after'
                    : matchStatus == 'Ongoing'
                        ? 'Finish later'
                        : matchStatus == 'Completed'
                            ? 'Finished'
                            : 'Canceled',
                style: AppTheme.getTheme(context).textTheme.titleSmall?.copyWith(
                      color: Colors.grey,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                countdown,
                style: AppTheme.getTheme(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
