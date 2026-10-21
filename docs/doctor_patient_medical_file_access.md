# Doctor access to the patient's medical file

## Context
When a patient books, they pick an **access duration** and **which modules** the doctor may see. The doctor needs to open that patient's medical file: the module grid with each module's ticket count, and the details inside each module. The rules:
- Only the allowed modules can be opened. The rest show as locked.
- Access works only inside the allowed duration.
- The doctor can only read. No add, edit or delete.

We reuse the existing care mode: `CareContextManager`, the `Active-Medical-Profile` header, and the locked cards on the medical file screen. Three things are new:
1. The backend returns the booking's permissions and enforces them.
2. The banner says this is doctor access.
3. Add/edit/delete buttons are hidden in doctor mode.

---

## Part 1: Backend plan (to share with the backend team)

### The idea
The patient grants a doctor read-only access to selected modules for a set number of hours, starting at booking time. The doctor can read only those modules, only within that window, and can never write.

### 1) New endpoint: doctor's access to a booking's patient
`GET /DoctorBookings/bookings/patient-access?bookingId={id}` (the app already calls this path; it can be renamed)

```json
{
  "data": {
    "patientId": "123",
    "patientName": "Ahmed Mohamed",
    "accessExpiresAt": "2026-10-20T12:00:00Z",
    "modulePermissions": [
      { "moduleName": "medications", "permission": "VIEW_ONLY", "isEnabledModule": true },
      { "moduleName": "radiology",   "permission": "VIEW_ONLY", "isEnabledModule": true }
    ]
  }
}
```
- `modulePermissions` uses the same shape as the existing care-access permissions (`ModulePermissionDto`).
- `permission` is always `VIEW_ONLY` for doctors.
- Module names are the same values the booking request sends in `dataAccessModules`.
- If no modules were allowed, or the window has expired, return an empty `modulePermissions` or a 403 with a clear message.

### 2) Reading patient data: reuse the existing endpoints
The doctor calls the **same module view endpoints and ticket-count endpoint** the patient uses, plus this header (already used by family care access):
```
Active-Medical-Profile: {patientId}
```

When a request comes from a **doctor** with this header, the server must check:
| Check | If it fails |
|---|---|
| A booking exists between this doctor and this patient | 403 |
| The access window is still open (`now < accessExpiresAt`) | 403 |
| The requested module is one the patient allowed | 403 |
| The request is a read (GET) | any POST/PUT/DELETE → 403 |

- The ticket-count endpoint (`getAllCategoriesTicketsCount`) must return the **patient's** counts, not the doctor's, when the header is present.
- These checks must happen on the server. The app only hides things; that alone does not protect the data.
- When access is cut mid-session, return **403**. The app closes the file on any 403 while in doctor mode.

### 2b) Bookings list: add the access end time
Add `dataAccessExpiresAt` (ISO date, or `null` when the patient allowed no access) to each item of `appointments[]` in `GET /DoctorBookings/bookings`. The "الملف الطبي" button on the booking row only shows while this time is in the future.

### 3) Duration rules (agreed)
- The window starts **at booking time**: `accessExpiresAt = bookingCreatedAt + dataAccessDurationHours`.
- The doctor can open the file **any time inside the window**: before, during or after the appointment, not only during the call.
- No duration picked (`dataAccessDurationHours = null`) means **no access**. The app treats a missing `accessExpiresAt` / `dataAccessExpiresAt` as no access.

### 4) Verified against the live server (2026-10-20)
Works as planned:
- `GET /api/DoctorBookings/bookings/patient-access?bookingId=` returns exactly the shape in section 1. Dates look like `2040-06-26T13:04:05.766+00:00`. `moduleName` values are `MedicalModule` names (e.g. `vitalSigns`).
- Booking not this doctor's → `403 {"success":false,"message":"You are not authorized to access this patient's medical file"}`.
- Window expired → `403` with `message: "Patient medical file access has expired"` and `data` (empty `modulePermissions`).
- `Ticket/count` with `Active-Medical-Profile` returns the patient's counts.

Still missing on the backend:
- **No server-side enforcement on module endpoints.** With the header, a doctor gets 200 + data for modules the patient did not allow (e.g. `MedicineUserEntryPage/GetUserMedicines` when only `vitalSigns` was allowed), and for a patient whose window has **expired**. Section 2's 403 checks are not implemented. The app also relies on that 403 to close the file mid-session.
- Bookings list: could not confirm `dataAccessExpiresAt` on `appointments[]` items (the test doctor had no bookings today). Until it's there, the booking-row button stays hidden; the video-call tile still works.
- Write requests (POST/PUT/DELETE) as a doctor were not tested, to avoid changing patient data.

---

## Part 2: Mobile

### A) Mark the context as doctor access
In `lib/core/networking/models/care_context_manager_model.dart`:
- Add to `CareContext`:
  - `CareAccessSource source` (`family` / `doctorBooking`)
  - `DateTime? expiresAt`
  - `onClose(reason)`: closes the file and returns to the screen that opened it.
- `enter(...)` accepts these fields and defaults to `family`, so existing callers don't change.
- Add getters:
  - `isDoctorAccess`
  - `isReadOnly`, which equals `isDoctorAccess`. The UI checks this one.

### B) Banner text (`lib/core/global/SharedWidgets/global_care_context_banner.dart`)
When `source == doctorBooking`:
- Text: "أنت تتصفح الملف الطبي للمريض {patientName} — صلاحية عرض فقط". If `expiresAt` is set, add a small line: "متاح حتى {hh:mm}".
- Exit button: "إغلاق الملف". It calls `CareContextManager.exit()`, through `onClose`, which pops back to the screen that opened the file (the call or bookings). Do **not** use `pushNamedAndRemoveUntil(bottomNavBar)`, because that would kill the call.
- Confirmation text: "هل تريد إغلاق الملف الطبي للمريض؟"
- Family care mode keeps its current banner.

### C) Hide add/edit/delete buttons (hidden, not disabled)
1. **Shared widget:** `AppBarWithCenteredTitle` in `lib/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart`. Details screens in about 19 modules use it. In `_buildActionButtons`, return `SizedBox.shrink()` when `CareContextManager.isReadOnly`. That hides edit, delete and send. One change covers most modules.
2. **Buttons built inside individual modules.** Wrap each one in `if (!CareContextManager.isReadOnly)`:
   - `risky_behaviors/.../risky_behavior_data_view.dart` (edit icon)
   - `genetic_diseases/.../family_tree_view.dart` ("تعديل")
   - `Biometrics/.../biometrics_history_view.dart` (delete / edit / edit value)
   - `test_laboratory/.../similar_analysis_card.dart` ("تعديل النتيجه")
   - `x_ray/.../x_ray_data_view_app_bar.dart` (`ViewAppBar`: delete / share)
   - `quality_of_life/.../quality_of_life_main_view.dart` (add button)
3. **Data-entry entry points:** `view_or_edit_medical_record_view.dart` and the `show_data_entry_types` grid are already blocked. `hasModuleAccessForDataEntryMedicalFilesCategory` returns false for `VIEW_ONLY`. The doctor also lands directly on the view screen.

### D) Opening the file (from the call or from bookings)
- Two entry points:
  1. The "الملف الطبي" tile in the call, in `video_call_actions_grid_widget.dart`.
  2. A "الملف الطبي" button on the doctor's booking row (`doctor/bookings`). It shows only while the access window is open.
- Both use one shared flow, `PatientMedicalFileLauncher` (`lib/features/doctor/patient_medical_file/`):
  1. Call the endpoint through the service and repo.
  2. Call `CareContextManager.enter(source: doctorBooking, expiresAt, onClose, ...)`.
  3. `pushNamed(Routes.medicalCategoriesTypesView)`.
- Call `exit()` in three places:
  - after the pushed route returns
  - when the call ends
  - in `VideoCallView.dispose`
- On a 403, or once `expiresAt` has passed:
  - call `exit()`
  - go back to the screen that opened the file
  - show "انتهت صلاحية الوصول لملف المريض"
- All new UI text is hard-coded Arabic, with no ARB keys.
- Run `build_runner` after adding the Retrofit method.

## Verification
1. Mock the endpoint with two allowed modules and open the file from the call:
   - Only those two modules open. The rest are dimmed and locked.
   - The counts are the patient's.
2. Open a details screen (medications, radiology, vital signs): there is no edit, delete or send button.
3. The banner shows the doctor text. "إغلاق الملف" returns to the call with the call still running, or to bookings if the file was opened from there.
4. After the window expires, the bookings button disappears. If the doctor is inside the file, they are sent back with the expiry message.
5. In family care mode, the banner and buttons are unchanged.
6. Run `flutter analyze`.
