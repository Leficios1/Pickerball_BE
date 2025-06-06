import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/widgets/app_bar_widget.dart';
import 'package:pickleball_app/features/setting/bloc/user_profile/user_profile_bloc.dart';
import 'package:pickleball_app/features/setting/bloc/user_profile/user_profile_event.dart';
import 'package:pickleball_app/features/setting/bloc/user_profile/user_profile_state.dart';

@RoutePage()
class UserProfilePage extends StatefulWidget {
  final int userId;

  const UserProfilePage({Key? key, @PathParam('userId') required this.userId}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<UserProfileBloc>().add(LoadUserProfile(userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'User Profile',
      ),
      body: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, state) {
          if (state is UserProfileLoading) {
            return Center(
              child: LoadingAnimationWidget.threeRotatingDots(
                color: AppColors.primaryColor,
                size: 50,
              ),
            );
          } else if (state is UserProfileLoaded) {
            final user = state.user;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  Container(
                    width: double.infinity,
                    color: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    child: Column(
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                              ? NetworkImage(user.avatarUrl!)
                              : null,
                          child: user.avatarUrl == null || user.avatarUrl!.isEmpty
                              ? Icon(Icons.person, size: 50, color: Colors.white)
                              : null,
                          backgroundColor: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        // Name
                        Text(
                          '${user.firstName} ${user.lastName} ${user.secondName ?? ''}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Email
                        Text(
                          user.email,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // User Details
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section Title
                        const Text(
                          'Personal Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),
                        const SizedBox(height: 8),

                        // Gender
                        _buildInfoRow(
                          Icons.person_outline, 
                          'Gender', 
                          user.gender ?? 'Not specified'
                        ),
                        
                        // Date of Birth
                        _buildInfoRow(
                          Icons.cake_outlined, 
                          'Date of Birth', 
                          user.dateOfBirth != null 
                              ? DateFormat('yyyy-MM-dd').format(user.dateOfBirth!) 
                              : 'Not specified'
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Player Details Section
                        if (user.userDetails != null) ...[
                          const Text(
                            'Player Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          const SizedBox(height: 8),
                          
                          // Experience Level
                          _buildInfoRow(
                            Icons.military_tech, 
                            'Experience Level', 
                            '${user.userDetails!.experienceLevel}'
                          ),
                          
                          // Ranking Points
                          _buildInfoRow(
                            Icons.score, 
                            'Ranking Points', 
                            '${user.userDetails!.rankingPoint}'
                          ),
                          
                          // Location
                          _buildInfoRow(
                            Icons.location_on_outlined, 
                            'Location', 
                            '${user.userDetails!.province}, ${user.userDetails!.city}'
                          ),
                        ],
                        
                        // Sponsor Details Section
                        if (user.sponsorDetails != null) ...[
                          const SizedBox(height: 24),
                          const Text(
                            'Sponsor Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          const SizedBox(height: 8),
                          
                          // Company Name
                          _buildInfoRow(
                            Icons.business, 
                            'Company', 
                            user.sponsorDetails!.companyName
                          ),
                          
                          // Contact Email
                          _buildInfoRow(
                            Icons.email_outlined, 
                            'Contact Email', 
                            user.sponsorDetails!.contactEmail
                          ),
                          
                          // Social Link
                          _buildInfoRow(
                            Icons.link, 
                            'Social Link', 
                            user.sponsorDetails!.urlSocial,
                            isLink: true,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is UserProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<UserProfileBloc>().add(LoadUserProfile(userId: widget.userId));
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }
          
          return const Center(child: Text('Loading user profile...'));
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primaryColor),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              isLink
                  ? GestureDetector(
                      onTap: () {
                        // Handle link tap if needed
                      },
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  : Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
