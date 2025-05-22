import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/dental_module/dental_view/views/tooth_anatomy_view.dart';

class DentalAnatomyDiagramEntryView extends StatelessWidget {
  const DentalAnatomyDiagramEntryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Column(
          children: [
            CustomAppBarWidget(
              haveBackArrow: true,
            ).paddingSymmetricHorizontal(16),
            verticalSpacing(16),
            ToothOverlay(
              toothWithDataList: [11,18,48],
              selectedActionsList: [55],
                overlayTitle:
                    "“من فضلك اختر السن المصاب لادخال البيانات الخاصة به”",
                onTap: (tappedTooth)async {
                await  context.pushNamed(
                    Routes.dentalDataEntryView,
                  );
                }),

          ],
        ),
      ),
    );
  }
}
