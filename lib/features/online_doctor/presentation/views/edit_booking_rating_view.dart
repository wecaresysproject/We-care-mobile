import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/online_doctor/data/models/booking_history_model.dart';
import 'package:we_care/features/online_doctor/logic/cubit/edit_booking_rating_cubit.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/booking_review_header_card.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctor_specializations_app_bar.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// شاشة "تعديل التقييم" — بتتفتح من "أضف تقييمك" / "تعديل تقييمك" فى شاشة
/// التفاصيل: المستخدم بيختار من 1 لـ 5 نجوم، ولما الـ API يأكد الحفظ بترجّع
/// الموعد بالتقييم الجديد (`BookingHistoryModel`) للشاشة اللى فتحتها.
class EditBookingRatingView extends StatelessWidget {
  const EditBookingRatingView({super.key, required this.booking});

  final BookingHistoryModel booking;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditBookingRatingCubit>(
      create: (_) => getIt<EditBookingRatingCubit>(),
      child: _EditBookingRatingBody(booking: booking),
    );
  }
}

class _EditBookingRatingBody extends StatefulWidget {
  const _EditBookingRatingBody({required this.booking});

  final BookingHistoryModel booking;

  @override
  State<_EditBookingRatingBody> createState() => _EditBookingRatingBodyState();
}

class _EditBookingRatingBodyState extends State<_EditBookingRatingBody> {
  /// التقييم بيتحفظ نجوم كاملة — التقييم الحالى بيتقرّب لأقرب نجمة.
  /// `null` يعنى المستخدم لسه مختارش (أول تقييم للموعد).
  late int? _selectedStars = widget.booking.userRating?.round();

  void _saveRating() {
    final selectedStars = _selectedStars;
    if (selectedStars == null) return;
    context.read<EditBookingRatingCubit>().saveRating(
          booking: widget.booking,
          stars: selectedStars,
        );
  }

  void _onSaveStatusChanged(
    BuildContext context,
    EditBookingRatingState state,
  ) {
    if (state.saveStatus == RequestStatus.success) {
      context.pop(result: state.ratedBooking);
    } else if (state.saveStatus == RequestStatus.failure) {
      showError(state.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedStars = _selectedStars;
    final isEditing = widget.booking.userRating != null;
    final isSaving = context.watch<EditBookingRatingCubit>().state.saveStatus ==
        RequestStatus.loading;

    return BlocListener<EditBookingRatingCubit, EditBookingRatingState>(
      listenWhen: (previous, current) =>
          previous.saveStatus != current.saveStatus,
      listener: _onSaveStatusChanged,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
                child: DoctorSpecializationsAppBar(
                  title: isEditing ? "تعديل التقييم" : "إضافة تقييم",
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 16.h),
                  child: Column(
                    children: [
                      BookingReviewHeaderCard(booking: widget.booking),
                      verticalSpacing(32),
                      Text(
                        "ما تقييمك للطبيب؟",
                        style: AppTextStyles.font16BlackSemiBold.copyWith(
                          fontWeight: FontWeight.w700,
                          color: OnlineDoctorTheme.headingColor,
                        ),
                      ),
                      verticalSpacing(16),
                      _RatingStarsPicker(
                        selectedStars: selectedStars,
                        onStarsSelected: (stars) =>
                            setState(() => _selectedStars = stars),
                      ),
                      verticalSpacing(14),
                      if (selectedStars == null)
                        Text(
                          "اضغط على النجوم لاختيار تقييمك",
                          style: AppTextStyles.font12blackWeight400.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: OnlineDoctorTheme.mutedText,
                          ),
                        )
                      else ...[
                        Text(
                          "${selectedStars.toStringAsFixed(1)} / 5",
                          style: AppTextStyles.font16BlackSemiBold.copyWith(
                            fontWeight: FontWeight.w800,
                            color: OnlineDoctorTheme.headingColor,
                          ),
                        ),
                        verticalSpacing(4),
                        Text(
                          ratingDescription(selectedStars.toDouble()),
                          style: AppTextStyles.font12blackWeight400.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: OnlineDoctorTheme.mutedText,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
                child: AppCustomButton(
                  title: "حفظ التقييم",
                  textFontSize: 16,
                  isLoading: isSaving,
                  isEnabled: selectedStars != null,
                  onPressed: _saveRating,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// صف الـ 5 نجوم — الضغط على نجمة بيختارها هى وكل اللى قبلها.
class _RatingStarsPicker extends StatelessWidget {
  const _RatingStarsPicker({
    required this.selectedStars,
    required this.onStarsSelected,
  });

  final int? selectedStars;
  final ValueChanged<int> onStarsSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var stars = 1; stars <= 5; stars++)
          GestureDetector(
            onTap: () => onStarsSelected(stars),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Icon(
                (selectedStars ?? 0) >= stars
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                size: 46.sp,
                color: OnlineDoctorTheme.ratingAmber,
              ),
            ),
          ),
      ],
    );
  }
}
