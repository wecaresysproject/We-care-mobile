import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_data_entry_view/Presentation/views/widgets/disable_dialog_for_mental_health_umbrella_widget.dart';

class DisableViewForWeCareMentalHealthUmbrella extends StatelessWidget {
  const DisableViewForWeCareMentalHealthUmbrella({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomAppBarWidget(
              haveBackArrow: true,
            ),
            verticalSpacing(100),
            DisableMentalHealthUmbrellaDialogWidget(),
          ],
        ),
      ),
    );
  }
}
