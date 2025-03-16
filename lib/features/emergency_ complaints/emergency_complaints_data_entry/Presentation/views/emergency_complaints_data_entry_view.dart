import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/features/emergency_%20complaints/emergency_complaints_data_entry/Presentation/views/widgets/emergency_complaints_data_entry_form_fields_widget.dart';
import 'package:we_care/features/emergency_%20complaints/emergency_complaints_data_entry/logic/cubit/emergency_complaints_data_entry_cubit.dart';

class EmergencyComplaintCategoryDataEntryView extends StatelessWidget {
  const EmergencyComplaintCategoryDataEntryView({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider<EmergencyComplaintsDataEntryCubit>(
      create: (context) {
        var cubit = getIt<EmergencyComplaintsDataEntryCubit>();
        // if (editingPrescriptionDetailsData.isNotNull) {
        //   return cubit
        //     ..loadPrescriptionDataForEditing(editingPrescriptionDetailsData!);
        // }
        return cubit..intialRequestsForEmergencyDataEntry();
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
                EmergencyComplaintDataEntryFormFields(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
