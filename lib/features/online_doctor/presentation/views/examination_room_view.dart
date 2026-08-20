import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_back_arrow.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/online_doctor/data/models/booking_model.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/booking_type_badge.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// شاشة غرفة الكشف — بتتفتح من زرار "دخول عند الطبيب" فى كارت الحجز:
/// ملخص الطبيب والموعد، زرار الدخول للمكالمة (بيتفعل فى وقت الموعد)،
/// إدارة المشاركين فى المحادثة، أسئلة المستخدم للطبيب، وتنويهات مهمة.
class ExaminationRoomView extends StatefulWidget {
  const ExaminationRoomView({super.key, required this.booking});

  final BookingModel booking;

  @override
  State<ExaminationRoomView> createState() => _ExaminationRoomViewState();
}

class _ExaminationRoomViewState extends State<ExaminationRoomView> {
  /// أقصى عدد مشاركين غير المريض فى محادثة الكشف.
  static const int maxParticipants = 3;

  //! المشاركون والأسئلة لسه محليين — هيتربطوا بـ endpoints الحجز مع التكامل.
  final List<_Participant> _participants = [
    const _Participant(
      name: "أحمد علي",
      relation: "أب",
      imageUrl: "https://randomuser.me/api/portraits/men/52.jpg",
    ),
    const _Participant(
      name: "منى أحمد",
      relation: "زوجة",
      imageUrl: "https://randomuser.me/api/portraits/women/65.jpg",
    ),
    const _Participant(
      name: "محمد علي",
      relation: "أخ",
      imageUrl: "https://randomuser.me/api/portraits/men/22.jpg",
    ),
  ];

  final List<String> _questions = [
    "هل أحتاج إلى الاستمرار على الدواء الحالي؟",
    "هل هناك فحوصات إضافية مطلوبة؟",
    "ما سبب هذه الأعراض التي أشعر بها مؤخراً؟",
  ];

  /// "عرض جميع الأسئلة" — القايمة بتعرض أول 3 بس لحد ما المستخدم يفردها.
  bool _showAllQuestions = false;

  BookingModel get _booking => widget.booking;

  String get _typeName => _booking.type.shortName;

  Future<void> _onEnterRoomPressed() async {
    if (_booking.isTimeNow(DateTime.now())) {
      await context.pushNamed(
        Routes.examinationCallView,
        arguments: _booking,
      );
      return;
    }
    _showMessage("يمكنك الدخول عند حلول موعد $_typeName");
  }

  Future<void> _onAddParticipantPressed() async {
    if (_participants.length >= maxParticipants) {
      _showMessage("لا يمكن إضافة أكثر من $maxParticipants مشاركين");
      return;
    }
    final participant = await showDialog<_Participant>(
      context: context,
      barrierColor: Colors.white.withValues(alpha: 0.4),
      builder: (_) => const _AddParticipantDialog(),
    );
    if (participant == null || !mounted) return;
    setState(() => _participants.add(participant));
  }

  void _onRemoveParticipant(_Participant participant) {
    setState(() => _participants.remove(participant));
  }

  Future<void> _onAddQuestionPressed() async {
    final question = await _showQuestionDialog();
    if (question == null || !mounted) return;
    setState(() => _questions.add(question));
  }

  Future<void> _onEditQuestion(int index) async {
    final question = await _showQuestionDialog(initialText: _questions[index]);
    if (question == null || !mounted) return;
    setState(() => _questions[index] = question);
  }

  void _onDeleteQuestion(int index) {
    setState(() => _questions.removeAt(index));
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
    return Scaffold(
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
                  _ParticipantsSection(
                    typeName: _typeName,
                    participants: _participants,
                    maxParticipants: maxParticipants,
                    onAddPressed: _onAddParticipantPressed,
                    onRemovePressed: _onRemoveParticipant,
                  ),
                  verticalSpacing(14),
                  _QuestionsSection(
                    typeName: _typeName,
                    questions: _questions,
                    showAll: _showAllQuestions,
                    onToggleShowAll: () => setState(
                      () => _showAllQuestions = !_showAllQuestions,
                    ),
                    onAddPressed: _onAddQuestionPressed,
                    onEditPressed: _onEditQuestion,
                    onDeletePressed: _onDeleteQuestion,
                  ),
                  verticalSpacing(14),
                  _ImportantNotesCard(typeName: _typeName),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// مشارك واحد فى محادثة الكشف — اسم وصلة قرابة وصورة اختيارية.
class _Participant {
  const _Participant({
    required this.name,
    required this.relation,
    this.imageUrl,
  });

  final String name;
  final String relation;

  /// المشارك المضاف يدويًا من غير صورة — بيظهر بأول حرف من اسمه.
  final String? imageUrl;
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
            border: Border.all(color: AppColorsManager.mainDarkBlue, width: 1.5),
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
  final List<_Participant> participants;
  final int maxParticipants;
  final VoidCallback onAddPressed;
  final void Function(_Participant participant) onRemovePressed;

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
                  "سيتم دعوة المشاركين للانضمام إلى محادثة $typeName",
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
class _PatientCard extends StatelessWidget {
  const _PatientCard();

  //! صورة المريض dummy لحد ما تتربط ببروفايل المستخدم.
  static const String _patientImageUrl =
      "https://randomuser.me/api/portraits/women/44.jpg";

  @override
  Widget build(BuildContext context) {
    return const _PersonCardShell(
      avatar: _PersonAvatar(
        name: "أنت",
        imageUrl: _patientImageUrl,
        showOnlineDot: true,
      ),
      name: "أنت",
      relation: "المريض",
      badge: _PersonBadge(
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

  final _Participant participant;
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
    final visibleCount = showAll
        ? questions.length
        : questions.length.clamp(0, collapsedCount);

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

/// دايالوج إضافة مشارك — اسم وصلة قرابة، وبيرجع `_Participant` عند التأكيد.
class _AddParticipantDialog extends StatefulWidget {
  const _AddParticipantDialog();

  @override
  State<_AddParticipantDialog> createState() => _AddParticipantDialogState();
}

class _AddParticipantDialogState extends State<_AddParticipantDialog> {
  final _nameController = TextEditingController();
  final _relationController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _relationController.dispose();
    super.dispose();
  }

  void _onConfirmPressed() {
    final name = _nameController.text.trim();
    final relation = _relationController.text.trim();
    if (name.isEmpty || relation.isEmpty) return;
    Navigator.of(context).pop(_Participant(name: name, relation: relation));
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
        children: [
          _DialogTextField(
            controller: _nameController,
            hint: "اسم المشارك",
          ),
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
      child: Padding(
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
  });

  final TextEditingController controller;
  final String hint;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: AppTextStyles.font14blackWeight400.copyWith(
        fontSize: 13.sp,
        color: OnlineDoctorTheme.headingColor,
      ),
      decoration: InputDecoration(
        hintText: hint,
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
