import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/routing/routes.dart';

class AddCarePersonButton extends StatelessWidget {
  const AddCarePersonButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCustomButton(
      isEnabled: true,
      onPressed: () {
        context.pushNamedWithSettingRootNavigator(
          Routes.joinCareRequestView,
        );
      },
      title: 'إضافة فرد جديد +',
    );
  }
}
