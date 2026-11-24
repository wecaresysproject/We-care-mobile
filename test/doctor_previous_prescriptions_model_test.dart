import 'package:flutter_test/flutter_test.dart';
import 'package:we_care/features/doctor/prescription/data/models/previous_prescription_model.dart';

void main() {
  test('parses patient and prescriptions, skipping ones without images', () {
    final model = PreviousPrescriptionsModel.fromJson({
      'patient': {'name': ' سارة ', 'age': 32, 'country': 'السعودية'},
      'prescriptions': [
        {
          'bookingId': 'b1',
          'date': '2026-11-10',
          'diagnosis': 'التهاب',
          'images': ['u1', '', null]
        },
        {'bookingId': 'b2', 'date': 'bad', 'diagnosis': null, 'images': []},
        'not a map',
      ],
    });
    expect(model.patient.name, 'سارة');
    expect(model.patient.age, 32);
    expect(model.prescriptions, hasLength(1));
    expect(model.prescriptions.single.images, ['u1']);
    expect(model.prescriptions.single.date, DateTime(2026, 11, 10));
  });

  test('missing data gives an empty list and null age', () {
    final model = PreviousPrescriptionsModel.fromJson(const {});
    expect(model.prescriptions, isEmpty);
    expect(model.patient.age, isNull);
  });
}
