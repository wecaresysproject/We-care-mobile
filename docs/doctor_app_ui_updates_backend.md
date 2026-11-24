# Doctor app UI updates: backend requests

This file collects the backend changes needed for the current round of doctor-app UI updates. Each numbered section is one feature. New features are added as new sections at the end.

| # | Feature | Backend work | Status |
|---|---|---|---|
| 1 | [Previous prescriptions on the call screen](#1-previous-prescriptions-on-the-call-screen) | 1 new endpoint | Done (backend + mobile) |
| 2 | [Patient files (ملفات المرضى)](#2-patient-files-ملفات-المرضى) | 3 new endpoints | Done (backend + mobile) |
| 3 | [Statistics (إحصائيات)](#3-statistics-إحصائيات) | 1 new endpoint | Waiting for backend (mobile done) |

---

## 1. Previous prescriptions on the call screen

**Screen:** Doctor app → video call screen → new tile **الروشتات القديمة**.
The old **الروشتة** tile is renamed **كتابة الروشتة**. It still uses `GET`/`PUT /DoctorBookings/bookings/prescription`, and nothing about it changes.

When the doctor taps **الروشتات القديمة**, the app opens **روشتات المريض**:
- A patient card: name, age and country.
- One row per prescription **this doctor** wrote for **this patient** in **earlier bookings**. Each row shows the date and the diagnosis, plus a **عرض الروشتة** button.
- **عرض الروشتة** opens **نسخة الروشتة**, which shows that prescription's page images (the same images saved by `PUT /DoctorBookings/bookings/prescription`). The doctor can share them from there.

**Status:** done on backend and mobile.

One new endpoint is needed.

### Endpoint: `GET /api/DoctorBookings/bookings/previous-prescriptions?bookingId={id}`

- **Auth:** the doctor's bearer token, the same as `patient-access` and `prescription`. If the request carries an `Active-Medical-Profile` header, ignore it.
- **`bookingId`:** the booking of the current call. The backend resolves the patient from it, so the app does not send a `patientId`.

**What to return:** prescriptions saved through `PUT /DoctorBookings/bookings/prescription` where:
- the booking belongs to the **calling doctor**, and
- the booking's patient is the **same patient** as the booking in `bookingId`, and
- the booking is **not** `bookingId` itself (the current one opens from **كتابة الروشتة**).

Order them by booking date, newest first. Return all of them; there is no paging.

**200:**
```json
{
  "success": true,
  "message": "Previous prescriptions fetched successfully",
  "data": {
    "patient": {
      "name": "سارة علي حسن",
      "age": 32,
      "country": "السعودية"
    },
    "prescriptions": [
      {
        "bookingId": "b_101",
        "date": "2026-11-10",
        "diagnosis": "التهاب الجيوب الأنفية",
        "images": ["https://.../page1.png", "https://.../page2.png"]
      },
      {
        "bookingId": "b_087",
        "date": "2026-07-15",
        "diagnosis": "",
        "images": ["https://.../page1.png"]
      }
    ]
  }
}
```

| Field | Type | Notes |
|---|---|---|
| `patient.name` | string | The patient's full name. |
| `patient.age` | int or `null` | Age in whole years today. `null` if the patient has no birth date. |
| `patient.country` | string | Arabic country name. `""` if unknown. |
| `prescriptions` | array | Newest first. Send `[]` when there are none, never `null`. The app then shows "لا توجد روشتات سابقة لهذا المريض". |
| `prescriptions[].bookingId` | string | The earlier booking's id. |
| `prescriptions[].date` | string | The **booking date**, `YYYY-MM-DD`. This is the same date printed on the prescription and used as the ticket's `preDescriptionDate`. |
| `prescriptions[].diagnosis` | string | `prescription.diagnosis` as saved. `""` when empty. |
| `prescriptions[].images` | array of strings | The saved page images in page order, page 1 first. These are the same images sent in the last `PUT`. Skip any prescription that has no images. |

**Errors.** Use the same shape and the same messages as the prescription endpoints:

| Check | Result if it fails |
|---|---|
| The booking in `bookingId` exists and belongs to the calling doctor | **403** `You are not authorized to access this patient's medical file` |
| The booking's data-access window is open (`now < accessExpiresAt`) | **403** `Patient medical file access has expired` |

The app opens this screen only during the call, so a 403 after the window ends is fine.

### Test cases
Setup: doctor `D1`, patient `P1`. `D1` saved prescriptions on `P1`'s earlier bookings `B1` (2026-03-20) and `B2` (2026-07-15). The current call is booking `B3`. Doctor `D2` also saved a prescription for `P1` on booking `B4`.

| # | Request | Expected |
|---|---|---|
| 1 | `D1`: `GET previous-prescriptions?bookingId=B3` | 200. `B2` then `B1`, each with its date, diagnosis and images. `B4` (another doctor) is not included. |
| 2 | `D1` saves a prescription on `B3`, then repeats #1 | Same as #1: the current booking `B3` is never included. |
| 3 | `D1` edits `B2`'s prescription, then repeats #1 | `B2` returns the new images and diagnosis. |
| 4 | `D1`, booking with a patient that has no earlier prescriptions | 200 with `prescriptions: []` and the patient filled in. |
| 5 | `D2`: `GET previous-prescriptions?bookingId=B3` | 403 `You are not authorized to access this patient's medical file` |
| 6 | `D1`: `GET` after `B3`'s `accessExpiresAt` | 403 `Patient medical file access has expired` |

---

## 2. Patient files (ملفات المرضى)

**Screen:** Doctor app → home → quick action **ملفات المرضى**. The screen has two tabs:

- **ملفات مفتوحة بالصلاحية** (open files): bookings whose patient-data access window is still open. Each row shows the patient's photo, name and age, the examination date, the booking status (**مجدول** / **منتهي**), and how much access time is left. The folder icon opens the patient's medical file, limited to the modules the patient allowed. It uses the existing `GET /DoctorBookings/bookings/patient-access?bookingId=`, so nothing changes there.
- **ملفات المرضى القدامى** (previous patients): every patient the doctor has examined at least once, one row per patient, even if that patient also has an open file. Each row shows the patient's photo, name, age and country, plus the date and type (**كشف** / **استشارة**) of their **last** booking with this doctor. **الروشتات** opens **روشتات المريض** with every prescription this doctor wrote for that patient. Tapping a prescription shows its page images (the same screens as section 1).

Both tabs have a name search and one filter: **حالة الكشف** on open files and **نوع الكشف** on previous patients.
- **Search runs on the backend.** 2a and 2b take an optional `search` query parameter. The app sends it after the doctor stops typing for half a second (debounced), so you get one request per pause, not one per letter.
- **Filters run in the app** on the list the endpoint returned. Both start on **الكل**, so the endpoints take no filter parameters.

**Status:** done on backend and mobile.

All three endpoints use the doctor's bearer token. If the request carries an `Active-Medical-Profile` header, ignore it. A patient's `profileImage` is `null` when there is no photo, the same as in `GET /DoctorBookings/bookings`.

### 2a. `GET /api/DoctorBookings/patient-files/open?search={text}`

Returns the calling doctor's bookings whose data-access window is open right now (`now < accessExpiresAt`). Include upcoming and finished bookings. Leave out cancelled bookings, and bookings where the patient allowed no modules. Order them by `accessExpiresAt`, soonest first.

**`search`** (optional): keep only rows whose patient name contains this text. See [Search rules](#search-rules-2a-and-2b). When it is missing or empty, return every row.

```json
{
  "success": true,
  "message": "Open patient files fetched successfully",
  "data": [
    {
      "bookingId": "b_201",
      "patient": { "name": "أحمد محمد علي", "profileImage": null, "age": 45 },
      "examinationDate": "2026-11-23T10:00:00+02:00",
      "status": "scheduled",
      "accessExpiresAt": "2026-11-26T10:00:00+02:00"
    }
  ]
}
```

| Field | Type | Notes |
|---|---|---|
| `bookingId` | string | Used with `patient-access` to open the medical file. |
| `patient.name` | string | |
| `patient.profileImage` | string or `null` | |
| `patient.age` | int or `null` | Age in whole years today. `null` if the patient has no birth date. |
| `examinationDate` | string | The booking's start time, ISO 8601 with an offset. |
| `status` | string | `scheduled`: the examination hasn't ended (**مجدول**). `completed`: it ended (**منتهي**). Use the same rule that moves a booking to `completedAppointments`. |
| `accessExpiresAt` | string | The end of the data-access window, ISO 8601 with an offset. It must match `patient-access`. The app shows the time left from it. |

Send `[]` when there are none, never `null`.

### 2b. `GET /api/DoctorBookings/patient-files/previous?search={text}`

Returns one row for each patient who has at least one **completed** booking with the calling doctor. Order them by `lastExaminationDate`, newest first.

**`search`** (optional): same as 2a.

```json
{
  "success": true,
  "message": "Previous patients fetched successfully",
  "data": [
    {
      "patientId": "p_77",
      "patient": {
        "name": "محمد محمود عبد الرحمن",
        "profileImage": "https://.../p77.jpg",
        "age": 38,
        "country": "مصر"
      },
      "lastExaminationDate": "2026-11-14T18:30:00+02:00",
      "lastType": "freeFollowUpConsultation"
    }
  ]
}
```

| Field | Type | Notes |
|---|---|---|
| `patientId` | string | Sent back to 2c. |
| `patient.name`, `patient.profileImage`, `patient.age` | | Same as 2a. |
| `patient.country` | string | Arabic country name. `""` if unknown. |
| `lastExaminationDate` | string | Start time of the patient's latest completed booking with this doctor, ISO 8601 with an offset. |
| `lastType` | string | That booking's `type`: `onlineExamination` (**كشف**) or `freeFollowUpConsultation` (**استشارة**). |

Send `[]` when there are none, never `null`.

### Search rules (2a and 2b)
- Match a patient whose full name **contains** the text anywhere, not only at the start. For example, `محمد` matches both `محمد محمود` and `أحمد محمد علي`.
- Ignore case, and trim spaces at both ends of the text.
- Treat these Arabic letter variants as the same, so the doctor finds the patient however the name was typed: `أ` `إ` `آ` `ا`, then `ة` `ه`, then `ى` `ي`.
- A search with no matches returns 200 with `data: []`, not 404.
- Keep the same ordering as without a search.

### 2c. `GET /api/DoctorBookings/patient-files/prescriptions?patientId={id}`

Returns every prescription the calling doctor saved (through `PUT /DoctorBookings/bookings/prescription`) on any booking with this patient. Order them by booking date, newest first.

**The response is exactly the same shape as section 1** (`data.patient` with `name`, `age`, `country`, and `data.prescriptions[]` with `bookingId`, `date`, `diagnosis`, `images`). The only differences are:
- It is looked up by `patientId`, not `bookingId`.
- No booking is left out, because there is no current booking.
- **No access-window check.** These are the doctor's own prescriptions, and old patients' windows have usually ended.

| Check | Result if it fails |
|---|---|
| The patient has at least one booking with the calling doctor | **403** `You are not authorized to access this patient's medical file` |

### Test cases
Setup: doctor `D1`.
- Patient `P1`: completed booking `B1` (2026-10-01, `onlineExamination`), with a prescription. Completed booking `B2` (2026-11-14, `freeFollowUpConsultation`), with a prescription; its window is still open.
- Patient `P2`: upcoming booking `B3` with an open window.
- Patient `P3`: completed booking `B4` whose window ended.
- Doctor `D2` has a completed booking with `P4`.

| # | Request | Expected |
|---|---|---|
| 1 | `D1`: `GET patient-files/open` | `B2` (`completed`) and `B3` (`scheduled`), ordered by `accessExpiresAt`. `B1` and `B4` are not included (window ended). |
| 2 | `D1`: `GET patient-files/previous` | `P1` (last booking `B2`, `freeFollowUpConsultation`), then `P3`. `P2` is not included (no completed booking). `P4` is not included (another doctor). |
| 3 | `D1`: `GET patient-files/prescriptions?patientId=P1` | 200. `B2`'s prescription, then `B1`'s. |
| 4 | `D1`: same as #3 after every window has ended | Still 200 with both prescriptions. |
| 5 | `D1`: `GET patient-files/prescriptions?patientId=P4` | 403 `You are not authorized to access this patient's medical file` |
| 6 | A doctor with no bookings: `open` and `previous` | 200 with `data: []` |
| 7 | `D1`: `GET patient-files/previous?search=` followed by part of `P3`'s name | Only `P3` |
| 8 | `D1`: `GET patient-files/open?search=xyz` | 200 with `data: []` |

---

## 3. Statistics (إحصائيات)

**Screen:** Doctor app → home → quick action **إحصائيات**. The doctor picks a month and a year, taps **عرض**, and sees 11 numbers for that month. The screen opens on the current month and loads it right away.

**Mobile status:** done. Until the endpoint exists, the screen shows a load error with a retry button.

### Endpoint: `GET /api/DoctorHome/statistics?month={1-12}&year={yyyy}`

- **Auth:** the doctor's bearer token, the same as the other `DoctorHome` endpoints.
- **`month`:** 1 to 12. **`year`:** four digits. Both are required.
- **Time zone:** count everything by the booking's start time in Egypt time (`Africa/Cairo`), so a booking at 00:30 on the 1st belongs to the new month.
- A month with no activity returns 200 with every number set to `0`.

```json
{
  "success": true,
  "message": "Statistics fetched successfully",
  "data": {
    "consultationsValue": 245800,
    "currency": "EGP",
    "totalBookings": 1562,
    "paidConsultations": 1248,
    "followUps": 486,
    "followUpRatio": 31.1,
    "repeatPatientsWithoutFollowUp": 126,
    "repeatPatientRatio": 8.2,
    "consultationDays": 22,
    "consultationHours": 36,
    "averageConsultationMinutes": 18,
    "unexaminedWaitingPatients": 152
  }
}
```

Every field is for the requested month only, and for the calling doctor only.

| Field | Card | Type | How to calculate it |
|---|---|---|---|
| `consultationsValue` | قيمة الكشوفات | number | Total amount patients paid for **paid examinations** (`onlineExamination` bookings that were paid). Free follow-ups add nothing. Refunded bookings are not counted. |
| `currency` | (after the value) | string | Currency of `consultationsValue`, e.g. `"EGP"`. |
| `totalBookings` | عدد الحجوزات الاجمالية | int | Every booking in the month, of any type and any status except cancelled. |
| `paidConsultations` | عدد الكشوفات المدفوعة | int | Paid `onlineExamination` bookings, not refunded. |
| `followUps` | عدد المتابعات | int | `freeFollowUpConsultation` bookings, not cancelled. |
| `followUpRatio` | نسبة المتابعات للكشوفات | number | `followUps ÷ paidConsultations × 100`, rounded to 1 decimal. `0` when `paidConsultations` is 0. |
| `repeatPatientsWithoutFollowUp` | عدد المرضى المكررين بدون المتابعات | int | Patients with **2 or more paid examinations** with this doctor in the month. Follow-ups don't count toward the 2. Count each patient once. |
| `repeatPatientRatio` | نسبة المرضى المكررين لإجمالي المرضى | number | `repeatPatientsWithoutFollowUp ÷ distinct patients with any booking in the month × 100`, rounded to 1 decimal. `0` when there are no patients. |
| `consultationDays` | عدد أيام الكشوفات | int | Number of distinct days in the month on which the doctor completed at least one session (examination or follow-up). |
| `consultationHours` | عدد ساعات الكشوفات | number | Total time of the completed sessions in the month, in hours, rounded to 1 decimal. A session's time is from the doctor starting the meeting to the doctor ending it. |
| `averageConsultationMinutes` | متوسط مدة الكشف | number | Total session time ÷ number of completed sessions, in minutes, rounded to a whole number. `0` when there are none. |
| `unexaminedWaitingPatients` | عدد مرضى الانتظار الذين لم يتم الكشف عليهم | int | Patients who joined the waiting list during the month and were never seen: rejected, or never accepted before the day ended. |

> **Please confirm or correct:** the formulas above are our reading of the card titles. Tell us before building if the business meant something else, for example whether **عدد المرضى المكررين** should also count follow-ups, or whether **نسبة المتابعات** should divide by total bookings instead of paid examinations.

**Errors:**

| Case | Result |
|---|---|
| `month` missing or outside 1–12, or `year` missing or not 4 digits | **400** with the usual error body |

### Test cases
Setup: doctor `D1`, November 2026.
- Patient `P1`: two paid examinations (500 EGP each) on Nov 3 and Nov 20, plus one follow-up on Nov 10.
- Patient `P2`: one paid examination (500 EGP) on Nov 3, refunded.
- Patient `P3`: joined the waiting list on Nov 5 and was rejected.
- Sessions completed: Nov 3 (30 min), Nov 10 (15 min), Nov 20 (45 min).

| # | Request | Expected |
|---|---|---|
| 1 | `D1`: `GET statistics?month=11&year=2026` | `consultationsValue` 1000, `totalBookings` 4, `paidConsultations` 2, `followUps` 1, `followUpRatio` 50, `repeatPatientsWithoutFollowUp` 1, `repeatPatientRatio` 50 (1 of `P1`/`P2`), `consultationDays` 3, `consultationHours` 1.5, `averageConsultationMinutes` 30, `unexaminedWaitingPatients` 1 |
| 2 | `D1`: `GET statistics?month=10&year=2026` (no activity) | 200, every number `0` |
| 3 | `D1`: `GET statistics?month=13&year=2026` | 400 |
| 4 | Another doctor: `GET statistics?month=11&year=2026` | Only that doctor's numbers, none of `D1`'s |

