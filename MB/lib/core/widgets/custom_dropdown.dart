import 'package:flutter/material.dart';
import 'package:pickleball_app/core/themes/app_colors.dart';
import 'package:pickleball_app/core/widgets/app_text_form_field.dart';

class CustomDropdown<T> extends StatefulWidget {
  final T? selectedValue;
  final ValueChanged<T>? onChanged;
  final List<T> items;
  final String label;
  final String Function(T) getLabel;
  final bool? readOnly;
  final Widget Function(BuildContext, T)? itemBuilder;

  const CustomDropdown({
    super.key,
    required this.selectedValue,
    this.onChanged,
    required this.items,
    required this.label,
    required this.getLabel,
    this.readOnly,
    this.itemBuilder,
  });

  @override
  _CustomDropdownState<T> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _updateControllerText();
  }

  @override
  void didUpdateWidget(CustomDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedValue != widget.selectedValue) {
      _updateControllerText();
    }
  }

  void _updateControllerText() {
    _controller = TextEditingController(
        text: widget.selectedValue != null
            ? widget.getLabel(widget.selectedValue!)
            : '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _showSelectionDialog() async {
    final selected = await showDialog<T>(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: AppColors.primaryColor,
                  ),
                  padding: EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  )
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    final item = widget.items[index];
                    return ListTile(
                      onTap: () => Navigator.pop(context, item),
                      title: widget.itemBuilder != null
                          ? widget.itemBuilder!(context, item)
                          : Text(widget.getLabel(item)),
                    );
                  },
                ),
              ),
              FilledButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text('Close',
                      style: TextStyle(
                        color: Colors.white,
                      ))
              )
            ],
          ),
        ),
      ),
    );

    if (selected != null && widget.onChanged != null) {
      widget.onChanged!(selected);
      _controller.text = widget.getLabel(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      controller: _controller,
      labelText: widget.label,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      readOnly: true,
      showKeyboard: false,
      onTap: widget.readOnly == true || widget.onChanged == null
          ? null
          : _showSelectionDialog,
      suffixIcon: const Icon(Icons.arrow_drop_down),
    );
  }
}
