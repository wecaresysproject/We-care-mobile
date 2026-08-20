# Online Doctor — API Contract

Base: `/api/v1`. All endpoints require `Authorization: Bearer <token>`.

Error shape is the same for every endpoint:

```json
{ "success": false, "errors": ["<message>"] }
```

| Status | When |
|--------|------|
| `400` | Missing / malformed query param |
| `401` | Missing / invalid token |
| `404` | Resource not found |
| `500` | Server error |

---

## 1. Get Doctors by Specialty

Returns the doctors list for a selected medical module/specialty (doctors list screen).

The app sends the module's `identifierName` from local data — never the Arabic display name.
Local data `{ "name": "باطنة", "identifierName": "internalMedicine" }` → `specialty=internalMedicine`.

### Request

```
GET /doctors?specialty={identifierName}
```

| Query param | Type   | Required | Description |
|-------------|--------|----------|-------------|
| `specialty` | string | yes      | `identifierName` of the selected module (e.g. `internalMedicine`) |

### Success — `200 OK`

```json
{
  "success": true,
  "data": [
    {
      "id": "64f1c2a9e8b3d0a1b2c3d4e5",
      "name": "د/ مصطفى علاء الدين",
      "specialty": "أخصائي باطنة",
      "workplace": "أستاذ مساعد - مستشفى عين شمس التخصصي",
      "profileImage": "https://cdn.example.com/doctors/64f1c2a9.jpg",
      "rating": 4.7,
      "likesCount": 20,
      "commentsCount": 95,
      "isOnline": false,
      "acceptsBookings": true,
      "nearestAvailableAppointment": {
        "date": "2026-05-26",
        "time": "10:30"
      }
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
| `rating` | number | Average rating, 0–5. |
| `likesCount` | int | |
| `commentsCount` | int | |
| `isOnline` | bool | Available for online consultation now. |
| `acceptsBookings` | bool | Currently accepts bookings. |
| `nearestAvailableAppointment` | object \| null | `date` = `YYYY-MM-DD`, `time` = `HH:mm` (24h). `null` if none. |

Empty specialty → `"data": []` (200), not 404.

---

## 2. Get Doctor Profile

Returns everything shown on the **ملف الطبيب** screen for one doctor.

### Request

```
GET /doctors/profile?doctorId={doctorId}
```

| Query param | Type   | Required | Description |
|-------------|--------|----------|-------------|
| `doctorId`  | string | yes      | `id` from the doctors list |

### Success — `200 OK`

```json
{
  "success": true,
  "data": {
    "id": "64f1c2a9e8b3d0a1b2c3d4e5",
    "name": "د/ مصطفى علاء الدين",
    "profileImage": "https://cdn.example.com/doctors/64f1c2a9.jpg",
    "isVerified": true,
    "isFavorite": false,
    "isOnline": false,
    "acceptsBookings": true,

    "specialty": "باطنة",
    "subSpecialty": "أمراض الجهاز الهضمى والكبد",
    "degree": "استشارى",
    "academicTitle": "أستاذ مساعد",
    "hospital": "مستشفى عين شمس التخصصى",
    "location": "مصر - الإسكندرية",

    "rating": 4.7,
    "likesCount": 20,
    "commentsCount": 95,
    "yearsOfExperience": 20,
    "patientsCount": 480,

    "nearestAvailableAppointment": {
      "date": "2026-05-26",
      "time": "10:30"
    },
    "workingDays": "الأحد - الأربعاء",
    "workingHours": "من 4:00 م - 9:00 م",
    "consultationFee": 800,

    "about": "أخصائى باطنة والجراحات الدقيقة المرتبطة بيها. أستاذ مساعد بجامعة الإسكندرية...",

    "medicalInterests": ["أمراض الجهاز الهضمى", "أمراض الكبد"],
    "professionalExperience": ["أستاذ مساعد بكلية الطب - جامعة الإسكندرية"],
    "languages": ["العربية", "الإنجليزية"],

    "education": [
      { "title": "بكالوريوس الطب والجراحة", "institution": "جامعة عين شمس", "country": "مصر", "year": "2005" }
    ],
    "certificates": [
      { "title": "زمالة الكلية الملكية للأطباء", "issuer": "Royal College of Physicians", "country": "المملكة المتحدة", "year": "2015" }
    ],
    "medicalAssociations": [
      { "association": "الجمعية المصرية لأمراض الباطنة", "membershipType": "عضو عامل", "scope": "مصر", "sinceYear": "2012" }
    ],
    "research": [
      { "title": "دراسة عن الكبد الدهنى", "type": "بحث علمى", "year": "2021", "actionLabel": "عرض البحث", "url": "https://example.com/research/123" }
    ],
    "awards": [
      { "title": "جائزة أفضل بحث طبى", "issuer": "جامعة الإسكندرية", "year": "2019" }
    ],
    "mediaAppearances": [
      { "title": "لقاء عن أمراض الكبد", "type": "فيديو", "platform": "YouTube", "actionLabel": "مشاهدة الفيديو", "url": "https://youtube.com/watch?v=abc123" }
    ],
    "reviews": [
      { "patientName": "محمد أحمد", "comment": "دكتور ممتاز وشرحه واضح جدًا" }
    ]
  }
}
```

| Field | Type | Description |
|-------|------|-------------|
| `id`, `name`, `profileImage`, `rating`, `likesCount`, `commentsCount`, `isOnline`, `acceptsBookings`, `nearestAvailableAppointment` | — | Same meaning/format as in the list endpoint. |
| `isVerified` | bool | Verified badge next to the name. |
| `isFavorite` | bool | Whether the **requesting user** favorited this doctor. |
| `specialty` | string | Main specialty (`"باطنة"`). |
| `subSpecialty` | string | Sub-specialty. |
| `degree` | string | `"استشارى"` / `"أخصائى"`. |
| `academicTitle` | string | e.g. `"أستاذ مساعد"`. |
| `hospital` | string | Workplace. |
| `location` | string | `"الدولة - المدينة"`. |
| `yearsOfExperience` | int | |
| `patientsCount` | int | |
| `workingDays` | string | Display string. |
| `workingHours` | string | Display string. |
| `consultationFee` | int | EGP. |
| `about` | string | Bio text. |
| `medicalInterests`, `professionalExperience`, `languages` | string[] | |
| `education[]` | object | `title`, `institution`, `country`, `year`. |
| `certificates[]` | object | `title`, `issuer`, `country`, `year`. |
| `medicalAssociations[]` | object | `association`, `membershipType`, `scope`, `sinceYear`. |
| `research[]` | object | `title`, `type`, `year`, `actionLabel`, `url` (nullable → button hidden). |
| `awards[]` | object | `title`, `issuer`, `year`. |
| `mediaAppearances[]` | object | `title`, `type`, `platform` (nullable), `actionLabel`, `url` (nullable → button hidden). |
| `reviews[]` | object | `patientName`, `comment`. |

Notes:
- All `year` / `sinceYear` values are strings (`"2015"`).
- All list fields return `[]` when empty, never `null` — empty sections are hidden in the UI.
- Unknown `doctorId` → `404`.

---

## 3. Favorite / Unfavorite Doctor

Toggles the heart on the doctor profile. Two idempotent calls — adding an already-favorited doctor or removing a non-favorited one still returns `200`.

### Add to favorites

```
POST /doctors/favorite?doctorId={doctorId}
```

### Remove from favorites

```
DELETE /doctors/favorite?doctorId={doctorId}
```

| Query param | Type   | Required | Description |
|-------------|--------|----------|-------------|
| `doctorId`  | string | yes      | `id` of the doctor |

No request body.

### Success — `200 OK`

```json
{
  "success": true,
  "data": { "isFavorite": true }
}
```

`isFavorite` reflects the state **after** the call (`true` for POST, `false` for DELETE). The app uses it to set the heart icon.

Unknown `doctorId` → `404`. The profile endpoint's `isFavorite` must reflect this state on the next fetch.
