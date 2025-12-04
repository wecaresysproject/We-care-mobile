import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/features/nutration/data/models/nutration_facts_data_model.dart';
import 'package:we_care/features/nutration/data/models/single_nutrient_model.dart';

class DeepSeekService {
  static final String deepSeekBaseUrl = dotenv.env['DEEPSEEK_BASE_URL'] ?? "";

  static final String apiKey = dotenv.env['DEEPSEEK_API_KEY'] ?? "";

  static Future<NutrationFactsModel?> analyzeDietPlan(String dietInput) async {
    try {
      AppLogger.debug(' deepSeekBaseUrl: $apiKey $deepSeekBaseUrl');
      final prompt = buildNutritionPrompt(dietInput);
      AppLogger.debug('Prompt: $prompt');
      final response = await http.post(
        Uri.parse(deepSeekBaseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          // 'model': 'gpt-3.5-turbo', // or 'gpt-4' if you have access
          'model': "deepseek/deepseek-chat", // or whatever the model ID is

          'messages': [
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'max_tokens': 1000,
          'temperature': 0.3, // Lower temperature for more consistent results
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];

        AppLogger.debug('deepseek Response: $content');

        // Extract JSON from the response
        final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(content);
        if (jsonMatch != null) {
          final jsonString = jsonMatch.group(0)!;
          final nutritionJson = jsonDecode(jsonString);

          return NutrationFactsModel.fromJson(nutritionJson);
        }
      } else {
        AppLogger.error(
            'deepseek API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      AppLogger.error('Error analyzing diet plan: $e');
    }

    return null;
  }

  /// Builds a detailed nutrition analysis prompt for a given user food input.
  static String buildNutritionPrompt(String dietInput) {
    return '''
أنت محلل غذائي خبير. مهمتك الأساسية هي تحويل أي قائمة أطعمة ومشروبات يرسلها المستخدم إلى تحليل غذائي دقيق ومتسق لكلٍ من العناصر الـ34 التالية بالترتيب المحدد أدناه. التزم بكل قاعدة من قواعد التقدير والمراجعة بدقة متناهية.

# قواعد التقدير العامة (إلزامية)
- وحدات القياس القياسية: بيضة = 50 جم، راحة يد (بروتين) ≈ 100–120 جم، قبضة يد (فاكهة/نشويات) ≈ 120–150 جم، طبق عادي ممتلئ ≈ 300–350 جم، كوب = 240 مل ≈ 240 جم.
- ملعقة كبيرة = 15 جم/مل، ملعقة صغيرة = 5 جم/مل.
- قاعدة الـUSDA إلزامية: استخدم USDA Food Data Central كمصدر أول. إذا ظهر فرق لقيم محلية استخدم جداول الصحة المصرية/السعودية كمرجع ثانوي.

# تحليل الطعام
- تحليل جميع الأطعمة والمشروبات بكامل الإضافات المذكورة بدون استثناءات.
- تقدير الكميات وتحويلها إلى جرام أو مل كوحدات قياسية.
- التعامل مع الغموض: إذا لم يذكر المستخدم وزنًا، استخدم الوزن القياسي للصنف الأكثر شيوعًا.
- الطهي والزيوت: القلي يضيف 12 جم زيت/حصة افتراضيًا إذا لم يذكر المستخدم مقدار الزيت، الصلصات الكريمية تُضاف حسب USDA، السلق والشوي لا يضيف دهونا تذكر.
- عدم الاختراع: لا تضف مكونات أو أصناف غير مذكورة.

# قواعد الحماية من الأخطاء الحسابية
- التحقق من توازن الدهون: (دهون مشبعة + أحادية + متعددة) ≤ الدهون الكلية.
- مراجعة القيم الشاذة: تحقق آليًا من عدم تجاوز UL المعروف (مثال: فيتامين C > 2000 mg).

# آلية الحساب والتجميع
1. التقدير الموحد للأوزان لكل صنف طبقًا للإرشادات.
2. لكل صنف، استخرج قيم جميع العناصر الـ34 لكل 100 جم/مل ثم حسب الكمية الفعلية.
3. التجميع النهائي: جمع القيم لكل عنصر عبر الأصناف وتحقق من تطابقها مع الجدول النهائي.

# المخرجات
- أرجع JSON فقط بدون أي نص إضافي.
- المفاتيح بالترتيب:
{
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

# الطعام المدخل
"$dietInput"

املأ القيم بالأرقام الصحيحة بناءً على التحليل الغذائي. التزم بالهيكل أعلاه بدقة.
''';
  }

  static Future<SingleNutrientModel?> analyzeSingleNutrient({
    required String dietInput,
    required String targetNutrient,
    required int targetValue,
  }) async {
    try {
      AppLogger.debug(
          'DeepSeek Single Nutrient: $apiKey $deepSeekBaseUrl | nutrient: $targetNutrient');

      final prompt = buildSingleNutrientPrompt(
        dietInput: dietInput,
        targetNutrient: targetNutrient,
        targetValue: targetValue,
      );

      final response = await http.post(
        Uri.parse(deepSeekBaseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode(
          {
            'model': "deepseek/deepseek-chat",
            'messages': [
              {
                'role': 'user',
                'content': prompt,
              }
            ],
            'max_tokens': 1000,
            'temperature': 0.2,
          },
        ),
      );

      if (response.statusCode == 200) {
        /// 🔥 تصحيح الترميز للـ response كامل
        final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        final content = decodedResponse['choices'][0]['message']['content'];

        AppLogger.debug("DeepSeek Parsed Content:\n$content");

        /// استخراج JSON فقط من النص
        final match = RegExp(r'\{.*\}', dotAll: true).firstMatch(content);
        if (match != null) {
          final jsonRaw = match.group(0)!;

          /// ❗ لا نستخدم utf8.decode هنا — مباشرة JSON decode
          final parsed = jsonDecode(jsonRaw);

          return SingleNutrientModel.fromJson(parsed);
        }
        AppLogger.error("❗JSON Not Found in response");
      } else {
        AppLogger.error("API Error ${response.statusCode} → ${response.body}");
      }
    } catch (e) {
      AppLogger.error("❗Error analyzing single nutrient → $e");
    }
    return null;
  }

  /// يبني البرومبت لتحليل عنصر غذائي واحد (Dynamic Nutrient)
  static String buildSingleNutrientPrompt({
    required String dietInput,
    required String targetNutrient,
    required int targetValue,
  }) {
    return '''
أنت محلل غذائي متخصص. سيتم تزويدك بعنصر غذائي واحد مستهدف للتحليل (مثل: بروتين، كالوري، فيتامين C...)
وبقائمة أطعمة ومشروبات تم استهلاكها خلال اليوم، إضافةً إلى "قيمة هدف" يجب أن لا يتجاوزها مجموع التحليل.

العنصر المطلوب تحليله: "$targetNutrient"  
القيمة القصوى المسموح بها لهذا العنصر: $targetValue  

----------

# مهمتك الأساسية

1) تحليل كل صنف غذائي وارد في القائمة بدون استثناء.  
2) تقدير الأوزان والاحجام وتحويلها إلى جرام/مل حسب القواعد الآتية:
   - بيضة = 50 جم
   - راحة يد بروتين ≈ 100–120 جم
   - قبضة يد نشويات/فاكهة ≈ 120–150 جم
   - طبق عادي ممتلئ ≈ 300–350 جم
   - كوب = 240 مل
   - ملعقة كبيرة = 15 جم/مل
   - ملعقة صغيرة = 5 جم/مل
3) الاعتماد على USDA FoodData Central كمصدر أساسي لقيم "$targetNutrient".  
4) عند الغموض، استخدم الوزن القياسي الأكثر شيوعًا في USDA.  
5) الطهي:
   - القلي يضيف 12 جم زيت افتراضيًا لكل حصة إذا لم يذكر المستخدم كمية الزيت.
   - السلق والشوي لا يضيفان دهونًا تذكر.
6) **ممنوع اختراع أطعمة غير مذكورة** — التزم بنص المدخلات فقط.
7) المطلوب حساب **"$targetNutrient" فقط**.
8) **مهم جداً — التقييد بالقيمة القصوى targetValue**:
   - مجموع "$targetNutrient" من جميع الأصناف **يجب ألا يتجاوز $targetValue**.
   - إذا كانت القيم المحسوبة تتجاوز الحد، قم تلقائيًا بعمل:
     - مراجعة تقدير الكميات،
     - اختيار أقل التقديرات المنطقية،
     - ضبط الحصص بحيث يبقى مجموع "$targetNutrient" ≤ $targetValue،
     - دون اختلاق بيانات غير موجودة.
   - الهدف: **نتيجة نهائية متسقة وغير متضاربة، لا تتخطى القيمة المحددة.**

9) قاعدة الالتزام الإجباري بالهدف (CRITICAL RULE):
   - مجموع قيم "$targetNutrient" لكل الأصناف **يجب أن يساوي تمامًا** القيمة "$targetValue" أو يكون أقل منها بشكل بسيط جدًا (<= 1%).
   - إذا أدت الكميات التقديرية العادية إلى تجاوز "$targetValue"، يجب عليك إعادة تقدير الكميات تلقائيًا:
       * تقليل حجم الحصة،
       * استخدام الحد الأدنى المنطقي،
       * أو إعادة ضبط الوزن الافتراضي للصنف.
   - **ممنوع منعًا باتًا** أن يكون مجموع القيم في الحقل "total_nutrient_intake" أعلى من "$targetValue".
   - **ممنوع كذلك** أن يظهر "total_nutrient_intake" ضمن الحد بينما مجموع القيم داخل "items" يتجاوزه — كلاهما يجب أن يتطابقا رياضيًا.
   - في حالة وجود تضارب، أعد الحساب حتى يصبح:
       total_nutrient_intake == sum(items[nutrient_intake])
   - القاعدة الذهبية: **لا يتم إنهاء الحساب قبل التأكد أن إجمالي المدخول النهائي مطابق للحد المستهدف بشكل دقيق.**

----------


# قائمة الأطعمة والمشروبات:

"$dietInput"

----------

أرجع النتيجة بالصيغة التالية، مع أرقام فعلية بدل الأصفار:

{
  "items": [
    {
      "name": "اسم الصنف الغذائي",
      "quantity_grams": 0,
      "nutrient_per_100g": 0,
      "nutrient_intake": 0
    }
  ],
  "total_nutrient_intake": 0
}

- name: اسم الصنف كما فسّرته أنت.
- quantity_grams: الوزن الفعلي المقدر أو المذكور (بالجرام أو ما يعادلها من مل).
- nutrient_per_100g: قيمة "$targetNutrient" لكل 100 جم/مل حسب المرجع الغذائي.
- nutrient_intake: القيمة الفعلية المستمدة من الكمية المتناولة.
- total_nutrient_intake: مجموع كل "nutrient_intake" لكل الأصناف.

أرجع JSON فقط بدون أي نص أو شرح إضافي خارج البنية السابقة.
''';
  }
}

// 9) **مهم جداً — الاتساق بين كل صنف والنتيجة النهائية:**
//    - يجب أن يكون مجموع "nutrient_intake" لجميع الأصناف مطابقًا للمجال المنطقي بحيث لا يتعدى "target_limit".
//    - إذا كان صنف واحد يمتلك قيمة "$targetNutrient" عالية ترفع المجموع فوق $targetValue، يجب تعديل تقدير الكمية تلقائيًا لتصبح الكمية منطقية وتبقى النتيجة النهائية ضمن الحد.
//    - **ممنوع تمامًا أن يظهر أي صنف بقيمة nutrient_intake تؤدي إلى إجمالي أعلى من $targetValue بينما يظهر total_nutrient_intake أقل أو يساوي الحد.**
//    - جميع القيم يجب أن تكون متناسقة، منطقية، ولا تعتمد على تخفيض المجموع النهائي فقط دون تعديل القيم الفردية.
