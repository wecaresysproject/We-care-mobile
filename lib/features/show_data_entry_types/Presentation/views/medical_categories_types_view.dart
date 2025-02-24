import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/features/show_data_entry_types/Presentation/views/widgets/medical_categories_types_grid_view.dart';

class MedicalCategoriesTypesView extends StatelessWidget {
  const MedicalCategoriesTypesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 2.h,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomAppBarWidget(
            haveBackArrow: true,
          ),
          verticalSpacing(24),
          MedicalCategoriesTypesGridView(),
        ],
      ).paddingSymmetricHorizontal(16),
    );
  }
}
