import 'package:flutter/material.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/basic_data/presentation/views/widgets/basic_data_content_widget.dart';

class BasicDataView extends StatelessWidget {
  const BasicDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsManager.basicDataScaffoldBackground,
      body: const SafeArea(child: BasicDataContentWidget()),
    );
  }
}
