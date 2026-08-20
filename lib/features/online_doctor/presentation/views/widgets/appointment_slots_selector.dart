import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_care/core/global/Helpers/font_weight_helper.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/online_doctor/data/models/appointment_slot_model.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/appointment_slot_card.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/booking_glass_card.dart';

/// اختيار الميعاد على مرحلتين — صف الأيام فوق (3 كروت ظاهرة وسهمين
/// للتنقل)، ولما المستخدم يختار يوم توقيتاته بتظهر تحته.
class AppointmentSlotsSelector extends StatefulWidget {
  const AppointmentSlotsSelector({
    super.key,
    required this.days,
    required this.selectedDayIndex,
    required this.selectedTimeIndex,
    required this.onDaySelected,
    required this.onTimeSelected,
  });

  final List<AppointmentDayModel> days;

  final int selectedDayIndex;

  /// `null` يعنى المستخدم لسه مختارش توقيت من اليوم المختار.
  final int? selectedTimeIndex;

  final ValueChanged<int> onDaySelected;
  final ValueChanged<int> onTimeSelected;

  @override
  State<AppointmentSlotsSelector> createState() =>
      _AppointmentSlotsSelectorState();
}

class _AppointmentSlotsSelectorState extends State<AppointmentSlotsSelector> {
  final _daysController = ScrollController();

  /// عرض كارت اليوم + المسافة اللى بعده.
  double get _stepExtent => 90.w + 16.w;

  @override
  void dispose() {
    _daysController.dispose();
    super.dispose();
  }

  void _scrollDaysBy(double delta) {
    if (!_daysController.hasClients) return;
    final target = (_daysController.offset + delta).clamp(
      _daysController.position.minScrollExtent,
      _daysController.position.maxScrollExtent,
    );
    _daysController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedDay = widget.days[widget.selectedDayIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _DaysArrow(
              pointsForward: false,
              onTap: () => _scrollDaysBy(-_stepExtent),
            ),
            SizedBox(
              // 3 كروت × 90 + مسافتين × 16 — نفس عرض التصميم.
              width: 90.w * 3 + 16.w * 2,
              child: SingleChildScrollView(
                controller: _daysController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    for (var index = 0;
                        index < widget.days.length;
                        index++) ...[
                      if (index != 0) horizontalSpacing(16),
                      SizedBox(
                        width: 90.w,
                        child: _DayCard(
                          day: widget.days[index],
                          isSelected: widget.selectedDayIndex == index,
                          onTap: () => widget.onDaySelected(index),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            _DaysArrow(
              pointsForward: true,
              onTap: () => _scrollDaysBy(_stepExtent),
            ),
          ],
        ),
        verticalSpacing(16),
        // مفتاح باسم اليوم — عشان لما اليوم يتغير الصف يترسم من أوله
        // ويرجع لأول توقيت بدل ما يفضل على سحبة اليوم القديم.
        SingleChildScrollView(
          key: ValueKey(widget.selectedDayIndex),
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              for (var index = 0;
                  index < selectedDay.slots.length;
                  index++) ...[
                if (index != 0) horizontalSpacing(16),
                AppointmentSlotCard(
                  slot: selectedDay.slots[index],
                  isSelected: widget.selectedTimeIndex == index,
                  onTap: () => widget.onTimeSelected(index),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// كارت يوم فى الصف العلوى — بنفس الكارت الزجاجى بتاع باقى الشاشة.
class _DayCard extends StatelessWidget {
  const _DayCard({
    required this.day,
    required this.isSelected,
    required this.onTap,
  });

  final AppointmentDayModel day;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BookingGlassCard(
      height: 54,
      borderRadius: 12,
      isSelected: isSelected,
      hasShadowWhenSelected: true,
      onTap: onTap,
      child: day.isToday
          ? Text(
              day.dayLabel,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeightHelper.medium,
                fontFamily: AppStrings.cairoFontFamily,
                color: AppColorsManager.mainDarkBlue,
                height: 20 / 16,
                letterSpacing: 0.16,
              ),
            )
          : Text(
              "${day.dayLabel}\n${day.dateLabel}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeightHelper.semiBold,
                fontFamily: AppStrings.cairoFontFamily,
                color: AppColorsManager.mainDarkBlue,
                height: 17 / 13,
              ),
            ),
    );
  }
}

class _DaysArrow extends StatelessWidget {
  const _DaysArrow({required this.pointsForward, required this.onTap});

  /// السهم اللى على شمال الشاشة بيروح للأيام الأبعد، واللى على اليمين بيرجع.
  final bool pointsForward;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Transform.flip(
        flipX: pointsForward,
        child: SvgPicture.asset(
          "assets/svgs/booking_slot_arrow.svg",
          width: 14.w,
          height: 28.h,
        ),
      ),
    );
  }
}
