# Doctor profile modules (view and edit): backend requirements

## Summary
The doctor's profile screen has 12 modules, from "Basic data" to "Booking settings". Today each module only has a `POST` that saves its data, so the screen opens empty every time the doctor goes back to it.

We want each module to open with the data the doctor saved before, already filled in the form. The doctor can change anything and press "حفظ التعديلات" to save.

What we need from the backend: 12 new `GET` endpoints, one for each module, on the same path as its current `POST`.

The 12 existing `POST` endpoints already replace the module's saved data, so they don't need any change.

The monthly examination target module already has `GET` and `POST` and is not part of this change.

## Agreed decisions
- **One document per module.** Each module is stored as one document for each doctor. `GET` returns it, and `POST` replaces it completely.
- **No item IDs, no `PUT` or `DELETE`.** The app always sends the full list, so if the doctor removes an item from a list and saves, it must be gone on the server.
- **`GET` returns the same shape as the `POST` body**, so the app reads it with the same models it sends.
- **Empty module is not an error.** If the doctor hasn't saved a module yet, `GET` returns `200` with empty data, never `404`. See [Empty responses](#empty-responses).
- **Values come back exactly as sent.** This covers dropdown values (country, specialty, languages, ...), dates and image URLs. The app matches them against its dropdown options to pre-select them.
- **Images.** `GET` returns the stored image URL. If the doctor doesn't change the image, the app sends the same URL back in the `POST`.
- **No admin review.** Editing a module saves directly. There is no "pending review" state.
- **The doctor comes from the token.** No doctor ID in the path or the query.
- **App-only behavior (no backend work):** the form opens filled in, and the "حفظ التعديلات" button stays disabled until the doctor changes at least one value.

## Flow
```
Doctor                           App                                  Backend
──────                           ───                                  ───────
Opens a module          ──▶      GET /DoctorUserForDoctor/<module> ──▶ Returns saved data
                                 (or empty data)
                                 Fills the form, button disabled
Changes any value       ──▶      Button enabled
Presses "حفظ التعديلات" ──▶      POST same path with the full data ──▶ Replaces the saved data
```

## Endpoints overview
All endpoints keep the current response shape: `{ success, message, data }`. All paths start with `/api/DoctorUserForDoctor/`.

| # | Module | Path | `GET` | `POST` |
|---|---|---|---|---|
| 1 | البيانات الأساسية | `basic-data` | New | No change |
| 2 | التخصص الطبي | `medical-specialty` | New | No change |
| 3 | الشهادات العلمية | `certificates` | New | No change |
| 4 | العضوية في الجمعيات الطبية | `memberships` | New | No change |
| 5 | الخبرات المهنية | `experiences` | New | No change |
| 6 | الرخص المهنية | `licenses` | New | No change |
| 7 | أبحاث ورسائل | `research-papers` | New | No change |
| 8 | الجوائز والتكريمات | `awards` | New | No change |
| 9 | الميديا والمقالات | `media-articles` | New | No change |
| 10 | معلومات بنكية | `bank-info` | New | No change |
| 11 | إعدادات الحجز | `booking-settings` | New | No change |
| 12 | أسعار الخدمات | `service-prices` | New | No change |

The `POST` request bodies don't change. The `POST` response can stay as it is today.

## Endpoint details
For every module below:
- The **fields table** lists every field in the app's model, with its type. All fields are required and non-null unless the table says otherwise.
- The **`GET` response** is the full response the app expects. Its `data` has exactly the same shape as the current `POST` body.

**Formats used in all modules:**
- Full dates are `yyyy-MM-dd`, for example `"2018-06-30"`.
- Year-only fields are `yyyy` strings, for example `"2021"`.
- Times are 24-hour `HH:mm`, for example `"13:00"`.

### 1. Basic data
`GET /DoctorUserForDoctor/basic-data`

| Field | Type | Notes |
|---|---|---|
| `personalPhotoUrl` | string | URL of the uploaded personal photo |
| `firstName` | string | |
| `fatherName` | string | |
| `familyName` | string | |
| `jobGrade` | string | Value from the job grade dropdown |
| `academicDegree` | string | Value from the academic degree dropdown |
| `gender` | string | |
| `birthDate` | string | `yyyy-MM-dd` |
| `country` | string | |
| `governorate` | string | |
| `city` | string | |
| `professionalMobileCountryCode` | string | For example `"+20"` |
| `professionalMobileNumber` | string | Without the country code |
| `contactMobileCountryCode` | string | For example `"+20"` |
| `contactMobileNumber` | string | Without the country code |
| `nationalIdOrPassportNumber` | string | |
| `nationalIdOrPassportPhotoUrl` | string | URL of the uploaded ID or passport photo |
| `spokenLanguages` | string[] | One or more languages |
| `shortBio` | string | |

```json
{
  "success": true,
  "message": "",
  "data": {
    "personalPhotoUrl": "https://example.com/uploads/doctors/personal-photo.jpg",
    "firstName": "أحمد",
    "fatherName": "محمود",
    "familyName": "مصطفى",
    "jobGrade": "استشاري",
    "academicDegree": "دكتوراه",
    "gender": "ذكر",
    "birthDate": "1985-04-12",
    "country": "مصر",
    "governorate": "القاهرة",
    "city": "مدينة نصر",
    "professionalMobileCountryCode": "+20",
    "professionalMobileNumber": "1001234567",
    "contactMobileCountryCode": "+20",
    "contactMobileNumber": "1112345678",
    "nationalIdOrPassportNumber": "28504120101234",
    "nationalIdOrPassportPhotoUrl": "https://example.com/uploads/doctors/national-id.jpg",
    "spokenLanguages": ["العربية", "الإنجليزية"],
    "shortBio": "استشاري أمراض المناعة بخبرة أكثر من 15 عامًا في تشخيص وعلاج أمراض المناعة الذاتية."
  }
}
```

### 2. Medical specialty
`GET /DoctorUserForDoctor/medical-specialty`

| Field | Type | Notes |
|---|---|---|
| `mainSpecialty` | string | Value from the specialty dropdown |
| `subSpecialty` | string | |
| `clinicalInterests` | string | Free text |

```json
{
  "success": true,
  "message": "",
  "data": {
    "mainSpecialty": "الباطنة",
    "subSpecialty": "المناعة",
    "clinicalInterests": "أمراض المناعة الذاتية، الحساسية المزمنة، نقص المناعة"
  }
}
```

### 3. Scientific certificates
`GET /DoctorUserForDoctor/certificates`

`data` has six keys, one for each certificate type: `bachelor`, `diploma`, `master`, `doctorate`, `fellowship` and `boardCertification`. Each key is a list of certificates. Please always return all six keys, using `[]` for a type the doctor didn't fill.

Each certificate:

| Field | Type | Notes |
|---|---|---|
| `degreeTitle` | string | |
| `grantingBody` | string | |
| `countryName` | string | |
| `obtainedDate` | string | `yyyy-MM-dd` |

```json
{
  "success": true,
  "message": "",
  "data": {
    "bachelor": [
      {
        "degreeTitle": "بكالوريوس الطب والجراحة",
        "grantingBody": "جامعة القاهرة",
        "countryName": "مصر",
        "obtainedDate": "2008-07-01"
      }
    ],
    "diploma": [
      {
        "degreeTitle": "دبلومة الباطنة العامة",
        "grantingBody": "جامعة عين شمس",
        "countryName": "مصر",
        "obtainedDate": "2011-09-15"
      }
    ],
    "master": [
      {
        "degreeTitle": "ماجستير الباطنة",
        "grantingBody": "جامعة القاهرة",
        "countryName": "مصر",
        "obtainedDate": "2013-06-20"
      }
    ],
    "doctorate": [
      {
        "degreeTitle": "دكتوراه أمراض المناعة",
        "grantingBody": "جامعة القاهرة",
        "countryName": "مصر",
        "obtainedDate": "2017-05-10"
      }
    ],
    "fellowship": [
      {
        "degreeTitle": "زمالة الكلية الملكية للأطباء",
        "grantingBody": "الكلية الملكية للأطباء",
        "countryName": "المملكة المتحدة",
        "obtainedDate": "2019-11-01"
      }
    ],
    "boardCertification": []
  }
}
```

### 4. Medical association memberships
`GET /DoctorUserForDoctor/memberships`

Each membership in `memberships`:

| Field | Type | Notes |
|---|---|---|
| `countryName` | string | |
| `associationName` | string | |
| `membershipNumber` | string | |
| `membershipLevel` | string | |
| `year` | string | `yyyy` |

```json
{
  "success": true,
  "message": "",
  "data": {
    "memberships": [
      {
        "countryName": "مصر",
        "associationName": "الجمعية المصرية للحساسية والمناعة",
        "membershipNumber": "EAA-10234",
        "membershipLevel": "عضو عامل",
        "year": "2018"
      },
      {
        "countryName": "الولايات المتحدة",
        "associationName": "American Academy of Allergy, Asthma & Immunology",
        "membershipNumber": "AAAAI-55871",
        "membershipLevel": "عضو دولي",
        "year": "2020"
      }
    ]
  }
}
```

### 5. Professional experience
`GET /DoctorUserForDoctor/experiences`

Each experience in `experiences`:

| Field | Type | Notes |
|---|---|---|
| `position` | string | |
| `workPlace` | string | |
| `fromDate` | string | `yyyy-MM-dd` |
| `toDate` | string | `yyyy-MM-dd` |
| `countryName` | string | |

```json
{
  "success": true,
  "message": "",
  "data": {
    "experiences": [
      {
        "position": "طبيب مقيم",
        "workPlace": "مستشفى قصر العيني",
        "fromDate": "2009-03-01",
        "toDate": "2012-02-28",
        "countryName": "مصر"
      },
      {
        "position": "أخصائي باطنة",
        "workPlace": "مستشفى الملك فهد",
        "fromDate": "2012-04-01",
        "toDate": "2018-06-30",
        "countryName": "السعودية"
      }
    ]
  }
}
```

### 6. Professional licenses
`GET /DoctorUserForDoctor/licenses`

Each license in `licenses`:

| Field | Type | Notes |
|---|---|---|
| `licenseNumber` | string | |
| `countryName` | string | |
| `licensingAuthority` | string | |
| `registrationNumber` | string | |
| `licenseDate` | string | `yyyy-MM-dd` |
| `expiryDate` | string | `yyyy-MM-dd` |
| `licenseImageUrl` | string | URL of the uploaded license image |

```json
{
  "success": true,
  "message": "",
  "data": {
    "licenses": [
      {
        "licenseNumber": "LIC-458921",
        "countryName": "مصر",
        "licensingAuthority": "نقابة أطباء مصر",
        "registrationNumber": "REG-77310",
        "licenseDate": "2015-03-01",
        "expiryDate": "2030-03-01",
        "licenseImageUrl": "https://example.com/uploads/doctors/license-egypt.jpg"
      },
      {
        "licenseNumber": "SCFHS-120934",
        "countryName": "السعودية",
        "licensingAuthority": "الهيئة السعودية للتخصصات الصحية",
        "registrationNumber": "REG-SA-4410",
        "licenseDate": "2012-04-01",
        "expiryDate": "2027-04-01",
        "licenseImageUrl": "https://example.com/uploads/doctors/license-saudi.jpg"
      }
    ]
  }
}
```

### 7. Research and papers
`GET /DoctorUserForDoctor/research-papers`

Each paper in `researchPapers`:

| Field | Type | Notes |
|---|---|---|
| `title` | string | |
| `year` | string | `yyyy` |
| `doiOrLink` | string | DOI or a link |

```json
{
  "success": true,
  "message": "",
  "data": {
    "researchPapers": [
      {
        "title": "معدلات انتشار الذئبة الحمراء بين مرضى المناعة في مصر",
        "year": "2017",
        "doiOrLink": "https://doi.org/10.1000/xyz123"
      },
      {
        "title": "Biologic therapy outcomes in rheumatoid arthritis",
        "year": "2021",
        "doiOrLink": "https://pubmed.ncbi.nlm.nih.gov/00000000"
      }
    ]
  }
}
```

### 8. Awards and honors
`GET /DoctorUserForDoctor/awards`

Each award in `awards`:

| Field | Type | Notes |
|---|---|---|
| `awardName` | string | |
| `countryName` | string | |
| `grantingBody` | string | |
| `year` | string | `yyyy` |

```json
{
  "success": true,
  "message": "",
  "data": {
    "awards": [
      {
        "awardName": "جائزة أفضل بحث علمي",
        "countryName": "مصر",
        "grantingBody": "جامعة القاهرة",
        "year": "2018"
      },
      {
        "awardName": "جائزة التميز الطبي",
        "countryName": "الإمارات",
        "grantingBody": "هيئة الصحة بدبي",
        "year": "2022"
      }
    ]
  }
}
```

### 9. Media and articles
`GET /DoctorUserForDoctor/media-articles`

Each item in `mediaArticles`:

| Field | Type | Notes |
|---|---|---|
| `title` | string | |
| `subject` | string | |
| `mediaLink` | string | Link to the article or video |

```json
{
  "success": true,
  "message": "",
  "data": {
    "mediaArticles": [
      {
        "title": "كيف تتعامل مع حساسية الربيع",
        "subject": "مقال توعوي عن أسباب حساسية الربيع وطرق الوقاية منها",
        "mediaLink": "https://example.com/articles/spring-allergy"
      },
      {
        "title": "لقاء تلفزيوني عن أمراض المناعة الذاتية",
        "subject": "حوار عن أعراض أمراض المناعة الذاتية وأحدث طرق العلاج",
        "mediaLink": "https://www.youtube.com/watch?v=xxxxxxxxxxx"
      }
    ]
  }
}
```

### 10. Bank information
`GET /DoctorUserForDoctor/bank-info`

Each account in `bankAccounts`:

| Field | Type | Notes |
|---|---|---|
| `countryName` | string | |
| `userName` | string | Account holder name |
| `bankName` | string | |
| `branchName` | string | |
| `accountNumber` | string | |
| `iban` | string | |

```json
{
  "success": true,
  "message": "",
  "data": {
    "bankAccounts": [
      {
        "countryName": "مصر",
        "userName": "أحمد محمود مصطفى",
        "bankName": "البنك الأهلي المصري",
        "branchName": "فرع مدينة نصر",
        "accountNumber": "1234567890123",
        "iban": "EG380019000500000000263180002"
      }
    ]
  }
}
```

### 11. Booking settings
`GET /DoctorUserForDoctor/booking-settings`

| Field | Type | Notes |
|---|---|---|
| `maxDailyBookings` | int | |
| `intervalMinutes` | int | Minutes between appointments |
| `weeklySchedule` | object[] | Always all 7 days, see below |

Each day in `weeklySchedule`:

| Field | Type | Notes |
|---|---|---|
| `day` | string | One of `saturday`, `sunday`, `monday`, `tuesday`, `wednesday`, `thursday`, `friday` |
| `isEnabled` | bool | Whether the doctor takes bookings on this day |
| `timeRanges` | object[] | Each item has `startTime` and `endTime` as `HH:mm`. Empty when `isEnabled` is `false` |

Please return all 7 days, including the days where `isEnabled` is `false`.

```json
{
  "success": true,
  "message": "",
  "data": {
    "maxDailyBookings": 20,
    "intervalMinutes": 15,
    "weeklySchedule": [
      {
        "day": "saturday",
        "isEnabled": true,
        "timeRanges": [
          { "startTime": "10:00", "endTime": "13:00" },
          { "startTime": "17:00", "endTime": "21:00" }
        ]
      },
      {
        "day": "sunday",
        "isEnabled": true,
        "timeRanges": [
          { "startTime": "17:00", "endTime": "21:00" }
        ]
      },
      {
        "day": "monday",
        "isEnabled": true,
        "timeRanges": [
          { "startTime": "10:00", "endTime": "13:00" }
        ]
      },
      {
        "day": "tuesday",
        "isEnabled": true,
        "timeRanges": [
          { "startTime": "17:00", "endTime": "21:00" }
        ]
      },
      {
        "day": "wednesday",
        "isEnabled": true,
        "timeRanges": [
          { "startTime": "10:00", "endTime": "13:00" },
          { "startTime": "17:00", "endTime": "21:00" }
        ]
      },
      {
        "day": "thursday",
        "isEnabled": false,
        "timeRanges": []
      },
      {
        "day": "friday",
        "isEnabled": false,
        "timeRanges": []
      }
    ]
  }
}
```

### 12. Service prices
`GET /DoctorUserForDoctor/service-prices`

| Field | Type | Notes |
|---|---|---|
| `examinationPriceInsideEgypt` | number | Decimal allowed |
| `examinationPriceOutsideEgypt` | number | Decimal allowed |
| `offersFollowUpConsultation` | bool | |
| `followUpConsultationValidityDays` | int, **nullable** | One of `3`, `5`, `7`, `10`, `14`, `21`, `30`. `null` when `offersFollowUpConsultation` is `false` |

```json
{
  "success": true,
  "message": "",
  "data": {
    "examinationPriceInsideEgypt": 500,
    "examinationPriceOutsideEgypt": 50,
    "offersFollowUpConsultation": true,
    "followUpConsultationValidityDays": 7
  }
}
```

## `POST` behavior (all 12 modules)
This is how the endpoints already work today. It's listed here so the new `GET` stays consistent with it.

- **Replace, don't append.** Whatever the app sends becomes the module's saved data. Any item that was saved before and isn't in the new body is deleted.
- **The first save and later saves use the same endpoint.** If the doctor has no saved data yet, `POST` creates it. Otherwise it replaces it.
- **Store values as sent**, without reformatting dates, numbers or text, so the next `GET` returns them unchanged.

## Empty responses
When the doctor hasn't saved a module yet, `GET` returns `200`:

| Module type | Modules | `data` |
|---|---|---|
| Single object | 1, 2, 11, 12 | `null` |
| List | 4–10 | The wrapper with an empty list, for example `{ "awards": [] }` |
| Certificates | 3 | All six keys with `[]` |

Single object (for example, basic data):
```json
{ "success": true, "message": "", "data": null }
```

List (for example, awards):
```json
{ "success": true, "message": "", "data": { "awards": [] } }
```

Certificates:
```json
{
  "success": true,
  "message": "",
  "data": {
    "bachelor": [],
    "diploma": [],
    "master": [],
    "doctorate": [],
    "fellowship": [],
    "boardCertification": []
  }
}
```

## Open questions for the backend
- [ ] Is anything already saved in a different format from what the app sends (for example, dates stored as full ISO timestamps)? If so, `GET` should convert it back to the formats above.
