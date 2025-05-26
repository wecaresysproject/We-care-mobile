import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/dental_module/data/models/get_tooth_operation_details_by_id.dart';
import 'package:we_care/features/dental_module/dental_data_entry_view/Presentation/views/widgets/dental_app_bar_widget.dart';
import 'package:we_care/features/dental_module/dental_data_entry_view/Presentation/views/widgets/dental_data_form_fields_widget.dart';
import 'package:we_care/features/dental_module/dental_data_entry_view/logic/cubit/dental_data_entry_cubit.dart';

class DentalDataEntryView extends StatelessWidget {
  const DentalDataEntryView({
    super.key,
    this.toothNumber,
    this.existingToothModel,
    this.toothId,
  });
  final ToothOperationDetails? existingToothModel;
  final String? toothNumber;
  final String? toothId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<DentalDataEntryCubit>(
      create: (context) {
        var cubit = getIt<DentalDataEntryCubit>();
        if (existingToothModel != null) {
          cubit.loadPastToothDataForEditing(
            existingToothModel!,
            teethId: toothId!,
          );
        } else {
          cubit.intialRequestsForDataEntry();
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
                DentalAppBarComponent(
                  toothNumber: toothNumber,
                ),
                verticalSpacing(24),
                DentalDataFormFieldsWidget(
                  toothNumber: toothNumber,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
