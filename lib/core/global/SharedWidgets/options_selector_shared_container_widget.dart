import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class OptionSelectorWidget extends StatefulWidget {
  final List<String> options;
  final String? initialSelectedOption;
  final Function(String)? onOptionSelected;
  final Color containerValidationColor;

  const OptionSelectorWidget({
    super.key,
    required this.options,
    this.initialSelectedOption,
    this.onOptionSelected,
    this.containerValidationColor =
        AppColorsManager.textfieldOutsideBorderColor,
  });

  @override
  OptionSelectorWidgetState createState() => OptionSelectorWidgetState();
}

class OptionSelectorWidgetState extends State<OptionSelectorWidget> {
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption =
        widget.initialSelectedOption; // Set initial selected value
  }

  @override
  void didUpdateWidget(covariant OptionSelectorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSelectedOption != widget.initialSelectedOption) {
      _selectedOption = widget.initialSelectedOption;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(7.w, 15.h, 7.w, 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: widget.containerValidationColor,
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
                children: widget.options.map((option) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedOption = option;
                      });
                      if (widget.onOptionSelected != null) {
                        widget.onOptionSelected!(option);
                      }
                    },
                    child: Column(
                      children: [
                        AnimatedScale(
                          scale: _selectedOption == option ? 1.12 : .9,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          child: Image.asset(
                            _selectedOption == option
                                ? "assets/images/selected_option.png"
                                : "assets/images/default_option.png",
                            width: 26,
                            height: 26,
                            errorBuilder: (context, error, stackTrace) {
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
                        ),
                        Text(
                          option,
                          softWrap: true,
                          style: AppTextStyles.font14BlueWeight700.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColorsManager.textColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        if (widget.containerValidationColor == AppColorsManager.warningColor)
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
