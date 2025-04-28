import 'package:flutter/material.dart';
import 'package:flutter_scalable_ocr/flutter_scalable_ocr.dart';
import 'package:image_picker/image_picker.dart';

class MedicineOCRScanner extends StatefulWidget {
  final Function(String) onMedicineDetected;

  const MedicineOCRScanner({Key? key, required this.onMedicineDetected}) 
      : super(key: key);

  @override
  _MedicineOCRScannerState createState() => _MedicineOCRScannerState();
}

class _MedicineOCRScannerState extends State<MedicineOCRScanner> {
  String _extractedText = "";
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("مسح علبة الدواء"),
      ),
      body: Stack(
        children: [
          ScalableOCR(
            paintboxCustom: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 4.0
              ..color = Colors.green,
            boxLeftOff: 0.2,
            boxBottomOff: 0.7,
            boxRightOff: 0.2,
            boxTopOff: 0.3,
            boxHeight: 150,
            getScannedText: (text) {
              setState(() {
                _extractedText = text;
              });
              _processExtractedText(text);
            },
            // overlay: Container(
            //   alignment: Alignment.topCenter,
            //   margin: EdgeInsets.only(top: 100),
            //   child: Text(
            //     "ضع اسم الدواء داخل المستطيل",
            //     style: TextStyle(
            //       color: Colors.white,
            //       fontSize: 20,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_extractedText.isNotEmpty) {
                    widget.onMedicineDetected(_extractedText);
                    Navigator.pop(context);
                  }
                },
                child: Text("تأكيد اسم الدواء"),
              ),
            ),
          ),
        ],
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