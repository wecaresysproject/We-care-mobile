import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:we_care/features/nutration/data/models/nutration_facts_data_model.dart';

class DeepSeekService {
  static final String deepSeekBaseUrl = dotenv.env['DEEPSEEK_BASE_URL'] ?? "";

  static final String apiKey = dotenv.env['DEEPSEEK_API_KEY'] ?? "";

  static Future<NutrationFactsModel?> analyzeDietPlan(String dietInput) async {
    try {
      log(' deepSeekBaseUrl: $apiKey $deepSeekBaseUrl');
      final prompt = _buildPrompt(dietInput);
      log('Prompt: $prompt');
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

        log('deepseek Response: $content');

        // Extract JSON from the response
        final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(content);
        if (jsonMatch != null) {
          final jsonString = jsonMatch.group(0)!;
          final nutritionJson = jsonDecode(jsonString);

          return NutrationFactsModel.fromJson(nutritionJson);
        }
      } else {
        log('deepseek API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      log('Error analyzing diet plan: $e');
    }

    return null;
  }

  static String _buildPrompt(String dietInput) {
    return '''
أنت محلل غذائي خبير. مهمتك الأساسية هي تحليل ما يكتبه المستخدم يوميًا عن طعامه وشرابه وتحويله إلى قيم غذائية دقيقة قدر الإمكان.

# الهدف
- تحليل جميع الأطعمة والمشروبات المذكورة.
- تقدير الكميات وتحويلها إلى وحدات قياسية (جرام/مل).
- استخدام القيم الغذائية المعتمدة (مثل قواعد USDA) للأطعمة المصرية والعربية قدر الإمكان.
- إرجاع النتيجة بصيغة JSON فقط، بدون أي نص إضافي.

# إرشادات تقدير الكميات
## 1. مبدأ التشبيه
- البيضة = 50 جم (مرجع أساسي).
- بحجم راحة اليد (قطعة بروتين: دجاج/لحم): ≈ 100–120 جم.
- بحجم قبضة اليد (فاكهة/نشويات): ≈ 120–150 جم.
- طبق عادي ممتلئ: ≈ 300–350 جم.
- كوب: ≈ 240 جم/مل.

## 2. أدوات المائدة
- ملعقة كبيرة (Table Spoon): ≈ 15 جم أو 15 مل.
- ملعقة صغيرة (Tea Spoon): ≈ 5 جم أو 5 مل.
- كوب (Cup): ≈ 240 جم أو 240 مل.

## 3. التعامل مع الغموض
- إذا لم تُذكر كمية (مثال: "أكلت تفاحة") → اعتبر الحجم المتوسط (≈ 100 جم).
- إذا كان الاسم عامًا (مثال: "حلوى") → اختر صنفًا شائعًا (مثال: كنافة ≈ 150 جم).
- الأفضل إعطاء تقدير منطقي ومتسق بدل تركه فارغًا.

## 4. طرق الطهي
- القلي يضيف ≈ 10–15 جم زيت للطبق.
- الصلصات الكريمية/الجبن تضيف دهون وسعرات إضافية.
- السلق أو الشوي → لا يضيف دهونًا تذكر.

# المخرجات
- أرجع JSON فقط.
- يجب أن يحتوي على هذه المفاتيح بالضبط، بهذا الترتيب:

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

//     return '''
// أنت خبير تغذية مكلّف بتحليل ما يكتبه المستخدم يوميًا عن الطعام الذي تناوله.

// - هدفك: تحليل جميع الأطعمة والمشروبات المذكورة.
// - فسّر الكميات بوحدات قياسية (جرام، ملليلتر) حتى لو لم يذكرها المستخدم.
// - استخدم تقديرات قياسية ثابتة للأحجام الشائعة (مثلاً: بيضة = 50 جم، رغيف بلدي صغير = 80 جم، ملعقة كبيرة زيت = 14 جم، كوب أرز مطبوخ = 150 جم، كوب = 240 مل، ملعقة صغيرة = 5 جم، ملعقة كبيرة = 14 جم، طبق كبير = 350 جم).
// - راعِ طريقة الطهي والإضافات (زيت، سمن، زبدة، سكر، ملح…) وتأثيرها على القيم الغذائية.
// - إذا ذكر المستخدم صنف غامض أو غير شائع، قم بتخمين أقرب صنف معروف مشابه له.

// الطعام المذكور: "$dietInput"

// أرجو أن ترجع النتيجة في صيغة JSON فقط، بدون أي نص إضافي، بالتنسيق التالي:

// {
//   "calories": 0,
//   "protein": 0,
//   "saturatedFats": 0,
//   "monounsaturatedFats": 0,
//   "polyunsaturatedFats": 0,
//   "totalFat": 0,
//   "cholesterol": 0,
//   "carbohydrates": 0,
//   "fiber": 0,
//   "sugars": 0,
//   "sodium": 0,
//   "potassium": 0,
//   "calcium": 0,
//   "iron": 0,
//   "magnesium": 0,
//   "zinc": 0,
//   "copper": 0,
//   "phosphorus": 0,
//   "manganese": 0,
//   "seleniumMcg": 0,
//   "iodineMcg": 0,
//   "vitaminAMcg": 0,
//   "vitaminDMcg": 0,
//   "vitaminEMg": 0,
//   "vitaminKMcg": 0,
//   "vitaminCMg": 0,
//   "vitaminB1Mg": 0,
//   "vitaminB2Mg": 0,
//   "vitaminB3Mg": 0,
//   "vitaminB6Mg": 0,
//   "folateMcg": 0,
//   "vitaminB12Mcg": 0,
//   "cholineMg": 0,
//   "waterL": 0
// }

// املأ القيم بناءً على التحليل الغذائي للطعام المذكور. استخدم القيم المناسبة للأطعمة المصرية والعربية. أرجع JSON فقط.
// ''';
  }
}
