import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/nutration/data/repos/nutration_data_entry_repo.dart';
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
      create: (context) => NutrationDataEntryCubit(
        getIt<NutrationDataEntryRepo>(),
        context,
      ),
      child: BlocConsumer<NutrationDataEntryCubit, NutrationDataEntryState>(
        listener: (context, state) {
          // Handle success state
          if (state.submitNutrationDataStatus == RequestStatus.success) {
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message ?? 'تم تعديل النظام الغذائي بنجاح',
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );

            // Pop with true to reload previous page
            Future.delayed(const Duration(milliseconds: 500), () {
              if (context.mounted) {
                Navigator.of(context).pop(true);
              }
            });
          }

          // Handle error state
          if (state.submitNutrationDataStatus == RequestStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message ?? 'حدث خطأ أثناء تعديل النظام الغذائي',
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading =
              state.submitNutrationDataStatus == RequestStatus.loading;

          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 48.h),
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
                          enabled: !isLoading,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xffF4F6F9),
                            contentPadding: EdgeInsets.all(16.w),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: AppColorsManager
                                    .textfieldOutsideBorderColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: AppColorsManager
                                    .textfieldOutsideBorderColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: AppColorsManager.mainDarkBlue,
                                width: 1.5,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: AppColorsManager
                                    .textfieldOutsideBorderColor
                                    .withOpacity(0.5),
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
                          isEnabled: _canSubmit && !isLoading,
                          title: isLoading ? "جاري التحليل..." : "تعديل",
                          onPressed: () async {
                            final updatedText = _controller.text.trim();

                            // Call the analyze method
                            await context
                                .read<NutrationDataEntryCubit>()
                                .analyzeUpdatedDietPlan(
                                  updatedText,
                                  widget.date,
                                );
                          },
                        ),
                      )
                    ],
                  ),
                ),

                // Loading overlay
                if (isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(24.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(),
                            SizedBox(height: 16.h),
                            Text(
                              "جاري تحليل النظام الغذائي...",
                              style: AppTextStyles.font16DarkGreyWeight400
                                  .copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
