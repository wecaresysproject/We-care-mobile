import 'package:flutter/material.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';

class SubmitCareRequestButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SubmitCareRequestButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AppCustomButton(
      isEnabled: true,
      onPressed: onPressed,
      title: 'إرسال الطلب',
    );
  }
}
