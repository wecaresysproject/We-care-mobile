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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_scalable_ocr/flutter_scalable_ocr.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_cubit.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_state.dart';

class MedicineOCRScanner extends StatefulWidget {
  const MedicineOCRScanner({
    super.key,
    required this.title,
  });

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
                    onPressed: () async {
                      await context
                          .read<MedicinesDataEntryCubit>()
                          .onMedicineNameDetected(text);
                    },
                    child: const Text(
                      "تأكيد اسم الدواء",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  BlocConsumer<MedicinesDataEntryCubit,
                      MedicinesDataEntryState>(
                    listener: (context, state) async {
                      if (state.matchedMedicineNamesWithScannedText.isEmpty &&
                          state.message.isNotEmpty) {
                        await showError(state.message);
                      }
                    },
                    builder: (context, state) {
                      if (state
                          .matchedMedicineNamesWithScannedText.isNotEmpty) {
                        return Container(
                          height: 100,
                          width: double.infinity,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: state
                                  .matchedMedicineNamesWithScannedText.length,
                              itemBuilder: (context, index) {
                                return Text(
                                  state.matchedMedicineNamesWithScannedText[
                                      index],
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
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
