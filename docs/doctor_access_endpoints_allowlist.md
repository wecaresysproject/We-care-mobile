# Doctor access: full endpoint allowlist

These are all the endpoints the app calls while a doctor is inside a patient's data. That covers three screens: the medical file, the medical report, and "توافق أدويتي".

Every one of these requests carries `Authorization: Bearer {doctorToken}` and `Active-Medical-Profile: {patientId}`. All paths are under `http://147.93.57.70/api`. None use path params; ids go in the query string.

**Why this matters:** any endpoint missing from the allowlist returns 403, and that screen or section fails to load for the doctor. The app closes the patient's file only on the two "access ended" messages in §6, so a missing entry breaks just that screen, not the whole session.

**Match on method + path, not path alone.** Some paths serve both a GET (allow) and a POST/PUT/DELETE (block). They're marked ⚠.

Live status was tested on 2026-11-03 against booking `6ae9b848392a31bc93e0ece9` (allowed: basicInformation, vitalSigns, medications):
- ✅ = works
- ❌ = returned `403 This endpoint is not available for doctor access`
- blank = not tested yet, because the module isn't allowed in the test booking

---

## 1. Module-independent (allow whenever the window is open)

| Method | Path | Notes | Live |
|---|---|---|---|
| GET | `Ticket/count?language&userType` | Grid counts. Suggestion: return counts for allowed modules only. Right now it reveals counts for hidden modules. | ✅ |
| GET | `UserGuide/module-guidance?moduleName=` | Help text and video for each screen. Not patient data. It fires as soon as **every** screen opens, so a 403 here breaks the help button on every screen. | ❌ |
| GET | `LongTextContents/prompt-by-name/CurrentDrugsCompatability` | Static AI prompt text. Not patient data. | ❌ |

## 2. Endpoints that must **ignore** the header (the doctor's own data)
These run in the background while the doctor is inside the patient's file. They belong to the **doctor's** account. The server should neither switch to the patient nor return 403. It should answer for the token owner (the doctor), as if the header weren't there.

| Method | Path | Live |
|---|---|---|
| GET | `Notifications` | ❌ |
| GET | `Notifications/unread-count` | ❌ |
| GET | `MessageNotification/user/all` | ❌ |
| POST | `Statistics/fcm-token` (the doctor's own FCM token sync) | not tested (write) |

> We'll also stop sending the header on these from the app side. The server should still handle it.

## 3. Medical report (`MedicalReports/*`)
| Method | Path | Module | Live |
|---|---|---|---|
| GET | `MedicalReports/basic-data` | basicInformation | ✅ |
| GET | `MedicalReports/vital-activities/categories` | vitalSigns | ✅ |
| GET | `MedicalReports/medicines/filters` | medications | ✅ |
| GET | `MedicalReports/chronic-diseases/filters` | chronicDiseases | |
| GET | `MedicalReports/emergency-complaints/filters` | urgentComplaints | |
| GET | `MedicalReports/radiology/filters` | radiology | 403 module (correct) |
| GET | `MedicalReports/lab-tests/filters` | medicalTests | |
| GET | `MedicalReports/prescriptions/filters` | doctorsPrescriptions | |
| GET | `MedicalReports/surgery/filters` | surgeries | |
| GET | `MedicalReports/GeneticDiseases/filters` | geneticDiseases | |
| GET | `MedicalReports/Allergy/filters` | allergies | |
| GET | `MedicalReports/Eyes/filters` | eyes | |
| GET | `MedicalReports/Teeth/filters` | dental | |
| GET | `MedicalReports/smart-nutrition/options` | smartNutritionalAnalyzer | |
| GET | `MedicalReports/supplements-vitamins/filters` | supplements | |
| GET | `MedicalReports/physical-activity/options` | sportsActivity | |
| GET | `MedicalReports/MentalDiseases/filters` | mentalHealth | |
| GET | `MedicalReports/Vaccine/filters` | vaccinations | |
| GET | `MedicalReports/RiskyBehaviour/filters` | riskyBehaviors | |
| POST (read) | `MedicalReports/fetch-data` | many (allowed sections only) | ✅ |
| GET | `MedicalReports/full-report-Medical-file-data` | many (allowed fields only) | ✅ |
| POST | `MedicalReports/upload-report` | **block** | ✅ 403 |
| GET | `MedicalReports/pdf/dates`, `MedicalReports/pdf?date` | **block** (the patient's saved PDFs). The app will hide the screen that calls these. | ✅ 403 |

## 4. Medical file: module view endpoints (GET only)

### basicInformation
| GET | `statistics/personal-user-data?language&userType` ⚠ shares a path with writes | ❌ |
|---|---|---|

### vitalSigns
| Method | Path | Live |
|---|---|---|
| GET | `VitalActivity/GetAllAvailableCategories?Language&userType` | ❌ |
| GET | `VitalActivity/GetFilterOptions?Language&userType` | ❌ |
| GET | `VitalActivity/FilterVitalActivity?Language&userType&year&month&day&category` | ❌ |
| GET | `VitalActivity/currentbiometrics?Language&userType` | ❌ |

### medications
| Method | Path | Live |
|---|---|---|
| GET | `MedicineUserEntryPage/GetUserMedicines?language&userType&page&pageSize` | ✅ |
| GET | `MedicineUserEntryPage/GetUserMedicineFilters?language&userType` | ❌ |
| GET | `MedicineUserEntryPage/SearchUserMedicineDocuments?language&userType&year&medicineName` | ❌ |
| GET | `MedicineUserEntryPage/GetMedicineById?medicineId&language&userType` | ❌ |
| GET | `MedicineUserEntryPage/GetMedicineActiveStatus?medicineId&userType&language` | ❌ |
| PUT | `MedicineUserEntryPage/UpdateMedicineStatus` | **block** (the app will hide the switch) |

### urgentComplaints
- GET `EnterEmergencyComplain/GetAllComplaints?language&userType&page&pageSize`
- GET `ViewEmergencyComplaint/years?language`
- GET `ViewEmergencyComplaint/AllSymptomsLocation?language`
- GET `ViewEmergencyComplaint/filter?year&Symptoms_LocationOfPainOrComplaint`
- GET `ViewEmergencyComplaint/GetAllComplaintsById?id&language`

### doctorsPrescriptions
- GET `PreDescriptionUserEntryPage/PreDescriptionGetUserFilters?language&UserType`
- GET `PreDescriptionUserEntryPage/PreDescriptionGetUserDocuments?language&UserType&page&pageSize`
- GET `PreDescriptionUserEntryPage/PreDescriptionSearchUserDocuments?language&doctorName&doctorspecialty&year&UserType`
- GET `PreDescriptionUserEntryPage/GetPreDescriptionPerOne?DocumentId&language&UserType`

### medicalTests
- GET `lab-tests/summary?language&userType&page&pageSize`
- GET `lab-tests/years`
- GET `lab-tests/UserGroupNames`
- GET `lab-tests/UserTestNames`
- GET `lab-tests/filter?language&year&groupTestName&testName`
- GET `lab-tests/doc?id&language`
- GET `lab-tests/search?language&testName`

### radiology
- GET `RadiologyUserEntryPage/RadiologyGetUserDocuments?language&UserType&page&pageSize`
- GET `RadiologyUserEntryPage/RadiologyGetUserFilters?language`
- GET `RadiologyUserEntryPage/RadiologySearchUserDocuments?language&year&radioType&bodyPart`
- GET `RadiologyUserEntryPage/GetRadiologyUserDocumentViewPerOne?documentId&language&UserType`

### surgeries
- GET `EnterSectionSurgery?language&userType&page&pageSize` ⚠ (same path as POST/PUT/DELETE)
- GET `ViewSectionSurgery/surgery-info?language`
- GET `ViewSectionSurgery/filter?language&surgeryRegion&year`
- GET `ViewSectionSurgery/filter-by-id?id&language`

### chronicDiseases
- GET `ChronicDiseases/summery-diseases?language&userType&page&limit`
- GET `ChronicDiseases/disease-by-id?id&language&userType`

### geneticDiseases
- GET `GeneticDiseasesAPIs/family-member-recommendations?language&userType`
- GET `GeneticDiseasesAPIs/medical-history-all?language&userType`
- GET `GeneticDiseasesAPIs/medical-history?language&userType&id` ⚠ (same path as POST/PUT/DELETE)
- GET `GeneticDiseasesAPIs/genetic-disease-details-by-disease-type?language&userType&diseaseType`
- GET `GeneticDiseasesAPIs/all-names?language&userType`
- GET `GeneticDiseasesAPIs/classifications?language&userType&name&code`

### allergies
- GET `v1/All-allergies?language&userType&page&pageSize`
- GET `v1/user-allergies?id&language&userType`

### eyes
- GET `EyesDataEntry/affected-eye-parts?language&UserType`
- GET `EyesDataEntry/eye-section-description?language&UserType&eyeSectionName`
- GET `EyesDataEntry/lens/documents?page&limit&language&UserType&affectedEyePart`
- GET `EyesDataEntry/lens/available-years?language&UserType&affectedEyePart`
- GET `EyesDataEntry/lens/documents/filter?year&category&language&UserType&affectedEyePart`
- GET `EyesDataEntry/lens/document?id&language&UserType` ⚠ (shared with DELETE)
- GET `EyesDataEntry/glasses?language&UserType&page&limit` ⚠ (shared with DELETE)
- GET `EyesDataEntry/glasses/details?id&language&UserType`

### dental
- GET `TeethDataEntry/GetAllTeethNumbersForUser?usertype&Language`
- GET `TeethDataEntry/GetUserTeethFilters?usertype&Language`
- GET `TeethDataEntry/SearchUserTeethDocuments?usertype&Language&teethNumber&year&subProcedure`
- GET `TeethDataEntry/GetTeethDocumentsByNumber?teethNumber&usertype&Language&page&pageSize`
- GET `TeethDataEntry/GetTeethDocumentById?id&usertype&Language`

### vaccinations
- GET `Vaccine/user-vaccines?dateFrom&dateTo`
- GET `Vaccine/years`
- GET `Vaccine/vaccine-user-entry?id` ⚠ (same path as POST/PUT/DELETE)

### mentalHealth
- GET `MentalAssessment/umbrella-status?userType&language`
- GET `v1/medicalIllnessDocuments?language&userType&page&limit`
- GET `v1/available-years?language&userType`
- GET `v1/documents/filter?year&language&userType`
- GET `v1/document?id&language&userType` ⚠ (shared with DELETE)
- GET `psych/umbrella-docs?language&userType&page&limit`
- GET `psych/questions/answered?language&userType`
- GET `psych/follow-up-reports?language&userType&page&limit`
- GET `psych/available-years?language&userType`
- GET `psych/reports/filter?year&language&userType`
- GET `psych/follow-up-report?id&language&userType`

### riskyBehaviors
- GET `RiskyBehaviors/submissions` ⚠ (shared with PUT)

### smartNutritionalAnalyzer
- GET `SmartNutritionAnalyzer/doc-data?language&planType`
- GET `SmartNutritionAnalyzer/weekly-plans-years?Language`
- GET `SmartNutritionAnalyzer/monthly-plans-years?Language`
- GET `SmartNutritionAnalyzer/all-weekly-plans?Language&year`
- GET `SmartNutritionAnalyzer/all-monthly-plans?Language&year`
- GET `SmartNutritionAnalyzer/doc-data-filtered?language&year&rangeDate&planType`
- GET `SmartNutritionAnalyzer/food-alternatives?language&elementName`
- GET `SmartNutritionAnalyzer/nutrient-status?language&elementName`
- GET `SmartNutritionAnalyzer/organ-names?language`
- GET `SmartNutritionAnalyzer/organ-effects?language&organName`
- GET `SmartNutritionAnalyzer/result-data?Language&date`
- GET `SmartNutritionAnalyzer/nutrient?elementName`
- GET `SmartNutritionAnalyzer/nutrition-by-food?elementName&date`
- PUT `SmartNutritionAnalyzer/update-standard`: **block** (the app will hide the edit button)

### sportsActivity
- GET `PhysicalActivityForUser/plans/years?Language`
- GET `PhysicalActivityForUser/physical-activity/metrics?language`
- GET `PhysicalActivityForUser/plans/ranges?Language&year`
- GET `PhysicalActivityForUser/physical-activity/range?language&year&range`
- GET `PhysicalActivityForUser/physical-activity/table`

### supplements
- GET `SupplementsAndVitamins/available-date-ranges?language`
- GET `SupplementsAndVitamins/EffectsSupplementsAndVitaminsTable?language&range`
- GET `SupplementsAndVitamins/supplements-elements?language&range`

## 5. Images and files
Detail screens have a "share" button that downloads an image or report from its raw URL **with** the header. If uploaded files go through the allowlist, their path must be allowed for the allowed modules. The app may instead drop the header on these downloads.

## 6. Error messages the app relies on
The app now closes the file only on these two:
- `Patient medical file access has expired`
- `You are not authorized to access this patient's medical file`

Other 403s (`This module is not included…`, `This endpoint is not available…`) will only fail that one request. Please keep these exact messages.
