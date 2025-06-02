import 'package:flutter/material.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_back_arrow.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class FamilyTreeViewCustomAppBar extends StatelessWidget {
  const FamilyTreeViewCustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Back arrow on the left
        CustomBackArrow(),

        // Manually spaced center text
        SizedBox(
          width: MediaQuery.of(context).size.width *
              0.25, // Adjust this width as needed
        ), // Adjust this width as needed
        Text(
          "شجرة العائلة",
          textAlign: TextAlign.center,
          style: AppTextStyles.font18blackWight500.copyWith(
            color: AppColorsManager.textColor,
          ),
        ),

        // Spacer to push the row to the right end
        Spacer(),
      ],
    );
  }
}
