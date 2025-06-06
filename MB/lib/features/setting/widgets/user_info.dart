import 'package:flutter/material.dart';
import 'package:pickleball_app/core/constants/app_enums.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/utils/limited_text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class UserInfo extends StatelessWidget {
  final String displayNamePlayer1;
  final String avatarUrlPlayer1;
  final String emailPlayer1;
  final VoidCallback? onPressed;
  final bool isFriend;
  final VoidCallback? onPressedDelete;
  final bool isAdded;
  final VoidCallback? onPressedAdd;
  final bool isTeam;
  final String? displayNamePlayer2;
  final String? avatarUrlPlayer2;
  final String? emailPlayer2;
  final bool isTournament;
  final int? rankingPlayer1;
  final int? rankingPlayer2;
  final String? donate;
  final String? gender;
  final String? rank;


  const UserInfo({
    super.key,
    required this.displayNamePlayer1,
    required this.avatarUrlPlayer1,
    required this.emailPlayer1,
    this.onPressed,
    this.isFriend = false,
    this.onPressedDelete,
    this.isAdded = false,
    this.onPressedAdd,
    this.isTeam = false,
    this.displayNamePlayer2,
    this.avatarUrlPlayer2,
    this.emailPlayer2,
    this.isTournament = false,
    this.rankingPlayer1,
    this.rankingPlayer2,
    this.donate,
    this.gender,
    this.rank
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF3F1F1),
          borderRadius: BorderRadius.circular(16),

        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First player
                  _buildPlayerInfo(
                    avatarUrl: avatarUrlPlayer1,
                    displayName: displayNamePlayer1,
                    email: emailPlayer1,
                    actionButton: _buildActionButton(),
                    isTournament: isTournament,
                    ranking: rankingPlayer1,
                    gender: gender,
                    rank: rank,
                    isMainPlayer: true,
                  ),
                  
                  // Team divider with badge
                  if (isTeam) 
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: AppColors.primaryColor.withOpacity(0.3),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.primaryColor.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.people_alt_rounded,
                                  size: 14,
                                  color: AppColors.primaryColor,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'TEAM',
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: AppColors.primaryColor.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  // Second player (if team)
                  if (isTeam)
                    _buildPlayerInfo(
                      avatarUrl: avatarUrlPlayer2 ?? '',
                      displayName: displayNamePlayer2 ?? '',
                      email: emailPlayer2 ?? '',
                      isTournament: isTournament,
                      ranking: rankingPlayer2,
                      isMainPlayer: false,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerInfo({
    required String avatarUrl,
    required String displayName,
    required String email,
    Widget? actionButton,
    required bool isTournament,
    int? ranking,
    String? gender,
    String? rank,
    bool isMainPlayer = true,
  }) {
    bool isWebsite = Uri.tryParse(email)?.hasAbsolutePath ?? false;
    
    // Get rank color based on ranking level
    Color getRankColor(int? ranking) {
      if (ranking == null) return AppColors.primaryColor;
      
      // Different colors for different ranking levels
      if (ranking <= 3) return Colors.green.shade700; // Beginner
      if (ranking <= 6) return Colors.blue.shade700;  // Intermediate
      return Colors.orange.shade800;                  // Advanced
    }
    
    // Get rank abbreviation
    String getRankAbbr(int? ranking) {
      if (ranking == null) return '';
      
      final level = RankLevel.fromValue(ranking);
      if (level == null) return '';
      
      return level.label.substring(level.label.length - 1);
    }
    
    Color rankColor = getRankColor(ranking);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar with badge
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isMainPlayer ? AppColors.primaryColor : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: isTournament ? 24 : 32,
                backgroundImage: NetworkImage(avatarUrl),
                backgroundColor: Colors.grey.shade200,
              ),
            ),
            if (ranking != null && !isTournament)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: rankColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: Center(
                    child: Text(
                      getRankAbbr(ranking),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 16),
        
        // Player details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name and tournament rank badge
              Row(
                children: [
                  Expanded(
                    child: Text(
                      displayName.length > 30 ? '${displayName.substring(0, 30)}...' : displayName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isMainPlayer ? Colors.black87 : Colors.black54,
                      ),

                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isTournament && ranking != null)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: rankColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: rankColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        RankLevel.fromValue(ranking)!.label,
                        style: TextStyle(
                          color: rankColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              
              SizedBox(height: 6),
              
              // Additional player info with icons
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  if (rank != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.military_tech,
                          size: 14,
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(width: 4),
                        Text(
                          rank,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    
                  if (gender != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          gender.toLowerCase() == 'male' ? Icons.male : Icons.female,
                          size: 14,
                          color: gender.toLowerCase() == 'male' ? Colors.blue : Colors.pink,
                        ),
                        SizedBox(width: 4),
                        Text(
                          gender,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              
              SizedBox(height: 6),
              
              // Email or website link
              if (isWebsite)
                GestureDetector(
                  onTap: () async {
                    final uri = Uri.parse(email);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.link,
                        size: 14,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Visit website',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 14,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: LimitedTextWidget(
                        content: email,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                
              // Donation info if available
              if (donate != null) ...[
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.volunteer_activism,
                      size: 14,
                      color: Colors.green,
                    ),
                    SizedBox(width: 4),
                    Text(
                      donate!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        
        // Action button (add/remove friend)
        if (actionButton != null) actionButton,
      ],
    );
  }

  Widget? _buildActionButton() {
    if (isFriend) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          constraints: BoxConstraints.tightFor(width: 36, height: 36),
          padding: EdgeInsets.zero,
          onPressed: onPressedDelete,
          icon: Icon(Icons.person_remove, color: Colors.red, size: 20),
          tooltip: 'Remove friend',
        ),
      );
    }
    
    if (isAdded) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          constraints: BoxConstraints.tightFor(width: 36, height: 36),
          padding: EdgeInsets.zero,
          onPressed: onPressedAdd,
          icon: Icon(Icons.person_add, color: AppColors.primaryColor, size: 20),
          tooltip: 'Add friend',
        ),
      );
    }
    
    return null;
  }
}
