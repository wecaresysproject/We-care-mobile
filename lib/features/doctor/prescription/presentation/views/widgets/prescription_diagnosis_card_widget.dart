import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/prescription/logic/cubit/doctor_prescription_cubit.dart';
import 'package:we_care/features/doctor/prescription/presentation/views/widgets/prescription_multiline_text_field.dart';

/// "التشخيص (اختياري)": free text that becomes the patient ticket's
/// diagnosis.
class PrescriptionDiagnosisCardWidget extends StatefulWidget {
  const PrescriptionDiagnosisCardWidget({super.key});

  @override
  State<PrescriptionDiagnosisCardWidget> createState() =>
      _PrescriptionDiagnosisCardWidgetState();
}

class _PrescriptionDiagnosisCardWidgetState
    extends State<PrescriptionDiagnosisCardWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: context.read<DoctorPrescriptionCubit>().state.diagnosis,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColorsManager.prescriptionCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.medical_information_outlined,
                size: 20.r,
                color: AppColorsManager.prescriptionTitleColor,
              ),
              horizontalSpacing(6),
              Text(
                "التشخيص",
                style: AppTextStyles.font16BlackSemiBold.copyWith(
                  color: AppColorsManager.prescriptionTitleColor,
                ),
              ),
              horizontalSpacing(4),
              Text(
                "(اختياري)",
                style: AppTextStyles.font13GreyWeight400.copyWith(
                  color: AppColorsManager.prescriptionSubtitleColor,
                ),
              ),
            ],
          ),
          verticalSpacing(10),
          PrescriptionMultilineTextField(
            controller: _controller,
            hintText: "مثال: التهاب الحلق",
            minLines: 1,
            maxLines: 3,
            onChanged: context.read<DoctorPrescriptionCubit>().updateDiagnosis,
          ),
        ],
      ),
    );
  }
}
