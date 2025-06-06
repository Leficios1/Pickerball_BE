import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/themes/app_theme.dart';
import 'package:pickleball_app/core/utils/responsive_utils.dart';
import 'package:pickleball_app/core/utils/extensions.dart';
import 'package:pickleball_app/router/router.gr.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool automaticallyImplyLeading;
  final String? imageIcon;
  final VoidCallback? onPressed;
  final List<Widget>? actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final bool? centerTitle;
  final double? toolbarHeight;
  final Color? backgroundColor;
  final bool? isPlayer;

  const AppBarWidget({
    Key? key,
    required this.title,
    this.automaticallyImplyLeading = true,
    this.actions,
    this.leading,
    this.bottom,
    this.centerTitle,
    this.toolbarHeight,
    this.backgroundColor,
    this.imageIcon,
    this.onPressed,
    this.isPlayer = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveUtils.getDeviceType(context);
    final fontSize = ResponsiveUtils.getScaledSize(
      context, 
      deviceType == DeviceScreenType.mobile ? 20 : 22
    );
    
    // Adjust button size based on screen width
    final buttonPadding = context.width < 360 ? 
      const EdgeInsets.symmetric(horizontal: 8, vertical: 6) : 
      const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
    
    final buttonText = context.width < 360 ? 'Create' : 'Create Tournament';
    
    final responsiveActions = deviceType != DeviceScreenType.mobile
        ? [...?actions, const SizedBox(width: 16)]
        : actions;
        
    return AppBar(
      title: Text(
        title,
        style: AppTheme.getTheme(context).textTheme.displayLarge?.copyWith(
          fontSize: fontSize,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: AppColors.primaryColor,
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: [
        if (imageIcon == null)
          isPlayer! == false && title == 'Tournaments'
              ? Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      AutoRouter.of(context).replace(CreateTournamentRoute());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: buttonPadding,
                    ),
                    child: Text(
                      buttonText,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: ResponsiveUtils.getScaledSize(context, 14),
                      ),
                    ),
                  ),
                )
              : Container()
        else
          IconButton(
            icon: ImageIcon(
              AssetImage(imageIcon!),
              color: Colors.white,
              size: ResponsiveUtils.getResponsiveIconSize(context),
            ),
            onPressed: onPressed,
          ),
      ],
      centerTitle: centerTitle,
      leading: leading,
      bottom: bottom,
      toolbarHeight: toolbarHeight,
      elevation: deviceType == DeviceScreenType.desktop ? 4 : 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight ?? kToolbarHeight);
}
