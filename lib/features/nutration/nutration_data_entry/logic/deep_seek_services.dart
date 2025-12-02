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
  }) async {
    try {
      AppLogger.debug(
          'DeepSeek Single Nutrient: $apiKey $deepSeekBaseUrl | nutrient: $targetNutrient');

      final prompt = buildSingleNutrientPrompt(
        dietInput: dietInput,
        targetNutrient: targetNutrient,
      );

      final response = await http.post(
        Uri.parse(deepSeekBaseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': "deepseek/deepseek-chat",
          'messages': [
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'max_tokens': 1200,
          'temperature': 0.2,
        }),
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
  }) {
    return '''
أنت محلل غذائي متخصص. سيتم تزويدك بعنصر غذائي واحد مستهدف للتحليل (مثال: فيتامين C) 
وبقائمة أطعمة ومشروبات تم استهلاكها خلال اليوم.

مهمتك:

1) تحليل كل صنف غذائي مذكور في القائمة بدون استثناء.
2) تقدير الأوزان/الأحجام وتحويلها إلى جرام أو مل كوحدات قياسية موحدة.
   استخدم القيم الافتراضية التالية عند غياب الكمية أو الحجم:
   - بيضة = 50 جم
   - راحة يد بروتين ≈ 100–120 جم
   - قبضة يد فاكهة/نشويات ≈ 120–150 جم
   - طبق عادي ممتلئ ≈ 300–350 جم
   - كوب = 240 مل ≈ 240 جم
   - ملعقة كبيرة = 15 جم/مل
   - ملعقة صغيرة = 5 جم/مل
3) استخدم USDA FoodData Central كمصدر أساسي للقيم الغذائية. 
   يمكن استخدام جداول محلية فقط إذا لم تتوفر بيانات واضحة، دون تغيير المنطق الأساسي.
4) في حال وجود غموض في حجم أو كمية الطعام، اختر الوزن القياسي للأصناف الأكثر شيوعًا في USDA.
5) الطهي والزيوت:
   - القلي يضيف 12 جم زيت لكل حصة بشكل افتراضي إذا لم يذكر المستخدم كمية الزيت.
   - السلق والشوي لا يضيفان دهونًا إضافية تُذكر.
6) لا تقم باختراع أطعمة أو مكونات غير مذكورة. استخدم فقط الأصناف المذكورة في القائمة.
7) المطلوب هو حساب هذا العنصر الغذائي فقط: "$targetNutrient".
8) يجب أن يكون الإخراج على شكل JSON فقط بدون أي نص إضافي أو تعليقات.

----------

# ما نحتاجه:

- تحديد كمية "$targetNutrient" في كل صنف غذائي في القائمة (لكل حصة فعلية تم تناولها).
- استخدام القيمة القياسية لـ "$targetNutrient" لكل 100 جم أو 100 مل لكل صنف، 
  ثم حساب الكمية الفعلية بناءً على كمية الطعام المستهلكة.
- جمع جميع القيم للوصول إلى إجمالي "$targetNutrient" اليومي.

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
