import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/font_weight_helper.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/booking_glass_card.dart';

/// عرض كارت المدة — مظبوط بحيث يظهر جزء من الكارت الخامس
/// فيبان إن الصف بيتسحب لمدد أكتر.
const double _durationCardWidth = 64;

/// صف المدد اللى الطبيب هيقدر يشوف فيها بيانات المريض —
/// بيتسحب أفقيًا لأن المدد أكتر من اللى بيوصل فى عرض الشاشة.
class DataAccessDurationSelector extends StatelessWidget {
  const DataAccessDurationSelector({
    super.key,
    required this.durations,
    required this.selectedIndex,
    required this.onDurationSelected,
  });

  final List<String> durations;

  /// `null` يعنى المستخدم لسه مختارش مدة.
  final int? selectedIndex;

  final ValueChanged<int> onDurationSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (var index = 0; index < durations.length; index++) ...[
            if (index != 0) horizontalSpacing(16),
            SizedBox(
              width: _durationCardWidth.w,
              child: BookingGlassCard(
                height: 54,
                borderRadius: 12,
                isSelected: selectedIndex == index,
                hasShadowWhenSelected: true,
                onTap: () => onDurationSelected(index),
                child: _DurationLabel(duration: durations[index]),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DurationLabel extends StatelessWidget {
  const _DurationLabel({required this.duration});

  final String duration;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeightHelper.medium,
      fontFamily: AppStrings.cairoFontFamily,
      color: AppColorsManager.textColor,
      height: 17 / 12,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("لمدة", style: style),
        verticalSpacing(2),
        // المدد الطويلة زى "12 ساعة" بتتصغّر بدل ما تعمل overflow.
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(duration, style: style, maxLines: 1),
          ),
        ),
      ],
    );
  }
}
