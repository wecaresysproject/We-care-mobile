import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/features/chronic_disease/chronic_disease_data_entry/Presentation/views/widgets/chronic_disease_data_entry_form_fields_widget.dart';
import 'package:we_care/features/chronic_disease/chronic_disease_data_entry/logic/cubit/chronic_disease_data_entry_cubit.dart';

class ChronicDiseaseDataEntryView extends StatelessWidget {
  const ChronicDiseaseDataEntryView({
    super.key,
    // this.editingPrescriptionDetailsData,
  });
  // final PrescriptionModel? editingPrescriptionDetailsData;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChronicDiseaseDataEntryCubit>(
      create: (context) {
        var cubit = getIt<ChronicDiseaseDataEntryCubit>();
        // if (editingPrescriptionDetailsData.isNotNull) {
        //   return cubit
        //     ..loadPrescriptionDataForEditing(editingPrescriptionDetailsData!);
        // }
        return cubit..intialRequests();
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
                ChronicDiseaseDataEntryFormFields(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
