# Patient Booking — API Contract

Base: `http://147.93.57.70/api/OnlineDoctor` (same base as [online_doctor_api.md](online_doctor_api.md)).
All endpoints expect `Authorization: Bearer <token>` — the app's Dio interceptor adds it.
The patient is always taken from the token; no `patientId` is sent.

> **Proposed contract (2026-10-04) — nothing here is implemented or verified yet.**
> Covers the **حجز موعد**, **حجوزاتي**, **تعديل الموعد**, **السجل السابق**,
> **تفاصيل الكشف / الاستشارة**, **تعديل التقييم**, **تعديل التعليق** and the
> **الكشف / الاستشارة** room screens.
> Items marked **⚠️ open** need a backend decision.

**Out of scope for now** (will be added in later iterations): payment flow, the video
call itself (**دخول إلى الكشف / الاستشارة** inside the room screen), and adding / removing
room participants.

Error shape — the app's shared error model (`ApiErrorModel` in
`lib/core/networking/api_error_model.dart`), used on **every** non-2xx response:

```json
{ "success": false, "errors": ["Doctor not found"] }
```

| Field | Type | Description |
|-------|------|-------------|
| `success` | bool | Always `false` on errors. |
| `errors` | string[] | One or more messages, never empty. Validation failures may return one entry per invalid field. |

Do **not** use the `{ "success": false, "message": "..." }` shape the existing Online
Doctor endpoints return — the app only tolerates it as a fallback.

| Status | When |
|--------|------|
| `400` | Missing / invalid parameter or body field |
| `401` | Missing / invalid token (`"errors": ["User is not authenticated"]`) |
| `404` | Unknown `doctorId` / `bookingId` / `questionId` (or a booking that belongs to another patient) |
| `409` | Slot is no longer available (booking / reschedule) |
| `500` | Server error |

### Conventions

- **Times are Egypt local time** (`Africa/Cairo`) — the screens state
  *"جميع المواعيد حسب التوقيت المحلي لجمهورية مصر العربية"*.
- Availability uses `date` = `YYYY-MM-DD` and `startTime` / `endTime` = `HH:mm` (24h),
  same format as `nearestAvailableAppointment` in the doctors list.
- Bookings use `startsAt` / `endsAt` as ISO 8601 **with offset**
  (`2026-10-05T18:00:00+03:00`) — the app runs a live countdown from them, so it needs an
  exact instant, not just a wall-clock time.
- List fields return `[]` when empty, never `null`.

### Shared objects

**Booking type** — `type`:

| Value | Meaning |
|-------|---------|
| `onlineExamination` | Paid online examination (**كشف أون لاين**). |
| `freeFollowUpConsultation` | Free follow-up consultation linked to a previous examination (**استشارة متابعة مجانية**). |

**Booking doctor** — `doctor` (same field names as the doctor profile endpoint):

```json
{
  "id": "6a82e9257e523ce1d86779dd",
  "name": "أحمد محمود مصطفى",
  "profileImage": "https://example.com/images/doctor.jpg",
  "specialty": "أنف وأذن وحنجرة",
  "academicTitle": "أستاذ مساعد",
  "hospital": "مستشفى عين شمس التخصصى",
  "location": { "country": "مصر", "governorate": "القاهرة" },
  "isOnline": true,
  "rating": 4.8,
  "commentsCount": 95
}
```

`id` is required — the app uses it for **حجز موعد جديد مع الطبيب** and for the doctor filter.
`rating` / `commentsCount` are the doctor's overall values (shown in the history card footer).

---

## 1. Get Doctor Availability

- **Type:** GET
- **Screen:** حجز موعد (day strip + time slots)
- **Purpose:** Return the doctor's bookable days and the free slots inside each day.
- **Endpoint:** `/api/PatientBooking/availability` — ✅ implemented by backend, verified 2026-10-07

### Request

```
GET /PatientBooking/availability?doctorId={doctorId}&fromDate={YYYY-MM-DD}&days={n}
```

| Query param | Type   | Required | Description |
|-------------|--------|----------|-------------|
| `doctorId`  | string | yes      | `id` of the doctor |
| `fromDate`  | string | no       | First day to return, `YYYY-MM-DD`. Default: today. |
| `days`      | int    | no       | Number of calendar days to scan from `fromDate`. Default: `14`. |

Why a range and not a single day: the day strip only shows days that **have** free slots
(اليوم ← الثلاثاء ← الخميس…), so the app needs the days and their slots together. For one
specific day, send `fromDate={date}&days=1`.

### Response — `200 OK`

```json
{
  "success": true,
  "data": [
    {
      "date": "2026-10-04",
      "slots": [
        { "startTime": "12:30", "endTime": "13:00" },
        { "startTime": "14:00", "endTime": "14:30" },
        { "startTime": "18:00", "endTime": "18:30" }
      ]
    },
    {
      "date": "2026-10-06",
      "slots": [
        { "startTime": "13:30", "endTime": "14:00" },
        { "startTime": "15:00", "endTime": "15:30" }
      ]
    }
  ]
}
```

| Field | Type | Description |
|-------|------|-------------|
| `date` | string | `YYYY-MM-DD`. The app derives the day name (**اليوم** / **الثلاثاء**) from it. |
| `slots[].startTime` | string | `HH:mm` (24h). |
| `slots[].endTime` | string | `HH:mm` (24h). |

Rules:
- Return **free slots only** — already-booked slots and slots that already started are excluded.
- Days with no free slots are omitted. Days sorted ascending, slots sorted ascending.
- No availability in the range → `"data": []` (200), not 404.

### Errors

`400` missing `doctorId` / bad `fromDate` · `401` · `404` unknown doctor · `500`

---

## 2. Book Appointment

- **Type:** POST
- **Screen:** حجز موعد (**إتمام الدفع** button)
- **Purpose:** Create an online-examination booking from the patient's selections.
- **Endpoint:** `/api/PatientBooking/bookings` — ✅ implemented by backend (route confirmed 2026-10-07; response body not verified yet)

**Payment is bypassed for now:** `paymentMethod` is stored as a booking option only. The
backend confirms the booking immediately and returns success/failure — no gateway call,
no card/wallet data.

### Request

```
POST /PatientBooking/bookings
```

```json
{
  "doctorId": "6a82e9257e523ce1d86779dd",
  "date": "2026-10-06",
  "startTime": "13:30",
  "paymentMethod": "bankCard",
  "dataAccessDurationHours": 24,
  "dataAccessModules": ["vitalSigns", "medications", "medicalTests"]
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `doctorId` | string | yes | Doctor being booked. |
| `date` | string | yes | Slot date, `YYYY-MM-DD` — as returned by availability. |
| `startTime` | string | yes | Slot start, `HH:mm` — as returned by availability. |
| `paymentMethod` | string | yes | `bankCard` (**بطاقة بنكية**) or `eWallet` (**محفظة الكترونية**). |
| `dataAccessDurationHours` | int | no | How long the doctor may view the patient's data. One of `12, 24, 48, 72, 96, 120, 144, 168, 240, 336`. |
| `dataAccessModules` | string[] | no | Modules the doctor may view — see [Appendix](#appendix--data-access-module-identifiers). `[]` / omitted = no access granted. |

The last two fields come from the **السماح بالوصول للبيانات** section of the screen — they
are optional in the UI, so the backend must accept the booking without them.

### Response — `201 Created`

Returns the created booking in the **same shape as an upcoming-bookings item** (section 3),
so the app can show it without refetching.

```json
{
  "success": true,
  "data": {
    "bookingId": "6b01f4c97e523ce1d8678a10",
    "type": "onlineExamination",
    "doctor": { "id": "6a82e9257e523ce1d86779dd", "name": "أحمد محمود مصطفى", "...": "..." },
    "startsAt": "2026-10-06T13:30:00+03:00",
    "endsAt": "2026-10-06T14:00:00+03:00",
    "fee": 500,
    "linkedExaminationDate": null
  }
}
```

`fee` is taken by the backend from the doctor's `consultationFee` — the app never sends a price.

### Errors

```json
{ "success": false, "errors": ["This slot is no longer available"] }
```

`400` missing/invalid field, slot in the past, or unknown module identifier · `401` ·
`404` unknown doctor · `409` slot already booked (the app refetches availability) · `500`

---

## 3. Get Upcoming Bookings

- **Type:** GET
- **Screen:** حجوزاتي → **المواعيد القادمة** tab
- **Purpose:** Return the patient's upcoming appointments (examinations and follow-up consultations).
- **Endpoint:** `/api/PatientBooking/bookings/upcoming` — ✅ implemented by backend, verified 2026-10-07

### Request

```
GET /PatientBooking/bookings/upcoming
```

No parameters.

### Response — `200 OK`

```json
{
  "success": true,
  "data": [
    {
      "bookingId": "6b01f4c97e523ce1d8678a10",
      "type": "onlineExamination",
      "doctor": {
        "id": "6a82e9257e523ce1d86779dd",
        "name": "أحمد محمود مصطفى",
        "profileImage": "https://example.com/images/doctor.jpg",
        "specialty": "أنف وأذن وحنجرة",
        "academicTitle": "أستاذ مساعد",
        "hospital": "مستشفى عين شمس التخصصى",
        "location": { "country": "مصر", "governorate": "القاهرة" },
        "isOnline": true,
        "rating": 4.8,
        "commentsCount": 95
      },
      "startsAt": "2026-10-05T18:00:00+03:00",
      "endsAt": "2026-10-05T18:30:00+03:00",
      "fee": 500,
      "linkedExaminationDate": null
    },
    {
      "bookingId": "6b01f4c97e523ce1d8678a11",
      "type": "freeFollowUpConsultation",
      "doctor": { "id": "6a82e9257e523ce1d86779de", "name": "محمد أنور السيد", "...": "..." },
      "startsAt": "2026-10-09T11:30:00+03:00",
      "endsAt": "2026-10-09T12:00:00+03:00",
      "fee": null,
      "linkedExaminationDate": "2026-10-04"
    }
  ]
}
```

| Field | Type | Description |
|-------|------|-------------|
| `bookingId` | string | Booking ID — used by details, cancel (section 7), reschedule (section 8) and the room screen (section 11). |
| `type` | string | `onlineExamination` \| `freeFollowUpConsultation`. |
| `doctor` | object | Booking doctor object (see *Shared objects*). |
| `startsAt` | string | ISO 8601 with offset. Drives the date, time and **متبقي على الكشف** countdown. |
| `endsAt` | string | ISO 8601 with offset. Until then the card stays in the **حان وقت الكشف** state. |
| `fee` | int \| null | EGP. `null` for `freeFollowUpConsultation`. |
| `linkedExaminationDate` | string \| null | `YYYY-MM-DD` of the examination the consultation belongs to (**مرتبطة بكشف يوم …**). `null` for `onlineExamination`. |

Rules:
- Include every booking whose `endsAt` is still in the future — i.e. **including
  appointments that already started** (the app shows them as **حان وقت الكشف**).
  After `endsAt` the booking moves to the history endpoint.
- Sorted by `startsAt` ascending. No bookings → `"data": []` (200).

`freeFollowUpConsultation` bookings are **created by the backend** — the app has no
endpoint for them (endpoint 2 only creates `onlineExamination`). The app just displays
whatever this endpoint returns.

### Errors

`401` · `500`

---

## 4. Get Bookings History

- **Type:** GET
- **Screen:** السجل السابق
- **Purpose:** Return the patient's previous appointments.
- **Endpoint:** `/api/PatientBooking/bookings/history` — ✅ implemented by backend (verified 2026-10-07 with an empty history only)

### Request

```
GET /PatientBooking/bookings/history
```

No parameters returns the full history. Filters are optional query params — see section 6.

### Response — `200 OK`

```json
{
  "success": true,
  "data": [
    {
      "bookingId": "6ac1f4c97e523ce1d8678901",
      "type": "onlineExamination",
      "status": "completed",
      "doctor": { "id": "6a82e9257e523ce1d86779dd", "name": "أحمد محمود مصطفى", "...": "..." },
      "startsAt": "2026-08-16T18:00:00+03:00",
      "fee": 500,
      "paymentMethod": "bankCard",
      "linkedExaminationDate": null
    },
    {
      "bookingId": "6ac1f4c97e523ce1d8678902",
      "type": "freeFollowUpConsultation",
      "status": "completed",
      "doctor": { "id": "6a82e9257e523ce1d86779de", "name": "محمد أنور السيد", "...": "..." },
      "startsAt": "2026-08-13T11:30:00+03:00",
      "fee": null,
      "paymentMethod": null,
      "linkedExaminationDate": "2026-08-08"
    }
  ]
}
```

| Field | Type | Description |
|-------|------|-------------|
| `bookingId`, `type`, `doctor`, `startsAt`, `fee`, `linkedExaminationDate` | — | Same meaning as in upcoming bookings. |
| `status` | string | `completed` (**مكتملة**) — the only value for now. Cancelled bookings are **not** returned here (see section 7). |
| `paymentMethod` | string \| null | `bankCard` \| `eWallet` — the value sent at booking. `null` for `freeFollowUpConsultation`. |

Rules:
- Sorted by `startsAt` descending (newest first). Empty → `"data": []` (200).
- Not paginated for now.

### Errors

`401` · `500`

---

## 5. Get Booking Details

- **Type:** GET
- **Screen:** تفاصيل الكشف / تفاصيل الاستشارة
- **Purpose:** Return the full details of one previous appointment.
- **Endpoint:** `/api/PatientBooking/bookings/details` — ✅ implemented by backend, verified 2026-10-11

**One endpoint for both types.** The two detail screens are the same layout; the only
differences are fee + payment method (examination) vs. linked examination date
(consultation), and both are already nullable fields selected by `type`. Separate
endpoints are not needed.

### Request

```
GET /PatientBooking/bookings/details?bookingId={bookingId}
```

| Query param | Type   | Required | Description |
|-------------|--------|----------|-------------|
| `bookingId` | string | yes      | `bookingId` from the history list |

### Response — `200 OK` — online examination

```json
{
  "success": true,
  "data": {
    "bookingId": "6ac1f4c97e523ce1d8678901",
    "type": "onlineExamination",
    "status": "completed",
    "doctor": {
      "id": "6a82e9257e523ce1d86779dd",
      "name": "أحمد محمود مصطفى",
      "profileImage": "https://example.com/images/doctor.jpg",
      "specialty": "أنف وأذن وحنجرة",
      "academicTitle": "أستاذ مساعد",
      "hospital": "مستشفى عين شمس التخصصى",
      "location": { "country": "مصر", "governorate": "القاهرة" },
      "isOnline": true,
      "rating": 4.8,
      "commentsCount": 95
    },
    "startsAt": "2026-08-16T18:00:00+03:00",
    "fee": 500,
    "paymentMethod": "bankCard",
    "linkedExaminationDate": null,
    "prescription": {
      "issuedDate": "2026-08-16",
      "fileUrl": "https://example.com/prescriptions/6ac1f4c9.pdf"
    },
    "userRating": { "value": 5, "date": "2026-08-16" },
    "userComment": {
      "text": "دكتور محترم جداً، استمع لشكوتي باهتمام وشرح الحالة بالتفصيل.",
      "date": "2026-08-16"
    }
  }
}
```

### Response — `200 OK` — free follow-up consultation

Same shape; examination-only fields are `null`, and here nothing was rated or prescribed yet:

```json
{
  "success": true,
  "data": {
    "bookingId": "6ac1f4c97e523ce1d8678902",
    "type": "freeFollowUpConsultation",
    "status": "completed",
    "doctor": { "id": "6a82e9257e523ce1d86779de", "name": "محمد أنور السيد", "...": "..." },
    "startsAt": "2026-08-13T11:30:00+03:00",
    "fee": null,
    "paymentMethod": null,
    "linkedExaminationDate": "2026-08-08",
    "prescription": null,
    "userRating": null,
    "userComment": null
  }
}
```

| Field | Type | Description |
|-------|------|-------------|
| `bookingId` … `linkedExaminationDate` | — | Same as the history item. |
| `prescription` | object \| null | `null` → **لا توجد روشتة لهذا الموعد**. |
| `prescription.issuedDate` | string | `YYYY-MM-DD`. |
| `prescription.fileUrl` | string \| null | File opened by **عرض / تحميل الروشتة**. `null` hides the button. |
| `userRating` | object \| null | The **requesting patient's** rating of this appointment. `null` → **لم تقم بتقييم هذا الموعد بعد**. |
| `userRating.value` | int | 1–5 (whole stars). Saved through section 9. |
| `userRating.date` | string | `YYYY-MM-DD`. |
| `userComment` | object \| null | The patient's comment on the doctor for this appointment. `null` → not commented yet. |
| `userComment.text` | string | Saved through section 10. |
| `userComment.date` | string | `YYYY-MM-DD`. |

### Errors

`400` missing `bookingId` · `401` · `404` unknown booking, or a booking of another patient · `500`

---

## 6. History Filters

The **السجل السابق** screen has two dropdowns: **إسم الطبيب** and **التخصص**.

### 6.1 Get Filter Options

- **Type:** GET
- **Screen:** السجل السابق (dropdown contents)
- **Purpose:** Return the doctors and specialties that appear in **this patient's** history.
- **Endpoint:** `/api/PatientBooking/bookings/history/filters` — ✅ implemented by backend (verified 2026-10-11 with an empty history only)

#### Request

```
GET /PatientBooking/bookings/history/filters
```

No parameters.

#### Response — `200 OK`

```json
{
  "success": true,
  "data": {
    "doctors": [
      { "id": "6a82e9257e523ce1d86779dd", "name": "أحمد محمود مصطفى" },
      { "id": "6a82e9257e523ce1d86779de", "name": "محمد أنور السيد" }
    ],
    "specialties": ["أنف وأذن وحنجرة", "طب الجلدية والتجميل"]
  }
}
```

| Field | Type | Description |
|-------|------|-------------|
| `doctors[]` | object | Distinct doctors the patient has previous appointments with. |
| `specialties[]` | string | Distinct `doctor.specialty` values in the patient's history. |

Only values that exist in the patient's own history — not all doctors/specialties in the
system. The app adds the **الكل** option itself. No history → both lists `[]`.

#### Errors

`401` · `500`

### 6.2 Apply Filter

- **Type:** GET
- **Screen:** السجل السابق (after picking a dropdown value)
- **Purpose:** Return the history filtered by the selected doctor and/or specialty.
- **Endpoint:** `/api/PatientBooking/bookings/history` — the **same route as section 4** with optional query params; no separate handler needed.

#### Request

```
GET /PatientBooking/bookings/history?doctorId={doctorId}&specialty={specialty}
```

| Query param | Type   | Required | Description |
|-------------|--------|----------|-------------|
| `doctorId`  | string | no       | `id` from `doctors[]`. Omitted = all doctors (**الكل**). |
| `specialty` | string | no       | A value from `specialties[]`, sent back verbatim (URL-encoded). Omitted = all specialties. |

Both sent → results must match **both** (AND).

#### Response — `200 OK`

Identical shape to section 4. No match → `"data": []` (200), not 404 — the app shows its
own empty state with a **clear filters** action.

#### Errors

`401` · `500`. An unknown `doctorId` / `specialty` returns `"data": []`, not an error.

---

## 7. Cancel Appointment

- **Type:** POST
- **Screen:** حجوزاتي → **إلغاء الموعد** on an examination card
- **Purpose:** Cancel an upcoming online examination and free its slot.
- **Endpoint:** `/api/PatientBooking/bookings/cancel` — ✅ implemented by backend (route confirmed 2026-10-11; response body not verified yet)

The confirmation step is an **in-app dialog** (*"هل أنت متأكد من إلغاء موعد الكشف مع …؟"*).
The app calls this endpoint **once**, only after the patient taps **تأكيد الإلغاء** — there
is no separate preview / confirm call.

### Request

```
POST /PatientBooking/bookings/cancel?bookingId={bookingId}
```

| Query param | Type   | Required | Description |
|-------------|--------|----------|-------------|
| `bookingId` | string | yes      | `bookingId` from the upcoming list |

No request body.

### Response — `200 OK`

```json
{
  "success": true,
  "data": { "bookingId": "6b01f4c97e523ce1d8678a10", "status": "cancelled" }
}
```

Rules:
- Only `onlineExamination` bookings can be cancelled — follow-up consultation cards have
  no cancel action.
- Only before `startsAt`. A booking that already started or ended cannot be cancelled.
- After success the booking is no longer returned by upcoming bookings (section 3), and
  its slot is returned again by availability (section 1).
- Idempotent: cancelling an already-cancelled booking returns the same `200` (the app's
  Dio layer retries a request that answered `500`).
- No refund logic while payment is bypassed.

**⚠️ open:** is there a cancellation deadline (e.g. not allowed less than N hours before
`startsAt`)? If so return `400` with a message the app can show. Also to decide: should
cancelled bookings appear in history with `status: "cancelled"`? The current design only
shows **مكتملة**, so for now they are not returned.

### Errors

```json
{ "success": false, "errors": ["This appointment can no longer be cancelled"] }
```

`400` missing `bookingId`, not an `onlineExamination`, or booking already started/ended ·
`401` · `404` unknown booking, or a booking of another patient · `500`

---

## 8. Reschedule Appointment

- **Type:** PUT
- **Screen:** تعديل الموعد (opened from **تعديل الموعد** on an examination card)
- **Purpose:** Move an upcoming online examination to another free slot of the same doctor.
- **Endpoint:** `/api/PatientBooking/bookings/reschedule` — ✅ implemented by backend (route confirmed 2026-10-11; response body not verified yet)

Screen flow:
1. The screen opens → the app calls **Get Doctor Availability** (section 1) with the
   booking's `doctor.id` to list each day and its free slots. No new endpoint is needed
   for the slots.
2. The patient picks a day and a slot → **تأكيد تعديل الموعد** → this endpoint.

### Request

```
PUT /PatientBooking/bookings/reschedule?bookingId={bookingId}
```

| Query param | Type   | Required | Description |
|-------------|--------|----------|-------------|
| `bookingId` | string | yes      | `bookingId` from the upcoming list |

```json
{
  "date": "2026-10-08",
  "startTime": "16:00"
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `date` | string | yes | New slot date, `YYYY-MM-DD` — as returned by availability. |
| `startTime` | string | yes | New slot start, `HH:mm` — as returned by availability. |

### Response — `200 OK`

Returns the updated booking in the **same shape as an upcoming-bookings item** (section 3).

```json
{
  "success": true,
  "data": {
    "bookingId": "6b01f4c97e523ce1d8678a10",
    "type": "onlineExamination",
    "doctor": { "id": "6a82e9257e523ce1d86779dd", "name": "أحمد محمود مصطفى", "...": "..." },
    "startsAt": "2026-10-08T16:00:00+03:00",
    "endsAt": "2026-10-08T16:30:00+03:00",
    "fee": 500,
    "linkedExaminationDate": null
  }
}
```

Rules:
- The **same booking** is moved: `bookingId`, doctor, `fee`, `paymentMethod` and the data
  access selections stay as they are. No new payment.
- Atomic: the new slot is taken and the old slot is freed in one operation. On any
  failure the booking stays at its old time.
- Only `onlineExamination` bookings, and only before `startsAt`.
- The new slot must be a free, future slot of the same doctor — otherwise `409` and the
  app refetches availability.

**⚠️ open:** reschedule limits — a deadline before `startsAt`, and/or a maximum number of
reschedules per booking? If any, return `400` with a message the app can show.

### Errors

```json
{ "success": false, "errors": ["This slot is no longer available"] }
```

`400` missing/invalid field, slot in the past, not an `onlineExamination`, or booking
already started/ended · `401` · `404` unknown booking, or a booking of another patient ·
`409` slot already booked · `500`

---

## 9. Add / Edit Rating

- **Type:** PUT
- **Screen:** تعديل التقييم (opened from **أضف تقييمك** / **تعديل تقييمك** in the details screen)
- **Purpose:** Save the patient's rating for one previous appointment.
- **Endpoint:** `/api/PatientBooking/bookings/rating` — ✅ implemented by backend (route confirmed 2026-10-11; response body not verified yet)

**One endpoint for add and edit.** A booking has at most one rating from its patient, so
the call is an upsert: the first call creates the rating, later calls replace it.

### Request

```
PUT /PatientBooking/bookings/rating?bookingId={bookingId}
```

| Query param | Type   | Required | Description |
|-------------|--------|----------|-------------|
| `bookingId` | string | yes      | `bookingId` of the previous appointment |

```json
{ "value": 4 }
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `value` | int | yes | 1–5 (whole stars). |

### Response — `200 OK`

Returns the saved rating in the **same shape as `userRating`** in booking details (section 5).

```json
{
  "success": true,
  "data": { "value": 4, "date": "2026-10-05" }
}
```

Rules:
- Only for `completed` bookings of the requesting patient — both `onlineExamination` and
  `freeFollowUpConsultation`.
- `date` is the day of the last save.
- The doctor's overall `rating` (doctors list, profile, booking doctor object) must
  reflect the change on the next fetch.

### Errors

`400` missing `bookingId`, `value` outside 1–5, or booking not completed · `401` ·
`404` unknown booking, or a booking of another patient · `500`

---

## 10. Add / Edit Comment

- **Type:** PUT
- **Screen:** تعديل التعليق (opened from **أضف تعليقك** / **تعديل تعليقك** in the details screen)
- **Purpose:** Save the patient's comment on the doctor for one previous appointment.
- **Endpoint:** `/api/PatientBooking/bookings/comment` — ✅ implemented by backend (route, `bookingId` query and `{ "text" }` body confirmed against Postman 2026-10-12; no saved response example yet, so the response shape below is not verified)

**One endpoint for add and edit**, same as the rating: one comment per booking, the first
call creates it and later calls replace its text.

### Request

```
PUT /PatientBooking/bookings/comment?bookingId={bookingId}
```

| Query param | Type   | Required | Description |
|-------------|--------|----------|-------------|
| `bookingId` | string | yes      | `bookingId` of the previous appointment |

```json
{ "text": "دكتور محترم جداً، استمع لشكوتي باهتمام وشرح الحالة بالتفصيل." }
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `text` | string | yes | 1–500 characters after trimming. |

### Response — `200 OK`

Returns the saved comment in the **same shape as `userComment`** in booking details (section 5).

```json
{
  "success": true,
  "data": {
    "text": "دكتور محترم جداً، استمع لشكوتي باهتمام وشرح الحالة بالتفصيل.",
    "date": "2026-10-05"
  }
}
```

Rules:
- Only for `completed` bookings of the requesting patient, both types.
- `date` is the day of the last save (**تم النشر في …**).
- The comment is the one listed in the doctor profile's `reviews[]` and counted in
  `commentsCount` — the first save adds one to the count, an edit does not.
- Rating and comment are independent: either can exist without the other.

**⚠️ open:** confirm the max length (the app limits the field to 500 characters for
now). Are comments published immediately or after moderation? Is deleting a rating or a
comment needed? (No design for it — not supported for now.)

### Errors

`400` missing `bookingId`, empty or too long `text`, or booking not completed · `401` ·
`404` unknown booking, or a booking of another patient · `500`

---

## 11. Get Appointment Room

- **Type:** GET
- **Screen:** الكشف / الاستشارة — *اجتماعك الطبي مع الطبيب* (opened from **دخول عند الطبيب** on an upcoming card)
- **Purpose:** Return everything the room screen shows for one upcoming appointment: the doctor and appointment summary, the participants, and the patient's questions for the doctor.
- **Endpoint:** `/api/PatientBooking/bookings/room` — ✅ implemented by backend (route and `bookingId` query confirmed against Postman 2026-10-12; no saved response example yet, so the response shape below is not verified)

This is the screen's **main endpoint** — one call when the screen opens. Works for both
booking types (the screen title is **الكشف** or **الاستشارة** according to `type`).

### Request

```
GET /PatientBooking/bookings/room?bookingId={bookingId}
```

| Query param | Type   | Required | Description |
|-------------|--------|----------|-------------|
| `bookingId` | string | yes      | `bookingId` from the upcoming list |

### Response — `200 OK`

```json
{
  "success": true,
  "data": {
    "bookingId": "6b01f4c97e523ce1d8678a11",
    "type": "freeFollowUpConsultation",
    "doctor": {
      "id": "6a82e9257e523ce1d86779de",
      "name": "محمد أنور السيد",
      "profileImage": "https://example.com/images/doctor.jpg",
      "specialty": "طب الجلدية",
      "academicTitle": "مدرس",
      "hospital": "مستشفى دار الفؤاد",
      "location": { "country": "مصر", "governorate": "الجيزة" },
      "isOnline": true,
      "rating": 5,
      "commentsCount": 48
    },
    "startsAt": "2026-10-10T11:30:00+03:00",
    "endsAt": "2026-10-10T12:00:00+03:00",
    "maxParticipants": 3,
    "participants": [
      { "participantId": "6c11a0c97e523ce1d8679b01", "name": "أحمد علي", "relation": "أب", "profileImage": "https://example.com/images/p1.jpg" },
      { "participantId": "6c11a0c97e523ce1d8679b02", "name": "منى أحمد", "relation": "زوجة", "profileImage": null }
    ],
    "questions": [
      { "questionId": "6c22b1c97e523ce1d8679c01", "text": "هل أحتاج إلى الاستمرار على الدواء الحالي؟" },
      { "questionId": "6c22b1c97e523ce1d8679c02", "text": "هل هناك فحوصات إضافية مطلوبة؟" },
      { "questionId": "6c22b1c97e523ce1d8679c03", "text": "ما سبب هذه الأعراض التي أشعر بها مؤخراً؟" }
    ]
  }
}
```

| Field | Type | Description |
|-------|------|-------------|
| `bookingId`, `type`, `doctor`, `startsAt`, `endsAt` | — | Same meaning as in upcoming bookings (section 3). |
| `maxParticipants` | int | Max people the patient can add to the call, besides themselves. Shown as **(3/3)** and *"يمكنك إضافة حتى 3 أشخاص"*. |
| `participants[]` | object | People invited to the call besides the patient. |
| `participants[].participantId` | string | Used later by the remove-participant endpoint. |
| `participants[].name` | string | |
| `participants[].relation` | string | Relation to the patient, free text (**أب**, **زوجة**, **أخ**…). |
| `participants[].profileImage` | string \| null | `null` → the app shows the first letter of the name. |
| `questions[]` | object | The patient's questions for the doctor — managed through section 12. |
| `questions[].questionId` | string | Used by edit and delete. |
| `questions[].text` | string | |

What the app does **not** need from the backend here:
- **حالة الكشف / الاستشارة** badge — **مجدول** before `startsAt`, **حان الوقت** between
  `startsAt` and `endsAt`. Derived from the two times, same as the upcoming cards.
- The **دخول إلى الكشف / الاستشارة** button is enabled from `startsAt`. The call itself is
  a later iteration.
- The patient's own card (**أنت · المريض · الأساسي**) is rendered by the app from the
  logged-in user — `participants[]` holds only the extra people.
- **معلومات مهمة** and the privacy note are static app text.

Rules:
- Available for the patient's upcoming bookings (until `endsAt`), both types.
- `participants[]` is **read-only for now** — the add / remove endpoints are deferred.
  Return `[]` until they exist.
- `questions[]` is sorted by creation, oldest first — the app numbers them 1, 2, 3…

### Errors

`400` missing `bookingId`, or booking cancelled / already ended · `401` ·
`404` unknown booking, or a booking of another patient · `500`

---

## 12. Questions for the Doctor

The **أسئلتي للطبيب** section of the room screen: the patient writes the questions they
want to discuss during the appointment. A question belongs to one booking. The list
itself comes from section 11; these three endpoints change it, and the app updates the
section from each response without refetching the room.

Shared rules:
- `text` is 1–300 characters after trimming.
- Questions can be added, edited and deleted until the booking's `endsAt`.
- The order never changes: a new question goes last, an edited one keeps its position.

**⚠️ open:** confirm the max length (300 is proposed — the app's dialog has no limit
today) and whether there is a max number of questions per booking. Also: when does the
doctor see these questions (before the call, or only during it)?

### 12.1 Add Question

- **Type:** POST
- **Screen:** الكشف / الاستشارة → **إضافة سؤال**
- **Purpose:** Add a question to the booking.
- **Endpoint:** `/api/PatientBooking/bookings/questions` — ✅ implemented by backend (method, route and query params confirmed against Postman 2026-10-12; no saved response example yet, so the response shape below is not verified)

#### Request

```
POST /PatientBooking/bookings/questions?bookingId={bookingId}
```

| Query param | Type   | Required | Description |
|-------------|--------|----------|-------------|
| `bookingId` | string | yes      | Booking the question belongs to |

```json
{ "text": "هل أحتاج إلى الاستمرار على الدواء الحالي؟" }
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `text` | string | yes | The question, 1–300 characters after trimming. |

#### Response — `201 Created`

```json
{
  "success": true,
  "data": {
    "questionId": "6c22b1c97e523ce1d8679c04",
    "text": "هل أحتاج إلى الاستمرار على الدواء الحالي؟"
  }
}
```

#### Errors

`400` missing `bookingId`, empty or too long `text`, or booking cancelled / already ended ·
`401` · `404` unknown booking, or a booking of another patient · `500`

### 12.2 Edit Question

- **Type:** PUT
- **Screen:** الكشف / الاستشارة → question menu (⋮) → **تعديل**
- **Purpose:** Replace the text of one question.
- **Endpoint:** `/api/PatientBooking/bookings/questions` — ✅ implemented by backend (method, route and query params confirmed against Postman 2026-10-12; no saved response example yet, so the response shape below is not verified)

#### Request

```
PUT /PatientBooking/bookings/questions?bookingId={bookingId}&questionId={questionId}
```

| Query param  | Type   | Required | Description |
|--------------|--------|----------|-------------|
| `bookingId`  | string | yes      | Booking the question belongs to |
| `questionId` | string | yes      | `questionId` from the room response or from add |

```json
{ "text": "هل أحتاج إلى تغيير جرعة الدواء الحالي؟" }
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `text` | string | yes | The new text, 1–300 characters after trimming. |

#### Response — `200 OK`

```json
{
  "success": true,
  "data": {
    "questionId": "6c22b1c97e523ce1d8679c01",
    "text": "هل أحتاج إلى تغيير جرعة الدواء الحالي؟"
  }
}
```

#### Errors

`400` missing parameter, empty or too long `text`, or booking cancelled / already ended ·
`401` · `404` unknown booking or question, or a booking of another patient · `500`

### 12.3 Delete Question

- **Type:** DELETE
- **Screen:** الكشف / الاستشارة → question menu (⋮) → **حذف**
- **Purpose:** Remove one question from the booking.
- **Endpoint:** `/api/PatientBooking/bookings/questions` — ✅ implemented by backend (method, route and query params confirmed against Postman 2026-10-12; no saved response example yet, so the response shape below is not verified)

#### Request

```
DELETE /PatientBooking/bookings/questions?bookingId={bookingId}&questionId={questionId}
```

| Query param  | Type   | Required | Description |
|--------------|--------|----------|-------------|
| `bookingId`  | string | yes      | Booking the question belongs to |
| `questionId` | string | yes      | `questionId` of the question to remove |

No request body.

#### Response — `200 OK`

```json
{
  "success": true,
  "data": { "questionId": "6c22b1c97e523ce1d8679c01" }
}
```

Idempotent: deleting a question that is already deleted returns the same `200` (the
app's Dio layer retries a request that answered `500`).

#### Errors

`400` missing parameter, or booking cancelled / already ended · `401` ·
`404` unknown booking, or a booking of another patient · `500`

---

## Open points

- **⚠️ Care mode** — when the user is acting on another patient's profile, the app sends
  the `Active-Medical-Profile` header. Backend to decide whether bookings belong to the
  token's user or to that active profile.
- **⚠️ Cancel / reschedule policy** — deadlines, reschedule limit, and whether cancelled
  bookings show in history (sections 7 and 8).
- **⚠️ Comments** — max length, moderation, and delete (section 10).
- **⚠️ Questions** — max length, max count, and when the doctor sees them (section 12).
- **Next iterations:** payment, the video call itself, add / remove room participants.

---

## Appendix — Data access module identifiers

Values sent in `dataAccessModules` (endpoint 2). Source of truth: `MedicalModule` in
`lib/core/models/medical_module_enum.dart`; the list shown on the booking screen is in
`lib/features/online_doctor/data/models/book_appointment_dummy_data.dart`.

| Module (Arabic, as shown in app) | Identifier |
|---|---|
| القياسات الحيوية | `vitalSigns` |
| الأدوية | `medications` |
| الشكاوى الطارئة | `urgentComplaints` |
| روشتة الأطباء | `doctorsPrescriptions` |
| التحاليل الطبية | `medicalTests` |
| الأشعة | `radiology` |
| العمليات | `surgeries` |
| الأمراض المزمنة | `chronicDiseases` |
| الأمراض الوراثية | `geneticDiseases` |
| الحساسية | `allergies` |
| العيون | `eyes` |
| الأسنان | `dental` |
| التطعيمات | `vaccinations` |
| الأمراض النفسية | `mentalHealth` |
| السلوكيات الخطرة | `riskyBehaviors` |
| المتابعة الغذائية | `smartNutritionalAnalyzer` |
| النشاط الرياضي | `sportsActivity` |
| المكملات الغذائية | `supplements` |

The remaining modules on the screen (المناظير الطبية، الأورام، الغسيل الكلوى…) are shown
disabled and are never sent yet.
