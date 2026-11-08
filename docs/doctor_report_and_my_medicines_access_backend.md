# Doctor access to the medical report and "my medicines compatibility": backend requirements

## 1. Summary
During a video call, the doctor can now do two things for the patient:
1. **Generate a medical report** (إعداد التقرير الطبي).
2. **Run a "current medicines compatibility" check** (توافق أدويتي).

Both must follow the access the patient granted when booking:
- **Only allowed modules.** The doctor sees data only from the modules the patient picked at booking (`dataAccessModules`).
- **Only within the window.** Access works only before `accessExpiresAt`, which is `bookingCreatedAt + dataAccessDurationHours`.
- **Read-only.** The doctor can never create, edit, delete or upload anything for the patient.

This is the same model as the doctor's access to the patient's medical file. Both features reuse existing patient endpoints. The changes are in who may call them and what they return.

## 2. How the doctor calls
Every request carries:
- The **doctor's own** bearer token: `Authorization: Bearer {doctorToken}`
- `Active-Medical-Profile: {patientId}`. This is the same header the medical-file access already uses.

The filter endpoints keep receiving `userType=patient` and `language=ar` as query params. The header decides whose data is returned.

> **Please confirm:** is `userType=patient` correct for a doctor reading a patient's data, or should the app send a different value?

## 3. Change to `patient-access`
`GET /api/DoctorBookings/bookings/patient-access?bookingId={id}`

While the window is open, always include `basicInformation` in `modulePermissions`, even though the patient doesn't pick it at booking. The report and the compatibility check need age, gender, weight and similar data.

```json
{
  "data": {
    "patientId": "123",
    "patientName": "Ahmed Mohamed",
    "accessExpiresAt": "2026-11-02T12:00:00+00:00",
    "modulePermissions": [
      { "moduleName": "basicInformation", "permission": "VIEW_ONLY", "isEnabledModule": true },
      { "moduleName": "vitalSigns",       "permission": "VIEW_ONLY", "isEnabledModule": true },
      { "moduleName": "medications",      "permission": "VIEW_ONLY", "isEnabledModule": true }
    ]
  }
}
```

## 4. Endpoints the doctor calls
All paths are under `/api/`.

### 4a. Single-module endpoints
Each endpoint belongs to one module.

| Method | Path | Module (`moduleName`) | Used by |
|---|---|---|---|
| GET | `MedicalReports/basic-data` | basicInformation | report |
| GET | `MedicalReports/vital-activities/categories` | vitalSigns | report |
| GET | `MedicalReports/medicines/filters` | medications | report, my medicines |
| GET | `MedicalReports/chronic-diseases/filters` | chronicDiseases | report |
| GET | `MedicalReports/emergency-complaints/filters` | urgentComplaints | report |
| GET | `MedicalReports/prescriptions/filters` | doctorsPrescriptions | report |
| GET | `MedicalReports/lab-tests/filters` | medicalTests | report |
| GET | `MedicalReports/radiology/filters` | radiology | report |
| GET | `MedicalReports/surgery/filters` | surgeries | report |
| GET | `MedicalReports/GeneticDiseases/filters` | geneticDiseases | report |
| GET | `MedicalReports/Allergy/filters` | allergies | report |
| GET | `MedicalReports/Eyes/filters` | eyes | report |
| GET | `MedicalReports/Teeth/filters` | dental | report |
| GET | `MedicalReports/MentalDiseases/filters` | mentalHealth | report |
| GET | `MedicalReports/smart-nutrition/options` | smartNutritionalAnalyzer | report |
| GET | `MedicalReports/physical-activity/options` | sportsActivity | report |
| GET | `MedicalReports/supplements-vitamins/filters` | supplements | report |
| GET | `MedicalReports/Vaccine/filters` | vaccinations | report |
| GET | `MedicalReports/RiskyBehaviour/filters` | riskyBehaviors | report |

### 4b. Multi-module endpoints
One request covers several modules.

| Method | Path | Used by | Notes |
|---|---|---|---|
| POST | `MedicalReports/fetch-data?language=ar` | report | Body has one section per module. This POST is a **read** and must be allowed for the doctor. In doctor mode the app sends disallowed sections as `null`: treat `null` as "not requested", don't fail. |
| GET | `MedicalReports/full-report-Medical-file-data` | my medicines | Returns one field per module. The app sends this data to the AI. |

## 5. Rules for a doctor request with `Active-Medical-Profile`

| Check | Single-module endpoint (4a) | Multi-module endpoint (4b) |
|---|---|---|
| A booking exists between this doctor and this patient | else **403** | else **403** |
| The window is open (`now < accessExpiresAt`) | else **403**, message `"Patient medical file access has expired"` | else **403**, same message |
| The module is allowed (or is `basicInformation`) | else **403** | **Do not fail.** Return allowed modules only. Disallowed sections or fields come back as `null` or empty. |
| Method | GET only | `fetch-data` (POST) is allowed as a read |

- Every other write (POST/PUT/DELETE) from a doctor with this header returns **403**.
- The checks must run on the server. The app also hides locked modules, but that alone doesn't protect the data.
- The app closes the screen and returns to the call only when the 403 message is `Patient medical file access has expired` or `You are not authorized to access this patient's medical file`. Any other 403 just fails that one request. Keep these two messages exactly as they are.
- A patient's own requests and family care-access requests must keep working exactly as today.

## 6. Endpoints a doctor must not call
| Method | Path | Expected |
|---|---|---|
| POST | `MedicalReports/upload-report` | 403. This attaches a report to the patient's file. The app hides this option for doctors. |
| GET | `MedicalReports/pdf/dates`, `MedicalReports/pdf?date=` | 403 (the patient's saved report PDFs), unless we agree otherwise. |

## 7. Error format
Use the same shape the `patient-access` endpoint already returns:
```json
{ "success": false, "message": "Patient medical file access has expired", "data": null }
```

## 8. Test cases
Setup: the booking allows `vitalSigns` and `medications` only. The window is open.

| # | Request (as the doctor, with the header) | Expected |
|---|---|---|
| 1 | `GET patient-access` | `modulePermissions` = basicInformation, vitalSigns, medications |
| 2 | `GET MedicalReports/medicines/filters` | 200, the **patient's** medicines |
| 3 | `GET MedicalReports/basic-data` | 200, the patient's basic data |
| 4 | `GET MedicalReports/radiology/filters` | 403 |
| 5 | `POST MedicalReports/fetch-data` with vitalSigns + radiology selected | 200: vitalSigns filled, radiology empty |
| 6 | `GET MedicalReports/full-report-Medical-file-data` | 200: only basicInformation + vitalSigns filled, all other fields null or empty |
| 7 | `POST MedicalReports/upload-report` | 403 |
| 8 | Any of 2–6 after `accessExpiresAt` | 403 "Patient medical file access has expired" |
| 9 | Any of 2–6 for another doctor's patient | 403 |
| 10 | Same requests as the patient, without the header | Unchanged from today |

## 9. Related open item
From the medical-file access work (`doctor_patient_medical_file_access.md` §4): the module view endpoints don't yet enforce the allowed modules for a doctor. The same rules in §5 apply there.
