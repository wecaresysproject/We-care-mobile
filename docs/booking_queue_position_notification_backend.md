# Booking queue position notification (كام كشف قدامك): backend requirements

## 1. Summary
A patient with a booking today gets a push notification that tells them how many examinations are left before their turn with the doctor:

> أمامك 5 كشوفات قبل دورك مع د. سارة علي

- **Starts at 5.** The first message goes out when 5 patients are left ahead of them. Then one message at 4, 3, 2 and 1.
- **Push only.** A normal FCM notification. It opens no screen and has no buttons, and the patient does not answer it.
- **No new endpoint.** The app needs nothing except this FCM message.

## 2. When to send it
**Patients ahead** = the number of the doctor's bookings for today that come before this booking (ordered by `startsAt`, the same order as `appointments[]` in the doctor bookings endpoint) and are not finished, cancelled or no-show. The consultation that is in progress right now counts as ahead.

Recalculate the count for each of the doctor's remaining bookings today whenever the queue gets shorter:
- the doctor ends a consultation
- a booking ahead is cancelled or marked as no-show

Send a message to a booking's patient only when **all** of these are true:
1. The new count is between **1 and 5**.
2. The count went down from the last message this booking got (or this booking got no message yet).
3. The booking is still active (not finished or cancelled).

Rules:
- **Each count is sent once per booking.** If the count goes back up, for example because a booking was moved earlier, send nothing until it drops below the last count sent.
- **If the count skips numbers, send only the latest one.** For example, 2 consultations end at once and the count goes 6 → 4: send only 4.
- **The first message can be below 5.** If the patient books when only 3 patients are left, their first message is 3.
- **Nothing at 0.** When the doctor starts the consultation, the existing `consultationStarted` message already tells the patient it is their turn.

Store the last count sent on the booking (for example `lastQueueNotifiedCount`) to apply rules 2 and 3.

## 3. Message text
`{doctorName}` is the doctor's name without a title, so the text adds "د.". The numbers are Western digits, like the rest of the app's messages.

| Patients ahead | `title` | `body` |
|---|---|---|
| 5 | اقترب دورك | أمامك 5 كشوفات قبل دورك مع د. {doctorName} |
| 4 | اقترب دورك | أمامك 4 كشوفات قبل دورك مع د. {doctorName} |
| 3 | اقترب دورك | أمامك 3 كشوفات قبل دورك مع د. {doctorName} |
| 2 | اقترب دورك | أمامك كشفان قبل دورك مع د. {doctorName} |
| 1 | دورك التالي | أمامك كشف واحد فقط، استعد لدورك مع د. {doctorName} |

## 4. FCM shape
Same format as the other messages (see `meeting_close_participants_backend.md`): a `notification` block, plus a `data.payload` JSON string with `pageRoute`.

```json
{
  "notification": {
    "title": "اقترب دورك",
    "body": "أمامك 3 كشوفات قبل دورك مع د. سارة علي"
  },
  "data": {
    "payload": "{\"pageRoute\":\"bookingQueuePosition\",\"bookingId\":\"6add4b536d23fa320ac35782\",\"doctorName\":\"سارة علي\",\"patientsAhead\":3}"
  },
  "android": {
    "priority": "high",
    "collapse_key": "queue_6add4b536d23fa320ac35782",
    "notification": {
      "channel_id": "we_care_fcm_channel",
      "tag": "queue_6add4b536d23fa320ac35782"
    }
  },
  "apns": {
    "headers": { "apns-collapse-id": "queue_6add4b536d23fa320ac35782" },
    "payload": { "aps": { "sound": "default" } }
  }
}
```

- `pageRoute` is always `"bookingQueuePosition"`.
- `patientsAhead` is a number, not a string.
- **Collapse by booking.** Use the same `tag` / `collapse_key` / `apns-collapse-id` (`queue_{bookingId}`) for every message of one booking. Each new message then replaces the last one in the notification tray, so the patient sees only the current count and not 5 old messages.
- **Recipient.** The patient account that made the booking. Send to all of its FCM tokens (the tokens from `POST Statistics/fcm-token`). If it has no token, skip the message.
- **Do not save it** in `GET /api/Notifications`. The count is only correct for a few minutes, so it should not stay on the messages page.

## 5. App side
No app change is needed. The app already shows any FCM message that has a `notification` block, in the foreground and in the background. Tapping it opens the app with no specific screen.

The collapse in §4 works when the app is in the background or closed. When the app is open, the app shows the message itself, so each count shows as a separate notification. This is fine for now.

## 6. Answers from the backend
- [x] **Waiting list.** A waiting-list booking joins the queue when the doctor accepts it, with `startsAt` = the time it was accepted.
- [x] **Doctor running late.** The order is by `startsAt` only.
- [x] **No-show.** There is no no-show status today, so a patient who doesn't show up keeps counting as ahead for everyone after them. See §7.

## 7. Proposed: skipped bookings stop counting (instead of a no-show endpoint)
A no-show endpoint would also need a new "لم يحضر" button in the doctor's app. This rule fixes the count without a new endpoint or button:

**When the doctor starts the consultation for a booking, every earlier booking today that was never started stops counting as ahead.** Then recalculate the queue and send the messages as in §2.

- For example, A finishes, B doesn't show up, and the doctor starts C. B stops counting, so D, E and the rest get their new counts at that moment.
- The count is off by at most 1, and only between A finishing and the doctor starting C.
- B is not cancelled. If B shows up later, the doctor can still start B's consultation as usual.
