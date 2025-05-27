import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/Presentation/views/widgets/familly_question_field_widget.dart';

class FamilyTreeDataEntryView extends StatelessWidget {
  const FamilyTreeDataEntryView({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              FamilyQuestionField(
                question: "كم عم لديك ؟",
                onChanged: (value) {},
              ),
              verticalSpacing(24),
              FamilyQuestionField(
                question: "كم عمة لديك ؟",
                onChanged: (value) {},
              ),
              verticalSpacing(32),
              FamilyQuestionField(
                question: "كم خال لديك ؟",
                onChanged: (value) {},
              ),
              verticalSpacing(32),
              FamilyQuestionField(
                question: "كم خالة لديك ؟",
                onChanged: (value) {},
              ),
              verticalSpacing(176),
              AppCustomButton(
                isLoading: false,
                title: "ارسال",
                onPressed: () async {
                  await context.pushNamed(
                      Routes.familyMemeberGeneticDiseaseDataEntryView);
                },
                isEnabled: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
