import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/Database/cach_helper.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_back_arrow.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/allowed_care_access/data/models/search_phone_number_response.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/selected_user_card.dart';
import 'package:we_care/features/online_doctor/data/models/appointment_room_model.dart';
import 'package:we_care/features/online_doctor/data/models/booking_model.dart';
import 'package:we_care/features/online_doctor/logic/cubit/appointment_room_cubit.dart';
import 'package:we_care/features/online_doctor/logic/cubit/participant_search_cubit.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/booking_type_badge.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// شاشة غرفة الكشف — بتتفتح من زرار "دخول عند الطبيب" فى كارت الحجز:
/// ملخص الطبيب والموعد، زرار الدخول للمكالمة (بيتفعل فى وقت الموعد)،
/// إدارة المشاركين فى المحادثة، أسئلة المستخدم للطبيب، وتنويهات مهمة.
class ExaminationRoomView extends StatelessWidget {
  const ExaminationRoomView({super.key, required this.booking});

  /// الحجز اللى اتفتحت منه الشاشة — بيتعرض على طول لحد ما بيانات الغرفة
  /// (المشاركين والأسئلة) توصل من الـ API.
  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppointmentRoomCubit>(
      create: (_) =>
          getIt<AppointmentRoomCubit>()..getAppointmentRoom(booking.bookingId),
      child: _ExaminationRoomBody(booking: booking),
    );
  }
}

class _ExaminationRoomBody extends StatefulWidget {
  const _ExaminationRoomBody({required this.booking});

  final BookingModel booking;

  @override
  State<_ExaminationRoomBody> createState() => _ExaminationRoomBodyState();
}

class _ExaminationRoomBodyState extends State<_ExaminationRoomBody> {
  /// نسخة الشاشة من الحجز — بتتحدث لما بيانات الغرفة توصل.
  late BookingModel _booking = widget.booking;

  /// أقصى عدد مشاركين غير المريض فى محادثة الكشف.
  int _maxParticipants = AppointmentRoomModel.defaultMaxParticipants;

  /// "عرض جميع الأسئلة" — القايمة بتعرض أول 3 بس لحد ما المستخدم يفردها.
  bool _showAllQuestions = false;

  String get _typeName => _booking.type.shortName;

  void _onRoomStateChanged(BuildContext context, AppointmentRoomState state) {
    final room = state.room;
    if (state.requestStatus == RequestStatus.success && room != null) {
      setState(() {
        _booking = room.booking;
        _maxParticipants = room.maxParticipants;
      });
    } else if (state.requestStatus == RequestStatus.failure) {
      showError(state.errorMessage);
    }
  }

  Future<void> _onEnterRoomPressed() async {
    //! bypass مؤقت لتجربة مكالمة الفيديو — فى الـ debug الدخول متاح قبل
    //! الموعد. يتشال بعد ما التجربة تخلص.
    if (kDebugMode || _booking.isTimeNow(DateTime.now())) {
      await context.pushNamed(
        Routes.examinationCallView,
        arguments: _booking,
      );
      return;
    }
    _showMessage("يمكنك الدخول عند حلول موعد $_typeName");
  }

  Future<void> _onAddParticipantPressed() async {
    final cubit = context.read<AppointmentRoomCubit>();
    if (cubit.state.participants.length >= _maxParticipants) {
      _showMessage("لا يمكن إضافة أكثر من $_maxParticipants مشاركين");
      return;
    }
    final newParticipant = await showDialog<_NewParticipant>(
      context: context,
      barrierColor: Colors.white.withValues(alpha: 0.4),
      builder: (_) => BlocProvider<ParticipantSearchCubit>(
        create: (_) => getIt<ParticipantSearchCubit>(),
        child: _AddParticipantDialog(
          addedUserIds: {
            for (final participant in cubit.state.participants)
              participant.userId,
          },
        ),
      ),
    );
    if (newParticipant == null || !mounted) return;
    cubit.addParticipant(
      user: newParticipant.user,
      relation: newParticipant.relation,
    );
  }

  Future<void> _onRemoveParticipant(RoomParticipantModel participant) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.white.withValues(alpha: 0.4),
      builder: (dialogContext) => _RoomDialogShell(
        icon: Icons.person_remove_rounded,
        iconColor: OnlineDoctorTheme.countdownAmber,
        iconSurface: OnlineDoctorTheme.countdownSurface,
        title: "إزالة مشارك",
        confirmLabel: "إزالة",
        onConfirmPressed: () => Navigator.of(dialogContext).pop(true),
        child: Text(
          "هل تريد إزالة ${participant.name} من محادثة $_typeName؟",
          textAlign: TextAlign.center,
          style: AppTextStyles.font14blackWeight400.copyWith(
            fontSize: 13.sp,
            height: 1.6,
            color: OnlineDoctorTheme.sectionBodyText,
          ),
        ),
      ),
    );
    if (confirmed != true || !mounted) return;
    context.read<AppointmentRoomCubit>().removeParticipant(participant);
  }

  void _onParticipantStateChanged(
    BuildContext context,
    AppointmentRoomState state,
  ) {
    if (state.participantRequestStatus == RequestStatus.success) {
      showSuccess(state.participantMessage);
    } else if (state.participantRequestStatus == RequestStatus.failure) {
      showError(state.participantMessage);
    }
  }

  Future<void> _onAddQuestionPressed() async {
    final question = await _showQuestionDialog();
    if (question == null || !mounted) return;
    context.read<AppointmentRoomCubit>().addQuestion(question);
  }

  Future<void> _onEditQuestion(int index) async {
    final cubit = context.read<AppointmentRoomCubit>();
    final current = cubit.state.questions[index];
    final question = await _showQuestionDialog(initialText: current.text);
    if (question == null || question == current.text || !mounted) return;
    cubit.editQuestion(question: current, text: question);
  }

  void _onDeleteQuestion(int index) {
    final cubit = context.read<AppointmentRoomCubit>();
    cubit.deleteQuestion(cubit.state.questions[index]);
  }

  void _onQuestionStateChanged(
    BuildContext context,
    AppointmentRoomState state,
  ) {
    if (state.questionRequestStatus == RequestStatus.failure) {
      showError(state.questionErrorMessage);
    }
  }

  Future<String?> _showQuestionDialog({String? initialText}) {
    return showDialog<String>(
      context: context,
      barrierColor: Colors.white.withValues(alpha: 0.4),
      builder: (_) => _QuestionDialog(initialText: initialText),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColorsManager.mainDarkBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.font14whiteWeight600.copyWith(
              fontSize: 12.5.sp,
            ),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final roomState = context.watch<AppointmentRoomCubit>().state;
    final isLoading = roomState.requestStatus == RequestStatus.loading;
    final isSavingQuestion =
        roomState.questionRequestStatus == RequestStatus.loading;
    final isSavingParticipant =
        roomState.participantRequestStatus == RequestStatus.loading;

    return MultiBlocListener(
      listeners: [
        BlocListener<AppointmentRoomCubit, AppointmentRoomState>(
          listenWhen: (previous, current) =>
              previous.requestStatus != current.requestStatus,
          listener: _onRoomStateChanged,
        ),
        BlocListener<AppointmentRoomCubit, AppointmentRoomState>(
          listenWhen: (previous, current) =>
              previous.questionRequestStatus != current.questionRequestStatus,
          listener: _onQuestionStateChanged,
        ),
        BlocListener<AppointmentRoomCubit, AppointmentRoomState>(
          listenWhen: (previous, current) =>
              previous.participantRequestStatus !=
              current.participantRequestStatus,
          listener: _onParticipantStateChanged,
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
                child: _ExaminationRoomAppBar(typeName: _typeName),
              ),
              verticalSpacing(12),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                  children: [
                    _DoctorSummaryCard(booking: _booking),
                    verticalSpacing(14),
                    _EnterRoomCard(
                      booking: _booking,
                      onEnterPressed: _onEnterRoomPressed,
                    ),
                    verticalSpacing(14),
                    if (isLoading)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 32.h),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColorsManager.mainDarkBlue,
                          ),
                        ),
                      )
                    else ...[
                      // طلب واحد على المشاركين فى المرة — القسم بيتقفل لحد
                      // ما الـ API يرد.
                      AbsorbPointer(
                        absorbing: isSavingParticipant,
                        child: AnimatedOpacity(
                          opacity: isSavingParticipant ? 0.5 : 1,
                          duration: const Duration(milliseconds: 150),
                          child: _ParticipantsSection(
                            typeName: _typeName,
                            participants: roomState.participants,
                            maxParticipants: _maxParticipants,
                            onAddPressed: _onAddParticipantPressed,
                            onRemovePressed: _onRemoveParticipant,
                          ),
                        ),
                      ),
                      verticalSpacing(14),
                      // طلب واحد على الأسئلة فى المرة — القسم بيتقفل لحد
                      // ما الـ API يرد.
                      AbsorbPointer(
                        absorbing: isSavingQuestion,
                        child: AnimatedOpacity(
                          opacity: isSavingQuestion ? 0.5 : 1,
                          duration: const Duration(milliseconds: 150),
                          child: _QuestionsSection(
                            typeName: _typeName,
                            questions: [
                              for (final question in roomState.questions)
                                question.text,
                            ],
                            showAll: _showAllQuestions,
                            onToggleShowAll: () => setState(
                              () => _showAllQuestions = !_showAllQuestions,
                            ),
                            onAddPressed: _onAddQuestionPressed,
                            onEditPressed: _onEditQuestion,
                            onDeletePressed: _onDeleteQuestion,
                          ),
                        ),
                      ),
                    ],
                    verticalSpacing(14),
                    _ImportantNotesCard(typeName: _typeName),
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

/// سهم رجوع، "الكشف" وتحتها "اجتماعك الطبى مع الطبيب"، وأيقونة استفهام فى النهاية.
class _ExaminationRoomAppBar extends StatelessWidget {
  const _ExaminationRoomAppBar({required this.typeName});

  final String typeName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CustomBackArrow(),
        Expanded(
          child: Column(
            children: [
              Text(
                typeName,
                textAlign: TextAlign.center,
                style: AppTextStyles.font20blackWeight600.copyWith(
                  fontSize: 19.sp,
                  color: Colors.black,
                ),
              ),
              Text(
                "اجتماعك الطبي مع الطبيب",
                textAlign: TextAlign.center,
                style: AppTextStyles.font12blackWeight400.copyWith(
                  fontSize: 11.5.sp,
                  color: OnlineDoctorTheme.mutedText,
                ),
              ),
            ],
          ),
        ),
        // أيقونة الاستفهام زى التصميم — شكلية لحد ما محتوى المساعدة يتحدد.
        Container(
          width: 34.w,
          height: 34.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border:
                Border.all(color: AppColorsManager.mainDarkBlue, width: 1.5),
          ),
          child: Icon(
            Icons.question_mark_rounded,
            size: 16.sp,
            color: AppColorsManager.mainDarkBlue,
          ),
        ),
      ],
    );
  }
}

/// كارت ملخص الطبيب والموعد — بيانات الطبيب فى البداية، وفى النهاية
/// بادچ النوع والتاريخ والوقت وحالة الموعد.
class _DoctorSummaryCard extends StatelessWidget {
  const _DoctorSummaryCard({required this.booking});

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    final doctor = booking.doctor;
    final mutedStyle = AppTextStyles.font12blackWeight400.copyWith(
      fontSize: 11.5.sp,
      height: 1.5,
      color: OnlineDoctorTheme.mutedText,
    );

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: OnlineDoctorTheme.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColorsManager.mainDarkBlue.withAlpha(10),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DoctorAvatar(
                    imageUrl: doctor.imageUrl,
                    isOnline: doctor.isOnline,
                  ),
                  horizontalSpacing(10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            doctor.name,
                            maxLines: 1,
                            style: AppTextStyles.font16BlackSemiBold.copyWith(
                              fontSize: 14.5.sp,
                              fontWeight: FontWeight.w700,
                              color: OnlineDoctorTheme.headingColor,
                            ),
                          ),
                        ),
                        verticalSpacing(4),
                        Text(
                          doctor.specialization,
                          maxLines: 1,
                          style: AppTextStyles.font14blackWeight400.copyWith(
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w700,
                            color: OnlineDoctorTheme.accentBlue,
                          ),
                        ),
                        verticalSpacing(5),
                        Text(
                          doctor.academicTitle,
                          maxLines: 1,
                          style: mutedStyle,
                        ),
                        verticalSpacing(3),
                        Text(
                          doctor.hospital,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: mutedStyle,
                        ),
                        verticalSpacing(6),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 12.sp,
                              color: OnlineDoctorTheme.mutedText,
                            ),
                            horizontalSpacing(3),
                            Flexible(
                              child: Text(
                                doctor.location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: mutedStyle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
              color: OnlineDoctorTheme.cardBorder,
            ),
            SizedBox(
              width: 118.w,
              child: _AppointmentSummaryBlock(booking: booking),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoctorAvatar extends StatelessWidget {
  const _DoctorAvatar({required this.imageUrl, required this.isOnline});

  final String imageUrl;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72.w,
      height: 72.w,
      child: Stack(
        children: [
          ClipOval(
            child: SizedBox.expand(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: OnlineDoctorTheme.cardSurface,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 16.w,
                    height: 16.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColorsManager.mainDarkBlue.withAlpha(120),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: OnlineDoctorTheme.cardSurface,
                  padding: EdgeInsets.all(10.w),
                  child: Image.asset(
                    "assets/images/doctor_or_specialist.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          if (isOnline)
            PositionedDirectional(
              bottom: 2.w,
              end: 4.w,
              child: Container(
                width: 14.w,
                height: 14.w,
                decoration: BoxDecoration(
                  color: OnlineDoctorTheme.onlineGreen,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// بادچ النوع والتاريخ والوقت وتحتهم "حالة الكشف" — "مجدول" أو "حان الوقت".
class _AppointmentSummaryBlock extends StatelessWidget {
  const _AppointmentSummaryBlock({required this.booking});

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    final isTimeNow = booking.isTimeNow(DateTime.now());
    final detailStyle = AppTextStyles.font12blackWeight400.copyWith(
      fontSize: 10.sp,
      fontWeight: FontWeight.w600,
      height: 1.5,
      color: OnlineDoctorTheme.headingColor,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: BookingTypeBadge(type: booking.type, isTimeNow: false),
        ),
        verticalSpacing(10),
        Row(
          children: [
            Image.asset(
              "assets/images/calender_icon.png",
              width: 13.w,
              height: 13.w,
              fit: BoxFit.contain,
            ),
            horizontalSpacing(5),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  booking.dateLabel,
                  maxLines: 1,
                  style: detailStyle,
                ),
              ),
            ),
          ],
        ),
        verticalSpacing(6),
        Row(
          children: [
            Icon(
              Icons.access_time_rounded,
              size: 13.sp,
              color: AppColorsManager.mainDarkBlue,
            ),
            horizontalSpacing(5),
            Text(booking.timeLabel, style: detailStyle),
          ],
        ),
        verticalSpacing(8),
        Container(height: 1, color: OnlineDoctorTheme.cardBorder),
        verticalSpacing(8),
        Text(
          "حالة ${booking.type.shortName}",
          style: detailStyle.copyWith(color: OnlineDoctorTheme.mutedText),
        ),
        verticalSpacing(5),
        _StatusBadge(isTimeNow: isTimeNow),
      ],
    );
  }
}

/// بادچ حالة الموعد — أخضر "مجدول" قبل الموعد، وأصفر "حان الوقت" فى وقته.
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isTimeNow});

  final bool isTimeNow;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isTimeNow
        ? OnlineDoctorTheme.countdownSurface
        : OnlineDoctorTheme.consultationSurface;
    final contentColor = isTimeNow
        ? OnlineDoctorTheme.countdownAmber
        : OnlineDoctorTheme.consultationGreen;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isTimeNow
                ? Icons.play_circle_outline_rounded
                : Icons.check_circle_outline_rounded,
            size: 13.sp,
            color: contentColor,
          ),
          horizontalSpacing(4),
          Text(
            isTimeNow ? "حان الوقت" : "مجدول",
            style: AppTextStyles.font12blackWeight400.copyWith(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: contentColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// كارت "جاهز للدخول إلى الكشف" — أيقونة الكاميرا وزرار الدخول
/// وتنويه إن الدخول بيتفعل عند حلول الموعد.
class _EnterRoomCard extends StatelessWidget {
  const _EnterRoomCard({required this.booking, required this.onEnterPressed});

  final BookingModel booking;
  final VoidCallback onEnterPressed;

  @override
  Widget build(BuildContext context) {
    final typeName = booking.type.shortName;
    final accentColor = booking.type.isExamination
        ? AppColorsManager.mainDarkBlue
        : OnlineDoctorTheme.consultationGreen;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: OnlineDoctorTheme.bookingSurface,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 64.w,
                height: 64.w,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.videocam_rounded,
                  size: 30.sp,
                  color: OnlineDoctorTheme.accentBlue,
                ),
              ),
              horizontalSpacing(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "جاهز للدخول إلى $typeName",
                      style: AppTextStyles.font16BlackSemiBold.copyWith(
                        fontWeight: FontWeight.w700,
                        color: OnlineDoctorTheme.headingColor,
                      ),
                    ),
                    verticalSpacing(5),
                    Text(
                      "اضغط على الزر للدخول إلى غرفة $typeName "
                      "والتواصل مع الطبيب",
                      style: AppTextStyles.font12blackWeight400.copyWith(
                        fontSize: 11.5.sp,
                        height: 1.5,
                        color: OnlineDoctorTheme.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          verticalSpacing(14),
          Material(
            color: accentColor,
            borderRadius: BorderRadius.circular(12.r),
            child: InkWell(
              onTap: onEnterPressed,
              borderRadius: BorderRadius.circular(12.r),
              child: SizedBox(
                height: 48.h,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.videocam_rounded,
                      size: 18.sp,
                      color: Colors.white,
                    ),
                    horizontalSpacing(8),
                    Text(
                      "دخول إلى $typeName",
                      style: AppTextStyles.font14whiteWeight600.copyWith(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          verticalSpacing(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 13.sp,
                color: OnlineDoctorTheme.mutedText,
              ),
              horizontalSpacing(5),
              Text(
                "يمكنك الدخول عند حلول موعد $typeName",
                style: AppTextStyles.font12blackWeight400.copyWith(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: OnlineDoctorTheme.mutedText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// قسم "المشاركون فى الكشف" — كارت المريض الأساسى وكروت المشاركين
/// وزرار الإضافة المتقطع، بحد أقصى 3 مشاركين.
class _ParticipantsSection extends StatelessWidget {
  const _ParticipantsSection({
    required this.typeName,
    required this.participants,
    required this.maxParticipants,
    required this.onAddPressed,
    required this.onRemovePressed,
  });

  final String typeName;
  final List<RoomParticipantModel> participants;
  final int maxParticipants;
  final VoidCallback onAddPressed;
  final void Function(RoomParticipantModel participant) onRemovePressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: OnlineDoctorTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: const BoxDecoration(
                  color: OnlineDoctorTheme.iconTint,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.group_rounded,
                  size: 18.sp,
                  color: OnlineDoctorTheme.accentBlue,
                ),
              ),
              horizontalSpacing(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "المشاركون في $typeName",
                      style: AppTextStyles.font16BlackSemiBold.copyWith(
                        fontWeight: FontWeight.w700,
                        color: OnlineDoctorTheme.headingColor,
                      ),
                    ),
                    verticalSpacing(3),
                    Text(
                      "يمكنك إضافة حتى $maxParticipants أشخاص "
                      "للمشاركة في محادثة $typeName",
                      style: AppTextStyles.font12blackWeight400.copyWith(
                        fontSize: 11.sp,
                        color: OnlineDoctorTheme.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          verticalSpacing(12),
          // الأربع كروت جنب بعض بعرض وارتفاع متساويين زى التصميم —
          // IntrinsicHeight عشان stretch تشتغل جوه ListView غير محدود الارتفاع.
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Expanded(child: _PatientCard()),
                for (final participant in participants) ...[
                  horizontalSpacing(7),
                  Expanded(
                    child: _ParticipantCard(
                      participant: participant,
                      onRemovePressed: () => onRemovePressed(participant),
                    ),
                  ),
                ],
              ],
            ),
          ),
          verticalSpacing(12),
          _AddParticipantButton(
            label: "إضافة مشارك\n(${participants.length}/$maxParticipants)",
            onPressed: onAddPressed,
          ),
          verticalSpacing(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_rounded,
                size: 13.sp,
                color: OnlineDoctorTheme.mutedText,
              ),
              horizontalSpacing(5),
              Flexible(
                child: Text(
                  "سيصل للمشاركين إشعار بموعد $typeName ورابط الدخول",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font12blackWeight400.copyWith(
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w600,
                    color: OnlineDoctorTheme.mutedText,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// كارت "أنت" — المريض صاحب الحجز، ومعلم عليه "الأساسى".
class _PatientCard extends StatefulWidget {
  const _PatientCard();

  @override
  State<_PatientCard> createState() => _PatientCardState();
}

class _PatientCardState extends State<_PatientCard> {
  /// صورة المستخدم المحفوظة من البيانات الأساسية — من غيرها بيظهر أول حرف.
  String? _patientImageUrl;

  @override
  void initState() {
    super.initState();
    _loadPatientImage();
  }

  Future<void> _loadPatientImage() async {
    final photo = await CacheHelper.getString("userPhoto");
    if (!mounted || photo.trim().isEmpty) return;
    setState(() => _patientImageUrl = photo);
  }

  @override
  Widget build(BuildContext context) {
    return _PersonCardShell(
      avatar: _PersonAvatar(
        name: "أنت",
        imageUrl: _patientImageUrl,
        showOnlineDot: true,
      ),
      name: "أنت",
      relation: "المريض",
      badge: const _PersonBadge(
        label: "الأساسي",
        backgroundColor: OnlineDoctorTheme.iconTint,
        contentColor: OnlineDoctorTheme.accentBlue,
      ),
    );
  }
}

/// كارت مشارك — صورة واسم وصلة قرابة وبادچ "مشارك"، وزرار X لإزالته.
class _ParticipantCard extends StatelessWidget {
  const _ParticipantCard({
    required this.participant,
    required this.onRemovePressed,
  });

  final RoomParticipantModel participant;
  final VoidCallback onRemovePressed;

  @override
  Widget build(BuildContext context) {
    return _PersonCardShell(
      avatar: _PersonAvatar(
        name: participant.name,
        imageUrl: participant.imageUrl,
      ),
      name: participant.name,
      relation: participant.relation,
      badge: const _PersonBadge(
        label: "مشارك",
        backgroundColor: OnlineDoctorTheme.consultationSurface,
        contentColor: OnlineDoctorTheme.consultationGreen,
      ),
      onRemovePressed: onRemovePressed,
    );
  }
}

/// جسم كارت الشخص المشترك بين "أنت" والمشاركين — كارت أبيض بظل خفيف
/// وزرار X فى ركنه العلوى زى التصميم.
class _PersonCardShell extends StatelessWidget {
  const _PersonCardShell({
    required this.avatar,
    required this.name,
    required this.relation,
    required this.badge,
    this.onRemovePressed,
  });

  final Widget avatar;
  final String name;
  final String relation;
  final Widget badge;
  final VoidCallback? onRemovePressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: OnlineDoctorTheme.cardBorder),
            boxShadow: [
              BoxShadow(
                color: AppColorsManager.mainDarkBlue.withAlpha(10),
                offset: const Offset(0, 3),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              avatar,
              verticalSpacing(8),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  name,
                  maxLines: 1,
                  style: AppTextStyles.font14blackWeight400.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    color: OnlineDoctorTheme.headingColor,
                  ),
                ),
              ),
              verticalSpacing(2),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  relation,
                  maxLines: 1,
                  style: AppTextStyles.font12blackWeight400.copyWith(
                    fontSize: 10.5.sp,
                    color: OnlineDoctorTheme.mutedText,
                  ),
                ),
              ),
              verticalSpacing(7),
              badge,
            ],
          ),
        ),
        if (onRemovePressed != null)
          PositionedDirectional(
            top: 5.h,
            end: 5.w,
            child: InkWell(
              onTap: onRemovePressed,
              customBorder: const CircleBorder(),
              child: Container(
                width: 22.w,
                height: 22.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: OnlineDoctorTheme.fieldBorder),
                  boxShadow: [
                    BoxShadow(
                      color: AppColorsManager.mainDarkBlue.withAlpha(20),
                      offset: const Offset(0, 1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 14.sp,
                  color: OnlineDoctorTheme.headingColor,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// أفاتار الشخص — صورته لو موجودة، وإلا أول حرف من اسمه على خلفية زرقا فاتحة.
class _PersonAvatar extends StatelessWidget {
  const _PersonAvatar({
    required this.name,
    this.imageUrl,
    this.showOnlineDot = false,
  });

  final String name;
  final String? imageUrl;
  final bool showOnlineDot;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 54.w,
      height: 54.w,
      child: Stack(
        children: [
          ClipOval(
            child: SizedBox.expand(
              child: imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: OnlineDoctorTheme.cardSurface,
                      ),
                      errorWidget: (context, url, error) =>
                          _InitialFallback(name: name),
                    )
                  : _InitialFallback(name: name),
            ),
          ),
          if (showOnlineDot)
            PositionedDirectional(
              bottom: 0,
              end: 2.w,
              child: Container(
                width: 13.w,
                height: 13.w,
                decoration: BoxDecoration(
                  color: OnlineDoctorTheme.onlineGreen,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _InitialFallback extends StatelessWidget {
  const _InitialFallback({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: OnlineDoctorTheme.iconTint,
      child: Text(
        name.characters.first,
        style: AppTextStyles.font16BlackSemiBold.copyWith(
          fontWeight: FontWeight.w700,
          color: OnlineDoctorTheme.headingColor,
        ),
      ),
    );
  }
}

class _PersonBadge extends StatelessWidget {
  const _PersonBadge({
    required this.label,
    required this.backgroundColor,
    required this.contentColor,
  });

  final String label;
  final Color backgroundColor;
  final Color contentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: AppTextStyles.font12blackWeight400.copyWith(
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          color: contentColor,
        ),
      ),
    );
  }
}

/// زرار "إضافة مشارك" بحدود متقطعة على عرض الكارت كله.
class _AddParticipantButton extends StatelessWidget {
  const _AddParticipantButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(14.r),
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: OnlineDoctorTheme.accentBlue.withAlpha(120),
          radius: 14.r,
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            color: OnlineDoctorTheme.cardSurface,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_add_alt_1_rounded,
                size: 22.sp,
                color: OnlineDoctorTheme.accentBlue,
              ),
              horizontalSpacing(8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppTextStyles.font14blackWeight400.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                  color: OnlineDoctorTheme.accentBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// راسم الحدود المتقطعة لزرار الإضافة — مفيش package للـ dashed border.
class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(radius),
        ),
      );

    const dashLength = 6.0;
    const gapLength = 4.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashLength),
          paint,
        );
        distance += dashLength + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}

/// قسم "أسئلتى للطبيب" — قايمة مرقمة بأول 3 أسئلة مع فرد الباقى،
/// وإضافة وتعديل وحذف الأسئلة.
class _QuestionsSection extends StatelessWidget {
  const _QuestionsSection({
    required this.typeName,
    required this.questions,
    required this.showAll,
    required this.onToggleShowAll,
    required this.onAddPressed,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  /// عدد الأسئلة الظاهرة قبل "عرض جميع الأسئلة".
  static const int collapsedCount = 3;

  final String typeName;
  final List<String> questions;
  final bool showAll;
  final VoidCallback onToggleShowAll;
  final VoidCallback onAddPressed;
  final void Function(int index) onEditPressed;
  final void Function(int index) onDeletePressed;

  @override
  Widget build(BuildContext context) {
    final visibleCount =
        showAll ? questions.length : questions.length.clamp(0, collapsedCount);

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: OnlineDoctorTheme.questionsSurface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: OnlineDoctorTheme.questionsBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34.w,
                height: 34.w,
                decoration: const BoxDecoration(
                  color: OnlineDoctorTheme.countdownSurface,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.question_mark_rounded,
                  size: 16.sp,
                  color: OnlineDoctorTheme.countdownAmber,
                ),
              ),
              horizontalSpacing(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "أسئلتي للطبيب",
                      style: AppTextStyles.font16BlackSemiBold.copyWith(
                        fontWeight: FontWeight.w700,
                        color: OnlineDoctorTheme.headingColor,
                      ),
                    ),
                    verticalSpacing(3),
                    Text(
                      "اكتب أسئلتك التي تريد مناقشتها مع الطبيب "
                      "أثناء $typeName.",
                      style: AppTextStyles.font12blackWeight400.copyWith(
                        fontSize: 11.sp,
                        color: OnlineDoctorTheme.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
              horizontalSpacing(8),
              _AddQuestionButton(onPressed: onAddPressed),
            ],
          ),
          verticalSpacing(12),
          for (var i = 0; i < visibleCount; i++) ...[
            _QuestionTile(
              index: i,
              question: questions[i],
              onEditPressed: () => onEditPressed(i),
              onDeletePressed: () => onDeletePressed(i),
            ),
            if (i != visibleCount - 1) verticalSpacing(8),
          ],
          if (questions.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Center(
                child: Text(
                  "لا توجد أسئلة بعد — اضغط \"إضافة سؤال\" لكتابة أول سؤال",
                  style: AppTextStyles.font12blackWeight400.copyWith(
                    fontSize: 11.sp,
                    color: OnlineDoctorTheme.mutedText,
                  ),
                ),
              ),
            ),
          if (questions.length > collapsedCount) ...[
            verticalSpacing(10),
            InkWell(
              onTap: onToggleShowAll,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    showAll
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.arrow_back_rounded,
                    size: 15.sp,
                    color: OnlineDoctorTheme.accentBlue,
                  ),
                  horizontalSpacing(5),
                  Text(
                    showAll
                        ? "عرض أول $collapsedCount أسئلة"
                        : "عرض جميع الأسئلة (${questions.length})",
                    style: AppTextStyles.font12blackWeight400.copyWith(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w700,
                      color: OnlineDoctorTheme.accentBlue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AddQuestionButton extends StatelessWidget {
  const _AddQuestionButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: OnlineDoctorTheme.questionsBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_rounded,
              size: 15.sp,
              color: OnlineDoctorTheme.countdownAmber,
            ),
            horizontalSpacing(3),
            Text(
              "إضافة سؤال",
              style: AppTextStyles.font12blackWeight400.copyWith(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: OnlineDoctorTheme.headingColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// سطر سؤال واحد — رقمه فى دايرة صفرا، ونصه، ومنيو تعديل/حذف.
class _QuestionTile extends StatelessWidget {
  const _QuestionTile({
    required this.index,
    required this.question,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  final int index;
  final String question;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: OnlineDoctorTheme.questionsBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 24.w,
            height: 24.w,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: OnlineDoctorTheme.countdownSurface,
              shape: BoxShape.circle,
            ),
            child: Text(
              "${index + 1}",
              style: AppTextStyles.font12blackWeight400.copyWith(
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
                color: OnlineDoctorTheme.countdownAmber,
              ),
            ),
          ),
          horizontalSpacing(8),
          Expanded(
            child: Text(
              question,
              style: AppTextStyles.font12blackWeight400.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                height: 1.5,
                color: OnlineDoctorTheme.headingColor,
              ),
            ),
          ),
          PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            icon: Icon(
              Icons.more_vert_rounded,
              size: 17.sp,
              color: OnlineDoctorTheme.mutedText,
            ),
            onSelected: (value) =>
                value == 'edit' ? onEditPressed() : onDeletePressed(),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: _QuestionMenuItem(
                  icon: Icons.edit_rounded,
                  label: "تعديل",
                  color: OnlineDoctorTheme.accentBlue,
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: _QuestionMenuItem(
                  icon: Icons.delete_outline_rounded,
                  label: "حذف",
                  color: OnlineDoctorTheme.offlineRed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuestionMenuItem extends StatelessWidget {
  const _QuestionMenuItem({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16.sp, color: color),
        horizontalSpacing(8),
        Text(
          label,
          style: AppTextStyles.font12blackWeight400.copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// كارت "معلومات مهمة" — نصايح قبل الدخول ودرع الخصوصية.
class _ImportantNotesCard extends StatelessWidget {
  const _ImportantNotesCard({required this.typeName});

  final String typeName;

  @override
  Widget build(BuildContext context) {
    final notes = [
      "تأكد من وجود اتصال إنترنت جيد قبل الدخول إلى $typeName.",
      "يفضل استخدام سماعة رأس للحصول على أفضل تجربة.",
      "يمكنك مشاركة التقارير والملفات أثناء $typeName من داخل غرفة المحادثة.",
    ];

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: OnlineDoctorTheme.bookingSurface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: OnlineDoctorTheme.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_rounded,
                      size: 17.sp,
                      color: OnlineDoctorTheme.accentBlue,
                    ),
                    horizontalSpacing(6),
                    Text(
                      "معلومات مهمة",
                      style: AppTextStyles.font16BlackSemiBold.copyWith(
                        fontSize: 14.5.sp,
                        fontWeight: FontWeight.w700,
                        color: OnlineDoctorTheme.headingColor,
                      ),
                    ),
                  ],
                ),
                verticalSpacing(8),
                for (final note in notes)
                  Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "•  ",
                          style: AppTextStyles.font12blackWeight400.copyWith(
                            color: OnlineDoctorTheme.mutedText,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            note,
                            style: AppTextStyles.font12blackWeight400.copyWith(
                              fontSize: 11.5.sp,
                              height: 1.6,
                              color: OnlineDoctorTheme.sectionBodyText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          horizontalSpacing(12),
          Column(
            children: [
              Container(
                width: 52.w,
                height: 52.w,
                decoration: const BoxDecoration(
                  gradient: OnlineDoctorTheme.shieldGradient,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shield_rounded,
                  size: 24.sp,
                  color: Colors.white,
                ),
              ),
              verticalSpacing(6),
              SizedBox(
                width: 80.w,
                child: Text(
                  "خصوصيتك وأمان بياناتك هي أولويتنا",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font12blackWeight400.copyWith(
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                    color: OnlineDoctorTheme.headingColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// المشارك اللى اتختار من دايالوج الإضافة — المستخدم وصلة قرابته.
typedef _NewParticipant = ({SearchPhoneNumberUser user, String relation});

/// دايالوج إضافة مشارك — بحث عن مستخدم برقم موبايله، اختياره من النتايج،
/// وصلة القرابة. بيرجع [_NewParticipant] عند التأكيد.
class _AddParticipantDialog extends StatefulWidget {
  const _AddParticipantDialog({required this.addedUserIds});

  /// حسابات المشاركين الحاليين — عشان نفس الشخص مايتضافش مرتين.
  final Set<String> addedUserIds;

  @override
  State<_AddParticipantDialog> createState() => _AddParticipantDialogState();
}

class _AddParticipantDialogState extends State<_AddParticipantDialog> {
  final _phoneController = TextEditingController();
  final _relationController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _relationController.dispose();
    super.dispose();
  }

  void _onSearchPressed() {
    FocusScope.of(context).unfocus();
    context.read<ParticipantSearchCubit>().search(_phoneController.text);
  }

  void _onConfirmPressed() {
    final user = context.read<ParticipantSearchCubit>().state.selectedUser;
    final relation = _relationController.text.trim();
    if (user == null) {
      showError("ابحث برقم الموبايل واختر الشخص أولًا");
      return;
    }
    if (widget.addedUserIds.contains(user.userId.toString())) {
      showError("${user.fullName} مضاف بالفعل");
      return;
    }
    if (relation.isEmpty) {
      showError("اكتب صلة القرابة");
      return;
    }
    Navigator.of(context).pop<_NewParticipant>(
      (user: user, relation: relation),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _RoomDialogShell(
      icon: Icons.person_add_alt_1_rounded,
      iconColor: OnlineDoctorTheme.accentBlue,
      iconSurface: OnlineDoctorTheme.iconTint,
      title: "إضافة مشارك",
      confirmLabel: "إضافة",
      onConfirmPressed: _onConfirmPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DialogTextField(
            controller: _phoneController,
            hint: "رقم موبايل المشارك",
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _onSearchPressed(),
            suffixIcon: IconButton(
              onPressed: _onSearchPressed,
              icon: Icon(
                Icons.search_rounded,
                size: 22.sp,
                color: AppColorsManager.mainDarkBlue,
              ),
            ),
          ),
          verticalSpacing(10),
          const _ParticipantSearchResults(),
          verticalSpacing(10),
          _DialogTextField(
            controller: _relationController,
            hint: "صلة القرابة — أب، زوجة، أخ...",
          ),
        ],
      ),
    );
  }
}

/// نتايج البحث برقم الموبايل — تحميل، رسالة فشل، "لا يوجد مستخدم"، أو
/// كروت المستخدمين واللى اتختار عليه علامة.
class _ParticipantSearchResults extends StatelessWidget {
  const _ParticipantSearchResults();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParticipantSearchCubit, ParticipantSearchState>(
      builder: (context, state) {
        switch (state.searchStatus) {
          case RequestStatus.initial:
            return const SizedBox.shrink();
          case RequestStatus.loading:
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Center(
                child: SizedBox(
                  width: 22.w,
                  height: 22.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColorsManager.mainDarkBlue,
                  ),
                ),
              ),
            );
          case RequestStatus.failure:
            return _SearchMessage(
              message: state.errorMessage,
              color: AppColorsManager.warningColor,
            );
          case RequestStatus.success:
            if (state.results.isEmpty) {
              return const _SearchMessage(
                message: "لا يوجد مستخدم بهذا الرقم",
                color: OnlineDoctorTheme.mutedText,
              );
            }
            return ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 180.h),
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: state.results.length,
                separatorBuilder: (_, __) => verticalSpacing(8),
                itemBuilder: (context, index) {
                  final user = state.results[index];
                  return SelectedUserCard(
                    user: user,
                    isSelected: user == state.selectedUser,
                    onTap: () =>
                        context.read<ParticipantSearchCubit>().selectUser(user),
                  );
                },
              ),
            );
        }
      },
    );
  }
}

class _SearchMessage extends StatelessWidget {
  const _SearchMessage({required this.message, required this.color});

  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      textAlign: TextAlign.center,
      style: AppTextStyles.font12blackWeight400.copyWith(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}

/// دايالوج كتابة/تعديل سؤال — بيرجع نص السؤال عند التأكيد.
class _QuestionDialog extends StatefulWidget {
  const _QuestionDialog({this.initialText});

  final String? initialText;

  @override
  State<_QuestionDialog> createState() => _QuestionDialogState();
}

class _QuestionDialogState extends State<_QuestionDialog> {
  late final _controller = TextEditingController(text: widget.initialText);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onConfirmPressed() {
    final question = _controller.text.trim();
    if (question.isEmpty) return;
    Navigator.of(context).pop(question);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialText != null;

    return _RoomDialogShell(
      icon: Icons.question_mark_rounded,
      iconColor: OnlineDoctorTheme.countdownAmber,
      iconSurface: OnlineDoctorTheme.countdownSurface,
      title: isEditing ? "تعديل السؤال" : "إضافة سؤال",
      confirmLabel: isEditing ? "حفظ" : "إضافة",
      onConfirmPressed: _onConfirmPressed,
      child: _DialogTextField(
        controller: _controller,
        hint: "اكتب سؤالك للطبيب...",
        maxLines: 3,
      ),
    );
  }
}

/// جسم دايالوجات الغرفة — أيقونة وعنوان ومحتوى وزرارى رجوع/تأكيد،
/// بنفس ستايل دايالوج إلغاء الموعد.
class _RoomDialogShell extends StatelessWidget {
  const _RoomDialogShell({
    required this.icon,
    required this.iconColor,
    required this.iconSurface,
    required this.title,
    required this.confirmLabel,
    required this.onConfirmPressed,
    required this.child,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconSurface;
  final String title;
  final String confirmLabel;
  final VoidCallback onConfirmPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      // قابل للسكرول عشان الكيبورد مايغطيش زرار التأكيد.
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: iconSurface,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 26.sp, color: iconColor),
            ),
            verticalSpacing(12),
            Text(
              title,
              style: AppTextStyles.font16BlackSemiBold.copyWith(
                fontWeight: FontWeight.w700,
                color: OnlineDoctorTheme.headingColor,
              ),
            ),
            verticalSpacing(14),
            child,
            verticalSpacing(18),
            Row(
              children: [
                Expanded(
                  child: _RoomDialogButton(
                    label: "رجوع",
                    backgroundColor: OnlineDoctorTheme.cardSurface,
                    contentColor: OnlineDoctorTheme.headingColor,
                    borderColor: OnlineDoctorTheme.fieldBorder,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
                horizontalSpacing(10),
                Expanded(
                  child: _RoomDialogButton(
                    label: confirmLabel,
                    backgroundColor: AppColorsManager.mainDarkBlue,
                    contentColor: Colors.white,
                    onTap: onConfirmPressed,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogTextField extends StatelessWidget {
  const _DialogTextField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      style: AppTextStyles.font14blackWeight400.copyWith(
        fontSize: 13.sp,
        color: OnlineDoctorTheme.headingColor,
      ),
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: suffixIcon,
        hintStyle: AppTextStyles.font12blackWeight400.copyWith(
          fontSize: 12.sp,
          color: OnlineDoctorTheme.mutedText,
        ),
        filled: true,
        fillColor: OnlineDoctorTheme.cardSurface,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: OnlineDoctorTheme.fieldBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: OnlineDoctorTheme.fieldBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColorsManager.mainDarkBlue),
        ),
      ),
    );
  }
}

class _RoomDialogButton extends StatelessWidget {
  const _RoomDialogButton({
    required this.label,
    required this.backgroundColor,
    required this.contentColor,
    required this.onTap,
    this.borderColor,
  });

  final String label;
  final Color backgroundColor;
  final Color contentColor;
  final Color? borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          height: 42.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border:
                borderColor != null ? Border.all(color: borderColor!) : null,
          ),
          child: Text(
            label,
            style: AppTextStyles.font14blackWeight400.copyWith(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: contentColor,
            ),
          ),
        ),
      ),
    );
  }
}
