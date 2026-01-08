import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/features/medication_compatibility/presentation/views/widgets/medication_compitability_form_field_widget.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_cubit.dart';

class MedicationCompatibilityView extends StatelessWidget {
  const MedicationCompatibilityView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MedicinesDataEntryCubit>(
      create: (context) {
        final cubit = getIt<MedicinesDataEntryCubit>();
        cubit.initialDataEntryRequests();
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppBarWithCenteredTitle(
                  title: 'اختبار توافق ادويتي',
                  showActionButtons: false,
                ),
                verticalSpacing(24),
                MedicationCompatibilityFormFieldsWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
