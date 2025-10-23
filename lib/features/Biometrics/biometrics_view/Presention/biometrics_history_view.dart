import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/Biometrics/biometrics_view/logic/biometrics_view_cubit.dart';
import 'package:we_care/features/Biometrics/biometrics_view/logic/biometrics_view_state.dart';
import 'package:we_care/features/Biometrics/data/models/biometrics_dataset_model.dart';

class BiometricHistoryView extends StatelessWidget {
  const BiometricHistoryView({
    super.key,
    required this.metricName,
    required this.metricImage,
  });

  final String metricName;
  final String metricImage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BiometricsViewCubit>(
      create: (context) => getIt<BiometricsViewCubit>()
        ..getFilteredBiometrics(biometricCategories: [metricName]),
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              AppBarWithCenteredTitle(
                title: "قياسات $metricName",
                showActionButtons: false,
              ),
              verticalSpacing(16),
              BlocConsumer<BiometricsViewCubit, BiometricsViewState>(
                listener: (context, state) async {
                  if (state.deleteRequestStatus == RequestStatus.success ||
                      state.editRequestStatus == RequestStatus.success) {
                    showSuccess(state.responseMessage);
                  }
                  if (state.deleteRequestStatus == RequestStatus.failure ||
                      state.editRequestStatus == RequestStatus.failure) {
                    showError(state.responseMessage);
                  }
                },
                builder: (context, state) {
                  return _buildDataTableByState(state, context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataTableByState(
      BiometricsViewState state, BuildContext context) {
    switch (state.requestStatus) {
      case RequestStatus.loading:
        return _buildLoadingState();

      case RequestStatus.success:
        return _buildSuccessState(state.biometricsData, context);

      default:
        return _buildInitialState();
    }
  }

  Widget _buildLoadingState() {
    return Container(
      height: 400.h,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff909090), width: 0.19),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColorsManager.mainDarkBlue,
            ),
            SizedBox(height: 16),
            Text(
              "جاري تحميل البيانات...",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String errorMessage, BuildContext context) {
    return SizedBox(
      height: 400.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48.sp,
            ),
            SizedBox(height: 16.h),
            Text(
              "خطأ في تحميل البيانات",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () {
                context
                    .read<BiometricsViewCubit>()
                    .getFilteredBiometrics(biometricCategories: [metricName]);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColorsManager.mainDarkBlue,
              ),
              child: const Text(
                "إعادة المحاولة",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessState(
      List<BiometricsDatasetModel> historyData, BuildContext context) {
    if (historyData.isEmpty) {
      return _buildEmptyState();
    }
    final formattedData = historyData.first.data.map((d) {
      final formattedDate = formatDateTime(d.originalDate);
      return BiometricData(
        formattedDate: formattedDate, // المعروضة في الجدول
        originalDate: d.originalDate, // الأصلية تُستخدم للإرسال للـ API
        value: d.value,
        secondaryValue: d.secondaryValue,
      );
    }).toList();

    return DataTable(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      headingRowColor: WidgetStateProperty.all(AppColorsManager.mainDarkBlue),
      columnSpacing: MediaQuery.of(context).size.width < 400 ? 10.w : 20.w,
      dataRowMaxHeight: 60.h,
      horizontalMargin: 6.w,
      headingTextStyle: _getHeadingTextStyle(),
      headingRowHeight: 48.h,
      showBottomBorder: true,
      border: TableBorder.all(
        style: BorderStyle.solid,
        borderRadius: BorderRadius.circular(18.r),
        color: const Color(0xff909090),
        width: 0.19,
      ),
      columns: _buildColumns(),
      rows: _buildRowsFromData(formattedData, context),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: 400.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 48.sp,
              color: Colors.grey,
            ),
            SizedBox(height: 16.h),
            Text(
              "لا توجد بيانات لهذا القياس",
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return SizedBox(
      height: 100.h,
      child: const Center(
        child: Text("جاري التحضير..."),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return [
      _buildColumn("التاريخ"),
      _buildColumn("القياس القديم"),
      _buildColumn("تعديل"),
      _buildColumn("حذف"),
    ];
  }

  List<DataRow> _buildRowsFromData(
      List<BiometricData> historyData, BuildContext context) {
    return historyData.map((item) {
      return DataRow(
        cells: [
          _buildCell(item.formattedDate ?? item.originalDate),
          _buildCell(item.secondaryValue == null
              ? item.value
              : "${item.secondaryValue}/ ${item.value}"),
          _buildEditCell(context, item),
          _buildDeleteCell(context, item.originalDate),
        ],
      );
    }).toList();
  }

  DataColumn _buildColumn(String label) {
    return DataColumn(
      headingRowAlignment: MainAxisAlignment.center,
      label: Expanded(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.font18blackWight500.copyWith(
            fontSize: 14.sp,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  DataCell _buildCell(String text) {
    return DataCell(
      Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyles.font12blackWeight400.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  DataCell _buildDeleteCell(BuildContext context, String date) {
    return DataCell(
      Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColorsManager.warningColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
            minimumSize: const Size(0, 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          onPressed: () async {
            final confirm = await _showDeleteConfirmationDialog(context);
            if (confirm == true && context.mounted) {
              await context
                  .read<BiometricsViewCubit>()
                  .deleteBiometricDataOfSpecificCategory(
                    date: date, // Pass the appropriate date here
                    biometricName: metricName,
                  );
              context
                  .read<BiometricsViewCubit>()
                  .getFilteredBiometrics(biometricCategories: [metricName]);
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delete, size: 16.sp),
              SizedBox(width: 2.w),
              Text(
                "حذف",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DataCell _buildEditCell(BuildContext context, BiometricData item) {
    return DataCell(
      Center(
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColorsManager.mainDarkBlue,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          onPressed: () async {
            final result = await _showEditDialog(context, item, metricName);

            if (result != null) {
              if (metricName.contains("ضغط")) {
                final systolic = result['systolic'];
                final diastolic = result['diastolic'];
                await context
                    .read<BiometricsViewCubit>()
                    .editBiometricDataOfSpecificCategory(
                      minValue: diastolic!,
                      maxValue: systolic,
                      date: item.originalDate,
                      biometricName: metricName,
                    );
                context
                    .read<BiometricsViewCubit>()
                    .getFilteredBiometrics(biometricCategories: [metricName]);
                print('الضغط الانقباضي: $systolic / الانبساطي: $diastolic');
              } else {
                final value = result['value'];
                await context
                    .read<BiometricsViewCubit>()
                    .editBiometricDataOfSpecificCategory(
                      minValue: value!,
                      maxValue: null,
                      date: item.originalDate,
                      biometricName: metricName,
                    );
                context
                    .read<BiometricsViewCubit>()
                    .getFilteredBiometrics(biometricCategories: [metricName]);
              }
            }
          },
          icon: Icon(Icons.edit, size: 12.sp),
          label: Text(
            "تعديل",
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          backgroundColor: const Color(0xFFE8EEF5),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "هل متأكد من حذف القياس ؟",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                    fontFamily: 'Cairo',
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => Navigator.pop(context, false),
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: AppColorsManager.unselectedNavIconColor,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            "لا",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColorsManager.mainDarkBlue,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: InkWell(
                        onTap: () => Navigator.pop(context, true),
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: AppColorsManager.unselectedNavIconColor,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            "نعم",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColorsManager.warningColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, String>?> _showEditDialog(
      BuildContext context, BiometricData item, String metricName) {
    final TextEditingController singleValueController = TextEditingController();
    final TextEditingController systolicController = TextEditingController();
    final TextEditingController diastolicController = TextEditingController();

    final bool isBloodPressure = metricName.contains("الضغط");

    return showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          title: Text(
            "تعديل القيمة",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
              fontFamily: 'Cairo',
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isBloodPressure
                    ? "أدخل القيم الجديدة للضغط (الانقباضي والانبساطي)"
                    : "أدخل القيمة الجديدة لـ $metricName",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 16.h),
              if (isBloodPressure) ...[
                TextField(
                  controller: systolicController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "الضغط الانقباضي (Systolic)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                TextField(
                  controller: diastolicController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "الضغط الانبساطي (Diastolic)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ] else ...[
                TextField(
                  controller: singleValueController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "القيمة الجديدة",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ],
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "إلغاء",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14.sp,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (isBloodPressure) {
                  final systolic = systolicController.text.trim();
                  final diastolic = diastolicController.text.trim();

                  if (systolic.isEmpty || diastolic.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("من فضلك أدخل القيمتين")),
                    );
                    return;
                  }

                  Navigator.pop(context, {
                    'systolic': systolic,
                    'diastolic': diastolic,
                  });
                } else {
                  final value = singleValueController.text.trim();
                  if (value.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("من فضلك أدخل قيمة صحيحة")),
                    );
                    return;
                  }

                  Navigator.pop(context, {
                    'value': value,
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColorsManager.mainDarkBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                "حفظ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  TextStyle _getHeadingTextStyle() {
    return AppTextStyles.font16DarkGreyWeight400.copyWith(
      color: AppColorsManager.backGroundColor,
      fontWeight: FontWeight.w600,
      fontSize: 15.sp,
    );
  }
}

String formatDateTime(String isoString) {
  final dateTime = DateTime.tryParse(isoString);
  if (dateTime == null) return isoString;

  final day = dateTime.day.toString().padLeft(2, '0');
  final month = dateTime.month.toString().padLeft(2, '0');
  int hour = dateTime.hour;
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final period = hour >= 12 ? 'PM' : 'AM';
  hour = hour % 12 == 0 ? 12 : hour % 12;

  return '$day/$month \n $hour:$minute $period';
}
