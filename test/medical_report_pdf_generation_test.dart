import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_report_response_model.dart';
import 'package:we_care/features/my_medical_reports/logic/medical_report_pdf_generator.dart';

/// Reproduces the medical-report export end to end, offline:
///
///   backend JSON  ->  MedicalReportResponseModel.fromJson  ->  PDF bytes
///
/// The fixture below is a `full-report-Medical-file-data` response for the
/// selections payload the user reported as "not generated as pdf" — every
/// module that was selected has at least one entry, using the exact filter
/// values that were sent (drug names, disease names, doctor name, ...).
///
/// Two things this test canNOT reproduce, by construction:
///  * remote images — `NetworkAssetBundle` fails inside `flutter test`, and the
///    generator swallows those failures, so the PDF renders the no-image path.
///  * a backend response whose shape differs from this fixture. If the export
///    still fails on device, dump the real response body into
///    `test/fixtures/medical_report_response.json` (see the last test) and
///    rerun — that test parses and renders the real payload.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final generator = MedicalReportPdfGenerator();

  Future<List<int>> render(Map<String, dynamic> data) async {
    final model = MedicalReportResponseModel.fromJson(_envelope(data));
    return generator.generateMedicalReport(model);
  }

  void expectIsPdf(List<int> bytes) {
    expect(bytes.length, greaterThan(1000),
        reason: 'a report with content should be more than a stub page');
    expect(String.fromCharCodes(bytes.take(4)), '%PDF');
  }

  test('the selections payload parses into MedicalReportResponseModel', () {
    final model = MedicalReportResponseModel.fromJson(_envelope(_fullData()));

    expect(model.data.basicInformation, isNotEmpty);
    expect(model.data.medicationsModule?.currentMedications, isNotEmpty);
    expect(model.data.medicationsModule?.expiredLast90Days, isNotEmpty);
    expect(model.data.complaintsModule?.mainComplaints, isNotEmpty);
    expect(model.data.radiology, isNotEmpty);
    expect(model.data.surgeryEntries, isNotEmpty);
    expect(model.data.preDescriptions, isNotEmpty);
    expect(model.data.geneticDiseases?.familyGeneticDiseases, isNotEmpty);
    expect(model.data.eyeModule?.eyeSymptoms, isNotEmpty);
    expect(model.data.teethModule?.teethSymptoms, isNotEmpty);
    expect(model.data.nutritionTrackingModule, isNotEmpty);
    expect(model.data.physicalActivityModule, isNotEmpty);
    expect(model.data.mentalIllnessModule?.behavioralDisorders, isNotEmpty);
    expect(model.data.monthlyHealthSurveySection?.rows, isNotEmpty);
    expect(model.data.riskyBehaviour, isNotEmpty);
    expect(model.data.vaccines, isNotEmpty);
  });

  test(
    'generates a PDF for the whole selections payload',
    () async {
      final bytes = await render(_fullData());
      expectIsPdf(bytes);

      final out = File('build/test_pdfs/medical_report_full.pdf');
      await out.parent.create(recursive: true);
      await out.writeAsBytes(bytes);
      // ignore: avoid_print
      print('PDF written to ${out.absolute.path} (${bytes.length} bytes)');
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );

  // One section at a time, so a failure names the section that breaks instead
  // of just failing the whole export the way the app does.
  group('section by section', () {
    for (final entry in _sections().entries) {
      test(
        entry.key,
        () async => expectIsPdf(await render({entry.key: entry.value})),
        timeout: const Timeout(Duration(minutes: 2)),
      );
    }
  });

  // The generator itself survives everything this fixture throws at it — what
  // actually aborts the export is `fromJson`. Most response fields are declared
  // non-nullable `String`, so a single missing key or a numeric value coming
  // back from the backend blows up before a single page is laid out, and
  // `MedicalReportExportLogic` reports it as "حدث خطأ أثناء تصدير التقرير".
  group('response shapes that abort the export before the PDF is built', () {
    void expectAborts(String label, Map<String, dynamic> data) {
      test(label, () {
        expect(
          () => MedicalReportResponseModel.fromJson(_envelope(data)),
          throwsA(isA<TypeError>()),
        );
      });
    }

    expectAborts('a vital-sign reading sent as a number, not a string', {
      'vitalSigns': [
        {
          'categoryName': 'الضغط',
          'reading': [
            {'min': 80, 'max': 120, 'date': '2026-07-01T00:00:00'},
          ],
        },
      ],
    });

    expectAborts('a null severity on a main complaint', {
      'complaintsModule': {
        'mainComplaints': [
          {
            'dateOfComplaintOnset': '2026-05-02T00:00:00',
            'partOfPlaceOfComplaints': 'الرأس',
            'symptoms_Complaint':
                'دوخة أو إغماء عند الوقوف بسبب انخفاض ضغط الدم',
            'natureOfComplaint': 'متقطع',
            'severityOfComplaint': null,
          },
        ],
      },
    });

    expectAborts('a surgery entry missing the optional-looking keys', {
      'surgeryEntries': [
        {
          'surgeryName': 'تغيير الصمام بالأورطي بالقسطرة (TAVI)',
          'surgeryDate': '2026-01-20T00:00:00',
        },
      ],
    });

    expectAborts('a vaccine without a code', {
      'vaccines': [
        {
          'date': '2026-02-14T00:00:00',
          'code': null,
          'vaccineName': 'لقاح الإنفلونزا الموسمية',
          'vaccineCategory': 'لقاحات موسمية',
          'dose': 'جرعة واحدة',
          'targetDisease': 'الإنفلونزا',
          'vaccineActionDescription': 'وصف',
        },
      ],
    });
  });

  test('lists every field whose null value would abort the export', () {
    final data = _fullData();
    final fatal = <String>[];

    for (final path in _leafPaths(data)) {
      try {
        MedicalReportResponseModel.fromJson(
          _envelope(_copyWithNull(data, path) as Map<String, dynamic>),
        );
      } on TypeError {
        fatal.add(path.join('.'));
      }
    }

    // Diagnostic: narrows a failing real response down to a field name fast.
    // ignore: avoid_print
    print('\nnull-hostile fields (${fatal.length}):\n  ${fatal.join('\n  ')}\n');

    // The fixture itself must stay parseable; the sweep above only mutates copies.
    expect(
      MedicalReportResponseModel.fromJson(_envelope(data)).data.vaccines,
      isNotEmpty,
    );
  });

  test(
    'renders the real backend response, when one is captured',
    () async {
      final fixture = File('test/fixtures/medical_report_response.json');
      if (!fixture.existsSync()) {
        // ignore: avoid_print
        print('skipped: drop the real response body into ${fixture.path} '
            'to reproduce the exact failure');
        return;
      }

      final body = jsonDecode(await fixture.readAsString());
      final model = MedicalReportResponseModel.fromJson(
        (body as Map).cast<String, dynamic>(),
      );
      final bytes = await generator.generateMedicalReport(model);
      expectIsPdf(bytes);

      final out = File('build/test_pdfs/medical_report_real.pdf');
      await out.parent.create(recursive: true);
      await out.writeAsBytes(bytes);
      // ignore: avoid_print
      print('PDF written to ${out.absolute.path} (${bytes.length} bytes)');
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );
}

/// Every scalar position in the response tree, as a `key`/`index` path.
List<List<Object>> _leafPaths(Object? node, [List<Object> prefix = const []]) {
  if (node is Map) {
    return [
      for (final entry in node.entries)
        ..._leafPaths(entry.value, [...prefix, entry.key as Object]),
    ];
  }
  if (node is List) {
    return [
      for (var i = 0; i < node.length; i++) ..._leafPaths(node[i], [...prefix, i]),
    ];
  }
  return [prefix];
}

/// Deep copy of [node] with the value at [path] replaced by null.
Object? _copyWithNull(Object? node, List<Object> path) {
  if (path.isEmpty) return null;
  final step = path.first;
  final rest = path.sublist(1);

  if (node is Map) {
    return <String, dynamic>{
      for (final entry in node.entries)
        entry.key as String: entry.key == step
            ? _copyWithNull(entry.value, rest)
            : entry.value,
    };
  }
  if (node is List) {
    return <dynamic>[
      for (var i = 0; i < node.length; i++)
        i == step ? _copyWithNull(node[i], rest) : node[i],
    ];
  }
  return node;
}

Map<String, dynamic> _envelope(Map<String, dynamic> data) => {
      'success': true,
      'message': 'تم جلب البيانات بنجاح',
      'userName': 'كريم عبد الدين',
      // A real (unreachable in tests) URL, so the profile-image fallback path runs.
      'imageUrl': 'https://wecare-files.s3.amazonaws.com/profiles/user.jpg',
      'data': data,
    };

Map<String, dynamic> _fullData() => {
      for (final entry in _sections().entries) entry.key: entry.value,
    };

/// Keyed by the JSON key `MedicalReportData` reads, one entry per module that
/// the reported selections payload asked for.
Map<String, dynamic> _sections() => {
      // "basicInformation": specificFields ["تاريخ الميلاد"], getAll true
      'basicInformation': [
        {'label': 'تاريخ الميلاد', 'value': '12/05/1985'},
        {'label': 'النوع', 'value': 'ذكر'},
        {'label': 'فصيلة الدم', 'value': 'O+'},
        {'label': 'نوع العجز الجسدي', 'value': 'لا يوجد'},
      ],

      // "vitalSigns": specificFields ["الضغط"]
      'vitalSigns': [
        {
          'categoryName': 'الضغط',
          'reading': [
            {'min': '80', 'max': '120', 'date': '2026-07-01T00:00:00'},
            {'min': '85', 'max': '135', 'date': '2026-07-14T00:00:00'},
            {'min': '90', 'max': '140', 'date': '2026-07-26T00:00:00'},
          ],
        },
      ],

      // "chronicDiseases": diseases ["سكر"]
      'chronicDiseases': [
        {
          'diagnosisStartDate': '2019-03-11T00:00:00',
          'diseaseName': 'سكر',
          'diseaseStatus': 'مستمر',
        },
      ],

      // "emergencyComplaints": complaints + otherComplaints, attachImages true
      'complaintsModule': {
        'mainComplaints': [
          {
            'dateOfComplaintOnset': '2026-05-02T00:00:00',
            'complaintImage':
                'https://wecare-files.s3.amazonaws.com/complaints/1.jpg',
            'partOfPlaceOfComplaints': 'الرأس',
            'symptoms_Complaint':
                'دوخة أو إغماء عند الوقوف بسبب انخفاض ضغط الدم',
            'natureOfComplaint': 'متقطع',
            'severityOfComplaint': 'متوسط',
          },
        ],
        'additionalComplaints': [
          {
            'dateOfComplaintOnset': '2026-05-02T00:00:00',
            'complaintImage': null,
            'additionalMedicalComplains':
                'صداع مستمر ودوخة متوسطة، ورغبة في النوم المتواصل',
          },
        ],
      },

      // "medications": currentMedicines + expiredLast3Months
      'medicationsModule': {
        'currentMedications': [
          {
            'startDate': '2026-06-01T00:00:00',
            'medicineName': 'HETEROSOFIR 400MG 28 TABLETS',
            'dosage': '½ حبة',
            'selectedDoseAmount': '400 مجم',
            'dosageFrequency': 'مرة يوميا',
            'timeDuration': '28 يوم',
          },
        ],
        'expiredLast90Days': [
          {
            'startDate': '2026-03-15T00:00:00',
            'medicineName': 'SOVALDI 400MG 28 TABLETS',
            'dosage': '1 حبة',
            'selectedDoseAmount': '400 مجم',
            'dosageFrequency': 'مرة يوميا',
            'timeDuration': '28 يوم',
          },
        ],
      },

      // "LabTests": GroupName ["لون البراز"], years [2026]
      'medicalTests': [
        {
          'testName': 'لون البراز',
          'code': 'STL-01',
          'group': 'لون البراز',
          'results': [
            {'value': 1.0, 'testDate': '2026-02-11T00:00:00'},
            {'value': 2.5, 'testDate': '2026-06-19T00:00:00'},
          ],
        },
      ],

      // "SurgeryEntries": surgeryNames, attachImages true
      'surgeryEntries': [
        {
          'surgeryName': 'تغيير الصمام بالأورطي بالقسطرة (TAVI)',
          'surgeryDate': '2026-01-20T00:00:00',
          'surgeryRegion': 'القلب',
          'usedTechnique': 'قسطرة',
          'surgeryStatus': 'ناجحة',
          'surgeonName': 'د/ محمد الشاذلي',
          'hospitalCenter': 'مركز القلب',
          'country': 'مصر',
          'medicalReportImage': [
            'https://wecare-files.s3.amazonaws.com/surgeries/1.jpg',
          ],
        },
      ],

      // "Radiology": RadioTypes ["X-ray"], attachImages true
      'radiology': [
        {
          'radiologyDate': '2026-04-08T00:00:00',
          'bodyPart': 'الصدر',
          'radioType': 'X-ray',
          'xrayImages': [
            'https://wecare-files.s3.amazonaws.com/xray/1.jpg',
            'https://wecare-files.s3.amazonaws.com/xray/2.jpg',
          ],
          'reportImages': [
            'https://wecare-files.s3.amazonaws.com/xray/report-1.jpg',
          ],
          'periodicUsage': ['احتياج دوري'],
        },
      ],

      // "Allergy": allergyTypes ["أدوية"]
      'allergy': [
        {
          'allergyType': 'أدوية',
          'allergyTriggers': ['بنسلين', 'أسبرين'],
          'symptomSeverity': 'شديد',
          'carryEpinephrine': true,
        },
      ],

      // "PreDescriptions": Doctors ["د/ سعيد مصطفى النحاس"], years [2026]
      'preDescriptions': [
        {
          'preDescriptionDate': '2026-03-03T00:00:00',
          'doctorName': 'د/ سعيد مصطفى النحاس',
          'doctorSpecialty': 'باطنة',
          'preDescriptionPhoto': [
            'https://wecare-files.s3.amazonaws.com/prescriptions/1.jpg',
          ],
          'country': 'مصر',
        },
      ],

      // "teeth": getAll with no filters
      'teethModule': {
        'teethSymptoms': [
          {
            'symptomStartDate': '2026-02-01T00:00:00',
            'teethNumber': '36',
            'symptomType': 'ألم عند المضغ',
            'complaintNature': 'متقطع',
            'symptomDuration': 'أسبوعين',
            'painNature': 'نابض',
          },
        ],
        'teethProcedures': [
          {
            'procedureDate': '2026-02-20T00:00:00',
            'teethNumber': '36',
            'primaryProcedure': 'حشو عصب',
            'subProcedure': 'حشو دائم',
            'xRayImages': [
              'https://wecare-files.s3.amazonaws.com/teeth/1.jpg',
            ],
          },
        ],
      },

      // "eyes": getAll, AttachImages + needMedicalRecord true
      'eyeModule': {
        'eyeSymptoms': [
          {
            'symptomStartDate': '2026-01-05T00:00:00',
            'affectedEyePart': 'العين اليمنى',
            'symptoms': ['زغللة', 'حساسية للضوء'],
            'symptomDuration': 'شهر',
          },
        ],
        'eyeProcedures': [
          {
            'medicalReportDate': '2026-01-25T00:00:00',
            'affectedEyePart': 'العين اليمنى',
            'symptoms': ['زغللة'],
            'medicalProcedures': ['قياس ضغط العين'],
            'medicalExaminationImages': [
              'https://wecare-files.s3.amazonaws.com/eyes/1.jpg',
            ],
            'medicalReportUrl': [
              'https://wecare-files.s3.amazonaws.com/eyes/report-1.jpg',
            ],
          },
        ],
      },

      // "mentalDiseases": psychologicalEmergencies ["السلوك القهري والإدماني"]
      'mentalIllnessModule': {
        'mentalIllnesses': [
          {
            'diagnosisDate': '2025-11-10T00:00:00',
            'mentalIllnessType': 'قلق عام',
            'illnessSeverity': 'متوسط',
            'illnessDuration': 'سنة',
          },
        ],
        'behavioralDisorders': [
          {
            'assessmentDate': '2026-06-01T00:00:00',
            'axes': 'السلوك القهري والإدماني',
            'overallLevel': 'مرتفع',
          },
        ],
      },

      // "geneticDiseases": family + expected ["السكري النوع الأول"]
      'geneticDiseases': {
        'familyGeneticDiseases': [
          {
            'geneticDisease': 'السكري النوع الأول',
            'members': [
              {'code': 'F-01', 'name': 'الأب', 'diseaseStatus': 'مصاب'},
              {'code': 'M-01', 'name': 'الأم', 'diseaseStatus': 'غير مصاب'},
            ],
          },
        ],
        'myExpectedGeneticDiseases': [
          {'geneticDisease': 'السكري النوع الأول', 'probabilityLevel': 'متوسطة'},
        ],
      },

      // "supplements": supplementNames, years [2026]
      'supplementsModule': {
        'supplements': [
          {
            'date': '2026-05-01T00:00:00',
            'supplementName': 'سنتـروم (متعدد فيتامينات ومعادن)',
            'dosage': '1 قرص',
            'planType': 'يومي',
          },
        ],
      },

      // "physicalActivity": dateRange ["من 29/12/2025 إلى 04/01/2026"]
      'physicalActivityModule': [
        {
          'dateRange': {
            'from': '2025-12-29T00:00:00',
            'to': '2026-01-04T00:00:00',
          },
          'planType': 'بناء عضلي',
          'totalExerciseDays': 5,
          'totalExerciseMinutes': 260,
          'averageMinutesPerDay': 52,
          'muscleBuildingUnitsActual': 3,
          'muscleBuildingUnitsStandard': 4,
          'muscleMaintenanceUnitsActual': 2,
          'muscleMaintenanceUnitsStandard': 2,
        },
      ],

      // "nutritionTracking": ranges ["من 09/07/2026 إلى 15/07/2026"]
      'nutritionTrackingModule': [
        {
          'dateRange': {
            'from': '2026-07-09T00:00:00',
            'to': '2026-07-15T00:00:00',
          },
          'nutritionReport': [
            {
              'nutrient': 'السعرات الحرارية',
              'dailyAverageActual': 2100,
              'dailyAverageStandard': 2400,
              'actualCumulative': 14700,
              'standardCumulative': 16800,
              'difference': -2100,
              'percentage': 87.5,
            },
            {
              'nutrient': 'البروتين',
              'dailyAverageActual': 78,
              'dailyAverageStandard': 90,
              'actualCumulative': 546,
              'standardCumulative': 630,
              'difference': -84,
              'percentage': 86.6,
            },
            {
              'nutrient': 'الدهون',
              'dailyAverageActual': 70,
              'dailyAverageStandard': 65,
              'actualCumulative': 490,
              'standardCumulative': 455,
              'difference': 35,
              'percentage': 107.6,
            },
          ],
        },
      ],

      // "monthlyHealthSurveySection": getAll true.
      // NOTE: the model reads the capitalized key `MonthlyHealthSurveySection`
      // while the request sends `monthlyHealthSurveySection` — if the backend
      // answers with the lowercase key this whole section is silently dropped.
      'MonthlyHealthSurveySection': {
        'columns': [
          'يناير 2026',
          'فبراير 2026',
          'مارس 2026',
          'أبريل 2026',
          'مايو 2026',
          'يونيو 2026',
          'يوليو 2026',
        ],
        'rows': [
          {
            'question': 'هل تشعر بالقدرة على ممارسة أنشطتك اليومية بشكل طبيعي؟',
            'answersOverMonths': [
              'نعم',
              'نعم',
              'أحيانا',
              'نعم',
              'لا',
              'أحيانا',
              'نعم',
            ],
          },
          {
            'question': 'هل تعاني من اضطراب في النوم خلال الشهر الماضي؟',
            'answersOverMonths': ['لا', 'أحيانا', 'نعم', 'نعم', null, 'لا'],
          },
        ],
      },

      // "riskyBehaviourSection": section ["التدخين"]
      'riskyBehaviour': [
        {
          'startDate': '2010-06-01T00:00:00',
          'section': 'التدخين',
          'type': 'سجائر',
          'usageRate': '20 سيجارة يوميا',
          'status': 'مستمر',
        },
      ],

      // "vaccine": years [2026]
      'vaccines': [
        {
          'date': '2026-02-14T00:00:00',
          'code': 'INF',
          'vaccineName': 'لقاح الإنفلونزا الموسمية',
          'vaccineCategory': 'لقاحات موسمية',
          'dose': 'جرعة واحدة',
          'targetDisease': 'الإنفلونزا',
          'vaccineActionDescription':
              'يحفز الجهاز المناعي لإنتاج أجسام مضادة ضد سلالات الإنفلونزا الموسمية',
        },
      ],
    };
