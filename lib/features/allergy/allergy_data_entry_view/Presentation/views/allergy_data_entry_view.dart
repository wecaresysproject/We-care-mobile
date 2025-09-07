import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/smart_assistant_button_shared_widget.dart';
import 'package:we_care/features/allergy/allergy_data_entry_view/Presentation/views/widgets/allergy_data_form_fields_widget.dart';
import 'package:we_care/features/allergy/allergy_data_entry_view/logic/cubit/allergy_data_entry_cubit.dart';

class AllergyDataEntryView extends StatelessWidget {
  const AllergyDataEntryView({
    super.key,
  }); //this.existingSurgeryModel});
  // final SurgeryModel? existingSurgeryModel;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AllergyDataEntryCubit>(
      create: (context) {
        var cubit = getIt<AllergyDataEntryCubit>();
        // if (existingSurgeryModel != null) {
        //   cubit.loadPastSurgeryDataForEditing(existingSurgeryModel!);
        // } else {
        //   cubit.intialRequestsForDataEntry();
        // }
        return cubit..intialRequestsForDataEntry();
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAppBarWidget(
                      haveBackArrow: true,
                    ),
                    verticalSpacing(24),
                    AllergyDataFormFieldsWidget(),
                  ],
                ),
              ),
            ),
            // Floating button at bottom-left
            Positioned(
              bottom: 5.h,
              left: 16.w,
              child: SmartAssistantButton(
                title: 'مساعد ذكي',
                subtitle: 'سورس من أفسس',
                imagePath: "assets/images/hasseya_module.png",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
