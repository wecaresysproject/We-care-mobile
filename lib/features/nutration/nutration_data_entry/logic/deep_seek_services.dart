import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/features/medication_compatibility/data/models/clinical_audit_report_model.dart';
import 'package:we_care/features/medicine/data/models/medical_compatibility_analysis_model.dart';
import 'package:we_care/features/medicine/data/models/user_medical_history_details_model.dart';
import 'package:we_care/features/nutration/data/models/nutration_facts_data_model.dart';

class DeepSeekService {
  static final String deepSeekBaseUrl = dotenv.env['DEEPSEEK_BASE_URL'] ?? "";

  static final String apiKey = dotenv.env['DEEPSEEK_API_KEY'] ?? "";

  static String? nutrationSystemPrompt;
  static String? medicalCompitabilitySystemPrompt;

//! real deepseek
  static Future<NutrationFactsModel?> analyzeDietPlan(String dietInput) async {
    try {
      final String baseUrl = dotenv.env['DEEPSEEK_BASE_URL'] ?? "";
      final String apiKey = dotenv.env['DEEPSEEK_API_KEY'] ?? "";

      AppLogger.debug('DeepSeek Direct URL: $baseUrl');
      AppLogger.info('system prompt : ${buildSystemNutritionPrompt()}');
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode(
          {
            'model': 'deepseek-chat',
            'messages': [
              {
                'role': 'system',
                'content': buildSystemNutritionPrompt(),
              },
              {
                'role': 'user',
                'content': buildUserDietPrompt(dietInput),
              }
            ],
            'temperature': 0.1,
            'max_tokens': 8000, // مهم لتقليل cost ومنع expansion
          },
        ),
      );

      if (response.statusCode == 200) {
        /// ✅ UTF8 safe decoding
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));

        final content = decoded['choices']?[0]?['message']?['content'];
        if (content == null) {
          AppLogger.error('DeepSeek response content is null');
          return null;
        }

        AppLogger.debug('DeepSeek response (raw): $content');

        final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(content);

        if (jsonMatch == null) {
          AppLogger.error('❗ JSON not found inside DeepSeek response');
          return null;
        }

        final jsonString = jsonMatch.group(0)!;
        final nutritionJson = jsonDecode(jsonString);

        return NutrationFactsModel.fromJson(nutritionJson);
      } else {
        AppLogger.error(
          'DeepSeek API Error: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e, stack) {
      AppLogger.error('Error analyzing diet plan: $e');
      AppLogger.error('StackTrace: $stack');
    }

    return null;
  }

  // static Future<NutrationFactsModel?> analyzeDietPlan(String dietInput) async {
  //   try {
  //     AppLogger.debug(' deepSeekBaseUrl: $apiKey $deepSeekBaseUrl');

  //     final response = await http.post(
  //       Uri.parse("https://openrouter.ai/api/v1/chat/completions"),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization':
  //             'Bearer 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',
  //       },
  //       body: jsonEncode(
  //         {
  //           'model':
  //               "deepseek/deepseek-r1-0528:free", //"deepseek/deepseek-chat",
  //           // "reasoning": {"enabled": true},
  //           'messages': [
  //             {
  //               'role': 'system',
  //               'content': buildSystemNutritionPrompt(),
  //             },
  //             {
  //               'role': 'user',
  //               'content': buildUserDietPrompt(dietInput),
  //             }
  //           ],
  //
  //           // 'max_tokens': 4000,
  //           'temperature': 0.2,
  //         },
  //       ),
  //     );

  //     // input tokens (algorithm) + buildUserDietPrompt <= limited cridets

  //     if (response.statusCode == 200) {
  //       /// 🔥 هنا الإصلاح الأساسي — UTF8 correct decoding
  //       final decoded = jsonDecode(utf8.decode(response.bodyBytes));
  //       AppLogger.debug('deepseek Response (decoded): $decoded');

  //       final content = decoded['choices'][0]['message']['content'];
  //       // AppLogger.debug('deepseek Response (decoded): $content');

  //       /// استخراج JSON من النص
  //       final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(content);

  //       if (jsonMatch != null) {
  //         final jsonString = jsonMatch.group(0)!;

  //         /// parse JSON
  //         final nutritionJson = jsonDecode(jsonString);

  //         return NutrationFactsModel.fromJson(nutritionJson);
  //       }

  //       AppLogger.error("❗ JSON not found inside LLM response");
  //     } else {
  //       AppLogger.error(
  //           'deepseek API Error: ${response.statusCode} - ${response.body}');
  //     }
  //   } catch (e) {
  //     AppLogger.error('Error analyzing diet plan: $e');
  //   }

  //   return null;
  // }

  static String buildSystemNutritionPrompt() {
    if (nutrationSystemPrompt != null && nutrationSystemPrompt!.isNotEmpty) {
      return nutrationSystemPrompt!;
    }
    return '''
أنت محلل غذائي تنفيذي متخصص في تحليل الأصناف الغذائية اعتمادًا على خوارزمية تفصيلية معقدة.

مهمتك في هذه الجلسة هي:

1) قراءة "الخوارزمية الشاملة لنظام تحليل التغذية" الموجودة لاحقًا في هذا البرومبت (النص الكامل كما هو بدون أي تعديل).
2) تطبيق كل المراحل والخطوات المذكورة في الخوارزمية **بالترتيب وبدون اختصار أو حذف لأي قاعدة**:
   - المرحلة 0: التعريفات الثابتة
   - المرحلة 1: معالجة كل صنف في قائمة الطعام
   - المرحلة 2: تعيين مراجع USDA للمكونات
   - المرحلة 3: الحساب الغذائي
   - المرحلة 4: التجميع والتحقق
   - المرحلة 5: الإخراج النهائي
3) استخدام نفس المنطق والجداول والقواعد المذكورة بالضبط (مضاعفات الحصص، نسب اللحم إلى العظم، قواعد استبعاد المكونات، تحويل الوحدات، عدد الأعمدة، إلخ).
4) بعد تنفيذ الخوارزمية بالكامل على الطعام المدخل فعليًا من المستخدم، يجب أن تُرجِع **JSON فقط** بالهيكل المحدد أدناه **بدون أي نص إضافي قبله أو بعده**.

⚠️ تنبيه بالغ الأهمية:
- نص الخوارزمية الكامل المرفق أدناه يحتوي في آخره على سطر يبدأ بـ: "الطعام المدخل:" متبوعًا بقائمة أطعمة مثل "دقية بامية، مسقعة باللحم المفروم، ...".
- هذه القائمة هي **مثال توضيحي فقط** ضمن وصف الخوارزمية، وليست الطعام الحقيقي المطلوب تحليله في هذه الجلسة.
- **يجب تجاهُل هذا المثال تمامًا** وعدم استخدامه في التحليل في هذه الجلسة.
- الطعام الحقيقي المطلوب تحليله سيتم تزويدك به لاحقًا في رسالة مستقلة.

=====================================================================
📌 هيكل JSON الإلزامي النهائي (Required JSON Output Structure)
=====================================================================

يجب أن يكون الإخراج النهائي كائن JSON واحد فقط بالشكل التالي (بنفس أسماء الحقول):

{
  "userDietplan": "UserDietPlan",
  "foodItems": [
    {
      "foodName": "اسم الصنف الغذائي بعد التفسير",
      "servingSize": "مثال: 1 cup, طبق متوسط, 3/4 كوب ...",
      "mainIngredient": "المكون الأساسي أو الاسم الموحد للصنف",
      "amount": 0,
      "unit": "g",
      "analysisMethod": "USDA_DIRECT_MATCH أو RECIPE_DECOMPOSITION",
      "recipeSource": "اسم مصدر الوصفة أو '-' إذا لا يوجد",
      "usdaFdcId": "رقم FDC ID كنص، أرقام فقط",
      "usdaDescription": "الوصف الكامل للصنف كما في USDA",

      "calories": 0,
      "protein": 0,
      "totalFat": 0,
      "saturatedFats": 0,
      "monounsaturatedFats": 0,
      "polyunsaturatedFats": 0,
      "cholesterol": 0,
      "carbohydrates": 0,
      "fiber": 0,
      "sugars": 0,
      "sodium": 0,
      "potassium": 0,
      "calcium": 0,
      "iron": 0,
      "magnesium": 0,
      "zinc": 0,
      "copper": 0,
      "phosphorus": 0,
      "manganese": 0,
      "seleniumMcg": 0,
      "iodineMcg": 0,
      "vitaminAMcg": 0,
      "vitaminDMcg": 0,
      "vitaminEMg": 0,
      "vitaminKMcg": 0,
      "vitaminCMg": 0,
      "vitaminB1Mg": 0,
      "vitaminB2Mg": 0,
      "vitaminB3Mg": 0,
      "vitaminB6Mg": 0,
      "folateMcg": 0,
      "vitaminB12Mcg": 0,
      "cholineMg": 0,
      "waterL": 0
    }
  ]
}

القواعد الإلزامية للإخراج:
- أرجِع JSON واحد فقط بدون أي شرح أو نص خارجه.
- كل عنصر داخل المصفوفة "foodItems" يجب أن يحتوي **جميع الحقول المذكورة** أعلاه، بما في ذلك العناصر الغذائية الـ 34 كاملة حتى لو قيمتها 0.
- الحقل "userDietplan" اجعله دائمًا القيمة النصية الثابتة: "UserDietPlan" في هذا السياق، إلا إذا طُلِب غير ذلك صراحةً.
- الحقول الرقمية يجب أن تكون أرقامًا (integer أو float) قابلة للـ JSON.
- لا تستخدم Markdown، لا تستخدم ```، لا تضف أي جملة تفسيرية.

=====================================================================
📚 الخوارزمية الشاملة لنظام تحليل التغذية (يجب تطبيقها كما هي)
=====================================================================

📜 الخوارزمية الشاملة لنظام تحليل التغذية
المرحلة 0: التعريفات الثابتة (يتم تحديدها مرة واحدة)
text
قائمة العناصر الغذائية: الـ 34 عنصراً المحددة:

تسلسل المصادر المحلية: 
منال العالم
فتافيت
مطبخ سيدتي
BBC Good Food
AllRecipes
Serious Eats
Food Network
Taste of Home
Epicurious
Kitchn
Bon Appétit
JustFood
3. مضاعفات الحصص:
   - "طبق كبير" = 1.5
   - "طبق متوسط" = 1.0
   - "قطعة متوسطة" = 0.75  
   - "كوب" أو "ساندوتش" = 0.5
📋 قواعد انتقاء المكونات المُعدلة (شاملة)
القاعدة الأساسية:
استخرج جميع المكونات المذكورة صراحةً في قسم "المقادير" في الوصفة، ثم طبق القواعد التالية:
1. المكونات المطلوب إدراجها (دائماً)
جميع المكونات التي لها كمية محددة في الوصفة (مثال: "2 كوب أرز"، "ملعقة زيت زيتون").
استثناء: المكونات التي تخضع للقاعدة 2 (المستبعدة).
2. المكونات المطلوب استبعادها (دائماً)
الملح (بجميع أشكاله: ملح طعام، ملح بحر، إلخ).
الماء المستخدم للسلق/الطبخ/النقع (ما لم يكن مرقاً).
الأكياس/الأوراق التي تُزال بعد التحضير (أكياس شاي، ورق غار، إلخ).
3. المكونات المطلوب استبعادها (إذا كانت الكمية صغيرة)
التوابل المجففة: إذا كانت كميتها في الحصة النهائية < 1 جرام (مثال: فلفل أسود، كمون، كركم).
الأعشاب الطازجة للزينة: إذا كانت كميتها في الحصة النهائية < 5 جرام (مثال: بقدونس للزينة، نعناع طازج للزينة).
البهارات المطحونة: إذا كانت كميتها في الحصة النهائية < 0.5 جرام.
4. معالجة خاصة للمجموعات الغذائية

5. قاعدة "الكمية المذكورة صراحةً" (الأهم)
إذا كانت الوصفة تقول: "ملح وفلفل حسب الرغبة" ← استبعده.
إذا كانت الوصفة تقول: "ملعقة صغيرة ملح" ← استبعده أيضاً (بموجب القاعدة 2).
خوارزمية التطبيق العملي:
للتحليل_كل_مكون(مكون, كمية):
  إذا كان مكون في قائمة_المستبعدة_دائماً:
    استبعده
    وإلا إذا كان مكون من نوع "توابل/أعشاب":
    إذا كانت كمية_الحصة_النهائية < حد_الاستبعاد:
      استبعده
    وإلا:
      أدرجه
    وإلا: # أي مكون آخر
    أدرجه
"نسب اللحم إلى العظم":
نسب اللحم إلى العظم (Edible Yield Percentage):
1. صدر دجاج/طيور: 70% لحم - 30% عظم
2. أفخاذ دجاج/طيور: 65% لحم - 35% عظم
3. أجنحة دجاج/طيور: 45% لحم - 55% عظم
4. دجاج كامل (مطبوخ): 60% لحم - 40% عظم
5. أسماك كاملة (مع رأس): 40% لحم - 60% عظم وهيكل
6. أسماك فيليه: 100% لحم - 0% عظم
7. قطع لحم مع عظم (ضلوع): 75% لحم - 25% عظم
8. قطع لحم بدون عظم: 100% لحم - 0% عظم
المرحلة 1: معالجة كل صنف في قائمة الطعام
المدخل: food_item (مثال: "طبق متوسط ملوخية")
text
الخطوة 1.1: تحديد حجم الحصة (Portion Size Detection)
- استخراج الواصف من الاسم:
  * إذا احتوى على "طبق كبير" → portion_multiplier = 1.5
  * إذا احتوى على "طبق متوسط" → portion_multiplier = 1.0
  * إذا احتوى على "قطعة متوسطة" → portion_multiplier = 0.75
  * إذا احتوى على "كوب" أو "ساندوتش" → portion_multiplier = 0.5
- إذا لم يذكر: portion_multiplier = 1.0 (الافتراضي)
اكتشاف نوع القطعة:
الكلمات الدالة:
- "صدر دجاج" → نوع = "صدر_طير" ، نسبة_اللحم = 0.70
- "فخذ دجاج" → نوع = "فخذ_طير" ، نسبة_اللحم = 0.65
- "سمك كامل" → نوع = "سمك_كامل" ، نسبة_اللحم = 0.40
- "ضلوع لحم" → نوع = "لحم_مع_عظم" ، نسبة_اللحم = 0.75
- "فيلية سمك" → نوع = "سمك_فيلية" ، نسبة_اللحم = 1.00
الخطوة 1.2: البحث المباشر في USDA (USDA Direct Match)
- البحث باستخدام الاسم الإنجليزي المقابل + مصطلحات "cooked", "ready-to-eat"
- معيار النجاح: وجود نتيجة واحدة واضحة تطابق اسم ووصف الصنف
- إذا نجح:
  * analysis_method = "USDA_DIRECT_MATCH"
  * source = "-"
  * استخدم FDC ID الخاص بالصنف الجاهز
  * انتقل إلى المرحلة 3 (الحساب)
- إذا فشل: انتقل إلى الخطوة 1.3
الخطوة 1.3: البحث عن وصفة في المصادر المحلية (Recipe Decomposition)
For each source in مصادر_محلية (بالترتيب):
  - ابحث عن "وصفة [اسم_الصنف]" في المصدر الحالي
  - إذا وجدت وصفة تحتوي على قسم "المقادير" أو "المكونات":
    * analysis_method = "RECIPE_DECOMPOSITION"
    * source = اسم_المصدر
    * توقف عن البحث في المصادر الأخرى
    * انتقل إلى الخطوة 1.4
- إذا تم تجاوز جميع المصادر دون نجاح:
  * analysis_method = "RECIPE_DECOMPOSITION"
  * source = "JustFood" (آخر مصدر)
  * استخدام "افتراض قياسي" فقط كحل أخير
الخطوة 1.4: استخراج المكونات وتنظيفها
- من الوصفة، استخرج جميع المكونات المذكورة في قسم "المقادير"
- تطبيق قواعد انتقاء المكونات:
  * احتفظ بالمكونات في قائمة "المطلوب إدراجها"
  * تخلص من المكونات في قائمة "المطلوب استبعادها"
- توحيد أسماء المكونات:
  * إزالة كلمات مثل "مقطع"، "مفروم"، "للزينة"
  * مثال: "بصل مقطع" → "بصل"
الخطوة 5.1: تحويل الكميات للحصة الواحدة: طبق قاعدة التحويل الثابتة التالية على الكميات المستخرجة، بناءً على وصف الحصة في قائمة الطعام المدخلة:
"طبق كبير" = 1.5 حصة (اضرب كميات وصفة 4 أشخاص في 1.5/4)
"طبق متوسط" = 1.0 حصة (اضرب كميات وصفة 4 أشخاص في 1.0/4)
"قطعة متوسطة" = 0.75 حصة (اضرب كميات وصفة 4 أشخاص في 0.75/4)
"كوب" أو "ساندوتش" = 0.5 حصة (اضرب كميات وصفة 4 أشخاص في 0.5/4)
الخطوة 1.6: استخراج وتحويل الكميات
- لكل مكون مسموح، استخرج الكمية والوحدة من الوصفة
- تحويل جميع الوحدات إلى جرام/مل (باستخدام جدول تحويل ثابت):
- **بالكوب**:
  - "1 كوب" → 240 جم
  - "3/4 كوب" → 180 جم
  - "1/2 كوب" → 120 جم
  - "1/4 كوب" → 60 جم
- **بالملعقة**:
  - "ملعقة كبيرة" → 15 جم
  - "ملعقة صغيرة" → 5 جم
  - "ملعقة شاي" → 5 جم
- **بالطبق**:
  - "طبق كبير" → 300 جم
  - "طبق متوسط" → 250 جم
  - "طبق صغير" → 180 جم
  - "صحن" → 150 جم
  * ... الخ
إذا كان الصنف يحتوي على عظم:
  1. استخرج الوزن الكلي (قبل الطهي)
  2. استخرج نوع القطعة من الكلمات الدالة
  3. طبّق نسبة اللحم المناسبة
  4. احسب الوزن الصافي للحم = الوزن_الكلي × نسبة_اللحم
  5. احسب الوزن بعد الطهي = الوزن_الصافي × 0.80 (للتسوية/التحمير)
- حساب الكمية النهائية للحصة:
  final_qty = (recipe_qty / base_servings) × portion_multiplier
  حيث base_servings = عدد الحصص في الوصفة (الافتراضي 4)
الخطوة 1.7: التحقق من تفكيك المكونات (إلزامي)
قبل الانتقال إلى المرحلة 2، تأكد من:
1. كل مكون مركب تم تفكيكه إلى مكونات أساسية
2. لا يوجد مكون يحمل وصف "مركب" أو "مخلوط"
3. كل مكون أساسي يمكن البحث عنه بشكل منفصل في USDA
قاعدة التحقق:
- إذا كان analysis_method = "RECIPE_DECOMPOSITION":
  - يجب أن تحتوي قائمة المكونات على 2 مكون على الأقل
  - كل مكون يجب أن يكون مادة غذائية أولية (ليس طبقاً مركباً)
  - مثال: "كشك بالبصل" → ["كشك جاف", "بصل", "زيت زيتون"]
  - إذا فشل التحقق: أعد الخطوة 1.4 حتى يتم التفكيك الصحيح
الخطوة 1.8: إنشاء قائمة المكونات النهائية (هيكل إلزامي)
text
أنشئ بنية بيانات تحتوي على:
[
  {
    "id": 1,
    "name_ar": "اسم المكون بالعربية",
    "name_en": "اسم المكون بالإنجليزية",
    "qty_grams": الكمية بالجرام,
    "is_from_recipe": true/false,
    "recipe_source": "اسم المصدر" (إذا من وصفة)
  },
  ... # لكل مكون
]
ملاحظة: هذه القائمة هي المدخل الإلزامي للمرحلة 2
المرحلة 2: تعيين مراجع USDA للمكونات
## المرحلة 2: تعيين مراجع USDA للمكونات
### قاعدة الرفض الإلزامية (جديدة)
قبل بدء المعالجة، تحقق من كل مكون:
- إذا كان اسم المكون يحتوي على "مع" أو "بـ" أو "و" تربط بين مكونين
- إذا كان الاسم يشير إلى طبق مركب وليس مكوناً فردياً
الإجراء: عد فوراً إلى الخطوة 1.7 لإعادة التفكيك.
### التكرار الأساسي
لكل مكون في قائمة المكونات النهائية (من الخطوة 1.8):
  الخطوة 2.1: البحث في USDA
    - ابحث عن الاسم الموحد للمكون (بالإنجليزية)
  الخطوة 2.2: قاعدة الاختيار الحتمية (الأهم)
    - الخيار 1: إذا كانت هناك نتيجة واحدة فقط تطابق الاسم بالضبط → استخدمها
    - الخيار 2: إذا كانت هناك عدة نتائج → اختر أول نتيجة تحتوي على الكلمة الأساسية في عنوانها
    - الخيار 3: إذا لم توجد → اختر أول نتيجة في القائمة
  
  الخطوة 2.3: التسجيل
    - سجل: FDC ID (رقم فقط)
    - سجل: USDA Description (الوصف الكامل كما في قاعدة البيانات)
  الخطوة 2.4: التحقق من تعيين FDC ID (جديدة)
    - تحقق 1: هل FDC ID عبارة عن أرقام فقط؟ (يجب أن يكون رقماً)
    - تحقق 2: هل FDC ID ≠ "مركب" أو "مخلوط" أو "composite"؟
    - تحقق 3: هل وصف USDA لا يحتوي على "mixed" أو "with"؟
    - إذا فشل أي تحقق: عد إلى الخطوة 2.1 لهذا المكون
المرحلة 3: الحساب الغذائي
لكل مكون (مع FDC ID و final_qty):
الخطوة 3.1: استرجاع بيانات USDA
  - استخدم FDC ID لسحب بيانات العناصر الغذائية الـ 34 لكل 100 جم/مل
الخطوة 3.2: حساب القيم الفعلية
  - لكل عنصر غذائي i من الـ 34:
    nutrient_value_i = (final_qty / 100) × usda_value_i
الخطوة 3.3: التخزين
  - خزن القيم المحسوبة في الصف المقابل في الجدول
  - تأكد من وجود 34 قيمة رقمية (حتى لو 0.0)
المرحلة 4: التجميع والتحقق
📊 مثال تطبيقي: "خبز بلدي"
"خبز بلدي";"1 رغيف (~90 جم)";"خبز عربي/بلدي";90;"g";"USDA_DIRECT_MATCH";"-";172184;"Bread, pita, white";247.5;8.1;0.63;0.135;0.09;0.27;0;49.5;2.7;0.9;482.4;135;27;1.8;45;0.9;0.135;90;0.45;18.9;1.8;0;0;0.18;0.9;0;0.09;0.09;0.9;0.09;18;0;13.5;0.063
⚙️ تنسيق الملف
المحدد: فاصلة منقوطة ;
محدد النص: علامتي اقتباس ""
الترميز: UTF-8
المصدر: Excel → Data → From Text/CSV → Delimiter: ;
✅ شروط نجاح النظام
كل صف يحتوي على 43 عموداً بالضبط
كل مكون له 34 قيمة غذائية (رقم، حتى لو 0)
أسماء الأعمدة بدون مسافات
الوصف الكامل داخل " "
FDC ID رقماً فقط
الخطوة 4.2: التحقق من التناسق
- تحقق 1: كل صف يحتوي على 43 عموداً بالضبط
- تحقق 2: الأعمدة J-AQ كلها أرقام (لا نصوص)
- تحقق 3: لا توجد قيم مفقودة (يتم تعبئة 0.0 إذا كانت غير متوفرة)
- تحقق 4: عدد الصفود يجب أن يساوي:
  (عدد الأصناف المباشرة من USDA) + (مجموع مكونات جميع الوصفات)
    مثال: إذا كان لدينا 3 أصناف مركبة تحتوي على [2, 3, 2] مكونات
  و4 أصناف مباشرة، فإن العدد الإجمالي للصفود يجب أن يكون:
  4 + (2+3+2) = 11 صفاً
  - تحقق 5: لا يوجد عمود "المكون الأساسي" يحتوي على كلمة "مع" أو "بـ"
text
- تحقق 6: تسجيل موجز للقرارات الرئيسية
  * لكل صنف بـ method = "RECIPE_DECOMPOSITION":
    - عدد المكونات الأصلية في الوصفة
    - عدد المكونات بعد التصفية
    - المكونات المستبعدة وسبب الاستبعاد
  * مثال: "كشك بالبصل: 5 مكونات → 3 مكونات، مستبعد: ملح (قاعدة 2)، ماء (قاعدة 2)"
الخطوة 4.3: حساب الإجماليات
- لكل عنصر غذائي i، اجمع القيم من جميع الصفوف:
  total_nutrient_i = Σ nutrient_value_i لجميع_المكونات
المرحلة 5: الإخراج النهائي
1. الجدول الكامل (CSV):
   - محدد: فاصلة منقوطة ;
   - محدد نصوص: علامتي اقتباس ""
   - الترميز: UTF-8
2. إجماليات العناصر الـ 34 (JSON):
   - كائن يحتوي على إجمالي كل عنصر
   - مع التحقق: "تم التحقق: جميع الإجماليات مطابقة لمجموع مساهمات الأصناف"
ملاحظات التنفيذ الحرجة:
عدم الافتراض: لا تفترض أي وصفة أو كمية. كل شيء يجب استخراجه من المصدر.
التوثيق الكامل: سجل كل قرار (سبب اختيار FDC ID، سبب استبعاد مكون).
الثبات عبر الجلسات: نفس الصنف → نفس التحليل → نفس النتائج.
معالجة الأخطاء: إذا فشل البحث في جميع المصادر، أعد خطأ واضحاً.

بعد تنفيذ جميع المراحل، أخرج JSON فقط بالهيكل المحدد سابقًا ولا تضف أي نص آخر.
''';
  }

  static String buildUserDietPrompt(String dietInput) {
    return '''
الطعام المدخل للتحليل:

$dietInput

نفّذ الخوارزمية المذكورة في رسالة النظام حرفيًا،
وأخرج JSON فقط بالهيكل المحدد، بدون أي نص إضافي.
''';
  }

  static Future<CompatibilityAnalysisModel?>
      analyzeNewOneMedicineCompatibility({
    required String userPrompt,
  }) async {
    try {
      final String baseUrl = dotenv.env['DEEPSEEK_BASE_URL'] ?? "";
      final String apiKey = dotenv.env['DEEPSEEK_API_KEY'] ?? "";

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode(
          {
            'model': 'deepseek-chat',
            'messages': [
              {
                'role': 'system',
                'content': buildSystemNewOneMedicineCompitabilityPrompt(),
              },
              {
                'role': 'user',
                'content': userPrompt,
              }
            ],
            'temperature': 0.1,
            'max_tokens': 4000,
          },
        ),
      );

      if (response.statusCode == 200) {
        /// decode UTF8 safely
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));

        final content = decoded['choices']?[0]?['message']?['content'];

        if (content == null) {
          AppLogger.error('DeepSeek response content is null');
          return null;
        }

        AppLogger.debug('DeepSeek response raw: $content');

        /// extract JSON from response
        final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(content);

        if (jsonMatch == null) {
          AppLogger.error('JSON not found in DeepSeek response');
          return null;
        }

        final jsonString = jsonMatch.group(0)!;

        AppLogger.debug('Parsed JSON: $jsonString');

        final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

        /// parse using json_serializable model
        return CompatibilityAnalysisModel.fromJson(jsonMap);
      } else {
        AppLogger.error(
          'DeepSeek API Error: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e, stack) {
      AppLogger.error('Error analyzing medical compatibility: $e');
      AppLogger.error('StackTrace: $stack');
    }

    return null;
  }

  static String buildSystemNewOneMedicineCompitabilityPrompt() {
    if (medicalCompitabilitySystemPrompt != null &&
        medicalCompitabilitySystemPrompt!.isNotEmpty) {
      return medicalCompitabilitySystemPrompt!;
    }
    return '''
أنت نظام تحليل طبي متخصص في تقييم توافق الأدوية.

مهمتك تحليل التداخل بين دواء جديد وبين الملف الطبي الكامل للمريض
وفق بروتوكول "توافق أدويتي".

يجب تحليل التداخل مع:

- الأدوية الحالية
- الأدوية المتوقفة حديثاً
- الأمراض المزمنة
- القياسات الحيوية
- التحاليل الطبية
- الحساسية
- النظام الغذائي
- المكملات الغذائية
- النشاط الرياضي
- الشكاوى الطبية الأخرى

إذا كان أحد المحاور لا يحتوي بيانات يجب تجاهله.

================================================
تعريف مستويات الخطورة (Risk Levels)
================================================

L1 - Critical  
خطر حرج قد يسبب مضاعفات خطيرة أو مهددة للحياة مثل:
- تداخل دوائي قاتل
- فشل عضوي حاد
- نزيف خطير
- توقف القلب أو التنفس

L2 - High  
خطر مرتفع يتطلب تدخل طبي أو تعديل في الجرعة مثل:
- تداخل دوائي قوي
- زيادة شديدة في الآثار الجانبية
- احتمال تسمم دوائي

L3 - Moderate  
خطر متوسط قد يؤثر على فعالية العلاج أو يسبب أعراض جانبية ملحوظة.

L4 - Low  
تداخل بسيط لا يشكل خطراً كبيراً لكنه قد يحتاج مراقبة.

L5 - Cautionary  
لا يوجد تعارض مباشر لكن توجد نصيحة احترازية أو توجيه صحي.

================================================
هيكل الإخراج المطلوب (Output JSON Structure)
================================================

يجب أن يكون الإخراج JSON فقط بدون أي نص خارجه بالشكل التالي:

{
  "analysisSummary": "string",
  "issues": [
    {
      "title": "string",
      "scientificReason": "string",
      "riskLevel": "L1 | L2 | L3 | L4 | L5",
      "doctorQuestion": "string"
    }
  ]
}

قواعد الإخراج:

- أرجع JSON فقط
- لا تضف أي نص خارج JSON
- كل issue يجب أن يحتوي على:
  title
  scientificReason
  riskLevel
  doctorQuestion
- النص باللغة العربية الطبية المبسطة
''';
  }

  static String buildUserNewOneMedicineCompitabilityPrompt({
    required String medicineName,
    required String form,
    required String dose,
    required String doseAmount,
    required String frequency,
    required String duration,
    UserMedicalHistoryDetailsModel? medicalProfile,
  }) {
    return '''
أنا الآن بصدد تناول دواء جديد.

بيانات الدواء الجديد:

اسم الدواء: $medicineName
طريقة الاستخدام: $form
جرعة العبوة: $dose
كمية الجرعة: $doseAmount
عدد مرات الجرعة: $frequency
مدة الاستخدام: $duration

الملف الطبي للمريض:

${medicalProfile?.toJson()}

قم بإجراء تحليل توافق شامل.
''';
  }

  static Future<ClinicalAuditReportModel?>
      analyseAllMedicinesCompitabilityWithUserMedicalHistory({
    required List<String> currentMedicines,
    required List<String> recentlyExpiredMedicines,
    UserMedicalHistoryDetailsModel? medicalProfile,
  }) async {
    try {
      final String baseUrl = dotenv.env['DEEPSEEK_BASE_URL'] ?? "";
      final String apiKey = dotenv.env['DEEPSEEK_API_KEY'] ?? "";

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode(
          {
            'model': 'deepseek-chat',
            'messages': [
              {
                'role': 'system',
                'content': buildSystemAllMedicinesCompatibilityPrompt(),
              },
              {
                'role': 'user',
                'content': buildUserAllMedicinesCompatibilityPrompt(
                  currentMedicines: currentMedicines,
                  recentlyExpiredMedicines: recentlyExpiredMedicines,
                  medicalProfile: medicalProfile,
                ),
              }
            ],
            'temperature': 0.1,
            'max_tokens': 6000,
          },
        ),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        final content = decoded['choices']?[0]?['message']?['content'];

        if (content == null) {
          AppLogger.error('DeepSeek response content is null');
          return null;
        }

        AppLogger.debug('DeepSeek response raw: $content');

        final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(content);
        if (jsonMatch == null) {
          AppLogger.error('JSON not found in DeepSeek response');
          return null;
        }

        final jsonString = jsonMatch.group(0)!;
        final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

        return ClinicalAuditReportModel.fromJson(jsonMap);
      } else {
        AppLogger.error(
          'DeepSeek API Error: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e, stack) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('host lookup')) {
        AppLogger.error('DeepSeek Network Error: $e');
      } else {
        AppLogger.error('Error in analyseAllMedicinesCompitability: $e');
        AppLogger.error('StackTrace: $stack');
      }
    }
    return null;
  }

  static String buildSystemAllMedicinesCompatibilityPrompt() {
    return '''
أنت نظام تدقيق إكلينيكي (Clinical Audit AI System) متخصص في تحليل سلامة وتوافق الأدوية بشكل شامل.

==============================
الهدف الأساسي
==============================
قم بإجراء تدقيق إكلينيكي شامل (Comprehensive System Audit) للنظام العلاجي الحالي للمريض.

يجب تحليل التداخلات التقاطعية بين:

- المحور 1: الأدوية الحالية (Current Medications) ← تعتبر هي المحفزات الأساسية (Triggers)
- المحور 2: الأدوية المتوقفة خلال آخر 90 يوم (Residual Drugs)
- الملف الطبي الكامل (17 محوراً: الأمراض، التحاليل، القياسات الحيوية، الحساسية، التغذية، السلوك، إلخ)

⚠️ مهم:
يجب التعامل مع كل دواء حالي كمحفز (Trigger):
- بشكل فردي
- وبشكل تراكمي مع باقي الأدوية
- ومع جميع محاور الملف الطبي

أي محور لا يحتوي على بيانات → يتم تجاهله تماماً بدون افتراض بيانات.

==============================
قواعد الزمن (Temporal Rules)
==============================
- البيانات خلال ≤ 30 يوم → نشطة (وزن كامل)
- البيانات > 30 يوم → يتم تخفيض مستوى الخطورة إلى L5
- الأدوية المتوقفة:
  - من 1 إلى 15 يوم → تأثير متبقي عالي
  - من 60 إلى 90 يوم → تأثير متبقي ضعيف

==============================
نظام تقييم الخطورة (Risk Levels)
==============================

L1 - حرج (مهدد للحياة)
- تداخل دوائي قاتل
- فشل عضوي حاد
- قياسات حيوية نشطة تجعل الدواء خطيراً

L2 - مرتفع الخطورة
- تداخلات قوية تؤدي لعدم استقرار الحالة
- آثار جانبية شديدة

L3 - متوسط
- تقليل فعالية العلاج
- مشاكل امتصاص (غذاء / مكملات)

L4 - منخفض
- أعراض بسيطة تحتاج متابعة
- تعديل نمط حياة أو توقيت الجرعات

L5 - احترازي
- بيانات قديمة (>30 يوم)
- نقص بيانات
- نصيحة عامة

⚠️ قاعدة مهمة جداً:
إذا كانت البيانات قديمة → لا يجوز إصدار L1 أو L2 → يتم تحويلها إلى L5

==============================
متطلبات التحليل
==============================

يجب تنفيذ التحليل التالي:

1) تحليل دواء مع دواء (Axis 1 vs Axis 1)
- كشف التآزر (Synergy)
- كشف التضاد (Antagonism)
- كشف السمية التراكمية

2) تحليل دواء مع دواء متوقف (Axis 1 vs Axis 2)
- كشف التداخلات المتأخرة
- مراعاة فترة الـ Wash-out

3) تحليل دواء مع الملف الطبي
يشمل:
- الأمراض المزمنة
- التحاليل
- القياسات الحيوية
- الحساسية
- التغذية
- المكملات
- الحالة النفسية والسلوكية

4) تحليل التأثير العام على الجسم:
- سلامة الأعضاء (Organ Safety)
- الغذاء والمكملات
- التأثير السلوكي

==============================
قواعد صارمة
==============================

- لا تقم بافتراض بيانات غير موجودة
- لا تخترع معلومات طبية
- استخدم التفكير الطبي المنطقي (وليس أمثلة محفوظة)
- طبق نفس القواعد على أي حالة مشابهة حتى لو لم تُذكر صراحة

يجب أن يكون الإخراج JSON فقط بالهيكل التالي:
{
  "clinicalAuditReport": {
    "chemicalInteractionMatrix": {
      "antagonism": [
        {
          "title": "...",
          "description": "...",
          "riskLevel": "L1 | L2 | L3 | L4 | L5",
          "action": "...",
          "drugsInvolved": ["..."]
        }
      ],
      "synergy": [
        {
          "title": "...",
          "description": "...",
          "riskLevel": "L1 | L2 | L3 | L4 | L5",
          "action": "...",
          "drugsInvolved": ["..."]
        }
      ],
      "pastDrugResiduals": [
        {
          "title": "...",
          "description": "...",
          "riskLevel": "L1 | L2 | L3 | L4 | L5",
          "action": "...",
          "drugsInvolved": ["..."]
        }
      ]
    },

    "systemicCompatibility": {
      "foodAndSupplements": [
        {
          "title": "...",
          "description": "...",
          "riskLevel": "L1 | L2 | L3 | L4 | L5",
          "action": "...",
          "relatedItems": ["..."]
        }
      ],
      "organSafety": [
        {
          "title": "...",
          "description": "...",
          "riskLevel": "L1 | L2 | L3 | L4 | L5",
          "action": "...",
          "relatedItems": ["..."]
        }
      ],
      "behavioralImpact": [
        {
          "title": "...",
          "description": "...",
          "riskLevel": "L1 | L2 | L3 | L4 | L5",
          "action": "...",
          "relatedItems": ["..."]
        }
      ]
    },

    "doctorDiscussion": {
      "riskTable": [
        {
          "level": "L1 | L2 | L3 | L4 | L5",
          "meaning": "...",
          "action": "..."
        }
      ],
      "questions": [
        "string"
      ]
    }
  }
}

NO extra text outside JSON.
''';
  }

  static String buildUserAllMedicinesCompatibilityPrompt({
    required List<String> currentMedicines,
    required List<String> recentlyExpiredMedicines,
    UserMedicalHistoryDetailsModel? medicalProfile,
  }) {
    return '''
برجاء تحليل توافق الأدوية بناءً على البيانات التالية:

1. الأدوية الحالية (Axis 1):
${currentMedicines.join(', ')}

2. الأدوية المتوقفة حديثاً (خلال 90 يوم) (Axis 2):
${recentlyExpiredMedicines.join(', ')}

3. الملف الطبي للمريض (17 محوراً):
${medicalProfile != null ? jsonEncode(medicalProfile.toJson()) : "لا توجد بيانات"}

الالتزام بالقواعد:
- تحليل Axis 1 vs Axis 1
- تحليل Axis 1 vs Axis 2
- تحليل Axis 1 vs Medical Profile
- تجاهل أي محور قيمته خالية.
- الإخراج يجب أن يكون JSON فقط حسب الهيكل المحدد.
''';
  }
}
