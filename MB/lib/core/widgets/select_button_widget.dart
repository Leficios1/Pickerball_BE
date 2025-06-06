import 'package:flutter/material.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/themes/app_theme.dart';

class SelectableButtonList extends StatefulWidget {
  final List<String> labels;
  final List<dynamic> values;
  final ValueChanged<dynamic> onSelected;
  final int? initialSelectedIndex;
  final dynamic selectedValue;

  const SelectableButtonList({
    Key? key,
    required this.labels,
    required this.values,
    required this.onSelected,
    this.initialSelectedIndex,
    this.selectedValue,
  })  : assert(labels.length == values.length,
            'Labels and values must have the same length'),
        super(key: key);

  @override
  State<SelectableButtonList> createState() => _SelectableButtonListState();
}

class _SelectableButtonListState extends State<SelectableButtonList> {
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialSelectedIndex;
  }

  @override
  void didUpdateWidget(covariant SelectableButtonList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue != oldWidget.selectedValue ||
        widget.selectedValue == null) {
      setState(() {
        _selectedIndex = widget.selectedValue != null
            ? widget.values.indexOf(widget.selectedValue)
            : null;
      });
    }
  }

  void _handleTap(int index) {
    setState(() {
      _selectedIndex = (_selectedIndex == index) ? null : index;
    });
    widget.onSelected(
        _selectedIndex != null ? widget.values[_selectedIndex!] : null);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(widget.labels.length, (index) {
        bool isSelected = _selectedIndex == index;
        return ElevatedButton(
          onPressed: () => _handleTap(index),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            backgroundColor:
                isSelected ? Colors.white : Colors.grey[300],
            foregroundColor: isSelected ? Colors.white : Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: isSelected ? 4 : 1,
          ),
          child: Text(
            widget.labels[index],
            style: AppTheme.getTheme(context).textTheme.titleLarge?.copyWith(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }),
    );
  }
}
