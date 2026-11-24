# Doctor Home — API Contract

Base: `http://147.93.57.70/api/DoctorHome`.
All endpoints expect `Authorization: Bearer <token>` of a **doctor** account (the app's Dio interceptor adds it).
The doctor always comes from the token. The app never sends a `doctorId`.

> **Implemented by backend and verified on 2026-11-17.** We called all four endpoints from
> the app with a doctor token. Each live response matched the shape documented below, with
> the same field names and types. `profileImage` came back `null` for a doctor with no
> photo, which is the expected behavior. (The Postman requests in the *Doctor Home Status*
> folder still carry a leftover JSON body copied from the prescription request. These are
> GET requests, so the body is ignored.)
> Items marked **⚠️ open** need a backend decision.

Covers the doctor app's **home screen** (الرئيسية). The screen has four sections, and each
section has its **own endpoint**:

| # | Section | Endpoint |
|---|---------|----------|
| 1 | Header: doctor name, specialty, photo | `GET /DoctorHome/profile-summary` |
| 2 | Daily bookings stats: **الانتظار**, **المتابعات**, **الحجوزات الحالية**, **الحجوزات المسموحة** | `GET /DoctorHome/bookings-stats` |
| 3 | Monthly examinations: **المستهدف** / **المحقق** | `GET /DoctorHome/monthly-examinations` |
| 4 | Performance: **المشاهدات**, **المشاركات**, **مرات الظهور** | `GET /DoctorHome/performance-stats` |

**Why four endpoints and not one:** the app calls all four at the same time, and each
section shows its own loading skeleton. If one query is slow (for example the performance
counters), only that section waits and the rest of the screen still shows. If one call
fails, only that section shows an error with a retry button. So **please keep every
endpoint independent.** None of them should depend on another.

**Out of scope for now:** the clinic logo. The ad banner, comments and ratings are in [doctor_home_ads_comments_ratings_api.md](doctor_home_ads_comments_ratings_api.md).

Error shape: the app's shared error model (`ApiErrorModel` in
`lib/core/networking/api_error_model.dart`), used on **every** non-2xx response:

```json
{ "success": false, "errors": ["Unauthorized"] }
```

| Status | When |
|--------|------|
| `401` | Missing / invalid token |
| `403` | The token does not belong to a doctor account |
| `500` | Server error |

### Conventions

- **Times are Egypt local time** (`Africa/Cairo`).
- **Today** means the current calendar day in `Africa/Cairo`. This is the same "today" used by
  `GET /DoctorBookings/bookings` (see [doctor_bookings_api.md](doctor_bookings_api.md)).
- Counters are integers and are never `null`. Return `0` when there is no data.
- No endpoint takes a parameter.

---

## 1. Get Profile Summary

- **Type:** GET
- **Section:** the header (doctor photo, name, specialty)
- **Endpoint:** `/api/DoctorHome/profile-summary`

The app **caches** this response on the device. On later launches it shows the cached
header at once, then calls this endpoint in the background and updates the header if
something changed. The app also refreshes the cache after the doctor edits their profile.
**Keep this endpoint light:** return only these three fields.

### Response — `200 OK`

```json
{
  "success": true,
  "data": {
    "name": "أحمد محمود",
    "specialty": "استشارى جهاز مناعى",
    "profileImage": "https://example.com/images/doctor.jpg"
  }
}
```

| Field | Type | Notes |
|-------|------|-------|
| `name` | string | Full name **without** the `د/` prefix. The app adds the prefix. |
| `specialty` | string | The text shown under the name, ready to display. |
| `profileImage` | string \| null | Absolute URL. `null` when the doctor has no photo, and the app shows a placeholder. |

> **⚠️ open:** what goes in `specialty`? It could be the main medical specialty only, or a
> title plus the specialty (for example *استشارى* + *جهاز مناعى*). The app shows whatever
> string you send.

---

## 2. Get Bookings Stats

- **Type:** GET
- **Section:** the four counters at the top of the screen
- **Endpoint:** `/api/DoctorHome/bookings-stats`

These counters change all day. The app does **not** cache them. It calls this endpoint
whenever the home screen opens and on pull-to-refresh. All counters are for **today**.

### Response — `200 OK`

```json
{
  "success": true,
  "data": {
    "waitingCount": 10,
    "followUpsCount": 8,
    "currentBookingsCount": 15,
    "allowedBookingsCount": 20
  }
}
```

| Field | Label in app | Meaning |
|-------|--------------|---------|
| `waitingCount` | الانتظار | Patients in today's waiting list right now. This must equal the length of `waitingList` returned by `GET /DoctorBookings/bookings`. |
| `followUpsCount` | المتابعات | Today's bookings with `type = freeFollowUpConsultation`. |
| `currentBookingsCount` | الحجوزات الحالية | Today's bookings (الكشوفات اليومية). Count every booking that is not cancelled or rejected, whether it is done or still coming. |
| `allowedBookingsCount` | الحجوزات المسموحة | The doctor's daily booking limit: `maxDailyBookings` from booking settings (`/DoctorUserForDoctor/booking-settings`). |

> **⚠️ open:** does `currentBookingsCount` include the follow-ups counted in
> `followUpsCount`, or only `type = onlineExamination`? The app only shows the numbers, so
> either works. Please confirm which one so both sides read it the same way.

---

## 3. Get Monthly Examinations

- **Type:** GET
- **Section:** **الكشوفات الشهرية** (target vs. achieved)
- **Endpoint:** `/api/DoctorHome/monthly-examinations`

This section is for the **current calendar month** (`Africa/Cairo`). It is not a rolling
30-day window, because it must match the monthly target the doctor sets in
`/DoctorUserForDoctor/monthly-examination-targets`, and that target is stored per calendar
month.

### Response — `200 OK`

```json
{
  "success": true,
  "data": {
    "targetCount": 10,
    "achievedCount": 8
  }
}
```

| Field | Type | Notes |
|-------|------|-------|
| `targetCount` | int | The current month's target from monthly-examination-targets. `0` if the doctor has not set one. |
| `achievedCount` | int | Completed examinations this month. Use the same definition as the achieved count already returned by monthly-examination-targets, so the two screens always show the same number. |

The app works out the percentage (**نسبة تحقيق 80%**) as `achievedCount / targetCount`, so
please **don't** send a percentage.

---

## 4. Get Performance Stats

- **Type:** GET
- **Section:** the three performance cards
- **Endpoint:** `/api/DoctorHome/performance-stats`

Each card shows two numbers. **في الشهر** is the **last 30 days** and **في السنة** is the
**last 12 months**. Both are rolling windows that end now and include today. They are not
calendar periods.

### Response — `200 OK`

```json
{
  "success": true,
  "data": {
    "views":       { "last30Days": 200, "last12Months": 600 },
    "shares":      { "last30Days": 200, "last12Months": 600 },
    "appearances": { "last30Days": 200, "last12Months": 600 }
  }
}
```

| Field | Label in app | Meaning |
|-------|--------------|---------|
| `views` | المشاهدات | How many times patients opened the doctor's profile page. |
| `shares` | المشاركات | How many times patients shared the doctor's profile. |
| `appearances` | مرات الظهور | How many times the doctor appeared in patients' search or listing results. |

> **⚠️ open: how these events get recorded.** As far as the mobile team knows, the backend
> does not count any of these three events today.
> - **views** and **appearances** can be counted on the server, inside the patient-side
>   endpoints that return the doctor profile and the doctors list or search results.
> - **shares** happen inside the patient app and don't call the server. Recording them needs
>   a small tracking endpoint that the patient app calls when the patient shares. Please
>   propose one.
>
> Also, should one patient opening the same profile many times count once or every time?
>
> This query is likely the heaviest on the screen. Using pre-aggregated daily counters (one
> row per doctor per day) keeps it fast.
