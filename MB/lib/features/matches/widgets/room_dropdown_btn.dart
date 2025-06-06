import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:pickleball_app/core/constants/app_strings.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/utils/extensions.dart';

class RoomDropdownBtn extends StatefulWidget {
  final VoidCallback onSelectSingle;
  final VoidCallback onSelectDouble;
  final VoidCallback onSelectQuickMatch;

  const RoomDropdownBtn({
    super.key,
    required this.onSelectSingle,
    required this.onSelectDouble,
    required this.onSelectQuickMatch,
  });

  @override
  RoomDropdownBtnState createState() => RoomDropdownBtnState();
}

class RoomDropdownBtnState extends State<RoomDropdownBtn> {
  String? _selectedOption;
  final List<String> items = [
    AppStrings.singleRoom, 
    AppStrings.doubleRoom,
    'Match Competitive',
  ];

  List<DropdownMenuItem<String>> _addDividersAfterItems(List<String> items) {
    final List<DropdownMenuItem<String>> menuItems = [];
    for (final String item in items) {
      menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item == AppStrings.singleRoom 
                        ? Icons.person 
                        : (item == AppStrings.doubleRoom 
                            ? Icons.people 
                            : Icons.flash_on),
                    color: AppColors.primaryColor,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Flexible(
                    child: Text(
                      item,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (item != items.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(),
            ),
        ],
      );
    }
    return menuItems;
  }

  List<double> _getCustomItemsHeights() {
    final List<double> itemsHeights = [];
    for (int i = 0; i < (items.length * 2) - 1; i++) {
      if (i.isEven) {
        itemsHeights.add(40.h);
      }
      if (i.isOdd) {
        itemsHeights.add(4.h);
      }
    }
    return itemsHeights;
  }

  void resetDropdown() {
    setState(() {
      _selectedOption = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width * 0.4, // Responsive width
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Text(
            AppStrings.createMatch,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          items: _addDividersAfterItems(items),
          value: _selectedOption,
          onChanged: (String? newValue) {
            setState(() {
              _selectedOption = newValue;
            });
            if (newValue != null) {
              if (newValue == AppStrings.singleRoom) {
                widget.onSelectSingle();
              } else if (newValue == AppStrings.doubleRoom) {
                widget.onSelectDouble();
              } else if (newValue == 'Match Competitive') {
                widget.onSelectQuickMatch();
              }
            }
          },
          buttonStyleData: ButtonStyleData(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            height: 40.h,
            width: context.width * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Colors.white,
            ),
            elevation: 0, // Remove shadow
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200.h,
            width: context.width * 0.4, // Ensure dropdown has enough width
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
            ),
          ),
          menuItemStyleData: MenuItemStyleData(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            customHeights: _getCustomItemsHeights(),
          ),
          iconStyleData: IconStyleData(
            icon: Icon(
              Icons.arrow_drop_down,
              size: 24.sp,
            ),
            iconSize: 24.sp,
            iconEnabledColor: AppColors.primaryColor,
            iconDisabledColor: Colors.orangeAccent,
          ),
        ),
      ),
    );
  }
}
