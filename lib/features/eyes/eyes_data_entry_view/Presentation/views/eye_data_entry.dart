import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/Presentation/eye_data_entry_form_fields_widget.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/Presentation/views/eye_procedures_and_syptoms_data_entry.dart';

class EyeDataEntry extends StatelessWidget {
  const EyeDataEntry({super.key, required this.selectedSyptoms});
  final List<SymptomItem> selectedSyptoms;
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
              EyeDataEntryFormFields(
                selectedSyptoms: selectedSyptoms,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
