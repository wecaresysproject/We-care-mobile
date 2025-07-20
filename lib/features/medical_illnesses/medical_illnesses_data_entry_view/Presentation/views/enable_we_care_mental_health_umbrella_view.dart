import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_data_entry_view/Presentation/views/widgets/enable_dialog_for_mental_health_umbrella_widget.dart';

class EnableViewForWeCareMentalHealthUmbrella extends StatelessWidget {
  const EnableViewForWeCareMentalHealthUmbrella({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Padding(
        padding:
            EdgeInsets.fromLTRB(16.w, 30.h, 16.w, context.screenHeight * .15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomAppBarWidget(
              haveBackArrow: true,
            ),
            verticalSpacing(77.5),
            EnableMentalHealthUmbrellaDialogWidget(),
          ],
        ),
      ),
    );
  }
}
