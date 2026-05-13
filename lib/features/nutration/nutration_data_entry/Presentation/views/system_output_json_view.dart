import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/nutration/nutration_data_entry/logic/deep_seek_services.dart';

class SystemOutputJsonResponseView extends StatelessWidget {
  const SystemOutputJsonResponseView({super.key});

  @override
  Widget build(BuildContext context) {
    final jsonResponse =
        DeepSeekService.systemOutputJsonResponse ?? "No data available";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DeepSeek Output JSON',
          style: AppTextStyles.font18blackWight500.copyWith(
            color: AppColorsManager.mainDarkBlue,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColorsManager.mainDarkBlue),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy, color: AppColorsManager.mainDarkBlue),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: jsonResponse));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copied to clipboard')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Response:',
              style: AppTextStyles.font16BlackSemiBold,
            ),
            verticalSpacing(10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: SelectableText(
                jsonResponse,
                textDirection: TextDirection.ltr, // 👈 أهم سطر
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
