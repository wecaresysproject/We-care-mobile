import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/features/vaccine/data/models/get_user_vaccines_response_model.dart';
import 'package:we_care/features/vaccine/vaccine_data_entry/Presentation/views/widgets/vaccine_data_form_fields_widget.dart';
import 'package:we_care/features/vaccine/vaccine_data_entry/logic/cubit/vaccine_data_entry_cubit.dart';

class VaccineDataEntryView extends StatelessWidget {
  const VaccineDataEntryView({
    super.key,
    this.editingVaccineData,
  });
  final UserVaccineModel? editingVaccineData;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VaccineDataEntryCubit>(
      create: (context) {
        var cubit = getIt<VaccineDataEntryCubit>();
        if (editingVaccineData != null) {
          cubit.loadVaccineDataForEditing(editingVaccineData!);
        } else {
          cubit.intialRequestsForVaccineDataEntry();
        }
        return cubit;
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
                VaccineDataEntryFormFields(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
