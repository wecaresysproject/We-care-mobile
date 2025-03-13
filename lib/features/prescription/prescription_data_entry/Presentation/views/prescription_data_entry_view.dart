import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/features/prescription/data/models/get_user_prescriptions_response_model.dart';
import 'package:we_care/features/prescription/prescription_data_entry/Presentation/views/widgets/prescription_data_entry_form_fields_widget.dart';
import 'package:we_care/features/prescription/prescription_data_entry/logic/cubit/prescription_data_entry_cubit.dart';

class PrescriptionCategoryDataEntryView extends StatelessWidget {
  const PrescriptionCategoryDataEntryView({
    super.key,
    this.editingPrescriptionDetailsData,
  });
  final PrescriptionModel? editingPrescriptionDetailsData;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PrescriptionDataEntryCubit>(
      create: (context) {
        var cubit = getIt<PrescriptionDataEntryCubit>();
        if (editingPrescriptionDetailsData.isNotNull) {
          return cubit
            ..loadPrescriptionDataForEditing(editingPrescriptionDetailsData!);
        }
        return cubit..intialRequestsForPrescriptionDataEntry();
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBarWidget(
                  haveBackArrow: true,
                ),
                verticalSpacing(24),
                PrescriptionDataEntryFormFields(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
