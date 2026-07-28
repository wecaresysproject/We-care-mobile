import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medicine/medicine_view/logic/medicine_view_cubit.dart';
import 'package:we_care/features/medicine/medicine_view/logic/medicine_view_state.dart';
import 'package:we_care/features/medicine/medicine_view/widgets/end_medicine_confirmation_dialog.dart';

class MedicineActiveStatusSwitch extends StatelessWidget {
  final String medicineId;

  const MedicineActiveStatusSwitch({
    super.key,
    required this.medicineId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicineViewCubit, MedicineViewState>(
      buildWhen: (previous, current) =>
          previous.isActiveMedicine != current.isActiveMedicine ||
          previous.isSwitchLoading != current.isSwitchLoading ||
          previous.isStatusResolved != current.isStatusResolved ||
          previous.medicineEndDate != current.medicineEndDate ||
          //* canEndMedicine depends on the loaded medicine, which arrives from a
          //* separate request than the status
          previous.selectestMedicineDetails != current.selectestMedicineDetails,
      builder: (context, state) {
        return Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                    color: AppColorsManager.mainDarkBlue, width: 0.3),
                gradient: const LinearGradient(
                  colors: [Color(0xFFECF5FF), Color(0xFFFBFDFD)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'حالة استمرارية الدواء',
                    style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                      fontSize: 15.sp,
                      color: AppColorsManager.mainDarkBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  _buildStatusControl(context, state),
                ],
              ),
            ),

            /// An ended medicine shows its end date; the tile hides itself when
            /// the date is unknown (legacy records / before the API returns it).
            if (state.isMedicineEnded)
              DetailsViewInfoTile(
                title: 'تاريخ انتهاء الدواء',
                value: state.medicineEndDate ?? '',
                icon: 'assets/images/date_icon.png',
                isExpanded: true,
              ),
          ],
        );
      },
    );
  }

  Widget _buildStatusControl(BuildContext context, MedicineViewState state) {
    if (state.isSwitchLoading) {
      return Padding(
        padding: EdgeInsets.only(left: 8.w),
        child: SizedBox(
          width: 20.w,
          height: 20.h,
          child: CircularProgressIndicator(
            strokeWidth: 2.w,
            color: AppColorsManager.mainDarkBlue,
          ),
        ),
      );
    }

    /// The status is not known yet (still loading, or the request failed) — a
    /// failed request must never be presented as an ended medicine.
    if (!state.isStatusResolved) {
      return Text(
        '—',
        style: AppTextStyles.font16DarkGreyWeight400.copyWith(
          color: AppColorsManager.mainDarkBlue,
        ),
      );
    }

    /// Ended: read-only, and there is no way back — restarting the medicine or
    /// changing its dose is a brand new medicine record.
    if (!state.isActiveMedicine) {
      return Text(
        'منتهي',
        style: AppTextStyles.font16DarkGreyWeight400.copyWith(
          fontSize: 15.sp,
          color: AppColorsManager.warningColor,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return Switch.adaptive(
      activeColor: AppColorsManager.mainDarkBlue,
      value: true,
      onChanged: state.canEndMedicine
          ? (value) async => _onStatusToggled(context, value)
          : null,
    );
  }

  Future<void> _onStatusToggled(BuildContext context, bool value) async {
    if (value) return; //* only turning the status off ends a medicine

    final cubit = context.read<MedicineViewCubit>();
    final medicine = cubit.state.selectestMedicineDetails;
    if (medicine == null) return;

    final endDate = await showEndMedicineConfirmationDialog(
      context: context,
      medicineName: medicine.medicineName,
      medicineStartDate: medicine.startDate,
    );

    //* cancelled or dismissed: no request, no state change, alarms untouched
    if (endDate == null) return;

    final isEnded = await cubit.endMedicine(
      medicineId: medicineId,
      endDate: endDate,
    );

    //* showSuccess/showError are Fluttertoast based and take no BuildContext
    if (isEnded) {
      await showSuccess('تم إنهاء الدواء بنجاح');
    } else {
      final errorMessage = cubit.state.switchErrorMessage;
      await showError(
        errorMessage.isEmpty
            ? 'تعذر إنهاء الدواء، حاول مرة أخرى'
            : errorMessage,
      );
    }
  }
}
