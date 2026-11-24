import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/online_doctor/data/models/booking_history_model.dart';
import 'package:we_care/features/online_doctor/data/models/booking_model.dart';
import 'package:we_care/features/online_doctor/logic/cubit/consultation_review_cubit.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/we_care_brand_mark.dart';

const int _maxCommentLength = 500;

/// شاشة "انتهت الاستشارة بنجاح" — بتظهر للمريض أول ما الطبيب ينهى المكالمة،
/// وبتطلب تقييم من 1 لـ 5 نجوم وتعليق. الاتنين اختياريين، و"تخطي الآن"
/// بيقفل الشاشة من غير ما يبعت حاجة.
class ConsultationReviewView extends StatelessWidget {
  const ConsultationReviewView({super.key, required this.booking});

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ConsultationReviewCubit>(
      create: (_) => getIt<ConsultationReviewCubit>(),
      child: _ConsultationReviewBody(booking: booking),
    );
  }
}

class _ConsultationReviewBody extends StatefulWidget {
  const _ConsultationReviewBody({required this.booking});

  final BookingModel booking;

  @override
  State<_ConsultationReviewBody> createState() =>
      _ConsultationReviewBodyState();
}

class _ConsultationReviewBodyState extends State<_ConsultationReviewBody> {
  final TextEditingController _commentController = TextEditingController();
  int? _selectedStars;

  String get _comment => _commentController.text.trim();

  bool get _canSubmit => _selectedStars != null || _comment.isNotEmpty;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_canSubmit) return;
    FocusScope.of(context).unfocus();
    context.read<ConsultationReviewCubit>().submitReview(
          bookingId: widget.booking.bookingId,
          stars: _selectedStars,
          comment: _comment,
        );
  }

  void _close() => Navigator.of(context).pop();

  void _onSubmitStatusChanged(
    BuildContext context,
    ConsultationReviewState state,
  ) {
    if (state.submitStatus == RequestStatus.success) {
      showSuccess("شكراً لك، تم إرسال تقييمك");
      _close();
    } else if (state.submitStatus == RequestStatus.failure) {
      showError(state.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting =
        context.watch<ConsultationReviewCubit>().state.submitStatus ==
            RequestStatus.loading;
    final type = widget.booking.type;
    final doctorName = widget.booking.doctor.name.trim();

    return BlocListener<ConsultationReviewCubit, ConsultationReviewState>(
      listenWhen: (previous, current) =>
          previous.submitStatus != current.submitStatus,
      listener: _onSubmitStatusChanged,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(12.w, 8.h, 16.w, 0),
                child: _ReviewTopBar(onClosePressed: _close),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 16.h),
                  child: Column(
                    children: [
                      const _SuccessBadge(),
                      verticalSpacing(20),
                      Text(
                        type.isExamination
                            ? "انتهى الكشف بنجاح"
                            : "انتهت الاستشارة بنجاح",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.font20blackWeight700.copyWith(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w800,
                          color: OnlineDoctorTheme.headingColor,
                        ),
                      ),
                      verticalSpacing(8),
                      Text(
                        "شكراً لاستخدامك WeCare",
                        style: AppTextStyles.font14blackWeight400.copyWith(
                          fontSize: 14.sp,
                          color: OnlineDoctorTheme.mutedText,
                        ),
                      ),
                      verticalSpacing(24),
                      const Divider(
                        height: 1,
                        color: OnlineDoctorTheme.footerDivider,
                      ),
                      verticalSpacing(24),
                      Text(
                        doctorName.isEmpty
                            ? "كيف كانت تجربتك مع الطبيب؟"
                            : "كيف كانت تجربتك مع د. $doctorName؟",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.font18blackWight500.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          color: OnlineDoctorTheme.headingColor,
                        ),
                      ),
                      verticalSpacing(8),
                      Text(
                        "يسعدنا معرفة رأيك لمساعدتنا في تحسين خدماتنا الطبية.",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.font12blackWeight400.copyWith(
                          fontSize: 12.5.sp,
                          height: 1.6,
                          color: OnlineDoctorTheme.mutedText,
                        ),
                      ),
                      verticalSpacing(18),
                      _RatingStarsPicker(
                        selectedStars: _selectedStars,
                        onStarsSelected: (stars) =>
                            setState(() => _selectedStars = stars),
                      ),
                      verticalSpacing(10),
                      _RatingHint(selectedStars: _selectedStars),
                      verticalSpacing(24),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          "أضف تعليقك (اختياري)",
                          style: AppTextStyles.font14blackWeight400.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: OnlineDoctorTheme.headingColor,
                          ),
                        ),
                      ),
                      verticalSpacing(10),
                      _CommentField(
                        controller: _commentController,
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 12.h),
                child: Column(
                  children: [
                    AppCustomButton(
                      title: "إرسال التقييم",
                      textFontSize: 16,
                      isLoading: isSubmitting,
                      isEnabled: _canSubmit,
                      onPressed: _submit,
                    ),
                    verticalSpacing(10),
                    _SkipButton(onPressed: isSubmitting ? null : _close),
                    verticalSpacing(10),
                    Text(
                      "جميع خيارات التقييم والتعليق اختيارية.",
                      style: AppTextStyles.font12blackWeight400.copyWith(
                        fontSize: 11.5.sp,
                        color: OnlineDoctorTheme.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// الشعار فى أول السطر وزرار الإغلاق فى آخره.
class _ReviewTopBar extends StatelessWidget {
  const _ReviewTopBar({required this.onClosePressed});

  final VoidCallback onClosePressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        WeCareBrandMark(width: 84.w),
        const Spacer(),
        IconButton(
          onPressed: onClosePressed,
          tooltip: "إغلاق",
          icon: Icon(
            Icons.close_rounded,
            size: 24.sp,
            color: OnlineDoctorTheme.mutedText,
          ),
        ),
      ],
    );
  }
}

/// علامة الصح الخضرا جوه دايرتين.
class _SuccessBadge extends StatelessWidget {
  const _SuccessBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104.w,
      height: 104.w,
      decoration: const BoxDecoration(
        color: AppColorsManager.homeAchievedGreenSurface,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Container(
        width: 64.w,
        height: 64.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColorsManager.doneColor, width: 3.5),
        ),
        child: Icon(
          Icons.check_rounded,
          size: 38.sp,
          color: AppColorsManager.doneColor,
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
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Icon(
                (selectedStars ?? 0) >= stars
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                size: 44.sp,
                color: (selectedStars ?? 0) >= stars
                    ? OnlineDoctorTheme.ratingAmber
                    : OnlineDoctorTheme.statsDivider,
              ),
            ),
          ),
      ],
    );
  }
}

/// تحت النجوم — التعليمات لحد ما المريض يختار، وبعدها وصف التقييم.
class _RatingHint extends StatelessWidget {
  const _RatingHint({required this.selectedStars});

  final int? selectedStars;

  @override
  Widget build(BuildContext context) {
    final stars = selectedStars;
    return Text(
      stars == null
          ? "اختر التقييم من نجمة إلى خمس نجوم"
          : "$stars / 5 · ${ratingDescription(stars.toDouble())}",
      style: AppTextStyles.font12blackWeight400.copyWith(
        fontSize: 12.sp,
        fontWeight: stars == null ? FontWeight.w500 : FontWeight.w700,
        color: stars == null
            ? OnlineDoctorTheme.mutedText
            : OnlineDoctorTheme.headingColor,
      ),
    );
  }
}

class _CommentField extends StatelessWidget {
  const _CommentField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14.r),
      borderSide: const BorderSide(color: OnlineDoctorTheme.fieldBorder),
    );
    return TextField(
      controller: controller,
      minLines: 4,
      maxLines: 6,
      maxLength: _maxCommentLength,
      onChanged: onChanged,
      style: AppTextStyles.font14blackWeight400.copyWith(
        fontSize: 13.sp,
        height: 1.7,
        color: OnlineDoctorTheme.headingColor,
      ),
      decoration: InputDecoration(
        hintText: "اكتب رأيك عن تجربتك مع الطبيب...",
        hintStyle: AppTextStyles.font12blackWeight400.copyWith(
          fontSize: 12.5.sp,
          color: OnlineDoctorTheme.mutedText,
        ),
        filled: true,
        fillColor: OnlineDoctorTheme.cardSurface,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: const BorderSide(color: AppColorsManager.mainDarkBlue),
        ),
      ),
    );
  }
}

/// زرار "تخطي الآن" — بنفس مقاس زرار الإرسال لكن بحدود بس.
class _SkipButton extends StatelessWidget {
  const _SkipButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColorsManager.mainDarkBlue,
          side: const BorderSide(color: AppColorsManager.mainDarkBlue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
        child: Text(
          "تخطي الآن",
          style: AppTextStyles.font14blackWeight400.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColorsManager.mainDarkBlue,
          ),
        ),
      ),
    );
  }
}
