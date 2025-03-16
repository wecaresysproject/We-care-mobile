import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class OptionSelectorWidget extends StatefulWidget {
  final List<String> options;
  final Function(String)? onOptionSelected;

  const OptionSelectorWidget({
    super.key,
    required this.options,
    this.onOptionSelected,
  });

  @override
  OptionSelectorWidgetState createState() => OptionSelectorWidgetState();
}

class OptionSelectorWidgetState extends State<OptionSelectorWidget> {
  String? _selectedOption; // Initially no selection

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(7.w, 15.h, 7.w, 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          10.r,
        ),
        border: Border.all(
          color: AppColorsManager
              .textfieldOutsideBorderColor, // Change border if error
          width: 0.8,
        ),
        color: AppColorsManager.textfieldInsideColor.withAlpha(100),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 20.h,
            child: Divider(
              thickness: 4,
              color: AppColorsManager.placeHolderColor,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: widget.options.map(
              (option) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedOption = option;
                    });
                    // Trigger the callback if provided
                    if (widget.onOptionSelected != null) {
                      widget.onOptionSelected!(option);
                    }
                  },
                  child: Column(
                    children: [
                      // Bullet Indicator (visible only if selected)
                      Image.asset(
                        _selectedOption == option
                            ? "assets/images/selected_option.png"
                            : "assets/images/default_option.png",
                        width: 26,
                        height: 26,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback in case the image fails to load
                          return Container(
                            width: 26.w,
                            height: 26.h,
                            decoration: BoxDecoration(
                              color: AppColorsManager.mainDarkBlue,
                              shape: BoxShape.circle,
                            ),
                          );
                        },
                      ),
                      // Option Text
                      Text(
                        option,
                        style: AppTextStyles.font14BlueWeight700.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColorsManager.textColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}
