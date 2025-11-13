import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/functions.dart';

Future<void> shareDetails({
  required String title, // العنوان الرئيسي مثل: "🩺 تفاصيل المرض المزمن"
  required Map<String, dynamic> details, // البيانات اللي هتتعرض
  List<Map<String, dynamic>>? subLists, // بيانات فرعية زي الأدوية مثلاً
  String? subListTitle, // عنوان البيانات الفرعية
  List<String>? imageUrls, // صور مرفقة (اختياري)
  String? errorMessage, // رسالة الخطأ لو حصل exception
}) async {
  try {
    final buffer = StringBuffer('$title\n\n');

    // 🧩 Helper function لإضافة السطور بس لو القيمة موجودة
    void addLine(String label, dynamic value) {
      if (value == null) return;
      final v = value.toString().trim();
      if (v.isEmpty || v ==  "لم يتم ادخال بيانات") return;
      buffer.writeln('$label $v');
    }

    // ✳️ نضيف كل المفاتيح اللي في details map
    details.forEach((label, value) => addLine(label, value));

    // ➕ نضيف الـ sublist (زي الأدوية)
    if (subLists != null && subLists.isNotEmpty) {
      buffer.writeln('\n${subListTitle ?? ""}');
      for (var item in subLists) {
        buffer.writeln('-----------------');
        item.forEach((label, value) => addLine(label, value));
      }
    }

    // 📷 تحميل الصور إن وجدت
    final tempDir = await getTemporaryDirectory();
    List<String> imagePaths = [];
    if (imageUrls != null && imageUrls.isNotEmpty) {
      for (int i = 0; i < imageUrls.length; i++) {
        final url = imageUrls[i];
        if (url.startsWith("http")) {
          final imagePath =
              await downloadImage(url, tempDir, 'shared_image_$i.png');
          if (imagePath != null) imagePaths.add(imagePath);
        }
      }
    }

    if (imagePaths.isNotEmpty) {
      buffer.writeln('\n📎 *مرفقات الصور بالأسفل*');
    }

    final text = buffer.toString();

    // 📤 المشاركة
    if (imagePaths.isNotEmpty) {
      await Share.shareXFiles(
        imagePaths.map((p) => XFile(p)).toList(),
        text: text,
      );
    } else {
      await Share.share(text);
    }
  } catch (e) {
    await showError(errorMessage ?? "❌ حدث خطأ أثناء المشاركة");
  }
}
