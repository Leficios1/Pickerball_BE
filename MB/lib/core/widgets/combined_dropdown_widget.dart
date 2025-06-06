import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/utils/extensions.dart';

class CombinedDropdownWidget extends StatefulWidget {
  final ValueChanged<String>? onMatchStyleChanged;
  final List<String> matchStyleItems;

  const CombinedDropdownWidget({
    Key? key,
    this.onMatchStyleChanged,
    required this.matchStyleItems,
  }) : super(key: key);

  @override
  _CombinedDropdownWidgetState createState() => _CombinedDropdownWidgetState();
}

class _CombinedDropdownWidgetState extends State<CombinedDropdownWidget> {
  String? _selectedMatchStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Text(
            'Select Match Style',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              color: Colors.black,
            ),
          ),
          items: widget.matchStyleItems.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: _selectedMatchStyle == item 
                      ? AppColors.primaryColor 
                      : Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          value: _selectedMatchStyle,
          onChanged: (value) {
            setState(() {
              _selectedMatchStyle = value;
            });
            if (widget.onMatchStyleChanged != null) {
              widget.onMatchStyleChanged!(value!);
            }
          },
          buttonStyleData: ButtonStyleData(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            height: 50.h,
            width: context.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1.5,
              ),
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200.h,
            width: context.width - 32.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            elevation: 3,
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all(6),
              thumbVisibility: MaterialStateProperty.all(true),
            ),
          ),
          menuItemStyleData: MenuItemStyleData(
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
          ),
          iconStyleData: IconStyleData(
            icon: const Icon(Icons.keyboard_arrow_down),
            iconSize: 24.sp,
            iconEnabledColor: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
