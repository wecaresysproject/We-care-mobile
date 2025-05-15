import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm/utils/alarm_set.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/emergency_complaints/data/models/medical_complaint_model.dart';
import 'package:we_care/features/medicine/data/models/get_all_user_medicines_responce_model.dart';
import 'package:we_care/features/medicine/data/models/medicine_data_entry_request_body.dart';
import 'package:we_care/features/medicine/data/repos/medicine_data_entry_repo.dart';
import 'package:we_care/features/medicine/medicines_data_entry/Presentation/views/alarm/alarm_demo/services/notifications.dart';
import 'package:we_care/features/medicine/medicines_data_entry/Presentation/views/alarm/alarm_demo/services/permission.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_state.dart';
import 'package:we_care/generated/l10n.dart';

class MedicinesDataEntryCubit extends Cubit<MedicinesDataEntryState> {
  MedicinesDataEntryCubit(this._medicinesDataEntryRepo)
      : super(
          MedicinesDataEntryState.initialState(),
        ) {
    AlarmPermissions.checkNotificationPermission().then(
      (_) => AlarmPermissions.checkAndroidScheduleExactAlarmPermission(),
    );
    unawaited(loadAlarms());
    ringSubscription ??= Alarm.ringing.listen(onAlarmRingingChanged);
    updateSubscription ??= Alarm.scheduled.listen(
      (_) {
        unawaited(loadAlarms());
      },
    );
    notifications = Notifications();
  }
  Future<void> loadAlarms() async {
    final updatedAlarms = await Alarm.getAlarms();
    updatedAlarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);

    // setState(
    //   () {
    //     alarms = updatedAlarms;
    //   },
    // );
  }

  ///called immediately after the alarm rings
  Future<void> onAlarmRingingChanged(AlarmSet alarms) async {
    if (alarms.alarms.isEmpty) return;
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(
    //     builder: (context) => MedicineAlarmRingingScreen(
    //       alarmSettings: alarms.alarms.first,
    //     ),
    //   ),
    // );
    //!listen to ui using listner to navigate to MedicineAlarmRingingScreen using state.ringingAlarm
    emit(
      state.copyWith(
        ringingAlarm: alarms.alarms.first,
      ),
    );
    unawaited(loadAlarms());
  }

  List<AlarmSettings> alarms = [];
  Notifications? notifications;

  static StreamSubscription<AlarmSet>? ringSubscription;
  static StreamSubscription<AlarmSet>? updateSubscription;

  final MedicinesDataEntryRepo _medicinesDataEntryRepo;
  final personalInfoController = TextEditingController();
  List<MedicalComplaint> medicalComplaints = [];
  Future<void> fetchAllAddedComplaints() async {
    try {
      final medicalComplaintBox =
          Hive.box<MedicalComplaint>("medical_complaints");
      medicalComplaints = medicalComplaintBox.values.toList(growable: true);
      emit(
        state.copyWith(
          medicalComplaints: medicalComplaints,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          medicalComplaints: [],
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> loadMedicinesDataEnteredForEditing(
    MedicineModel pastDataEntered,
  ) async {
    await storeTempUserPastComplaints(pastDataEntered.mainSymptoms);

    emit(
      state.copyWith(
        medicineStartDate: pastDataEntered.startDate,
        selectedMedicineName: pastDataEntered.medicineName,
        selectedMedicalForm: pastDataEntered.usageMethod,
        selectedDose: pastDataEntered.dosage,
        selectedNoOfDose: pastDataEntered.dosageFrequency,
        doseDuration: pastDataEntered.usageDuration,
        timePeriods: pastDataEntered.timeDuration,
        selectedChronicDisease: pastDataEntered.chronicDiseaseMedicine,
        medicalComplaints: pastDataEntered.mainSymptoms,
        selectedDoctorName: pastDataEntered.doctorName,
        selectedAlarmTime: pastDataEntered.reminder,
        isEditMode: true,
        updatedDocumentId: pastDataEntered.id,
      ),
    );
    personalInfoController.text = pastDataEntered.personalNotes;
    validateRequiredFields();
    await initialDataEntryRequests();
  }

  Future<void> storeTempUserPastComplaints(
      List<MedicalComplaint> emergencyComplaints) async {
    final medicalComplaintBox =
        Hive.box<MedicalComplaint>("medical_complaints");

    // Loop through the list and store each complaint in the box
    for (var oldComplains in emergencyComplaints) {
      await medicalComplaintBox.add(oldComplains);
    }
  }

  Future<void> submitEditsForMedicine() async {
    emit(
      state.copyWith(
        medicinesDataEntryStatus: RequestStatus.loading,
      ),
    );
    final response =
        await _medicinesDataEntryRepo.editSpecifcMedicineDataDetails(
      medicineId: state.updatedDocumentId,
      requestBody: MedicineDataEntryRequestBody(
        startDate: state.medicineStartDate!,
        medicineName: state.selectedMedicineName!,
        usageMethod: state.selectedMedicalForm!,
        dosage: state.selectedDose!,
        dosageFrequency: state.selectedNoOfDose!,
        usageDuration: state.doseDuration!,
        timeDuration: state.timePeriods!,
        chronicDiseaseMedicine: state.selectedChronicDisease!,
        doctorName: state.selectedDoctorName!,
        reminder: state.selectedAlarmTime!,
        reminderStatus: state.selectedAlarmTime.isNotNull ? true : false,
        personalNotes: personalInfoController.text,
        userMedicalComplaint: state.medicalComplaints,
      ),
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
    );

    response.when(
      success: (successMessage) {
        emit(
          state.copyWith(
            medicinesDataEntryStatus: RequestStatus.success,
            message: successMessage,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            medicinesDataEntryStatus: RequestStatus.failure,
            message: error.errors.first,
          ),
        );
      },
    );
  }

  Future<void> initialDataEntryRequests() async {
    await emitAllMedicinesNames();
    await emitAllDosageFrequencies();
    await getAllUsageCategories();
  }

  Future<void> emitAllMedicinesNames() async {
    emit(
      state.copyWith(
        medicinesNamesOptionsLoadingState: OptionsLoadingState.loading,
      ),
    );
    final response = await _medicinesDataEntryRepo.getAllMedicinesNames(
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
    );
    response.when(
      success: (response) {
        final medcineNames = response.map((e) => e.tradeName).toList();
        emit(
          state.copyWith(
            medicinesNames: medcineNames,
            medicinesBasicInfo: response,
            medicinesNamesOptionsLoadingState: OptionsLoadingState.loaded,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            isLoading: false,
            medicinesNamesOptionsLoadingState: OptionsLoadingState.error,
          ),
        );
      },
    );
  }

  void getMedcineIdByName(String selectedMedicineName) {
    for (final medcineInfo in state.medicinesBasicInfo!) {
      if (medcineInfo.tradeName == selectedMedicineName) {
        emit(
          state.copyWith(
            medicineId: medcineInfo.id,
          ),
        );
        return;
      }
    }
  }

  Future<void> emitMedicineforms() async {
    emit(
      state.copyWith(
        medicalFormsOptionsLoadingState: OptionsLoadingState.loading,
      ),
    );
    final response = await _medicinesDataEntryRepo.getMedcineForms(
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      medicineId: state.medicineId,
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            medicineForms: response,
            medicalFormsOptionsLoadingState: OptionsLoadingState.loaded,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            medicalFormsOptionsLoadingState: OptionsLoadingState.error,
          ),
        );
      },
    );
  }

  Future<void> emitMedcineDosesByForms() async {
    emit(
      state.copyWith(
        medicalDosesOptionsLoadingState: OptionsLoadingState.loading,
      ),
    );
    final response = await _medicinesDataEntryRepo.getMedcineDosesByForms(
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name,
      medicineId: state.medicineId,
      medicineForm: state.selectedMedicalForm ?? "", //TODO: handle this later
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            medicalDoses: response,
            medicalDosesOptionsLoadingState: OptionsLoadingState.loaded,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            medicalDosesOptionsLoadingState: OptionsLoadingState.error,
          ),
        );
      },
    );
  }

  Future<void> emitAllDosageFrequencies() async {
    emit(
      state.copyWith(
        dosageFrequenciesOptionsLoadingState: OptionsLoadingState.loading,
      ),
    );
    final response = await _medicinesDataEntryRepo.getAllDosageFrequencies(
      langauge: AppStrings.arabicLang,
      userType: UserTypes.patient.name,
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            dosageFrequencies: response,
            dosageFrequenciesOptionsLoadingState: OptionsLoadingState.loaded,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            dosageFrequenciesOptionsLoadingState: OptionsLoadingState.error,
          ),
        );
      },
    );
  }

  Future<void> getAllUsageCategories() async {
    emit(
      state.copyWith(
        allUsageCategoriesOptionsLoadingState: OptionsLoadingState.loading,
      ),
    );
    final response = await _medicinesDataEntryRepo.getAllUsageCategories(
      langauge: AppStrings.arabicLang,
      userType: UserTypes.patient.name,
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            allUsageCategories: response,
            allUsageCategoriesOptionsLoadingState: OptionsLoadingState.loaded,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            allUsageCategoriesOptionsLoadingState: OptionsLoadingState.error,
          ),
        );
      },
    );
  }

  Future<void> emitAllDurationsForCategory() async {
    emit(
      state.copyWith(
        allDurationsBasedOnCategoryOptionsLoadingState:
            OptionsLoadingState.loading,
      ),
    );
    final response = await _medicinesDataEntryRepo.getAllDurationsForCategory(
      langauge: AppStrings.arabicLang,
      userType: UserTypes.patient.name,
      category: state.doseDuration!,
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
            allDurationsBasedOnCategory: response,
            allDurationsBasedOnCategoryOptionsLoadingState:
                OptionsLoadingState.loaded,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            allDurationsBasedOnCategoryOptionsLoadingState:
                OptionsLoadingState.error,
          ),
        );
      },
    );
  }

  Future<void> getMedicineDetails(String medicineId) async {
    final response = await _medicinesDataEntryRepo.getMedicineDetailsById(
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name,
      medicineId: medicineId,
    );
    response.when(
      success: (response) {
        emit(
          state.copyWith(
              // medicineDetails: response,
              ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
          ),
        );
      },
    );
  }

  Future<void> postMedicinesDataEntry(S locale) async {
    emit(
      state.copyWith(
        medicinesDataEntryStatus: RequestStatus.loading,
      ),
    );
    final response = await _medicinesDataEntryRepo.postMedicinesDataEntry(
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      requestBody: MedicineDataEntryRequestBody(
        startDate: state.medicineStartDate!,
        medicineName: state.selectedMedicineName!,
        usageMethod: state.selectedMedicalForm!,
        dosage: state.selectedDose!,
        dosageFrequency: state.selectedNoOfDose!,
        usageDuration: state.doseDuration!,
        timeDuration: state.timePeriods!,
        chronicDiseaseMedicine: locale.no_data_entered,
        doctorName: state.selectedDoctorName ?? locale.no_data_entered,
        reminder: state.selectedAlarmTime ?? locale.no_data_entered,
        reminderStatus: state.selectedAlarmTime.isNotNull ? true : false,
        personalNotes: personalInfoController.text.isNotEmpty
            ? personalInfoController.text
            : locale.no_data_entered,
        userMedicalComplaint: state.medicalComplaints,
      ),
      language: AppStrings.arabicLang,
    );
    response.when(
      success: (successMessage) {
        emit(
          state.copyWith(
            message: successMessage,
            medicinesDataEntryStatus: RequestStatus.success,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            message: error.errors.first,
            medicinesDataEntryStatus: RequestStatus.failure,
          ),
        );
      },
    );
  }

  Future<void> removeAddedMedicalComplaint(int index) async {
    final Box<MedicalComplaint> medicalComplaintsBox =
        Hive.box<MedicalComplaint>("medical_complaints");

    if (index >= 0 && index < medicalComplaintsBox.length) {
      await medicalComplaintsBox.deleteAt(index);
    }
  }

  Future<void> clearAllAddedComplaints() async {
    try {
      final medicalComplaintBox =
          Hive.box<MedicalComplaint>("medical_complaints");
      await medicalComplaintBox.clear();
    } catch (e) {
      emit(
        state.copyWith(
          message: e.toString(),
        ),
      );
    }
  }

  Duration? getTotalDurationFromText(String durationText) {
    switch (durationText.trim()) {
      case "6 أسابيع":
        return const Duration(days: 6 * 7); // 6 أسابيع (أسبوع = 7 أيام)

      case "شهرين":
        return const Duration(days: 2 * 30); // شهرين (تم افتراض 30 يوم لكل شهر)

      case "3 أشهر":
        return const Duration(days: 3 * 30); // 3 أشهر

      case "6 أشهر":
        return const Duration(days: 6 * 30); // 6 أشهر

      case "9 أشهر":
        return const Duration(days: 9 * 30); // 9 أشهر

      case "سنة واحدة":
        return const Duration(days: 365); // سنة واحدة

      case "سنتين":
        return const Duration(days: 365 * 2); // سنتين

      case "3 سنوات":
        return const Duration(days: 365 * 3); // 3 سنوات

      case "مدى الحياة":
        return null; // مدة غير محددة

      case "يوم واحد فقط":
        return const Duration(days: 1); // يوم واحد فقط

      case "يومين":
        return const Duration(days: 2); // يومين

      case "3 أيام":
        return const Duration(days: 3); // 3 أيام

      case "5 أيام":
        return const Duration(days: 5); // 5 أيام

      case "7 أيام (أسبوع)":
        return const Duration(days: 7); // 7 أيام (أسبوع)

      case "10 أيام":
        return const Duration(days: 10); // 10 أيام

      case "14 يومًا (أسبوعين)":
        return const Duration(days: 14); // 14 يومًا (أسبوعين)

      case "21 يومًا (3 أسابيع)":
        return const Duration(days: 21); // 21 يومًا (3 أسابيع)

      case "شهر (30 يومًا)":
        return const Duration(days: 30); // شهر (30 يومًا)

      case "4 أيام":
        return const Duration(days: 4); // 4 أيام

      case "حتى انتهاء العبوة":
        return null; // يتم تحديدها حسب حالة الدواء

      case "حتى زوال الأعراض":
        return null; // يتم تحديدها بناءً على زوال الأعراض

      case "حتى مراجعة الطبيب":
        return null; // يعتمد على موعد مراجعة الطبيب

      case "حسب الحاجة":
        return null; // يتم تحديدها عند الحاجة فقط

      case "حسب استجابة المريض":
        return null; // يتم تحديدها بناءً على استجابة المريض

      case "حسب إرشادات الطبيب":
        return null; // يتم تحديدها بناءً على إرشادات الطبيب

      // إضافات جديدة:
      case "يومين في الأسبوع":
        return const Duration(days: 2 * 7); // يومين في الأسبوع

      case "3 أيام في الأسبوع":
        return const Duration(days: 3 * 7); // 3 أيام في الأسبوع

      case "أسبوع كل شهر":
        return const Duration(days: 7); // أسبوع كل شهر

      case "10 أيام كل شهر":
        return const Duration(days: 10); // 10 أيام كل شهر

      case "استخدام موسمي":
        return null; // يعتمد على الموسم المحدد

      default:
        return null; // نص غير معروف أو حالة غير محددة
    }
  }

  Duration? getRepeatDurationFromText(String frequencyText) {
    switch (frequencyText.trim()) {
      case "مرة واحدة يوميًا":
      case "مرة واحدة يوميًا فق":
        return const Duration(days: 1);

      case "مرتين يوميًا (كل 12 ساعة)":
      case "مرتين يوميًا (كل 12 ساعة) فقط":
        return const Duration(hours: 12);

      case "3 مرات يوميًا (كل 8 ساعات)":
        return const Duration(hours: 8);

      case "4 مرات يوميًا (كل 6 ساعات)":
        return const Duration(hours: 6);

      case "5 مرات يوميًا":
        return const Duration(
            hours: 4, minutes: 48); // تقريبًا كل 4 ساعات و 48 دقيقة

      case "كل ساعتين":
        return const Duration(hours: 2);

      case "كل 3 ساعات":
        return const Duration(hours: 3);

      case "كل 4 ساعات":
        return const Duration(hours: 4);

      case "كل 6 ساعات":
        return const Duration(hours: 6);

      case "كل 8 ساعات":
        return const Duration(hours: 8);

      case "كل 12 ساعة":
        return const Duration(hours: 12);

      case "مرة واحدة في الأسبوع":
        return const Duration(days: 7);

      case "مرتين في الأسبوع":
        return const Duration(days: 3); // كل 3-4 أيام تقريبا

      case "3 مرات في الأسبوع":
        return const Duration(days: 2); // كل يومين تقريبا

      case "مرة كل 10 أيام":
        return const Duration(days: 10);

      case "مرة كل 15 يوم":
        return const Duration(days: 15);

      case "مرة كل شهر":
        return const Duration(days: 30);

      case "قبل النوم":
      case "قبل النوم فقط":
        return const Duration(days: 1); // تعامل معه كأنها مرة يومياً قبل النوم

      // الحالات الخاصة - مش لها تكرار ثابت:
      case "عند الحاجة فقط":
      case "بعد كل وجبة رئيسية":
      case "بعد الوجبات الخفيفة":
      case "عند الشعور بالألم":
      case "عند ظهور الأعراض":
      case "حسب تعليمات الطبيب":
      case "عند اللزوم":
      case "عند الحاجة":
      case "تحديث":
        return null; // مالهاش Duration ثابت - ما تحطش منبه او تسأل الدكتور مثلا.

      default:
        return null; // أي نص مش مفهوم نرجع null
    }
  }

  void updateSelectedAlarmTime(String? alarmTime) {
    emit(
      state.copyWith(
        selectedAlarmTime: alarmTime,
      ),
    );
  }

  /// Update Field Values
  void updateStartMedicineDate(String? date) {
    emit(state.copyWith(medicineStartDate: date));
    validateRequiredFields();
  }

  Future<void> updateSelectedMedicineName(String? medicineName) async {
    emit(state.copyWith(selectedMedicineName: medicineName));
    validateRequiredFields();
    getMedcineIdByName(medicineName!);
    await emitMedicineforms();
  }

  Future<void> updateSelectedMedicalForm(String? form) async {
    emit(state.copyWith(selectedMedicalForm: form));
    await emitMedcineDosesByForms();
    validateRequiredFields();
  }

  void updateSelectedDose(String? dose) {
    emit(state.copyWith(selectedDose: dose));
    validateRequiredFields();
  }

  void updateSelectedDoseFrequency(String? noOfDose) {
    emit(state.copyWith(selectedNoOfDose: noOfDose));
    validateRequiredFields();
  }

  Future<void> updateSelectedDoseDuration(String? doseDuration) async {
    emit(state.copyWith(doseDuration: doseDuration));
    await emitAllDurationsForCategory();
    validateRequiredFields();
  }

  void updateSelectedTimePeriod(String? timePeriods) {
    emit(state.copyWith(timePeriods: timePeriods));
    validateRequiredFields();
  }

  void updateSelectedChronicDisease(String? value) {
    emit(state.copyWith(selectedChronicDisease: value));
  }

  void updateSelectedDoctorName(String? value) {
    emit(state.copyWith(selectedDoctorName: value));
  }

  void validateRequiredFields() {
    if (state.medicineStartDate == null ||
        state.selectedMedicineName == null ||
        state.selectedMedicalForm == null ||
        state.selectedDose == null ||
        state.selectedNoOfDose == null ||
        state.doseDuration == null ||
        state.timePeriods == null) {
      emit(
        state.copyWith(
          isFormValidated: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isFormValidated: true,
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    personalInfoController.dispose();
    await clearAllAddedComplaints();
    ringSubscription?.cancel();
    updateSubscription?.cancel();
    return super.close();
  }
}
