import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickleball_app/core/models/models.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/utils/snackbar_helper.dart';
import 'package:pickleball_app/core/widgets/app_bar_widget.dart';
import 'package:pickleball_app/features/setting/widgets/setting_btn.dart';
import 'package:pickleball_app/features/setting/widgets/user_info.dart';
import 'package:pickleball_app/router/router.gr.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/blocs/app_bloc.dart';
import '../../../core/blocs/app_event.dart';
import '../../../core/blocs/app_state.dart';

@RoutePage()
class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> with SingleTickerProviderStateMixin {
  User? userInfo;
  bool isAuthenticated = false;
  late AnimationController _animationController;
  
  // Section expand/collapse state
  final Map<String, bool> _sectionExpanded = {
    'account': true,
    'information': true,
    'support': true,
    'legal': true,
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _animationController.forward();
    
    // Default all sections to collapsed except Account
    _sectionExpanded['information'] = false;
    _sectionExpanded['support'] = false;
    _sectionExpanded['legal'] = false;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSection(String section) {
    setState(() {
      _sectionExpanded[section] = !(_sectionExpanded[section] ?? true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Settings',
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.defaultGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            isAuthenticated = state is AppAuthenticatedPlayer ||
                state is AppAuthenticatedSponsor;
            userInfo = isAuthenticated ? (state as dynamic).userInfo as User? : null;
            
            return SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // User Profile Section with Animation - more compact
                          if (isAuthenticated && userInfo != null)
                            _buildCompactProfileCard()
                              .animate()
                              .fadeIn(duration: 400.ms)
                              .slideY(begin: -0.1, end: 0, duration: 300.ms),
                              
                          SizedBox(height: isAuthenticated ? 16 : 8),
                          
                          // Account Section
                          _buildSectionHeader('Account', 'account'),
                          if (_sectionExpanded['account'] ?? true)
                            Column(
                              children: [
                                if (!isAuthenticated)
                                  _buildCompactSettingButton(
                                    'Login/Register',
                                    FontAwesomeIcons.rightToBracket,
                                    () => context.router.push(AuthenticationRoute()),
                                  ),
                                if (isAuthenticated)
                                  _buildCompactSettingButton(
                                    'Profile Settings', 
                                    FontAwesomeIcons.userGear,
                                    () => context.router.push(ProfileRoute()),
                                  ),
                                _buildCompactSettingButton(
                                  'Friends',
                                  FontAwesomeIcons.userGroup,
                                  () {
                                    isAuthenticated
                                        ? context.router.push(FriendRoute())
                                        : SnackbarHelper.showSnackBar('Please login to view friends');
                                  },
                                ),
                                _buildCompactSettingButton(
                                  'Notifications',
                                  FontAwesomeIcons.solidBell,
                                  () => context.router.push(NotificationRoute()),
                                ),
                              ].animate(interval: 20.ms).fadeIn(duration: 200.ms).slideX(begin: -0.05, end: 0),
                            ),
                            
                          const SizedBox(height: 8),
                          
                          // Information Section
                          _buildSectionHeader('Information', 'information'),
                          if (_sectionExpanded['information'] ?? true)
                            Column(
                              children: [
                                _buildCompactSettingButton(
                                  'Pickleball Information',
                                  FontAwesomeIcons.baseballBatBall,
                                  () => context.router.push(BlogCategoriesRoute()),
                                ),
                              ].animate(interval: 20.ms).fadeIn(duration: 200.ms).slideX(begin: -0.05, end: 0),
                            ),
                            
                          const SizedBox(height: 8),
                          
                          
                          // // Legal Section
                          // _buildSectionHeader('Legal', 'legal'),
                          // if (_sectionExpanded['legal'] ?? true)
                          //   Column(
                          //     children: [
                          //       _buildCompactSettingButton(
                          //         'Privacy Policy',
                          //         FontAwesomeIcons.shieldHalved,
                          //         () => context.router.push(PrivacyPolicyRoute()),
                          //       ),
                          //       _buildCompactSettingButton(
                          //         'Terms of Service',
                          //         FontAwesomeIcons.fileContract,
                          //         () => context.router.push(TermsOfServiceRoute()),
                          //       ),
                          //     ].animate(interval: 20.ms).fadeIn(duration: 200.ms).slideX(begin: -0.05, end: 0),
                          //   ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Logout Button - fixed at bottom
                  if (isAuthenticated)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                      child: _buildLogoutButton(),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildSectionHeader(String title, String section) {
    final bool isExpanded = _sectionExpanded[section] ?? true;
    
    return GestureDetector(
      onTap: () => _toggleSection(section),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.02),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            AnimatedRotation(
              turns: isExpanded ? 0.0 : 0.25,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                color: Colors.white.withOpacity(0.7),
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCompactProfileCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.12),
            Colors.white.withOpacity(0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => context.router.push(ProfileRoute()),
          splashColor: Colors.white.withOpacity(0.1),
          highlightColor: Colors.white.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(userInfo!.avatarUrl!),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${userInfo!.firstName} ${userInfo!.lastName}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        userInfo!.email,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.white.withOpacity(0.7),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactSettingButton(String title, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                FaIcon(
                  icon,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.chevron_right,
                  color: Colors.white.withOpacity(0.6),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            Colors.redAccent.shade200,
            Colors.red.shade600,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.shade800.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            context.read<AppBloc>().add(AppLoggedOut(context: context));
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.rightFromBracket,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 10),
                Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
    .animate()
    .fadeIn(duration: 400.ms, delay: 200.ms)
    .slideY(begin: 0.2, end: 0, duration: 500.ms, delay: 200.ms)
    .shimmer(duration: 1200.ms, delay: 800.ms);
  }
}
