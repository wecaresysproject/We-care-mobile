import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class CustomDropdown extends StatefulWidget {
  final String categoryLabel;
  final String hintText;
  final List<String> options;
  final Function(String) onSelected;
  final bool isRequired; // Add this to mark the dropdown as required

  const CustomDropdown({
    super.key,
    required this.categoryLabel,
    required this.hintText,
    required this.options,
    required this.onSelected,
    this.isRequired = false, // Default to false
  });

  @override
  CustomDropdownState createState() => CustomDropdownState();
}

class CustomDropdownState extends State<CustomDropdown> {
  String? selectedValue;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _dropdownKey = GlobalKey();

  bool _isValid = true; // Track validation state

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _showDropdown();
    } else {
      _removeDropdown();
    }
  }

  void _showDropdown() {
    RenderBox renderBox =
        _dropdownKey.currentContext!.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Dismiss when tapping outside
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _removeDropdown,
            ),
          ),

          // Dropdown Menu
          Positioned(
            width: renderBox.size.width,
            left: offset.dx,
            top: offset.dy + renderBox.size.height + 8.h,
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: 250.h, // Ensures list is scrollable
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(
                    color: AppColorsManager.placeHolderColor,
                    width: 1,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.options.map((option) {
                      return RadioListTile<String>(
                        selected: selectedValue == option,
                        shape: RoundedRectangleBorder(
                          // Ensure background applies correctly
                          borderRadius: BorderRadius.circular(
                              12.r), // Add rounded corners
                        ),
                        tileColor: selectedValue == option
                            ? AppColorsManager.mainDarkBlue
                            : Colors.transparent,
                        fillColor: WidgetStateProperty.resolveWith<Color?>(
                          (states) {
                            if (states.contains(WidgetState.selected)) {
                              return AppColorsManager.mainDarkBlue;
                            }
                            return AppColorsManager.placeHolderColor;
                          },
                        ),
                        title: Text(
                          option,
                          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                            color: selectedValue == option
                                ? AppColorsManager.mainDarkBlue
                                : null,
                          ),
                        ),
                        value: option,
                        groupValue: selectedValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue = newValue;
                            _isValid = true; // Reset validation on selection
                          });
                          widget.onSelected(newValue!);
                          _removeDropdown();
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // Method to validate the dropdown
  bool validate() {
    if (widget.isRequired && selectedValue == null) {
      setState(() {
        _isValid = false; // Set validation to false if no value is selected
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.categoryLabel,
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(10),
        GestureDetector(
          onTap: () {
            _toggleDropdown();
            setState(() {});
          },
          child: CompositedTransformTarget(
            link: _layerLink,
            child: Container(
              key: _dropdownKey,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: _isValid
                      ? (_overlayEntry == null
                          ? AppColorsManager.placeHolderColor
                          : AppColorsManager.mainDarkBlue)
                      : Colors.red, // Red border for invalid state
                ),
                color: AppColorsManager.textfieldInsideColor.withAlpha(100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedValue ?? widget.hintText,
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          selectedValue == null ? Colors.black54 : Colors.black,
                    ),
                  ),
                  Image.asset(
                    _overlayEntry == null
                        ? "assets/images/arrow_up_icon.png"
                        : "assets/images/arrow_down_icon.png",
                    height: 24.h,
                    width: 16.w,
                  )
                ],
              ),
            ),
          ),
        ),
        if (!_isValid) // Show validation error message
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text(
              "هذا الحقل مطلوب",
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }
}
