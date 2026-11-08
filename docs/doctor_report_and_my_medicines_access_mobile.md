# Doctor access to "إعداد التقرير الطبي" and "توافق أدويتي": mobile plan

The backend side is in `doctor_report_and_my_medicines_access_backend.md`.

## Context
In a video call, the doctor can already open the patient's medical file, limited to the modules the patient allowed at booking. See `doctor_patient_medical_file_access.md`. That flow is built from:
- `PatientMedicalFileLauncher`
- `GET /DoctorBookings/bookings/patient-access`
- care mode with the `Active-Medical-Profile` header
- locked cards for modules the patient did not allow

Two more tiles in the call grid now follow the same rule:
1. **إعداد التقرير الطبي** (medical report)
2. **توافق أدويتي** (my-medicines compatibility)

Before this change, both tiles did nothing on tap. The screens behind them, `my_medical_reports` and `medicines_compatibility`, are patient-side screens. They read the current user's data and check no module permissions.

Agreed rules:
- Only these two tiles for now. "توافق دواء جديد" and "الروشتة" come later.
- In the report, modules the patient did not allow show **locked**, the same way as in the medical file.
- "توافق أدويتي" needs the `medications` module. Without it the tile is locked and shows a message.
- `basicInformation` is always granted to a doctor with an open booking. The booking screen never offers it, but the report and the AI depend on it.

## Approach
Reuse the doctor care mode. Tapping either tile does this:
1. Fetch the booking's patient-access.
2. Enter care mode: doctor source, read-only, with an expiry timer, and close on a 403.
3. Push the existing patient screen.

Inside each screen, each module is gated by the existing `CareContextManager.hasModuleAccessForViewMedicalFilesCategory`. That helper returns `true` outside care mode, so the patient's own experience does not change.

### 1. Generalize the launcher
`lib/features/doctor/patient_medical_file/presentation/patient_medical_file_launcher.dart`
- `open(...)` takes two optional params:
  - `route`, which defaults to `Routes.medicalCategoriesTypesView`
  - `requiredModule`
- After the existing checks for an expired window and for no allowed module: if `requiredModule` is set and not allowed, show `'المريض لم يسمح بالوصول لـ{module.nameAr}'` and do not enter.
- Push `route` instead of the hardcoded medical categories route.
- Everything else is unchanged: closing via `popUntil`, the expiry timer, and exiting on return.

`lib/features/doctor/patient_medical_file/data/models/booking_patient_access_model.dart`
- If `basicInformation` is missing from `modulePermissions`, add it as `VIEW_ONLY`. This is a fallback until the backend sends it.
- `hasAnyModule` ignores `basicInformation`. Otherwise a booking with no other module would look like it has access.
- New helper `allows(MedicalModule)`.

### 2. Call grid: wire and lock the tiles
In `video_call_actions_grid_widget.dart` and `video_call_action_tile_widget.dart`:
- New callbacks: `onMedicalReportTap` and `onMyMedicinesCompatibilityTap`.
- New per-tile `isLocked` flag. A locked tile is dimmed with a lock icon. Tapping it shows a message instead of opening anything.

In `video_call_view.dart`:
- `initState` fetches patient-access once through `PatientMedicalFileRepo`, so the tiles can be locked before any tap.
  - "توافق أدويتي" is locked when `medications` is not allowed.
  - Both tiles are locked when access has expired or no module is allowed.
- Each tap still goes through `PatientMedicalFileLauncher.open(...)`, which re-checks expiry at open time:
  - Report: `route: Routes.myMedicalReportsView`
  - My medicines: `route: Routes.medicinesCompatibilityView`, `requiredModule: MedicalModule.medications`

### 3. Medical report in doctor mode
`lib/features/my_medical_reports/presentation/views/my_medical_reports_view.dart`
- For each category: `hasAccess = CareContextManager.hasModuleAccessForViewMedicalFilesCategory(category.moduleNameIdentifier)`.
- `MedicalReportCategoryItem` gets `isLocked`. A locked item has a dim overlay and `Icons.lock_outline`, matching `MedicalCategoryItem` in `medical_categories_types_grid_view.dart`.
- A locked section ignores the checkbox and the expand toggle, and its filters are never fetched.
- In doctor mode, the title is `'التقرير الطبي للمريض'`.

`lib/features/my_medical_reports/logic/medical_report_generation_cubit.dart` (`emitGenerateReport`): in care mode, every disallowed module's section is sent as `null` via `_ifAllowed(...)`. Outside care mode the request is unchanged.

`lib/features/my_medical_reports/presentation/widgets/export_report_dialog.dart`
- The "attach to backend" checkbox is hidden when `CareContextManager.isReadOnly`, because the upload is a write.
- PDF export and AI consult stay.

`qualityOfLife` is never offered at booking, so it is always locked for doctors. This is expected.

### 4. My-medicines compatibility in doctor mode
- The medicine list comes from `MedicalReports/medicines/filters`. With the header, it returns the patient's medicines. `requiredModule` already guarantees access to `medications`.
- The screen sends the whole medical file to DeepSeek through a direct HTTP call, not through our backend. That file is `UserMedicalHistoryDetailsModel`, from `full-report-Medical-file-data`. So the app strips disallowed modules before sending:
  - `UserMedicalHistoryDetailsModel.limitedToAllowedModules()` returns a copy. A field is `null` whenever `hasModuleAccessForViewMedicalFilesCategory(module)` is `false`.
  - `MedicinesCompatibilityCubit.getUserMedicalHistoryDetails` applies it before storing the file in state.

Field → module:

| Field | Module | Field | Module |
|---|---|---|---|
| basicInformation | basicInformation | allergy | allergies |
| vitalSigns | vitalSigns | eyeModule | eyes |
| chronicDiseases | chronicDiseases | teethModule | dental |
| complaintsModule | urgentComplaints | mentalIllnessModule | mentalHealth |
| preDescriptions | doctorsPrescriptions | nutritionTrackingModule | smartNutritionalAnalyzer |
| medicalTests | medicalTests | physicalActivityModule | sportsActivity |
| radiology | radiology | supplementsModule | supplements |
| surgeryEntries | surgeries | vaccines | vaccinations |
| geneticDiseases | geneticDiseases | riskyBehaviour | riskyBehaviors |
| | | monthlyHealthSurvey | qualityOfLife |

## Files touched
- `lib/features/doctor/patient_medical_file/presentation/patient_medical_file_launcher.dart`
- `lib/features/doctor/patient_medical_file/data/models/booking_patient_access_model.dart`
- `lib/features/doctor/video_call/presentation/views/video_call_view.dart`
- `lib/features/doctor/video_call/presentation/views/widgets/video_call_actions_grid_widget.dart`
- `lib/features/doctor/video_call/presentation/views/widgets/video_call_action_tile_widget.dart`
- `lib/features/my_medical_reports/presentation/views/my_medical_reports_view.dart` and the `MedicalReportCategoryItem` widget
- `lib/features/my_medical_reports/logic/medical_report_generation_cubit.dart`
- `lib/features/my_medical_reports/presentation/widgets/export_report_dialog.dart`
- `lib/features/medicine/data/models/user_medical_history_details_model.dart`
- `lib/features/home_tab/Presentation/views/medicines_compatibility/logic/medicines_compatibility_cubit.dart`

All new UI text is hard-coded Arabic, with no ARB keys. There are no Retrofit changes.

## Verification (after the backend confirms its part)
1. Book with only `vitalSigns` and `medications` allowed, then start the call as the doctor.
   - **Report**:
     - Only basic info, vital signs and medications can be selected. The rest are locked.
     - The report contains the patient's data.
     - There is no upload checkbox.
     - The banner shows the doctor text, and "إغلاق الملف" returns to the call with the call still running.
   - **My medicines**: the screen shows the patient's medicines. The AI request contains only `basicInformation` and `vitalSigns`.
2. Book without `medications`: "توافق أدويتي" is locked and shows the message.
3. Let the window expire while inside a screen: the app goes back to the call and shows 'انتهت صلاحية الوصول لملف المريض'.
4. As a patient, outside care mode: both screens are unchanged.
5. Run `flutter analyze`.
