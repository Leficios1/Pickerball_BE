import 'package:flutter/material.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/themes/app_theme.dart';

class SettingBtn extends StatefulWidget {
  final String title;
  final IconData iconAsset;
  final VoidCallback onTap;

  const SettingBtn(
      {super.key,
      required this.title,
      required this.iconAsset,
      required this.onTap});

  @override
  _SettingBtnState createState() => _SettingBtnState();
}

class _SettingBtnState extends State<SettingBtn> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 20,
      child: ElevatedButton(
          onPressed: widget.onTap,
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.white,
              ),
          child: Row(
            children: [
              Icon(
                widget.iconAsset,
                size: 35,
                color: AppColors.primaryColor,
              ),
              SizedBox(width: 10),
              Text(widget.title,
                  style: AppTheme.getTheme(context).textTheme.displaySmall),
              Spacer(),
              Icon(Icons.arrow_forward_ios),
            ],
          )),
    );
  }
}
