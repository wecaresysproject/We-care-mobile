1. Video Meeting API — Flutter Integration Documentation
WeCareSys Video Meetings
API integration guide for Flutter developers
Base URL
http://147.93.57.70/api/Video
Authentication
Authorization: Bearer <JWT_TOKEN>
Content-Type
application/json
Database
Doctor → VideoMeetings

2. Available endpoints
Method
Endpoint
Purpose
POST
/create
إنشاء اجتماع فيديو جديد
GET
/{appointmentId}
جلب اجتماع الحجز
POST
/{appointmentId}/start
تسجيل بدء الاجتماع
POST
/{appointmentId}/end
تسجيل انتهاء الاجتماع

كل الـ endpoints محمية بـ [Authorize]، وبالتالي لازم Flutter يبعت JWT صالح في كل طلب.

3. Endpoint details

A. Create video meeting
POST
/create
الغرض: إنشاء غرفة فيديو مرتبطة بالحجز وإرجاع رابط الاجتماع.
Request body:

{
  "appointmentId": "APPOINTMENT_ID"
}

Successful response — 200 OK:

{
  "success": true,
  "data": {
    "id": "MONGODB_DOCUMENT_ID",
    "appointmentId": "APPOINTMENT_ID",
    "userId": "CURRENT_USER_ID",
    "userType": "Doctor",
    "roomName": "wecare-APPOINTMENT_ID-UNIQUE_ID",
    "meetingUrl": "https://meet.jit.si/GENERATED_ROOM_NAME",
    "status": "created",
    "createdAt": "2026-10-13T12:00:00Z"
  }
}

ملاحظات لمطور Flutter:
appointmentId مطلوب، ويجب أن يكون معرّف الحجز الفعلي.
roomName وmeetingUrl يتم إنشاؤهما في الـ Backend، فلا تنشئهما يدويًا في Flutter.
احفظ meetingUrl أو أعد جلبه باستخدام endpoint الحجز.
لا تستدعِ /create في كل مرة يضغط فيها المستخدم على زر دخول الاجتماع، وإلا قد تنشئ غرفًا متعددة لنفس الحجز.
مهم: الكود الحالي لا يتحقق من أن الحجز موجود فعلًا أو أن المستخدم طبيب أو مريض مرتبط بهذا الحجز؛ لازم نضيف التحقق ده قبل الاعتماد على الـ API في الإنتاج.

B. Get video meeting

GET
/{appointmentId}
مثال:
GET /api/Video/APPOINTMENT_ID
Authorization: Bearer YOUR_JWT_TOKEN
Successful response:

{
  "success": true,
  "data": {
    "id": "MONGODB_DOCUMENT_ID",
    "appointmentId": "APPOINTMENT_ID",
    "userId": "CURRENT_USER_ID",
    "userType": "Doctor",
    "roomName": "GENERATED_ROOM_NAME",
    "meetingUrl": "https://meet.jit.si/GENERATED_ROOM_NAME",
    "status": "created",
    "createdAt": "2026-10-13T12:00:00Z",
    "startedAt": null,
    "endedAt": null
  }
}

هذا الـ endpoint يرجع أحدث اجتماع يطابق appointmentId وuserId الموجود في الـ JWT.
نقطة مهمة جدًا: لو الطبيب أنشأ الاجتماع، والمريض حاول جلبه باستخدام حسابه، فلن يجد الاجتماع بهذه الطريقة؛ لأن userId مختلف. هنحتاج تعديل صلاحيات البحث بحيث الطبيب والمريض المرتبطان بنفس الحجز يقدرا يصلوا إلى نفس الاجتماع، من غير ما نسمح لأي مستخدم آخر بالوصول إليه.

C. Start video meeting
POST
/{appointmentId}/start
مثال:
POST /api/Video/APPOINTMENT_ID/start
Authorization: Bearer YOUR_JWT_TOKEN
لا يحتاج إلى Request body.
Successful response:
{
  "success": true,
  "data": {
    "id": "MONGODB_DOCUMENT_ID",
    "appointmentId": "APPOINTMENT_ID",
    "status": "started",
    "startedAt": "2026-10-13T12:05:00Z"
  }
}

هذا الطلب يسجل status = started ووقت startedAt في قاعدة البيانات. هو لا يشغّل الكاميرا ولا يبدأ مكالمة الفيديو بنفسه.

D. End video meeting
POST
/{appointmentId}/end
مثال:

POST /api/Video/APPOINTMENT_ID/end

Authorization: Bearer YOUR_JWT_TOKEN
لا يحتاج إلى Request body.
Successful response:

{
  "success": true,
  "data": {
    "id": "MONGODB_DOCUMENT_ID",
    "appointmentId": "APPOINTMENT_ID",
    "status": "ended",
    "endedAt": "2026-10-13T12:30:00Z"
  }
}

هذا الطلب يسجل انتهاء الاجتماع في MongoDB، لكنه لا ينهي جلسة Jitsi تلقائيًا؛ Flutter يحتاج إنهاء تجربة الفيديو أيضًا.

4. Authentication and error handling
كل Request لازم يحتوي على الـ JWT الخاص بالمستخدم الحالي:
Authorization: Bearer YOUR_JWT_TOKEN
Content-Type: application/json
الـ Token لازم يكون صادرًا من نظام تسجيل الدخول الحالي، ويحتوي على claim باسم id؛ لأن الكنترولر يعتمد على:
User.FindFirst("id")?.Value
ويقرأ نوع المستخدم من claim باسم userType. لو الـ JWT عندك يستخدم اسمًا مختلفًا للـ claim، لازم توحّده مع الكود.
الـ HTTP responses المتوقعة:
Status code
Meaning
Flutter action
200
العملية نجحت
اقرأ data
400
البيانات غير صحيحة
اعرض رسالة الخطأ
401
الـ Token غير صالح أو مفقود
أعد تسجيل الدخول عند الحاجة
404
الاجتماع غير موجود
تحقق من الحجز والاجتماع
500
خطأ داخلي في السيرفر
اعرض رسالة عامة وسجّل التفاصيل بأمان

مثال على Error response:

{
  "success": false,
  "errors": [
    "Video meeting not found"
  ]
}

في Flutter، تعامل مع errors باعتبارها قائمة، ولا تفترض أن جميع الأخطاء ترجع بنفس الرسالة.

5. Recommended Flutter workflow
ده التسلسل المقترح لربط الطبيب والمريض بالاجتماع:
1. المستخدم يفتح تفاصيل الحجز
Flutter لديه appointmentId والـ JWT
2. GET /api/Video/
ابحث عن اجتماع موجود ومصرح للمستخدم بدخوله
3. هل الاجتماع موجود؟
لو موجود، استخدم نفس الاجتماع. لو غير موجود، أنشئه وفق صلاحيات الحجز.
4. افتح واجهة الفيديو
استخدم Jitsi SDK أو واجهة الويب المناسبة، مع التحقق من صلاحية الدخول
5. عند بدء الاجتماع وانتهائه
سجّل أحداث البداية والنهاية في الـ Backend، وأنهِ جلسة الفيديو الفعلية أيضًا
لاحظ أن الـ Workflow ده يحتاج تعديلًا في الـ Backend حتى يعمل بشكل صحيح للطبيب والمريض معًا، كما سنوضح أدناه.
