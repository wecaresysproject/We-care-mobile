import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_model.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_summary_model.dart';

/// Payloads captured from the live dev server (`GET /api/OnlineDoctor` and
/// `GET /api/OnlineDoctor/profile`) on 2026-08-26 — see docs/api/online_doctor_api.md.
const _listItemJson = r'''
{"id":"6a82e9257e523ce1d86779dd","name":"محمد علي العوايدي","specialty":"استشاري أمراض القلب والقسطرة","workplace":"مستشفى القاهرة الجامعي","profileImage":"https://example.com/images/doctor.jpg","rating":0,"likesCount":0,"commentsCount":0,"isOnline":false,"acceptsBookings":true,"nearestAvailableAppointment":{"date":"2026-08-27","time":"16:00"}}
''';

const _profileJson = r'''
{"id":"6a82e9257e523ce1d86779dd","name":"محمد علي العوايدي","profileImage":"https://example.com/images/doctor.jpg","isVerified":false,"isFavorite":false,"isOnline":false,"acceptsBookings":true,"specialty":"أمراض القلب","subSpecialty":["القسطرة القلبية","كهرباء القلب"],"degree":"بكالوريوس طب وجراحة","academicTitle":"دكتوراه أمراض القلب","hospital":"مستشفى القاهرة الجامعي","location":{"country":"مصر","governorate":"القاهرة","city":"الجيزة"},"yearsOfExperience":23,"rating":0,"likesCount":0,"commentsCount":0,"patientsCount":0,"nearestAvailableAppointment":{"date":"2026-08-27","time":"16:00"},"workingDays":["السبت","الثلاثاء","الأحد","الخميس"],"workingHours":["17:00 - 21:00","16:00 - 20:00"],"consultationFee":500,"about":"استشاري أمراض القلب والقسطرة، متخصص في علاج أمراض القلب والتدخلات القلبية وتركيب الدعامات.","medicalInterests":["مناظير القلب","الدعامات","التدخلات القلبية"],"professionalExperience":[{"position":"طبيب مقيم","workplace":"مستشفى القاهرة الجامعي","fromDate":"2002-12-31","toDate":"2007-12-30","country":"مصر"},{"position":"أخصائي أمراض القلب","workplace":"مستشفى عين شمس التخصصي","fromDate":"2007-12-31","toDate":"2014-12-30","country":"مصر"},{"position":"استشاري أمراض القلب والقسطرة","workplace":"مستشفى دار الفؤاد","fromDate":"2014-12-31","toDate":"","country":"مصر"}],"languages":["العربية","English"],"education":[{"title":"بكالوريوس طب وجراحة","institution":"جامعة القاهرة","country":"مصر","year":"2002"},{"title":"ماجستير أمراض القلب","institution":"جامعة عين شمس","country":"مصر","year":"2007"},{"title":"دكتوراه أمراض القلب","institution":"جامعة القاهرة","country":"مصر","year":"2012"}],"certificates":[{"title":"ACLS","issuer":"American Heart Association","country":"مصر","year":"2008"},{"title":"الزمالة البريطانية في أمراض القلب","issuer":"Royal College","country":"المملكة المتحدة","year":"2013"}],"medicalAssociations":[{"association":"نقابة الأطباء المصرية","membershipNumber":"453212","membershipLevel":"عضو","year":"2002"},{"association":"الجمعية المصرية لأمراض القلب","membershipNumber":"CARD-12345","membershipLevel":"عضو عامل","year":"2015"}],"research":[{"title":"Advances in Cardiac Catheterization","type":"بحث علمي","year":"2024","referenceUrl":"https://pubmed.ncbi.nlm.nih.gov/12345678/","doi":"10.1234/example.2024","pubmedId":"12345678"},{"title":"Modern Techniques in Coronary Intervention","type":"رسالة علمية","year":"2022","referenceUrl":"https://doi.org/10.1234/example.2022","doi":"10.1234/example.2022","pubmedId":"87654321"}],"awards":[{"title":"أفضل استشاري أمراض قلب","issuer":"الجمعية المصرية لأمراض القلب","country":"مصر","year":"2025","referenceUrl":"https://example.com/awards/2025"},{"title":"جائزة التميز الطبي","issuer":"وزارة الصحة والسكان","country":"مصر","year":"2023","referenceUrl":"https://example.com/awards/2023"}],"mediaAppearances":[{"subject":"نصائح للوقاية من أمراض القلب","type":"مقال","url":"https://example.com/articles/heart-prevention"},{"subject":"التطورات الحديثة في القسطرة القلبية","type":"فيديو","url":"https://example.com/videos/cardiac-catheterization"}],"reviews":[],"clinics":[{"address":"15 شارع التحرير - الدقي - الجيزة","phone":"01001234567","consultationFee":500,"workingDays":["السبت","الثلاثاء"],"workingHours":"17:00 - 21:00","googleMap":"https://maps.google.com/?q=Dokki+Giza"},{"address":"20 شارع جامعة الدول العربية - المهندسين - الجيزة","phone":"01101234567","consultationFee":600,"workingDays":["الأحد","الأربعاء"],"workingHours":"16:00 - 20:00","googleMap":"https://maps.google.com/?q=Mohandessin+Giza"}],"hospitalsCenters":[{"name":"مستشفى دار الفؤاد","address":"6 أكتوبر - الجيزة","phone":"01005555555","consultationFee":700,"workingDays":["الأحد","الخميس"],"workingHours":"18:00 - 22:00","googleMap":"https://maps.google.com/?q=Dar+Al+Fouad"},{"name":"مركز القلب التخصصي","address":"مدينة نصر - القاهرة","phone":"01006666666","consultationFee":650,"workingDays":["السبت","الأربعاء"],"workingHours":"17:00 - 21:00","googleMap":"https://maps.google.com/?q=Nasr+City+Cairo"}]}
''';

Map<String, dynamic> _decode(String raw) =>
    jsonDecode(raw) as Map<String, dynamic>;

void main() {
  group('DoctorSummaryModel', () {
    test('parses the live list payload, including an int rating', () {
      final doctor = DoctorSummaryModel.fromJson(_decode(_listItemJson));

      expect(doctor.id, '6a82e9257e523ce1d86779dd');
      expect(doctor.rating, 0.0);
      expect(doctor.acceptsBookings, isTrue);
      expect(doctor.imageUrl, 'https://example.com/images/doctor.jpg');
      expect(doctor.nearestAvailableAppointment?.dateLabel, 'الخميس 27 أغسطس');
      expect(doctor.nearestAvailableAppointment?.timeLabel, '04:00 مساءً');
    });

    test('tolerates a null image and a missing appointment', () {
      final doctor = DoctorSummaryModel.fromJson({
        'id': 'x',
        'name': 'n',
        'specialty': 's',
        'profileImage': null,
        'nearestAvailableAppointment': null,
      });

      expect(doctor.imageUrl, '');
      expect(doctor.workplace, '');
      expect(doctor.rating, 0.0);
      expect(doctor.nearestAvailableAppointment, isNull);
    });
  });

  group('DoctorModel', () {
    final doctor = DoctorModel.fromJson(_decode(_profileJson));

    test('parses the live profile payload', () {
      expect(doctor.subSpecialty, ['القسطرة القلبية', 'كهرباء القلب']);
      expect(doctor.locationLabel, 'مصر - القاهرة - الجيزة');
      expect(doctor.workingDaysLabel, 'السبت - الثلاثاء - الأحد - الخميس');
      expect(doctor.workingHoursLabel, '17:00 - 21:00 / 16:00 - 20:00');
      expect(doctor.consultationFee, 500);
      expect(doctor.rating, 0.0);
      expect(doctor.reviews, isEmpty);
      expect(doctor.clinics, hasLength(2));
      expect(doctor.hospitalsCenters.first.name, 'مستشفى دار الفؤاد');
    });

    test('builds display labels for the profile sections', () {
      expect(
        doctor.professionalExperience.last.label,
        'استشاري أمراض القلب والقسطرة — مستشفى دار الفؤاد (2014 - حتى الآن)',
      );
      expect(doctor.professionalExperience.first.periodLabel, '2002 - 2007');
      expect(doctor.medicalAssociations.first.membershipNumber, '453212');
      expect(doctor.research.first.actionLabel, 'عرض البحث');
      expect(doctor.research.last.actionLabel, 'عرض الرسالة');
      expect(doctor.mediaAppearances.first.actionLabel, 'قراءة المقال');
      expect(doctor.mediaAppearances.last.actionLabel, 'مشاهدة الفيديو');
      expect(doctor.awards.first.referenceUrl, isNotNull);
    });

    test('falls back to empty values when optional keys are missing', () {
      final minimal = DoctorModel.fromJson({'id': 'x', 'name': 'n'});

      expect(minimal.specialty, '');
      expect(minimal.isFavorite, isFalse);
      expect(minimal.location, isNull);
      expect(minimal.locationLabel, '');
      expect(minimal.education, isEmpty);
      expect(minimal.workingDaysLabel, '');
      expect(minimal.nearestAvailableAppointment, isNull);
    });
  });
}
