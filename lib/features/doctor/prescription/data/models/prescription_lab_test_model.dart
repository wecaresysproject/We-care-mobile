import 'package:equatable/equatable.dart';

/// One lab test row in the prescription: the group or English test name
/// the doctor picked, and the tests chosen from what's listed for it.
class PrescriptionLabTestModel extends Equatable {
  const PrescriptionLabTestModel({
    this.groupName,
    this.testNameEn,
    this.tests = const [],
  }) : assert(groupName != null || testNameEn != null);

  factory PrescriptionLabTestModel.fromJson(Map<String, dynamic> json) {
    final groupName = _nonBlank(json['groupName']);
    final testNameEn = _nonBlank(json['testNameEn']);
    return PrescriptionLabTestModel(
      // One of the two is always set by the app; fall back to an empty group
      // so a malformed row can't break the screen.
      groupName: groupName ?? (testNameEn == null ? '' : null),
      testNameEn: testNameEn,
      tests: [
        for (final test in json['tests'] as List<dynamic>? ?? const [])
          test.toString(),
      ],
    );
  }

  static String? _nonBlank(Object? value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? null : text;
  }

  Map<String, dynamic> toJson() => {
        'groupName': groupName,
        'testNameEn': testNameEn,
        'tests': tests,
      };

  /// المجموعة — picked, or the group of [testNameEn].
  final String? groupName;

  /// الاسم (En) — null when a group was picked.
  final String? testNameEn;

  /// The tests picked from the list — empty when nothing was listed
  /// (e.g. a typed name).
  final List<String> tests;

  /// What the table's "التحاليل" column shows.
  List<String> get testNames =>
      tests.isNotEmpty ? tests : [if (testNameEn != null) testNameEn!];

  @override
  List<Object?> get props => [groupName, testNameEn, tests];
}
