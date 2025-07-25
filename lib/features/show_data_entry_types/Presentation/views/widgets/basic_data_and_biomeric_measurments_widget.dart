import 'package:flutter/material.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/show_data_entry_types/Presentation/views/widgets/data_entry_categories_grid_view.dart';

class BasicDataAndBiometricMeasurementsCategories extends StatelessWidget {
  const BasicDataAndBiometricMeasurementsCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CategoryItem(
          title: "القياسات الحيوية",
          imagePath: "assets/images/medical_tools_img.png",
          routeName: Routes.biometricsDataEntryView,
          isActive: true,
          cornerImagePath: "assets/images/qyasat_hayawya.png",
        ),
        CategoryItem(
          title: "البيانات الاساسية",
          imagePath: "assets/images/pin_edit_icon.png",
          routeName: "basicDataEntry",
          isActive: true,
          cornerImagePath: "assets/images/basic_data.png",
        ),
      ],
    );
  }
}
