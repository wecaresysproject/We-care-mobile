import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/smart_assistant_button_shared_widget.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/Presentation/views/widgets/personal_genetic_diseases_data_entry_form_fields_widget.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/logic/cubit/genetic_diseases_data_entry_cubit.dart';

class PersonalGeneticDiseaseDataEntryView extends StatelessWidget {
  const PersonalGeneticDiseaseDataEntryView({
    super.key,
    // this.medicineToEdit,
  });
  // final MedicineModel? medicineToEdit;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PersonalGeneticDiseasesDataEntryCubit>(
      create: (context) {
        final cubit = getIt<PersonalGeneticDiseasesDataEntryCubit>();
        // if (medicineToEdit != null) {
        //   cubit.loadMedicinesDataEnteredForEditing(medicineToEdit!);
        // } else {
        //   cubit.initialDataEntryRequests();
        // }
        cubit.initialDataEntryRequests();
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Stack(
          children: [
            SingleChildScrollView(
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
                    PersonalGeneticDiseasesDataEntryFormFieldsWidget(),
                  ],
                ),
              ),
            ),
            // Floating button at bottom-left
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.1,
              left: 16.w,
              child: SmartAssistantButton(
                title: 'مساعد ذكي',
                subtitle: 'ابن سهل البلخي',
                imagePath: "assets/images/genetic_dissease_module.png",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
