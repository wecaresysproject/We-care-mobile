# Doctor Bookings — API Contract

Base: `http://147.93.57.70/api/DoctorBookings`.
All endpoints expect `Authorization: Bearer <token>` of a **doctor** account — the app's Dio interceptor adds it.
The doctor is always taken from the token; no `doctorId` is sent.

> **Implemented by backend — methods, routes and query params confirmed against Postman
> 2026-10-13.** Postman has no saved response examples yet, so the response shapes below
> are still the proposed ones and are not verified.
>
> **⚠️ Observed 2026-10-13 — the live response of section 1 differs from this contract:**
> `data` is `{ "date": "2026-10-13", "appointments": [], "waitingList": [] }` — there is
> no `doctor` object, and the lists are named `appointments` / `waitingList` instead of
> `todayAppointments` / `waitingPatients`. The app reads the live names and hides the
> doctor header card. Both lists were empty, so the item shape is still unverified.
> Covers the doctor-side **الحجوزات** screen (*إدارة مواعيد اليوم والمرضى في الانتظار*):
> today's appointments and the waiting list.
> Items marked **⚠️ open** need a backend decision.

This is the doctor-side counterpart of [patient_booking_api.md](patient_booking_api.md):
the same bookings, the same `bookingId`, and the same `type` values.

**Out of scope for now:** **السماح بالدخول** (letting the patient into the call) — it
belongs to the video-call flow, which is not defined yet on either side.

Error shape — the app's shared error model (`ApiErrorModel` in
`lib/core/networking/api_error_model.dart`), used on **every** non-2xx response:

```json
{ "success": false, "errors": ["Booking not found"] }
```

| Status | When |
|--------|------|
| `400` | Missing / invalid parameter |
| `401` | Missing / invalid token |
| `403` | The token does not belong to a doctor account |
| `404` | Unknown `bookingId`, or a booking of another doctor |
| `409` | The patient is no longer in the waiting list (accept / reject only) |
| `500` | Server error |

### Conventions

- **Times are Egypt local time** (`Africa/Cairo`), sent as ISO 8601 **with offset**
  (`2026-10-06T09:00:00+03:00`) — the app shows live minute counters from them.
- **Today** means the current calendar day in `Africa/Cairo`.
- List fields return `[]` when empty, never `null`.
- `type` — same values as the patient contract: `onlineExamination` (**كشف**) and
  `freeFollowUpConsultation` (**استشارة**).

---

## 1. Get Doctor Bookings

- **Type:** GET
- **Screen:** الحجوزات (doctor app)
- **Purpose:** Return everything the screen shows: the doctor header, today's appointments, and the waiting list.
- **Endpoint:** `/api/DoctorBookings/bookings`

This is the screen's **main endpoint** — one call when the screen opens, and again on refresh.

### Request

```
GET /DoctorBookings/bookings
```

No parameters.

### Response — `200 OK`

```json
{
  "success": true,
  "data": {
    "doctor": {
      "name": "أحمد محمود مصطفى",
      "specialty": "أنف وأذن وحنجرة",
      "profileImage": "https://example.com/images/doctor.jpg"
    },
    "todayAppointments": [
      {
        "bookingId": "6b01f4c97e523ce1d8678a10",
        "type": "onlineExamination",
        "patient": { "name": "أحمد محمد علي", "profileImage": null },
        "startsAt": "2026-10-06T09:00:00+03:00"
      },
      {
        "bookingId": "6b01f4c97e523ce1d8678a12",
        "type": "freeFollowUpConsultation",
        "patient": { "name": "محمد حسن إبراهيم", "profileImage": "https://example.com/images/p3.jpg" },
        "startsAt": "2026-10-06T10:00:00+03:00"
      }
    ],
    "waitingPatients": [
      {
        "bookingId": "6b01f4c97e523ce1d8678b01",
        "type": "onlineExamination",
        "patient": { "name": "ليلى محمود يوسف", "profileImage": null },
        "requestedAt": "2026-10-06T08:15:00+03:00"
      }
    ]
  }
}
```

| Field | Type | Description |
|-------|------|-------------|
| `doctor.name` | string | The logged-in doctor's display name (header card). |
| `doctor.specialty` | string | Main specialty, shown under the name. |
| `doctor.profileImage` | string \| null | Image URL. |
| `todayAppointments[]` | object | **مواعيد اليوم** — one row per appointment. |
| `waitingPatients[]` | object | **قائمة الانتظار** — one row per waiting patient. |
| `bookingId` | string | Booking ID. Sent to accept / reject, and later to the call flow. |
| `type` | string | `onlineExamination` \| `freeFollowUpConsultation` — picks the **كشف** / **استشارة** badge. |
| `patient.name` | string | Patient display name. |
| `patient.profileImage` | string \| null | `null` → the app shows a placeholder avatar. |
| `startsAt` | string | Appointment time (today's appointments only). |
| `requestedAt` | string | When the patient joined the waiting list (waiting patients only). |

What the app derives itself — no fields needed:
- The **5 مرضى** / **3 مرضى** badges — the length of each list.
- The time under the name (**09:00 ص**) — from `startsAt` / `requestedAt`.
- The appointment status, from `startsAt`: **متبقي N دقيقة** before it, **حان الموعد** at
  it, **متأخر N دقيقة** after it.
- **منذ N دقيقة** in the waiting list — from `requestedAt`.

Rules:
- `todayAppointments`: the doctor's confirmed bookings whose `startsAt` is today, not
  cancelled and not completed. Sorted by `startsAt` ascending. An appointment whose time
  has passed **stays in the list** (shown as **متأخر**) until its session is completed.
- `waitingPatients`: patients waiting for the doctor's decision, oldest `requestedAt` first.
- Nothing to show → the list is `[]` (200).

**⚠️ open:** what puts a patient on the waiting list? No patient-side endpoint creates a
waiting request yet. Our reading of the screen: a patient **without a confirmed slot
today** who asks to be seen — the screen says an accepted patient *"سيتم إضافته إلى
مواعيد اليوم"*. This needs to be confirmed, then the patient-side request endpoint added
to the patient contract.

App models: `BookingsModel`, `TodayAppointmentModel`, `WaitingPatientModel`
(`lib/features/doctor/bookings/data/models/`) — parsed from this shape.

### Errors

`401` · `403` not a doctor account · `500`

---

## 2. Accept Waiting Patient

- **Type:** POST
- **Screen:** الحجوزات → قائمة الانتظار → **قبول**
- **Purpose:** Accept a waiting patient — moves them from the waiting list into today's appointments.
- **Endpoint:** `/api/DoctorBookings/waiting-list/accept`

### Request

```
POST /DoctorBookings/waiting-list/accept?bookingId={bookingId}
```

| Query param | Type   | Required | Description |
|-------------|--------|----------|-------------|
| `bookingId` | string | yes      | `bookingId` of the waiting patient |

No request body.

### Response — `200 OK`

Returns the patient as a **today's-appointment item** (same shape as in section 1), so
the app moves the row without refetching.

```json
{
  "success": true,
  "data": {
    "bookingId": "6b01f4c97e523ce1d8678b01",
    "type": "onlineExamination",
    "patient": { "name": "ليلى محمود يوسف", "profileImage": null },
    "startsAt": "2026-10-06T09:00:00+03:00"
  }
}
```

Rules:
- The entry keeps the same `bookingId`.
- `startsAt` is set by the backend — the acceptance time, so the row shows **حان الموعد**.
- Accepting does **not** start the call: the doctor still presses **السماح بالدخول**
  when ready.
- After success the patient is returned in `todayAppointments` and no longer in
  `waitingPatients`.
- Idempotent: accepting an already-accepted patient returns the same `200` (the app's
  Dio layer retries a request that answered `500`).

### Errors

```json
{ "success": false, "errors": ["Patient is no longer in the waiting list"] }
```

`400` missing `bookingId` · `401` · `403` · `404` unknown booking, or a booking of
another doctor · `409` the patient left the waiting list or was already rejected (the
app removes the row and refetches) · `500`

---

## 3. Reject Waiting Patient

- **Type:** POST
- **Screen:** الحجوزات → قائمة الانتظار → **رفض**
- **Purpose:** Reject a waiting patient — removes them from the waiting list.
- **Endpoint:** `/api/DoctorBookings/waiting-list/reject`

### Request

```
POST /DoctorBookings/waiting-list/reject?bookingId={bookingId}
```

| Query param | Type   | Required | Description |
|-------------|--------|----------|-------------|
| `bookingId` | string | yes      | `bookingId` of the waiting patient |

No request body — the design has no rejection reason.

### Response — `200 OK`

```json
{
  "success": true,
  "data": { "bookingId": "6b01f4c97e523ce1d8678b01", "status": "rejected" }
}
```

Rules:
- After success the patient is no longer returned in `waitingPatients`, and is **not**
  added to `todayAppointments`.
- Idempotent: rejecting an already-rejected patient returns the same `200`.

### Errors

`400` missing `bookingId` · `401` · `403` · `404` unknown booking, or a booking of
another doctor · `409` the patient left the waiting list or was already accepted (the
app refetches) · `500`

---

## Open points

- **⚠️ Waiting-list source** — which patient action creates a waiting entry (section 1).
- **⚠️ Patient notification** — is the patient notified (push) when accepted or rejected?
  The app has no screen for it yet.
- **⚠️ Daily limit** — does accepting a waiting patient count against the doctor's
  `maxDailyBookings` (booking settings), and is accept blocked when it is reached?
- **⚠️ New waiting patients** — the app learns about them by refetching section 1 (on
  open and on refresh). Say if a push / socket channel is preferred.
- **⚠️ Late appointments** — the patient contract moves a booking to history at `endsAt`,
  while this screen keeps a late appointment until its session is completed. The two
  sides need one rule for an appointment that did not start on time.
- **Next iteration:** **السماح بالدخول** and the video-call flow.
