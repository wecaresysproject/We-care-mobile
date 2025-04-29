import 'package:flutter/material.dart';
import 'package:flutter_scalable_ocr/flutter_scalable_ocr.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';

class MedicineOCRScanner extends StatefulWidget {
  final Function(String) onMedicineDetected;

  const MedicineOCRScanner({super.key, required this.onMedicineDetected});

  @override
  MedicineOCRScannerState createState() => MedicineOCRScannerState();
}

class MedicineOCRScannerState extends State<MedicineOCRScanner> {
  String _extractedText = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "مسح علبة الدواء",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Stack(
          children: [
            ScalableOCR(
              paintboxCustom: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 4.0
                ..color = Colors.green,
              boxHeight: 350,
              getScannedText: (text) {
                setState(() {
                  _extractedText = text;
                });
              },
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_extractedText.isEmpty) {
                      widget.onMedicineDetected(_extractedText);
                      context.pop();
                    }
                  },
                  child: Text(
                    "تأكيد اسم الدواء",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _processExtractedText(String fullText) {
    // معالجة النص لاستخراج اسم الدواء فقط
    // يمكنك إضافة منطقك الخاص هنا لتصفية النتائج
    final lines = fullText.split('\n');
    for (var line in lines) {
      if (line.trim().isNotEmpty) {
        widget.onMedicineDetected(line.trim());
        break;
      }
    }
  }
}
