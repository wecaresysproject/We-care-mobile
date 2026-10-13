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
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/online_doctor/data/models/booking_history_model.dart';
import 'package:we_care/features/online_doctor/logic/cubit/edit_booking_comment_cubit.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/booking_review_header_card.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctor_specializations_app_bar.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// أقصى طول للتعليق — نفس الحد المكتوب فى الـ API contract.
const int _maxCommentLength = 500;

/// شاشة "تعديل التعليق" — بتتفتح من "أضف تعليقك" / "تعديل تعليقك" فى شاشة
/// التفاصيل: المستخدم بيكتب تعليقه على الطبيب، ولما الـ API يأكد الحفظ
/// بترجّع الموعد بالتعليق الجديد (`BookingHistoryModel`) للشاشة اللى فتحتها.
class EditBookingCommentView extends StatelessWidget {
  const EditBookingCommentView({super.key, required this.booking});

  final BookingHistoryModel booking;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditBookingCommentCubit>(
      create: (_) => getIt<EditBookingCommentCubit>(),
      child: _EditBookingCommentBody(booking: booking),
    );
  }
}

class _EditBookingCommentBody extends StatefulWidget {
  const _EditBookingCommentBody({required this.booking});

  final BookingHistoryModel booking;

  @override
  State<_EditBookingCommentBody> createState() =>
      _EditBookingCommentBodyState();
}

class _EditBookingCommentBodyState extends State<_EditBookingCommentBody> {
  late final _commentController =
      TextEditingController(text: widget.booking.userComment);

  /// التعليق لازم يبقى مكتوب ومختلف عن المحفوظ عشان زرار الحفظ يتفعّل.
  bool get _canSave {
    final comment = _commentController.text.trim();
    return comment.isNotEmpty && comment != widget.booking.userComment;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _saveComment() {
    if (!_canSave) return;
    context.read<EditBookingCommentCubit>().saveComment(
          booking: widget.booking,
          text: _commentController.text.trim(),
        );
  }

  void _onSaveStatusChanged(
    BuildContext context,
    EditBookingCommentState state,
  ) {
    if (state.saveStatus == RequestStatus.success) {
      context.pop(result: state.commentedBooking);
    } else if (state.saveStatus == RequestStatus.failure) {
      showError(state.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.booking.userComment != null;
    final isSaving =
        context.watch<EditBookingCommentCubit>().state.saveStatus ==
            RequestStatus.loading;

    return BlocListener<EditBookingCommentCubit, EditBookingCommentState>(
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
                  title: isEditing ? "تعديل التعليق" : "إضافة تعليق",
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BookingReviewHeaderCard(booking: widget.booking),
                      verticalSpacing(24),
                      Text(
                        "تعليقك على الطبيب",
                        style: AppTextStyles.font14blackWeight400.copyWith(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: OnlineDoctorTheme.headingColor,
                        ),
                      ),
                      verticalSpacing(10),
                      TextField(
                        controller: _commentController,
                        maxLines: 6,
                        maxLength: _maxCommentLength,
                        onChanged: (_) => setState(() {}),
                        style: AppTextStyles.font14blackWeight400.copyWith(
                          fontSize: 13.sp,
                          height: 1.7,
                          color: OnlineDoctorTheme.headingColor,
                        ),
                        decoration: InputDecoration(
                          hintText: "اكتب رأيك في الطبيب وتجربتك مع الموعد...",
                          hintStyle:
                              AppTextStyles.font12blackWeight400.copyWith(
                            fontSize: 12.sp,
                            color: OnlineDoctorTheme.mutedText,
                          ),
                          filled: true,
                          fillColor: OnlineDoctorTheme.cardSurface,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 12.h,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: const BorderSide(
                              color: OnlineDoctorTheme.fieldBorder,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: const BorderSide(
                              color: OnlineDoctorTheme.fieldBorder,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              color: AppColorsManager.mainDarkBlue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
                child: AppCustomButton(
                  title: isEditing ? "حفظ التعليق" : "نشر التعليق",
                  textFontSize: 16,
                  isLoading: isSaving,
                  isEnabled: _canSave,
                  onPressed: _saveComment,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
