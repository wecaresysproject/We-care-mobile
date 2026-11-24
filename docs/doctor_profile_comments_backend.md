# Doctor Profile — Comments (Backend Request)

**Screen:** Patient app → doctor profile (ملف الطبيب).
**Section:** **التعليقات**, shown right after **معلومات الحجز** and before **التخصص والاهتمامات الطبية**.
The section shows the 3 newest comments. A **المزيد** button loads more.

**Mobile status:** done. The section stays hidden until the profile response includes `latestComments`, so nothing breaks before the backend ships. Nothing else on the profile screen changes.

The comments come from the same place as the existing `comments` count on the profile. These are the comments patients save through `PUT /PatientBooking/bookings/comment`.

Two changes are needed:

1. **Change an existing endpoint:** add `latestComments` to `GET /api/OnlineDoctor/profile`.
2. **Add a new endpoint:** `GET /api/OnlineDoctor/comments`, which **المزيد** calls.

---

## 1. Add `latestComments` to `GET /api/OnlineDoctor/profile?doctorId=3`

Add a new `latestComments` array inside `data`. Keep the existing `comments` field as the total number of comments.

```json
{
  "success": true,
  "message": "تم جلب ملف الطبيب بنجاح.",
  "data": {
    "doctorId": "3",
    "...": "all existing fields stay as they are",
    "rating": 4.3,
    "likes": 1,
    "comments": 7,
    "latestComments": [
      {
        "id": "6b0a1f2c9d3e4a5b6c7d8e9f",
        "patientName": "أشرف السيد أمين",
        "comment": "اداء مميز ودكتور محترم وشاطر.",
        "createdAt": "2026-11-18T20:11:00+02:00"
      },
      {
        "id": "6b0a1f2c9d3e4a5b6c7d8ea0",
        "patientName": "أشرف السيد أمين",
        "comment": "ارى انه من افضل الدكاترة الحاليين، واوصي به بشدة.",
        "createdAt": "2026-11-18T02:00:00+02:00"
      },
      {
        "id": "6b0a1f2c9d3e4a5b6c7d8ea1",
        "patientName": "أشرف السيد أمين",
        "comment": "دكتور ممتاز، و دقيق في عمله.",
        "createdAt": "2026-11-18T01:59:00+02:00"
      }
    ]
  }
}
```

| Field | Type | Notes |
|---|---|---|
| `comments` | int | Already exists. Total number of comments on this doctor, shown next to **التعليقات**. It also decides whether **المزيد** appears, so it must count the same comments as the list. |
| `latestComments` | array | The **3 newest** comments, newest first. Send `[]` when there are none, never `null`. |
| `latestComments[].id` | string | Comment ID. Must stay the same across requests, because the app uses it to drop duplicates when it loads more. |
| `latestComments[].patientName` | string | Name shown on the comment. |
| `latestComments[].comment` | string | Full comment text. Exclude empty comments. |
| `latestComments[].createdAt` | string | When the comment was written. ISO 8601 with an offset. |

---

## 2. New endpoint: `GET /api/OnlineDoctor/comments`

The app calls this when the patient taps **المزيد**. It returns the next page of comments, newest first.

- **Auth:** the same bearer token as the profile endpoint.
- **Query params:**

| Param | Type | Notes |
|---|---|---|
| `doctorId` | string | Required. Same value as in the profile endpoint. |
| `skip` | int | How many comments the app already shows. The first tap sends `skip=3`, because the profile already returned 3. |
| `take` | int | Page size. The app sends `10`. |

Example: `GET /api/OnlineDoctor/comments?doctorId=3&skip=3&take=10`

```json
{
  "success": true,
  "message": "تم جلب التعليقات بنجاح.",
  "data": {
    "totalCount": 7,
    "comments": [
      {
        "id": "6b0a1f2c9d3e4a5b6c7d8ea2",
        "patientName": "محمد علي",
        "comment": "متابعة ممتازة وشرح واضح.",
        "createdAt": "2026-11-15T13:40:00+02:00"
      }
    ]
  }
}
```

| Field | Type | Notes |
|---|---|---|
| `totalCount` | int | Total number of comments on this doctor. Same value as `comments` in the profile. |
| `comments` | array | Up to `take` comments after skipping the newest `skip`. Same object shape and same ordering as `latestComments`. Send `[]` when nothing is left. |

**Rules:**

- Use the same ordering as `latestComments`: `createdAt` descending, then `id` as a tiebreaker. Otherwise pages can repeat or skip comments.
- An unknown `doctorId` returns `404` with the usual error body.
- Leave out empty and deleted comments, both from the list and from `totalCount`.
