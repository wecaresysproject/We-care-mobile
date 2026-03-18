import 'dart:io';

import 'package:appcheck/appcheck.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';

class ConsultAIHelper {
  static const Map<String, String> aiModels = {
    'ChatGPT': 'com.openai.chatgpt',
    'Gemini': 'com.google.android.apps.bard',
    'DeepSeek': 'com.deepseek.chat',
    'Claude': 'com.anthropic.claude',
    'Perplexity': 'ai.perplexity.app.android',
  };

  static Future<bool> checkIfAppInstalled(String packageName) async {
    return await AppCheck().isAppInstalled(packageName);
  }

  static void showNotInstalledDialog(
      BuildContext context, String modelName, String packageName) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text("التطبيق غير مثبت",
              style: AppTextStyles.font16BlackSemiBold),
          content: Text("تطبيق $modelName غير مثبت على جهازك. هل تريد تثبيته؟",
              style: AppTextStyles.font14blackWeight400),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("إلغاء"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final url = Uri.parse("market://details?id=$packageName");
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  await launchUrl(Uri.parse(
                      "https://play.google.com/store/apps/details?id=$packageName"));
                }
              },
              child: const Text("تثبيت"),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> copyToClipboard(BuildContext context, String text) async {
    if (text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("النص فارغ"),
        ),
      );
      return;
    }

    await Clipboard.setData(ClipboardData(text: text));

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 3),
        content: Text(
            "تم نسخ النص. يمكنك لصقه داخل المحادثة مع تطبيق الذكاء الاصطناعي."),
      ),
    );
  }

  static Future<void> handleHandoff({
    required BuildContext context,
    required String modelName,
    required String text,
    File? pdfFile,
  }) async {
    final packageName = aiModels[modelName];
    if (packageName == null) return;

    final isInstalled = await checkIfAppInstalled(packageName);

    if (isInstalled) {
      try {
        await copyToClipboard(context, text);

        if (pdfFile != null) {
          await Share.shareXFiles(
            [XFile(pdfFile.path, mimeType: 'application/pdf')],
            text: text,
          );
        } else {
          await Share.share(text);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  "حدث خطأ أثناء الانتقال للتطبيق. يرجى المحاولة مرة أخرى."),
            ),
          );
        }
      }
    } else {
      if (context.mounted) {
        showNotInstalledDialog(context, modelName, packageName);
      }
    }
  }
}
