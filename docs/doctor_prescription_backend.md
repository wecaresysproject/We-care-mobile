# Doctor prescription (الروشتة): backend requirements

## 1. Summary
During a video call, the doctor writes a prescription for the patient. It has:
- An optional **diagnosis** (التشخيص).
- **Medicines.** Picked from the medicines list, or typed by hand.
- **Examinations.** X-rays and lab tests (from the list or typed by hand), endoscopies (free text) and additional examinations (free text).
- **Patient instructions.** A list of free-text lines.

When the doctor taps "حفظ وإرسال", the app turns the prescription into **one or more images** (one image per page), uploads them, and sends the images together with the written data. The backend then:
1. **Stores the written data,** so the doctor can reopen the prescription and edit it.
2. **Creates a normal prescription ticket in the patient's prescriptions module,** with the images as its photos. The patient sees it with the same tile and details screen as any other prescription, and the medical report PDF shows its images like any other prescription.

Rules we agreed on:
- **One prescription per booking,** identified by `bookingId`. It maps to **one** ticket in the patient's module.
- **Saving sends it.** The patient sees the ticket right after the first save. There is no draft state.
- **The doctor can edit it** and save again until the booking's data-access window ends (`accessExpiresAt`, the same window as the medical-file access). Each save replaces the ticket's images; it never creates a second ticket.
- **The patient cannot edit or delete** a ticket written by a doctor. They can view and share it.
- **Prescriptions module only.** Nothing is copied into the medicines, lab tests or radiology modules.

## 2. Flow
```
Doctor opens the prescription from the call screen
  └─ GET  /DoctorBookings/bookings/prescription?bookingId=   → fills the screen (or empty)

Doctor taps "حفظ وإرسال"
  1. App builds the prescription pages and turns each page into a PNG
  2. POST /FileUpload/upload-image   (one call per image,
                                      all sent at the same time) → image URLs
  3. PUT  /DoctorBookings/bookings/prescription?bookingId=    → written data + image URLs
       Backend: stores the written data
                first save  → creates the patient's ticket
                later saves → updates the same ticket's images

Patient opens the prescriptions module
  └─ existing list / details endpoints                       → the ticket, with the images as photos
```

- A prescription is usually 1–2 pages, sometimes 3 or more. The uploads run in parallel, so the wait is about one upload.
- If any upload fails, the app does not call the `PUT`. The doctor retries the whole save, so the data and the images never get out of sync.
- `bookingId` is the same booking id the app already uses for the call and for `patient-access`.

## 3. Doctor endpoints
These follow the existing `patient-access` endpoint. The doctor calls them with their own bearer token (`Authorization: Bearer {doctorToken}`). The patient is resolved from the booking, so the app does not send a `patientId`. If the request carries an `Active-Medical-Profile` header, ignore it here.

### 3a. Get the booking's prescription
`GET /api/DoctorBookings/bookings/prescription?bookingId={id}`

The app calls this each time the doctor opens the prescription screen, to fill it with what was already saved.

**200, already saved:**
```json
{
  "success": true,
  "message": "Prescription fetched successfully",
  "data": {
    "bookingId": "abc123",
    "patientPrescriptionId": "presc_789",
    "createdAt": "2026-11-11T10:05:00+00:00",
    "editedAt": "2026-11-11T10:20:00+00:00",
    "images": ["https://.../page1.png", "https://.../page2.png"],
    "prescription": { "...": "the object from §4" }
  }
}
```
- `patientPrescriptionId` is the id of the ticket created in the patient's module.
- `editedAt` is `null` when the prescription was saved once and never edited.

**200, not written yet:** return `"data": null`, not 404. A missing prescription is the normal first state.

### 3b. Save or edit the booking's prescription
`PUT /api/DoctorBookings/bookings/prescription?bookingId={id}`

```json
{
  "images": ["https://.../page1.png", "https://.../page2.png"],
  "prescription": { "...": "the object from §4" }
}
```

- **Upsert.** Create the prescription if the booking has none, otherwise replace it. The same call is used for the first save and every edit.
- **Replace everything.** The body is the full current state. If a section comes back as `[]`, empty that section. `images` replaces the previous images; keep them in the order sent (page order). The previous image files are no longer used and may be deleted.
- On the first save, set `createdAt`. On every later save, set `editedAt` to now.
- After storing, create or update the patient's ticket (§5).
- Return the saved object in the same shape as §3a.

**Validation (400):**
| Case | Message |
|---|---|
| Every section is empty (diagnosis alone is not enough) | `Prescription must contain at least one item` |
| A required field inside an item is missing or blank (see the table in §4) | `Invalid prescription data` |
| `images` is missing or empty | `Prescription images are required` |

The app already blocks these cases. The server must still check them.

### 3c. Access rules for §3a and §3b
| Check | Result if it fails |
|---|---|
| The booking exists and belongs to the calling doctor | **403** `You are not authorized to access this patient's medical file` |
| The window is open (`now < accessExpiresAt`) | **403** `Patient medical file access has expired` |

- The window check applies to **saving** (§3b). Reading (§3a) inside the window must work; after the window, 403 is fine because the app only opens this screen during the call.
- Keep the two messages exactly as written. The app already recognizes them from the medical-file access work.

### 3d. Image upload
The app uploads each page with the existing endpoint, the same one the patient uses for prescription photos, using the doctor's token. Nothing changes in the endpoint itself:

`POST /api/FileUpload/upload-image?language=ar` (multipart, one image per request)

```json
{ "success": true, "message": "Image uploaded successfully", "imageUrl": "https://.../page1.png" }
```

- One request per page, sent in parallel. Several uploads from the same doctor at the same moment must work.
- Each page is a PNG of about 1200 × 1200 px (roughly 100–300 KB).
- The app sends the returned URLs in `images` in page order: page 1 first.

> **Please confirm:** a doctor's token can call `upload-image`, and the returned URL can then be read by the patient and by the medical report.

## 4. The `prescription` object
The doctor's save request and the `GET` response use the same object.

```json
{
  "diagnosis": "التهاب الحلق",
  "medicines": [
    {
      "medicineId": "65f0c1...",
      "name": "Panadol Extra",
      "medicalForm": "أقراص",
      "doseAmount": "قرص واحد",
      "doseFrequency": "3 مرات يوميًا",
      "duration": "5 أيام",
      "instructions": "بعد الأكل"
    }
  ],
  "manualMedicines": ["Augmentin 1g قرص كل 12 ساعة لمدة أسبوع"],
  "xRays": [
    { "bodyPart": "الصدر", "type": "أشعة سينية", "purposes": ["تشخيص", "متابعة"] }
  ],
  "manualXRays": ["أشعة مقطعية على الجيوب الأنفية"],
  "labTests": [
    { "groupName": "صورة دم كاملة", "testNameEn": null, "tests": ["Hemoglobin", "WBC"] },
    { "groupName": "وظائف الكبد", "testNameEn": "ALT", "tests": ["ALT", "AST"] }
  ],
  "manualLabTests": ["تحليل فيتامين د"],
  "endoscopies": ["منظار معدة"],
  "additionalExaminations": ["رسم قلب"],
  "patientInstructions": ["الإكثار من شرب السوائل", "الراحة التامة لمدة يومين"]
}
```

| Field | Type | Required inside each item | Notes |
|---|---|---|---|
| `diagnosis` | string | — | Optional; `""` when empty. Goes into the ticket's `disease` (§5). |
| `medicines` | array of objects | `name`, `medicalForm`, `doseAmount`, `doseFrequency`, `duration` | `medicineId` is the id from the medicines list and may be `null`. `instructions` is optional; send `""` when it is empty. |
| `manualMedicines` | array of strings | — | One typed medicine per item. |
| `xRays` | array of objects | `bodyPart`, `type` | `purposes` (نوعية الاحتياج) is optional and may be `[]`. |
| `manualXRays` | array of strings | — | |
| `labTests` | array of objects | `groupName` **or** `testNameEn` | The doctor picks either a group or an English test name, then some of that group's tests. If the doctor picked a group, `testNameEn` is `null`. If the doctor picked an English name, `testNameEn` is that name and `groupName` is its group (it may be `null` if unknown). `tests` may be `[]` when the doctor typed a name that has no listed tests. |
| `manualLabTests` | array of strings | — | |
| `endoscopies` | array of strings | — | |
| `additionalExaminations` | array of strings | — | |
| `patientInstructions` | array of strings | — | One instruction per item, in display order. |

- **Store the text exactly as sent, not only ids.** The doctor's edit screen must show what the doctor wrote, even if a medicine or test is renamed in the lookups later.
- All arrays are always sent; an empty section is `[]`. The order of items in each array is the display order, so keep it.
- The backend doesn't need to interpret this object beyond the validation in §3b. It only has to store it and return it in §3a.

## 5. The patient's ticket
On the first `PUT`, create a prescription ticket for the booking's patient, the same kind of record that `AddPreDescriptionUserEntry` creates. On every later `PUT`, update **that same ticket**. Fill it as follows:

| Ticket field | Value |
|---|---|
| `preDescriptionDate` | The **booking date**, in the same format as the patient's own tickets |
| `doctorName` | The doctor who wrote it |
| `doctorSpecialty` | That doctor's specialty |
| `disease` (التشخيص) | `prescription.diagnosis`. If empty, fill it the same way as when a patient leaves it empty. |
| `hospital` | `"استشارة أونلاين"` |
| `preDescriptionPhoto` | `images` from the `PUT`, in the same order |
| `cause`, `country`, `governate`, `preDescriptionNotes` | Empty, filled the same way as when a patient leaves them empty |
| `modifiedAt` | The time of the last save |
| `userId`, `userType`, `language` | The booking's patient, `"Patient"`, `"ar"` |
| `isCreatedByDoctor` *(new)* | `true` |

**New field `isCreatedByDoctor`.** Add it to the existing list, search and details responses (`PreDescriptionGetUserDocuments`, `PreDescriptionSearchUserDocuments`, `GetPreDescriptionPerOne`): `true` for tickets created here, `false` for the patient's own tickets. The app uses it to hide the edit and delete buttons.

**The patient cannot change it:** `EditPreDescriptionUserDocument` and `DeletePreDescriptionUserDocument` must return **403** for a ticket with `isCreatedByDoctor: true`.

Everything else stays as today:
- The ticket appears in the list, search and filters (doctor name, specialty, year) like any other prescription.
- The medical report (`MedicalReports/prescriptions/filters`, `fetch-data`) includes it like any other prescription, with its images.
- Family care access and a doctor's `doctorsPrescriptions` access see it like any other prescription.

## 6. Error format
Use the same shape as the other endpoints:
```json
{ "success": false, "message": "Prescription must contain at least one item", "data": null }
```

## 7. Test cases
Setup: booking `B1` between doctor `D1` and patient `P1`. The window is open.

| # | Request | Expected |
|---|---|---|
| 1 | `D1`: `GET prescription?bookingId=B1` before any save | 200, `data: null` |
| 2 | `D1`: `PUT prescription?bookingId=B1` with a diagnosis, 2 medicines, 1 instruction and 1 image | 200, `createdAt` set, `editedAt: null`, `patientPrescriptionId` set |
| 3 | `D1`: `GET prescription?bookingId=B1` | 200, same content as #2, same order |
| 4 | `P1`: list prescriptions | One new ticket: booking date, `D1`'s name and specialty, `disease` = the diagnosis, `hospital: "استشارة أونلاين"`, 1 photo, `isCreatedByDoctor: true` |
| 5 | `D1`: `PUT` again with `medicines: []`, 1 X-ray and 2 images | 200, `editedAt` set, the medicines are gone |
| 6 | `P1`: list prescriptions | Still **one** ticket for `B1`, now with the 2 new photos in the order sent |
| 7 | `P1`: medical report with prescriptions selected | The ticket is included with its 2 images |
| 8 | `P1`: edit or delete the ticket | 403 |
| 9 | `D1`: `PUT` with every section empty | 400 `Prescription must contain at least one item` |
| 10 | `D1`: `PUT` with a medicine that has no `duration` | 400 `Invalid prescription data` |
| 11 | `D1`: `PUT` with `images: []` | 400 `Prescription images are required` |
| 12 | Another doctor `D2`: `GET` or `PUT` for `B1` | 403 `You are not authorized to access this patient's medical file` |
| 13 | `D1`: `PUT` after `accessExpiresAt` | 403 `Patient medical file access has expired` |
| 14 | `P1`: list, search, details, edit and delete for their own prescriptions | Unchanged from today, plus `isCreatedByDoctor: false` |

## 8. Out of scope for now
- **Notifying the patient** when a prescription arrives or is edited. Planned as a follow-up.
- **Opening the prescription from the bookings list** after the call ends. To be decided later.
