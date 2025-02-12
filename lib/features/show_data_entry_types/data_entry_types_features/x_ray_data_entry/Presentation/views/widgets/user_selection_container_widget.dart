import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class UserSelectionContainer extends StatefulWidget {
  const UserSelectionContainer({
    super.key,
    required this.options,
    required this.categoryLabel,
    required this.bottomSheetTitle,
    required this.onOptionSelected,
    required this.containerHintText,
    this.allowManualEntry = false,
    this.containerBorderColor = AppColorsManager.textfieldOutsideBorderColor,
  });

  final List<String> options;
  final String categoryLabel;
  final String bottomSheetTitle;
  final String containerHintText;
  final Function(String) onOptionSelected;
  final bool allowManualEntry;
  final Color containerBorderColor;

  @override
  State<UserSelectionContainer> createState() => _UserSelectionContainerState();
}

class _UserSelectionContainerState extends State<UserSelectionContainer> {
  String? selectedItem;

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
            showSelectionBottomSheet(
              context: context,
              onAddNew: () {},
              title: widget.bottomSheetTitle,
              options: widget.options,
              initialSelectedItem: selectedItem,
              onItemSelected: (selected) {
                setState(() {
                  selectedItem = selected;
                });
                widget.onOptionSelected(selected);
              },
              allowManualEntry: widget.allowManualEntry,
            );
          },
          child: Container(
            width: double.infinity,
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.containerBorderColor, // Change border if error
                width: 0.8,
              ),
              color: AppColorsManager.textfieldInsideColor.withAlpha(100),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedItem ?? widget.containerHintText,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Image.asset(
                  selectedItem != null
                      ? "assets/images/arrow_up_icon.png"
                      : "assets/images/arrow_down_icon.png",
                  height: 24.h,
                  width: 16.w,
                ),
              ],
            ),
          ),
        ),
        if (widget.containerBorderColor ==
            AppColorsManager
                .warningColor) // Show error message if required and not selected
          Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: Text(
              context.translate.required_field,
              style: TextStyle(color: Colors.red, fontSize: 14.sp),
            ),
          ),
      ],
    );
  }
}

void showSelectionBottomSheet({
  required BuildContext context,
  required String title,
  required List<String> options,
  required Function(String) onItemSelected,
  String? initialSelectedItem,
  bool allowManualEntry = false,
  VoidCallback? onAddNew,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(18.r),
      ),
    ),
    builder: (context) {
      String? selectedItem = initialSelectedItem; // Track selected item

      return StatefulBuilder(
        builder: (context, setState) {
          TextEditingController manualInputController = TextEditingController();

          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 16.w, vertical: allowManualEntry ? 30.h : 8.h), //8
            child: Column(
              mainAxisSize:
                  allowManualEntry ? MainAxisSize.max : MainAxisSize.min,
              children: [
                verticalSpacing(12),

                // Close Button & Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.font18blackWight500.copyWith(
                        color: AppColorsManager.textfieldOutsideBorderColor,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(
                        "assets/images/close_icon.png",
                        height: 20,
                        width: 20,
                      ),
                    )
                  ],
                ),
                verticalSpacing(20),

                // Options List
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    bool isSelected = selectedItem == options[index];

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedItem = options[index]; // Update selection
                        });
                        onItemSelected(options[index]); // Return selected item
                        Navigator.pop(context); // Close bottom sheet
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 12,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  options[index],
                                  style: AppTextStyles.font16DarkGreyWeight400
                                      .copyWith(
                                    color: isSelected
                                        ? AppColorsManager.mainDarkBlue
                                        : Color(0xff555555),
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                isSelected
                                    ? Image.asset(
                                        "assets/images/check_right.png",
                                        height: 15,
                                        width: 20,
                                      )
                                    : SizedBox.shrink(),
                              ],
                            ),
                          ),
                          Divider(
                            height: 1,
                            thickness: 0.3,
                            indent: 14,
                            color: AppColorsManager.placeHolderColor,
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // Add New Option Button (Optional)
                if (allowManualEntry && onAddNew != null)
                  Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: manualInputController,
                            decoration: InputDecoration(
                              labelText: "أدخل اسمًا يدويًا",
                              border: InputBorder.none, // Removes border
                              enabledBorder:
                                  InputBorder.none, // No border when enabled
                              focusedBorder:
                                  InputBorder.none, // No border when focused
                              labelStyle: AppTextStyles.font16DarkGreyWeight400
                                  .copyWith(
                                color: Color(0xff555555),
                              ),
                              hintStyle: AppTextStyles.font16DarkGreyWeight400
                                  .copyWith(
                                color: Color(0xff555555),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            if (manualInputController.text.isNotEmpty) {
                              setState(() {
                                selectedItem = manualInputController.text;
                              });
                              onItemSelected(manualInputController.text);
                              Navigator.pop(context);
                            }
                          },
                          child: Image.asset(
                            "assets/images/plus_icon.png",
                            height: 28,
                            width: 48,
                          ),
                        )
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      );
    },
  );
}
