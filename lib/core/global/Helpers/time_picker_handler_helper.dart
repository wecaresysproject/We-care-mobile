// time_picker_handler.dart
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';

class TimePickerHandler {
  /// Shows a time picker dialog and returns the selected TimeOfDay.
  Future<TimeOfDay?> showPicker(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: 'اختيار الوقت',
      barrierColor: const Color.fromARGB(72, 0, 0, 0), // Back of dialog
      orientation: Orientation.portrait,
      barrierDismissible: true,
      initialEntryMode: TimePickerEntryMode.dial,
      anchorPoint: const Offset(0, 2),
      cancelText: 'إلغاء',
      hourLabelText: 'ساعه',
      errorInvalidText: 'الوقت غير صالح',
      minuteLabelText: 'دقيقه',
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: false,
          ),
          child: child!,
        );
      },
    );

    return pickedTime; // Return the selected time
  }

  /// Converts a TimeOfDay to TZDateTime in the local timezone.
  TZDateTime convertTimeOfDayToTZDateTime(TimeOfDay time) {
    final now = DateTime.now(); // Get the current date

    // Create a DateTime object for the selected time
    final DateTime selectedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // Convert to TZDateTime in the local timezone
    return tz.TZDateTime.from(
      selectedDateTime,
      tz.local,
    );
  }

  TimeOfDay? convertStringToTimeOfDay(String? timeString) {
    if (timeString == null || timeString.isEmpty) return null;

    // Split the time string into hours and minutes
    final parts = timeString.split(':');
    int hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1].substring(0, 2));

    // Determine whether it's AM or PM
    final isPM = timeString.contains('م');

    // Adjust hours if it's PM
    if (isPM && hours != 12) {
      hours += 12;
    }

    // Create the TimeOfDay object
    return TimeOfDay(hour: hours, minute: minutes);
  }
}
