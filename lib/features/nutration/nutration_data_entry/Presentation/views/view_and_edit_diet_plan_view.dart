import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/nutration/nutration_data_entry/logic/cubit/nutration_data_entry_cubit.dart';

class ViewAndEditDietPlanView extends StatefulWidget {
  final String writtenDietPlan;
  final String date;

  const ViewAndEditDietPlanView({
    super.key,
    required this.writtenDietPlan,
    required this.date,
  });

  @override
  State<ViewAndEditDietPlanView> createState() =>
      _ViewAndEditDietPlanViewState();
}

class _ViewAndEditDietPlanViewState extends State<ViewAndEditDietPlanView> {
  late final String _initialDietPlan;
  late TextEditingController _controller;
  bool _canSubmit = false;

  @override
  void initState() {
    super.initState();
    _initialDietPlan = widget.writtenDietPlan;
    _controller = TextEditingController(text: _initialDietPlan);
    _controller.addListener(_handleTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    final hasChanges = _controller.text.trim() != _initialDietPlan.trim();
    if (hasChanges != _canSubmit) {
      setState(() {
        _canSubmit = hasChanges;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NutrationDataEntryCubit>(
      create: (context) => getIt<NutrationDataEntryCubit>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 48.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBarWithCenteredTitle(
                title: "مشاهدة وتعديل النظام الغذائي",
                fontSize: 18,
                showActionButtons: false,
                shareFunction: () {},
              ),
              Text(
                "النظام الغذائي",
                style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColorsManager.mainDarkBlue,
                ),
              ),

              SizedBox(height: 10.h),

              /// TextField
              Expanded(
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xffF4F6F9),
                    contentPadding: EdgeInsets.all(16.w),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: AppColorsManager.textfieldOutsideBorderColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: AppColorsManager.textfieldOutsideBorderColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: AppColorsManager.mainDarkBlue,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              /// Submit Button

              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: AppCustomButton(
                  isEnabled: _canSubmit,
                  title: "تعديل",
                  onPressed: () {
                    final updatedText = _controller.text.trim();
                    Navigator.of(context).pop(updatedText);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
