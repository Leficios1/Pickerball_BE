import 'package:flutter/material.dart';
import 'package:pickleball_app/core/constants/app_strings.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/themes/app_theme.dart';
import 'package:pickleball_app/core/utils/extensions.dart';
import 'package:pickleball_app/core/utils/snackbar_helper.dart';
import 'package:pickleball_app/core/widgets/responsive_text.dart';

class CardProfileBtn extends StatelessWidget {
  final bool isLogin;
  final String? image; // Nullable image
  final String fullName;
  final VoidCallback? onTap;
  final String? title;
  final String? rank;

  const CardProfileBtn({
    super.key,
    required this.image,
    required this.fullName,
    required this.isLogin,
    this.onTap,
    this.title,
    this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.w),
      child: Row(
        children: [
          _buildProfileImage(context),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResponsiveText(
                title ?? fullName,
                style: AppTheme.getTheme(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 5.h),
              Row(
                children: [
                  ResponsiveText(
                    title != null ? fullName : (rank ?? ''),
                    style: AppTheme.getTheme(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),

        ],
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    if (!isLogin) {
      return _buildPlaceholderImage(context, AppStrings.plsLoginToFeature);
    }

    if (image != null && image!.isNotEmpty) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: context.smallerDimension * 0.15,
          height: context.smallerDimension * 0.15,
          margin: EdgeInsets.all(5.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(image!),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    return _buildPlaceholderImage(context, AppStrings.plsLoginToFeature);
  }

  Widget _buildPlaceholderImage(BuildContext context, String message) {
    return Container(
      width: context.smallerDimension * 0.15,
      height: context.smallerDimension * 0.15,
      margin: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [const Color(0xFF6A11CB), const Color(0xFF2575FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6A11CB).withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(context.smallerDimension * 0.15),
          splashColor: Colors.white.withOpacity(0.3),
          onTap: onTap ?? () => SnackbarHelper.showSnackBar(message),
          child: Icon(
            Icons.person_outlined,
            size: context.smallerDimension * 0.09,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
