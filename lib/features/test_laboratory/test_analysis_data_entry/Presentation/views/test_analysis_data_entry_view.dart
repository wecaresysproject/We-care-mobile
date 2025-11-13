import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_data_entry/logic/cubit/emergency_complaint_details_cubit.dart';
import 'package:we_care/features/test_laboratory/data/models/get_analysis_by_id_response_model.dart';
import 'package:we_care/features/test_laboratory/test_analysis_data_entry/Presentation/views/widgets/test_analysis_data_form_fields_widget.dart';
import 'package:we_care/features/test_laboratory/test_analysis_data_entry/logic/cubit/test_analysis_data_entry_cubit.dart';

class TestAnalysisDataEntryView extends StatelessWidget {
  const TestAnalysisDataEntryView({super.key, this.editingAnalysisDetailsData});
  final AnalysisDetailedData? editingAnalysisDetailsData;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TestAnalysisDataEntryCubit>(
          create: (context) {
            var cubit = getIt<TestAnalysisDataEntryCubit>();
            if (editingAnalysisDetailsData != null) {
              cubit.loadAnalysisDataForEditing(editingAnalysisDetailsData!);
            } else {
              cubit.intialRequestsForTestAnalysisDataEntry();
            }
            return cubit;
          },
        ),
        BlocProvider<EmergencyComplaintDataEntryDetailsCubit>(
          create: (context) => getIt<EmergencyComplaintDataEntryDetailsCubit>(),
        ),
      ],
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
                TestAnalysisDataEntryFormFields(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
