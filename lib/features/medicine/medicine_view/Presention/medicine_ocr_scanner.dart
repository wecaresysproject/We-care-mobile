// import 'package:flutter/material.dart';
// import 'package:flutter_scalable_ocr/flutter_scalable_ocr.dart';
// import 'package:we_care/core/global/Helpers/extensions.dart';

// class MedicineOCRScanner extends StatefulWidget {
//   final Function(String) onMedicineDetected;

//   const MedicineOCRScanner({super.key, required this.onMedicineDetected});

//   @override
//   MedicineOCRScannerState createState() => MedicineOCRScannerState();
// }

// class MedicineOCRScannerState extends State<MedicineOCRScanner> {
//   String _extractedText = "";

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         appBar: AppBar(
//           centerTitle: true,
//           title: Text(
//             "مسح علبة الدواء",
//             style: TextStyle(
//               color: Colors.white,
//             ),
//           ),
//         ),
//         body: Stack(
//           children: [
//             ScalableOCR(
//               paintboxCustom: Paint()
//                 ..style = PaintingStyle.stroke
//                 ..strokeWidth = 4.0
//                 ..color = Colors.green,
//               boxHeight: 350,
//               getScannedText: (text) {
//                 setState(() {
//                   _extractedText = text;
//                 });
//               },
//             ),
//             Positioned(
//               bottom: 20,
//               left: 0,
//               right: 0,
//               child: Center(
//                 child: ElevatedButton(
//                   onPressed: () {
// if (_extractedText.isEmpty) {
//   widget.onMedicineDetected(_extractedText);
//   context.pop();
// }
//                   },
//                   child: Text(
//                     "تأكيد اسم الدواء",
//                     style: TextStyle(
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _processExtractedText(String fullText) {
//     // معالجة النص لاستخراج اسم الدواء فقط
//     // يمكنك إضافة منطقك الخاص هنا لتصفية النتائج
//     final lines = fullText.split('\n');
//     for (var line in lines) {
//       if (line.trim().isNotEmpty) {
//         widget.onMedicineDetected(line.trim());
//         break;
//       }
//     }
//   }
// }

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_scalable_ocr/flutter_scalable_ocr.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';

class MedicineOCRScanner extends StatefulWidget {
  const MedicineOCRScanner({
    super.key,
    required this.title,
    required this.onMedicineDetected,
  });
  final Function(String) onMedicineDetected;

  final String title;

  @override
  State<MedicineOCRScanner> createState() => _MedicineOCRScannerState();
}

class _MedicineOCRScannerState extends State<MedicineOCRScanner> {
  String text = "";
  final StreamController<String> controller = StreamController<String>();
  bool torchOn = false;
  int cameraSelection = 0;
  bool lockCamera = true;
  bool loading = false;
  final GlobalKey<ScalableOCRState> cameraKey = GlobalKey<ScalableOCRState>();

  void setText(value) {
    controller.add(value);
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              !loading
                  ? ScalableOCR(
                      key: cameraKey,
                      torchOn: torchOn,
                      cameraSelection: cameraSelection,
                      lockCamera: lockCamera,
                      paintboxCustom: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 4.0
                        ..color = const Color.fromARGB(153, 102, 160, 241),
                      // boxLeftOff: 5,
                      // boxBottomOff: 2.5,
                      // boxRightOff: 5,
                      // boxTopOff: 2.5,
                      boxHeight: MediaQuery.of(context).size.height / 3,
                      getRawData: (value) {
                        inspect(value);
                      },
                      getScannedText: (value) {
                        setText(value);
                      })
                  : Padding(
                      padding: const EdgeInsets.all(17.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
              StreamBuilder<String>(
                stream: controller.stream,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return Result(
                      text: snapshot.data != null ? snapshot.data! : "");
                },
              ),
              Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          loading = true;
                          cameraSelection = cameraSelection == 0 ? 1 : 0;
                        });
                        Future.delayed(const Duration(milliseconds: 150), () {
                          setState(() {
                            loading = false;
                          });
                        });
                      },
                      child: const Text("Switch Camera")),
                  ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          loading = true;
                          torchOn = !torchOn;
                        });
                        Future.delayed(const Duration(milliseconds: 150), () {
                          setState(() {
                            loading = false;
                          });
                        });
                      },
                      child: const Text("Toggle Torch")),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          loading = true;
                          lockCamera = !lockCamera;
                        });
                        Future.delayed(const Duration(milliseconds: 150), () {
                          setState(() {
                            loading = false;
                          });
                        });
                      },
                      child: const Text("Toggle Lock Camera")),
                  ElevatedButton(
                    onPressed: () {
                      if (text.isEmpty) {
                        widget.onMedicineDetected(text);
                        context.pop();
                      }
                    },
                    child: const Text(
                      "تأكيد اسم الدواء",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}

class Result extends StatelessWidget {
  const Result({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      "Readed text: $text",
      style: const TextStyle(color: Colors.white),
    );
  }
}
