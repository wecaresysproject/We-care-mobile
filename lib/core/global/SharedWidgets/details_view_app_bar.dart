import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_back_arrow.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';

class DetailsViewAppBar extends StatelessWidget {
  const DetailsViewAppBar({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Align(
          alignment: isArabic() ? Alignment.topRight : Alignment.topLeft,
          child: CustomBackArrow(),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.font20blackWeight600.copyWith(fontSize: 21.sp),
          ),
        ),
        horizontalSpacing(24.h)
      ],
    );
  }
}
