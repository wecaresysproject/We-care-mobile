# Online Doctor — API Contract

Base: `http://147.93.57.70/api/OnlineDoctor` (Postman: *OnlineDoctor* collection).
All endpoints expect `Authorization: Bearer <token>` — the app's Dio interceptor adds it.

> Verified against the live dev server on 2026-08-26. Items marked **⚠️ open** differ
> between this contract and the current backend behaviour and need a backend decision.

Error shape (verified on `404`):

```json
{ "success": false, "message": "Doctor not found" }
```

Note: this is `message`, not the `errors[]` array most other modules use —
`ApiErrorHandler` already handles both.

| Status | When |
|--------|------|
| `401` | Missing / invalid token (`"User is not authenticated"`) |
| `404` | Unknown `doctorId` |
| `500` | Server error |

---

## 1. Get Doctors by Specialty

Returns the doctors list for a selected specialty (doctors list screen).

### Request

```
GET /OnlineDoctor?specialty={identifierName}
```

| Query param | Type   | Required | Description |
|-------------|--------|----------|-------------|
| `specialty` | string | yes      | `identifierName` of the selected specialty (e.g. `internalMedicine`) |

The app sends the specialty's `identifierName` from local data
(`lib/features/online_doctor/data/models/doctor_specializations_data.dart`) —
never the Arabic display name. Omitting `specialty` returns all doctors (`200`).

**⚠️ open:** the backend currently matches `specialty` *exactly* against the doctor
profile's Arabic `specialty` value (e.g. `أمراض القلب`) and returns `"data": []` for
`identifierName` values. Backend must map `identifierName` → doctors (or expose the
canonical list of identifiers) before this screen shows real data.

### Success — `200 OK` (verified)

```json
{
  "success": true,
  "data": [
    {
      "id": "6a82e9257e523ce1d86779dd",
      "name": "محمد علي العوايدي",
      "specialty": "استشاري أمراض القلب والقسطرة",
      "workplace": "مستشفى القاهرة الجامعي",
      "profileImage": "https://example.com/images/doctor.jpg",
      "rating": 0,
      "likesCount": 0,
      "commentsCount": 0,
      "isOnline": false,
      "acceptsBookings": true,
      "nearestAvailableAppointment": { "date": "2026-08-27", "time": "16:00" }
    }
  ]
}
```

| Field | Type | Description |
|-------|------|-------------|
| `id` | string | Doctor ID — passed to the profile endpoint. |
| `name` | string | Display name. |
| `specialty` | string | Specialty/title shown under the name. |
| `workplace` | string | Academic title + workplace. |
| `profileImage` | string \| null | Image URL. |
| `rating` | number | Average rating, 0–5 (may arrive as an int, e.g. `0`). |
| `likesCount` | int | |
| `commentsCount` | int | |
| `isOnline` | bool | Available for online consultation now. |
| `acceptsBookings` | bool | Currently accepts bookings. |
| `nearestAvailableAppointment` | object \| null | `date` = `YYYY-MM-DD`, `time` = `HH:mm` (24h). `null` if none. |

Empty specialty → `"data": []` (200), not 404.

App model: `DoctorSummaryModel`.

---

## 2. Get Doctor Profile

Returns everything shown on the **ملف الطبيب** screen for one doctor.

### Request

```
GET /OnlineDoctor/profile?doctorId={doctorId}
```

| Query param | Type   | Required | Description |
|-------------|--------|----------|-------------|
| `doctorId`  | string | yes      | `id` from the doctors list |

### Success — `200 OK` (verified — differs from the original draft, see notes)

```json
{
  "success": true,
  "data": {
    "id": "6a82e9257e523ce1d86779dd",
    "name": "محمد علي العوايدي",
    "profileImage": "https://example.com/images/doctor.jpg",
    "isVerified": false,
    "isFavorite": false,
    "isOnline": false,
    "acceptsBookings": true,

    "specialty": "أمراض القلب",
    "subSpecialty": ["القسطرة القلبية", "كهرباء القلب"],
    "degree": "بكالوريوس طب وجراحة",
    "academicTitle": "دكتوراه أمراض القلب",
    "hospital": "مستشفى القاهرة الجامعي",
    "location": { "country": "مصر", "governorate": "القاهرة", "city": "الجيزة" },

    "yearsOfExperience": 23,
    "rating": 0,
    "likesCount": 0,
    "commentsCount": 0,
    "patientsCount": 0,

    "nearestAvailableAppointment": { "date": "2026-08-27", "time": "16:00" },
    "workingDays": ["السبت", "الثلاثاء", "الأحد", "الخميس"],
    "workingHours": ["17:00 - 21:00", "16:00 - 20:00"],
    "consultationFee": 500,

    "about": "استشاري أمراض القلب والقسطرة...",

    "medicalInterests": ["مناظير القلب", "الدعامات"],
    "professionalExperience": [
      { "position": "طبيب مقيم", "workplace": "مستشفى القاهرة الجامعي", "fromDate": "2002-12-31", "toDate": "2007-12-30", "country": "مصر" },
      { "position": "استشاري أمراض القلب والقسطرة", "workplace": "مستشفى دار الفؤاد", "fromDate": "2014-12-31", "toDate": "", "country": "مصر" }
    ],
    "languages": ["العربية", "English"],

    "education": [
      { "title": "بكالوريوس طب وجراحة", "institution": "جامعة القاهرة", "country": "مصر", "year": "2002" }
    ],
    "certificates": [
      { "title": "ACLS", "issuer": "American Heart Association", "country": "مصر", "year": "2008" }
    ],
    "medicalAssociations": [
      { "association": "نقابة الأطباء المصرية", "membershipNumber": "453212", "membershipLevel": "عضو", "year": "2002" }
    ],
    "research": [
      { "title": "Advances in Cardiac Catheterization", "type": "بحث علمي", "year": "2024", "referenceUrl": "https://pubmed.ncbi.nlm.nih.gov/12345678/", "doi": "10.1234/example.2024", "pubmedId": "12345678" }
    ],
    "awards": [
      { "title": "أفضل استشاري أمراض قلب", "issuer": "الجمعية المصرية لأمراض القلب", "country": "مصر", "year": "2025", "referenceUrl": "https://example.com/awards/2025" }
    ],
    "mediaAppearances": [
      { "subject": "نصائح للوقاية من أمراض القلب", "type": "مقال", "url": "https://example.com/articles/heart-prevention" }
    ],
    "reviews": [],

    "clinics": [
      { "address": "15 شارع التحرير - الدقي - الجيزة", "phone": "01001234567", "consultationFee": 500, "workingDays": ["السبت", "الثلاثاء"], "workingHours": "17:00 - 21:00", "googleMap": "https://maps.google.com/?q=Dokki+Giza" }
    ],
    "hospitalsCenters": [
      { "name": "مستشفى دار الفؤاد", "address": "6 أكتوبر - الجيزة", "phone": "01005555555", "consultationFee": 700, "workingDays": ["الأحد", "الخميس"], "workingHours": "18:00 - 22:00", "googleMap": "https://maps.google.com/?q=Dar+Al+Fouad" }
    ]
  }
}
```

| Field | Type | Description |
|-------|------|-------------|
| `id`, `name`, `profileImage`, `rating`, `likesCount`, `commentsCount`, `isOnline`, `acceptsBookings`, `nearestAvailableAppointment` | — | Same meaning/format as in the list endpoint. |
| `isVerified` | bool | Verified badge next to the name. |
| `isFavorite` | bool | Whether the **requesting user** favorited this doctor. |
| `specialty` | string | Main specialty (`"أمراض القلب"`). |
| `subSpecialty` | string[] | Sub-specialties — shown as a bullet list. |
| `degree` | string | `"استشارى"` / `"أخصائى"`. |
| `academicTitle` | string | e.g. `"أستاذ مساعد"`. |
| `hospital` | string | Workplace. |
| `location` | object | `{ country, governorate, city }` — the app renders `"مصر - القاهرة - الجيزة"`. |
| `yearsOfExperience` | int | |
| `patientsCount` | int | |
| `workingDays` | string[] | Day names — joined with `" - "` in the UI. |
| `workingHours` | string[] | Time ranges — joined with `" / "` in the UI. |
| `consultationFee` | int | EGP. |
| `about` | string | Bio text. |
| `medicalInterests`, `languages` | string[] | |
| `professionalExperience[]` | object | `position`, `workplace`, `fromDate`, `toDate` (`""` = current), `country`. Rendered as `"position — workplace (2014 - حتى الآن)"`. |
| `education[]` | object | `title`, `institution`, `country`, `year`. |
| `certificates[]` | object | `title`, `issuer`, `country`, `year`. |
| `medicalAssociations[]` | object | `association`, `membershipLevel`, `membershipNumber` (nullable), `year`. |
| `research[]` | object | `title`, `type`, `year`, `referenceUrl` (nullable → button hidden), `doi`, `pubmedId`. |
| `awards[]` | object | `title`, `issuer`, `country` (nullable), `year`, `referenceUrl` (nullable → button hidden). |
| `mediaAppearances[]` | object | `subject`, `type` (`"فيديو"` / `"مقال"` — picks the button label), `url` (nullable → button hidden). |
| `reviews[]` | object | `patientName`, `comment` — **not yet verified** (always `[]` on the dev server). |
| `clinics[]`, `hospitalsCenters[]` | object | Practice locations — parsed into `DoctorPracticeLocationModel`, **not rendered yet** (no design). |

Notes:
- All `year` values are strings (`"2015"`).
- All list fields return `[]` when empty, never `null` — empty sections are hidden in the UI.
- Unknown `doctorId` → `404`.
- The profile endpoint currently responds `200` **without** a token — backend should enforce auth so `isFavorite` is always per-user.

App model: `DoctorModel` (+ entry models in `doctor_profile_entries.dart`).

---

## 3. Favorite / Unfavorite Doctor

Toggles the heart on the doctor profile. Two idempotent calls — adding an already-favorited doctor or removing a non-favorited one still returns `200`.

### Add to favorites

```
POST /OnlineDoctor/favorite?doctorId={doctorId}
```

### Remove from favorites

```
DELETE /OnlineDoctor/favorite?doctorId={doctorId}
```

| Query param | Type   | Required | Description |
|-------------|--------|----------|-------------|
| `doctorId`  | string | yes      | `id` of the doctor |

No request body.

### Success — `200 OK` (expected)

```json
{
  "success": true,
  "data": { "isFavorite": true }
}
```

`isFavorite` reflects the state **after** the call (`true` for POST, `false` for DELETE).
The app sets the heart from this value; if `data.isFavorite` is missing it falls back to
the requested state.

**⚠️ open:** not yet verified — both calls return `401 {"success":false,"message":"User is not authenticated"}`
with the token stored in the Postman collection, even though the same token is accepted by
the GET endpoints. Needs a token for a user that exists on the dev server.

Unknown `doctorId` → `404`. The profile endpoint's `isFavorite` must reflect this state on the next fetch.

---

## Appendix — Specialty identifiers

The app sends these `identifierName` values in `GET /OnlineDoctor?specialty=`. Source of truth: `lib/features/online_doctor/data/models/doctor_specializations_data.dart`.

| # | Specialty (Arabic, as shown in app) | `identifierName` (sent in `?specialty=`) |
|---|---|---|
| 1 | باطنة | `internalMedicine` |
| 2 | جلدية | `dermatology` |
| 3 | أطفال | `pediatrics` |
| 4 | كبد وجهاز هضمي | `gastroenterology` |
| 5 | نساء وتوليد | `obstetricsGynecology` |
| 6 | تجميل وجراحة تجميل | `plasticSurgery` |
| 7 | تخسيس (علاج السمنة) | `obesityTreatment` |
| 8 | تغذية علاجية | `clinicalNutrition` |
| 9 | سكر وغدد صماء | `endocrinology` |
| 10 | أمراض نفسية وعصبية | `psychiatry` |
| 11 | عقم وحقن مجهري | `infertility` |
| 12 | أنف وأذن وحنجرة | `ent` |
| 13 | مسالك بولية | `urology` |
| 14 | تخاطب ونطق | `speechTherapy` |
| 15 | عيون | `ophthalmology` |
| 16 | قلب وأوعية دموية | `cardiology` |
| 17 | مخ وأعصاب | `neurology` |
| 18 | حميات وأمراض معدية | `infectiousDiseases` |
| 19 | أمراض الصدرية | `pulmonology` |
| 20 | عظام | `orthopedics` |
| 21 | أسنان | `dentistry` |
| 22 | روماتيزم ومفاصل | `rheumatology` |
| 23 | جراحة أوعية دموية | `vascularSurgery` |
| 24 | حساسية ومناعة | `allergyImmunology` |
| 25 | أورام | `oncology` |
| 26 | جراحة عامة | `generalSurgery` |
| 27 | كلى | `nephrology` |
| 28 | جراحة أطفال | `pediatricSurgery` |
| 29 | أمراض الدم | `hematology` |
| 30 | علاج طبيعي وتأهيل | `physiotherapy` |
| 31 | طب المسنين | `geriatrics` |
| 32 | طب الرياضة واصابات الملاعب | `sportsMedicine` |
