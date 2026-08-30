import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_profile_entries.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/doctor_profile_entry_tile.dart';

/// بيجمّع الأجزاء غير الفاضية بـ " — " — `null` لو كلها فاضية عشان السطر يتخفى.
String? _joinNonEmpty(List<String?> parts) {
  final filled = parts
      .where((part) => part != null && part.trim().isNotEmpty)
      .map((part) => part!.trim())
      .toList();
  return filled.isEmpty ? null : filled.join(" — ");
}

/// عمود بيرص عناصر القسم ببعضها بمسافة ثابتة.
class _EntriesColumn extends StatelessWidget {
  const _EntriesColumn({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var index = 0; index < children.length; index++) ...[
          if (index != 0) verticalSpacing(12),
          children[index],
        ],
      ],
    );
  }
}

/// محتوى قسم "التعليم والمؤهلات" — مؤهلات مرقّمة بالجهة والسنة.
class DoctorQualificationsList extends StatelessWidget {
  const DoctorQualificationsList({super.key, required this.qualifications});

  final List<DoctorQualificationModel> qualifications;

  @override
  Widget build(BuildContext context) {
    return _EntriesColumn(
      children: [
        for (var index = 0; index < qualifications.length; index++)
          DoctorProfileEntryTile(
            index: index + 1,
            title: qualifications[index].title,
            subtitle: _joinNonEmpty([
              qualifications[index].institution,
              qualifications[index].country,
            ]),
            trailingLine: _joinNonEmpty([qualifications[index].year]),
          ),
      ],
    );
  }
}

/// محتوى قسم "الدورات والشهادات المهنية".
class DoctorCertificatesList extends StatelessWidget {
  const DoctorCertificatesList({super.key, required this.certificates});

  final List<DoctorCertificateModel> certificates;

  @override
  Widget build(BuildContext context) {
    return _EntriesColumn(
      children: [
        for (var index = 0; index < certificates.length; index++)
          DoctorProfileEntryTile(
            index: index + 1,
            title: certificates[index].title,
            subtitle: _joinNonEmpty([
              certificates[index].issuer,
              certificates[index].country,
            ]),
            trailingLine: _joinNonEmpty([certificates[index].year]),
          ),
      ],
    );
  }
}

/// محتوى قسم "الجمعيات الطبية".
class DoctorMembershipsList extends StatelessWidget {
  const DoctorMembershipsList({super.key, required this.memberships});

  final List<DoctorMembershipModel> memberships;

  @override
  Widget build(BuildContext context) {
    return _EntriesColumn(
      children: [
        for (var index = 0; index < memberships.length; index++)
          DoctorProfileEntryTile(
            index: index + 1,
            title: memberships[index].association,
            subtitle: _joinNonEmpty([
              memberships[index].membershipLevel,
              if (memberships[index].membershipNumber?.trim().isNotEmpty ??
                  false)
                "رقم العضوية: ${memberships[index].membershipNumber}",
            ]),
            trailingLine: memberships[index].year.trim().isEmpty
                ? null
                : "منذ ${memberships[index].year}",
          ),
      ],
    );
  }
}

/// محتوى قسم "الأبحاث والرسائل العلمية" — كل بحث وليه رابط عرض.
class DoctorResearchList extends StatelessWidget {
  const DoctorResearchList({super.key, required this.research});

  final List<DoctorResearchModel> research;

  @override
  Widget build(BuildContext context) {
    return _EntriesColumn(
      children: [
        for (final item in research)
          DoctorProfileEntryTile(
            title: item.title,
            subtitle: _joinNonEmpty([item.type, item.year]),
            actionLabel: item.referenceUrl == null ? null : item.actionLabel,
            onActionTap: () async => launchExternalUrl(item.referenceUrl),
          ),
      ],
    );
  }
}

/// محتوى قسم "الجوائز والتكريمات".
class DoctorAwardsList extends StatelessWidget {
  const DoctorAwardsList({super.key, required this.awards});

  final List<DoctorAwardModel> awards;

  @override
  Widget build(BuildContext context) {
    return _EntriesColumn(
      children: [
        for (final award in awards)
          DoctorProfileEntryTile(
            title: award.title,
            subtitle: _joinNonEmpty([award.issuer, award.country]),
            trailingLine: _joinNonEmpty([award.year]),
            actionLabel: award.referenceUrl == null ? null : "عرض الجائزة",
            onActionTap: () async => launchExternalUrl(award.referenceUrl),
          ),
      ],
    );
  }
}

/// محتوى قسم "ميديا ومقالات" — كل عنصر وليه رابط مشاهدة أو قراءة.
class DoctorMediaList extends StatelessWidget {
  const DoctorMediaList({super.key, required this.media});

  final List<DoctorMediaModel> media;

  @override
  Widget build(BuildContext context) {
    return _EntriesColumn(
      children: [
        for (final item in media)
          DoctorProfileEntryTile(
            title: item.subject,
            subtitle: _joinNonEmpty([item.type]),
            actionLabel: item.url == null ? null : item.actionLabel,
            onActionTap: () async => launchExternalUrl(item.url),
          ),
      ],
    );
  }
}
