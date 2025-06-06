import 'package:flutter/material.dart';
import 'package:pickleball_app/core/models/registration_details.dart';
import 'package:pickleball_app/core/services/tournament/dto/sponsor_response.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/themes/app_theme.dart';
import 'package:pickleball_app/core/utils/format_vnd.dart';
import 'package:pickleball_app/core/utils/responsive_utils.dart';
import 'package:pickleball_app/core/widgets/emptyStateCard.dart';
import 'package:pickleball_app/features/setting/widgets/user_info.dart';

class ListMemberWidget extends StatefulWidget {
  final List<RegistrationDetails>? players;
  final List<Map<String, dynamic>>? referees;
  final List<SponsorResponse>? sponsors;

  const ListMemberWidget({
    super.key,
    required this.players,
    required this.referees,
    required this.sponsors,
  });

  @override
  _ListMemberWidgetState createState() => _ListMemberWidgetState();
}

class _ListMemberWidgetState extends State<ListMemberWidget> {
  String _selectedOption = 'Players';

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>>? members;
    switch (_selectedOption) {
      case 'Referees':
        members = widget.referees;
        break;
      case 'Players':
        members = widget.players
            ?.map((player) => {
                  'displayNamePlayer1':
                      '${player.playerDetails.firstName}, ${player.playerDetails.lastName} ${player.playerDetails.secondName ?? ''}',
                  'avatarUrlPlayer1': player.playerDetails.avatarUrl,
                  'emailPlayer1': player.playerDetails.email,
                  'isTeam': player.partnerDetails != null,
                  'isTournament': true,
                  'rankingPlayer1': player.playerDetails.ranking,
                  if (player.partnerDetails != null) ...{
                    'displayNamePlayer2':
                        '${player.partnerDetails!.firstName}, ${player.partnerDetails!.lastName} ${player.partnerDetails!.secondName ?? ''}',
                    'avatarUrlPlayer2': player.partnerDetails!.avatarUrl,
                    'emailPlayer2': player.partnerDetails!.email,
                    'rankingPlayer2': player.partnerDetails!.ranking,
                  }
                })
            .toList();
        break;
      case 'Sponsors':
        members = widget.sponsors
            ?.map((player) => {
                  'displayNamePlayer1': player.name,
                  'avatarUrlPlayer1': player.logo ?? '',
                  'emailPlayer1': player.website,
                  'donate': formatVND(player.donate),
                })
            .toList();
        break;
      default:
        members = widget.players
            ?.map((player) => {
                  'displayNamePlayer1':
                      '${player.playerDetails.firstName}, ${player.playerDetails.lastName} ${player.playerDetails.secondName ?? ''}',
                  'avatarUrlPlayer1': player.playerDetails.avatarUrl,
                  'emailPlayer1': player.playerDetails.email,
                  'isTeam': player.partnerDetails != null,
                  'isTournament': true,
                  'rankingPlayer1': player.playerDetails.ranking,
                  if (player.partnerDetails != null) ...{
                    'displayNamePlayer2':
                        '${player.partnerDetails!.firstName}, ${player.partnerDetails!.lastName} ${player.partnerDetails!.secondName}',
                    'avatarUrlPlayer2': player.partnerDetails!.avatarUrl,
                    'emailPlayer2': player.partnerDetails!.email,
                    'rankingPlayer2': player.partnerDetails!.ranking.toString(),
                  }
                })
            .toList();
        break;
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: SegmentedButton<String>(
                  segments: [
                    ButtonSegment<String>(
                      value: 'Players',
                      label: Text('Players', style: AppTheme.getTheme(context).textTheme.titleMedium?.copyWith(
                        color: _selectedOption == 'Players'
                            ? Colors.white
                            : AppColors.primaryColor,
                      )),
                    ),
                    ButtonSegment<String>(
                      value: 'Referees',
                      label: Text('Referees', style: AppTheme.getTheme(context).textTheme.titleMedium?.copyWith(
                        color: _selectedOption == 'Referees'
                            ? Colors.white
                            : AppColors.primaryColor,
                      )),
                    ),
                    ButtonSegment<String>(
                      value: 'Sponsors',
                      label: Text('Sponsors', style: AppTheme.getTheme(context).textTheme.titleMedium?.copyWith(
                        color: _selectedOption == 'Sponsors'
                            ? Colors.white
                            : AppColors.primaryColor,
                      )),
                    ),
                  ],
                  showSelectedIcon: false,
                  style: SegmentedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryColor,
                    selectedForegroundColor: Colors.white,
                    selectedBackgroundColor: AppColors.primaryColor,
                    side: BorderSide.none,
                  ),
                  selected: {_selectedOption},
                  onSelectionChanged: (newSelection) {
                    setState(() {
                      _selectedOption = newSelection.first;
                    });
                  },
                ),
              ),
              members == null || members.isEmpty
                  ? _buildEmptyState()
                  : SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: members.length,
                        itemBuilder: (context, index) {
                          final member = members![index];
                          return Padding(
                              padding:
                                  EdgeInsets.only(left: 10, right: 10, top: 5),
                              child: SizedBox(
                                width: double.infinity,
                                child: UserInfo(
                                  displayNamePlayer1:
                                      member['displayNamePlayer1'],
                                  avatarUrlPlayer1: member['avatarUrlPlayer1'],
                                  emailPlayer1: member['emailPlayer1'],
                                  rankingPlayer1:
                                      member['rankingPlayer1'] ?? 0,
                                  displayNamePlayer2:
                                      member['displayNamePlayer2'] ?? '',
                                  avatarUrlPlayer2:
                                      member['avatarUrlPlayer2'] ?? '',
                                  emailPlayer2: member['emailPlayer2'] ?? '',
                                  rankingPlayer2:
                                      member['rankingPlayer2'] ?? 0,
                                  isTeam: member['isTeam'] ?? false,
                                  isTournament: member['isTournament'] ?? false,
                                  donate: member['donate'],
                                  onPressed: () {},
                                ),
                              ));
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildEmptyState() {
    // Choose icon and message based on selected tab
    IconData icon;
    String title;
    String description;
    
    switch (_selectedOption) {
      case 'Players':
        icon = Icons.people_outline;
        title = "No Players Yet";
        description = "There are no players registered for this tournament yet.";
        break;
      case 'Referees':
        icon = Icons.sports_score_outlined;
        title = "No Referees Yet";
        description = "No referees have been assigned to this tournament.";
        break;
      case 'Sponsors':
        icon = Icons.business_center_outlined;
        title = "No Sponsors Yet";
        description = "This tournament doesn't have any sponsors yet.";
        break;
      default:
        icon = Icons.group_outlined;
        title = "No Members";
        description = "There are no members to display.";
    }
    
    return EmptyStateCard(
      icon: icon,
      title: title,
      description: description,
      iconColor: AppColors.primaryColor,
      iconSize: ResponsiveUtils.getScaledSize(context, 50),
    );
  }
}
