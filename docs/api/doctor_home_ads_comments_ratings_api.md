# Doctor Home — Ads, Comments & Ratings API Contract

Base: `http://147.93.57.70/api/DoctorHome`.
All endpoints expect `Authorization: Bearer <token>` of a **doctor** account (the app's Dio interceptor adds it).
The doctor always comes from the token. The app never sends a `doctorId`.

> **Status:** ads (section 1) are implemented. Comments and ratings (sections 2–3) are not
> implemented by backend yet (requested 2026-11-19). The app is already wired to all three
> endpoints exactly as documented below. Until comments and ratings exist, each of those
> sections shows its own error with a retry button.
> Items marked **⚠️ open** need a backend decision.

Covers the three lower sections of the doctor app's **home screen** (الرئيسية). The top
four sections (header, bookings stats, monthly examinations, performance) are documented in
[doctor_home_api.md](doctor_home_api.md). The same rules apply here: **each section has its
own endpoint**, the app calls them all at the same time, and if one fails only that section
shows an error. Please keep every endpoint independent.

| # | Section | Endpoint |
|---|---------|----------|
| 1 | Ad banner carousel (الإعلانات) | `GET /Ad/doctor/all` ✅ implemented |
| 2 | Comments: total count + latest comments (التعليقات) | `GET /DoctorHome/latest-comments` |
| 3 | Ratings bar: **المقيمين** count + average rating | `GET /DoctorHome/ratings-summary` |

**Out of scope for now:** the full comments list behind **عرض المزيد**. It will get its own
paginated endpoint later.

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

- No endpoint takes a parameter.
- Counters are integers and are never `null`. Return `0` when there is no data.
- Timestamps are ISO 8601 **with offset** in Egypt local time (`Africa/Cairo`), for example
  `2026-11-19T10:15:00+02:00`. This is the same format as `GET /DoctorBookings/bookings`.

---

## 1. Get Ads

- **Type:** GET
- **Section:** the ad banner carousel under the header
- **Endpoint:** `/api/Ad/doctor/all?userType=Doctor&language=ar`

> **Implemented by backend and verified on 2026-11-19.** The backend built this endpoint
> instead of the `GET /DoctorHome/ads` we first proposed. The app is wired to it exactly as
> shown here. Postman: *Ads → Get Ads For Each Doctors*.

The banner is an auto-playing carousel, the same as the ads on the patient home. The app
shows the ads in the order you send them, and hides the section when `data` is empty.

### Query parameters

| Name | Value |
|------|-------|
| `userType` | `Doctor` |
| `language` | `ar` |

### Response — `200 OK` (verified)

```json
{
  "success": true,
  "errors": null,
  "data": [
    "http://localhost:5283/api/ads/media/f08cdc50-715b-447a-a135-803336e25318.png"
  ]
}
```

| Field | Type | Notes |
|-------|------|-------|
| `data` | string[] | Ad image URLs. This is the same shape as the patient ads endpoint (`/Ad/user/all`). |

> **⚠️ open: image URLs point to `localhost`.** The live response returns
> `http://localhost:5283/...`. A phone can't reach `localhost` on the server, so the images
> fail to load in the app. Please return the public host (for example
> `http://147.93.57.70/...`).

---

## 2. Get Latest Comments

- **Type:** GET
- **Section:** **التعليقات** — the total count and the newest comments
- **Endpoint:** `/api/DoctorHome/latest-comments`

These are the comments patients wrote on this doctor's profile. They come from the **same
source** as `commentsCount` and `reviews[]` on the patient side (see
[online_doctor_api.md](online_doctor_api.md)), so the numbers on both sides must match.

Each comment shows the patient's name on the right and the **date and time** it was written
on the left (for example `19 نوفمبر 2026 - 10:15 صباحاً`). The app formats the date; send
only the raw timestamp.

### Response — `200 OK`

```json
{
  "success": true,
  "data": {
    "totalCount": 80,
    "comments": [
      {
        "id": "6a8f2d417e523ce1d8670101",
        "patientName": "مصطفى عبدالله",
        "comment": "دكتور ممتاز وشرح الحالة بالتفصيل.",
        "createdAt": "2026-11-19T10:15:00+02:00"
      },
      {
        "id": "6a8f2d417e523ce1d8670102",
        "patientName": "ندى كمال",
        "comment": "المتابعة كانت سريعة ومنظمة.",
        "createdAt": "2026-11-18T18:40:00+02:00"
      }
    ]
  }
}
```

| Field | Type | Notes |
|-------|------|-------|
| `totalCount` | int | All comments on this doctor (the number next to **التعليقات**). `0` when there are none. |
| `comments` | array | The **3 newest** comments, newest first. `[]` when there are none. |
| `comments[].id` | string | Comment ID. |
| `comments[].patientName` | string | Name shown on the comment. |
| `comments[].comment` | string | The comment text. The app trims long text visually; send the full text. |
| `comments[].createdAt` | string | When the comment was written. ISO 8601 with offset. |

> **⚠️ open:** if a patient posts anonymously (or deletes their account), what should
> `patientName` be? Please send a display-ready value (for example `"مريض"`) rather than
> `null`.

---

## 3. Get Ratings Summary

- **Type:** GET
- **Section:** the ratings bar — **المقيمين** with the count and the stars
- **Endpoint:** `/api/DoctorHome/ratings-summary`

### Response — `200 OK`

```json
{
  "success": true,
  "data": {
    "ratingsCount": 150,
    "averageRating": 4.3
  }
}
```

| Field | Type | Notes |
|-------|------|-------|
| `ratingsCount` | int | How many patients rated the doctor (the number next to **المقيمين**). `0` when there are none. |
| `averageRating` | number | Average of all ratings, `0`–`5`, rounded to **one decimal**. `0` when there are no ratings. Must equal `rating` on the patient side (see [online_doctor_api.md](online_doctor_api.md)). |

The app draws the stars from `averageRating`, so please **don't** send a star count.

