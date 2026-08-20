import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// قسم قابل للطى فى ملف الطبيب — أيقونة وعنوان وسهم، وتحتهم المحتوى.
class DoctorProfileExpandableSection extends StatefulWidget {
  const DoctorProfileExpandableSection({
    super.key,
    required this.title,
    this.icon,
    this.iconAsset,
    this.body,
    this.items = const [],
    this.content,
    this.initiallyExpanded = false,
  });

  final String title;

  /// أيقونة القسم — إما `IconData` أو صورة من الـ assets.
  final IconData? icon;
  final String? iconAsset;

  /// فقرة نصية — بتتعرض لما القسم يكون فيه كلام متصل زى "نبذة عن الطبيب".
  final String? body;

  /// نقاط مختصرة — بتتعرض كل واحدة فى سطر.
  final List<String> items;

  /// محتوى مخصص — بيتستخدم للأقسام اللى ليها شكل خاص زى اللغات والتخصص.
  final Widget? content;

  final bool initiallyExpanded;

  @override
  State<DoctorProfileExpandableSection> createState() =>
      _DoctorProfileExpandableSectionState();
}

class _DoctorProfileExpandableSectionState
    extends State<DoctorProfileExpandableSection> {
  late bool _isExpanded = widget.initiallyExpanded;

  bool get _hasContent =>
      widget.content != null || widget.body != null || widget.items.isNotEmpty;

  Widget _buildContent() {
    if (widget.content != null) return widget.content!;
    if (widget.body != null) {
      return Text(
        widget.body!,
        style: AppTextStyles.font14blackWeight400.copyWith(
          fontSize: 10.5.sp,
          height: 1.9,
          color: OnlineDoctorTheme.sectionBodyText,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [for (final item in widget.items) _SectionItem(item)],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: OnlineDoctorTheme.sectionSurface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: OnlineDoctorTheme.sectionBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: Row(
                children: [
                  _SectionIcon(icon: widget.icon, iconAsset: widget.iconAsset),
                  horizontalSpacing(8),
                  Expanded(
                    child: Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.font16BlackSemiBold.copyWith(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w700,
                        color: OnlineDoctorTheme.headingColor,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20.sp,
                      color: OnlineDoctorTheme.headingColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded && _hasContent)
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
              child: _buildContent(),
            ),
        ],
      ),
    );
  }
}

class _SectionIcon extends StatelessWidget {
  const _SectionIcon({this.icon, this.iconAsset});

  final IconData? icon;
  final String? iconAsset;

  @override
  Widget build(BuildContext context) {
    if (iconAsset != null) {
      return Image.asset(
        iconAsset!,
        width: 17.w,
        height: 17.h,
        color: OnlineDoctorTheme.accentBlue,
      );
    }
    return Icon(
      icon,
      size: 18.sp,
      color: OnlineDoctorTheme.accentBlue,
    );
  }
}

class _SectionItem extends StatelessWidget {
  const _SectionItem(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: Container(
              width: 5.w,
              height: 5.w,
              decoration: const BoxDecoration(
                color: OnlineDoctorTheme.accentBlue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          horizontalSpacing(8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.font14blackWeight400.copyWith(
                fontSize: 10.5.sp,
                height: 1.7,
                color: OnlineDoctorTheme.sectionBodyText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
