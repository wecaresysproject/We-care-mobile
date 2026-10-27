# Close participants in the consultation meeting: backend requirements

## Summary
A patient can add close people (existing users in the system) to their consultation meeting by searching for them by mobile number. Each added person gets an FCM message when they are added and another when the doctor starts the consultation. They then join the same Jitsi room as the doctor and the patient.

What we need from the backend:
- Changes to 4 existing endpoints.
- 5 new endpoints.
- 1 optional endpoint.

## Agreed decisions
- **Direct add.** There is no invite and no accept step. The patient adds the person, and the person only gets a message telling them.
- **Search by mobile number** uses the existing care-access search endpoint. The add form also asks for the **relation**.
- **Participant limit** is always 3, not counting the patient. The server still returns it as `maxParticipants` so the app doesn't hard-code it.
- **Participants only join the call.** They can't see the patient's medical file or questions.
- **The patient also gets `consultationStarted`** when the doctor starts the meeting, alongside the participants.
- **Messages are stored on the backend.** Every FCM sent for this feature is also saved as a message, so it shows on the in-app messages page even if the push notification is gone.
- **Security.** `GET /Video` returns the meeting only to the doctor, the patient and the added participants. Anyone else gets 403. JWT on Jitsi is deferred to a later phase.
- **No server change for the call itself.** Jitsi already supports several people in one room, and participants join with the same `roomName`.

## Flow
```
Patient                      Backend                               Close person
───────                      ───────                               ────────────
Search by phone (#1)
Add participant (#3)  ──▶    Save message + send FCM
                             (meetingParticipantAdded)    ──▶      Sees it on the messages page (#7, #9)

Doctor starts meeting (#6) ▶ Save message + send FCM to the
                             patient and every participant
                             (consultationStarted)             ──▶ Opens the call from the push
                                                                   or the messages page:
                                                                   GET /Video (#5) → Jitsi room
```

## Endpoints overview
All endpoints keep the current response shape: `{ success, message, data }`.

| # | Endpoint | Status | What's needed |
|---|---|---|---|
| 1 | `GET AccessManagement/searchPhoneNumber?PhoneNumber=` | Change | Return `profileImage` for each user |
| 2 | `GET PatientBooking/bookings/room?bookingId=` | Change | Return the stored `participants[]` and `maxParticipants` |
| 3 | `POST PatientBooking/bookings/participants?bookingId=` | New | Add a participant, then save a message and send FCM |
| 4 | `DELETE PatientBooking/bookings/participants?bookingId=&participantId=` | New | Remove a participant |
| 5 | `GET Video?appointmentId=` | Change | Allow participants; return `displayName` and `role` |
| 6 | `POST Video/start?appointmentId=` | Change | Save a message and send FCM to the patient and every participant |
| 7 | `GET Notifications?pageNumber=&pageSize=` | New | The current user's messages |
| 8 | `GET Notifications/unread-count` | New | Unread count for the bell badge |
| 9 | `PUT Notifications/{id}/read` | New | Mark a message as read |
| 10 | `GET PatientBooking/bookings/participations` | Optional | Upcoming meetings the current user was added to |

The paths are suggestions and can follow the backend's own naming. The fields and the behavior are what matter.

## Endpoint details

### 1. Search by phone (change)
`GET AccessManagement/searchPhoneNumber?PhoneNumber=+201xxxxxxxxx`

Add a nullable `profileImage` to each user. This only adds a field, so the care-access screen keeps working.

```json
{ "data": { "users": [ { "userId": 12, "fullName": "...", "phoneNumber": "+20...", "profileImage": "https://..." } ] } }
```

### 2. Room data (change)
`GET PatientBooking/bookings/room?bookingId=55`

Return the participants stored in the database, alongside the current booking fields and questions.

```json
{
  "data": {
    "bookingId": 55,
    "...": "other booking fields unchanged",
    "maxParticipants": 3,
    "participants": [
      { "participantId": 7, "userId": 12, "name": "...", "relation": "Brother", "profileImage": null }
    ],
    "questions": []
  }
}
```

### 3. Add participant (new)
`POST PatientBooking/bookings/participants?bookingId=55`

This follows the same pattern as the existing `bookings/questions` endpoint: `bookingId` goes in the query and the data goes in the body.

```json
{ "userId": 12, "relation": "Brother" }
```

**Response:** the added participant, in the same shape as an item of `participants` in #2.

**Validation.** Return a clear Arabic `message` for each case:
- The booking belongs to the requesting patient and hasn't ended.
- The patient isn't adding themselves.
- The person isn't already added to this booking.
- The count doesn't go over `maxParticipants`.
- `relation` isn't empty.

**On success:** save a `meetingParticipantAdded` message for the participant and send them FCM. See [Notifications](#notifications).

### 4. Remove participant (new)
`DELETE PatientBooking/bookings/participants?bookingId=55&participantId=7`

- Only the patient who owns the booking can remove a participant.
- After removal, `GET /Video` returns 403 for that person.
- Optional: send the removed person a message saying they were removed from the meeting.

### 5. Meeting data (change)
`GET Video?appointmentId=55`

- Allow the doctor, the patient and the added participants. Anyone else gets 403.
- Participants get only the meeting data here. Endpoints for the patient's medical file and questions must keep returning 403 for them.
- Keep returning 404 while the doctor hasn't created the meeting yet, as it does today.
- Add `displayName` (the requester's real name) and `role`. `displayName` is the name shown under each video in Jitsi.
- Please return the same two fields from `POST Video/create` and `POST Video/start`, so the doctor joins with their real name too.

```json
{
  "data": {
    "appointmentId": 55,
    "roomName": "...",
    "meetingUrl": "https://<jitsi>/...",
    "status": "created | started | ended",
    "startedAt": null,
    "endedAt": null,
    "displayName": "Mohamed Ahmed",
    "role": "doctor | patient | participant"
  }
}
```

### 6. Start meeting (change)
`POST Video/start?appointmentId=55`

When the status changes to `started`, save a `consultationStarted` message and send FCM to the patient and to every participant added to the booking.

Do this **on the first transition only**. The doctor's app calls this endpoint every time the call screen opens, so later calls must not send duplicate notifications.

### 7. Messages list (new)
`GET Notifications?pageNumber=1&pageSize=20`

Returns the current user's messages, newest first. Each item uses the [stored message shape](#stored-message-shape-item-in-7).

```json
{ "data": { "items": [], "totalCount": 42, "pageNumber": 1, "pageSize": 20 } }
```

### 8. Unread count (new)
`GET Notifications/unread-count` returns `{ "data": { "count": 3 } }`.

### 9. Mark as read (new)
`PUT Notifications/{id}/read`. Optional: `PUT Notifications/read-all`.

### 10. My meetings as a participant (optional)
`GET PatientBooking/bookings/participations` returns the upcoming meetings the user was added to. Each item has `appointmentId`, `patientName`, `doctorName`, `startsAt` and `status`.

This lets a close person reach the meeting even if they never saw the message.

## Notifications
There are two message types:
- `meetingParticipantAdded`, sent from #3.
- `consultationStarted`, sent from #6.

Each message is saved to the database first. Then FCM is sent, carrying the saved message's `id`.

### Stored message shape (item in #7)
```json
{
  "id": 101,
  "type": "meetingParticipantAdded",
  "title": "تمت إضافتك لاستشارة",
  "body": "أضافك محمد أحمد لاستشارته مع د. سارة علي يوم 25/10 الساعة 7:00 م",
  "createdAt": "2026-10-21T10:00:00Z",
  "isRead": false,
  "data": {
    "appointmentId": 55,
    "patientName": "محمد أحمد",
    "doctorName": "سارة علي",
    "startsAt": "2026-10-25T17:00:00Z",
    "bookingType": "onlineExamination"
  }
}
```

### FCM shape
The app reads `data.payload` as a JSON string and routes on `pageRoute`, so these messages must use the same format. Every message needs both a `notification` block and a `data` block.

```json
{
  "notification": { "title": "...", "body": "..." },
  "data": {
    "payload": "{\"pageRoute\":\"consultationStarted\",\"notificationId\":102,\"appointmentId\":55,\"patientName\":\"...\",\"doctorName\":\"...\",\"startsAt\":\"2026-10-25T17:00:00Z\"}"
  },
  "android": { "priority": "high", "notification": { "channel_id": "we_care_fcm_channel" } },
  "apns": { "payload": { "aps": { "sound": "default" } } }
}
```

- `pageRoute` has exactly the same value as `type`.
- Use the token the app already sends to `POST Statistics/fcm-token`. If the user has several devices, send to all of their tokens.
- If the user has no token, still save the message so it shows on the messages page.

## Update: fields needed for the invitation card and details page
The `meetingParticipantAdded` message now shows a card and a details page with the inviter's and the doctor's info. The app already reads the current response; these fields are missing.

**Where:** each `meetingParticipantAdded` item in `GET /api/Notifications`, and the FCM `data.payload` of the same message (tapping the push opens the details page straight from the payload).

| Field | Type | Example | Shown as |
|---|---|---|---|
| `patientImage` | string, nullable | `"https://..."` | Inviter's photo |
| `patientPhone` | string | `"+20 100 123 4567"` | Inviter's phone on the details page |
| `relation` | string | `"أخت"` | The relation the patient typed when adding this person |
| `doctorImage` | string, nullable | `"https://..."` | Doctor's photo |
| `doctorAcademicTitle` | string | `"استشاري"` | First part of the line under the doctor's name |
| `doctorSpecialty` | string | `"أمراض القلب والأوعية الدموية"` | Rest of that line |
| `doctorQualification` | string | `"دكتوراه الطب – أمراض القلب"` | The line with the graduation icon |
| `bookingType` | string | `"onlineExamination"` | Already in `payload`; please also add it next to the other fields |

Example item after the change:
```json
{
  "id": "6ade093d4b2a324d7271ba5c",
  "type": "meetingParticipantAdded",
  "title": "تمت إضافتك لاستشارة",
  "message": "...",
  "appointmentId": "6add4b536d23fa320ac35782",
  "patientName": "منى أحمد",
  "patientImage": null,
  "patientPhone": "+20 100 123 4567",
  "relation": "أخت",
  "doctorName": "هالة منصور",
  "doctorImage": null,
  "doctorAcademicTitle": "استشاري",
  "doctorSpecialty": "أمراض القلب والأوعية الدموية",
  "doctorQualification": "دكتوراه الطب – أمراض القلب",
  "bookingType": "onlineExamination",
  "startsAt": "2026-10-25T20:30:00+03:00",
  "pageRoute": "meetingParticipantAdded",
  "payload": "{...the same fields...}",
  "createdAt": "2026-10-25T13:50:53.091Z",
  "isRead": false
}
```

## Open questions for the backend
- [ ] Is an FCM token stored for each device, or only the latest token for each user?
