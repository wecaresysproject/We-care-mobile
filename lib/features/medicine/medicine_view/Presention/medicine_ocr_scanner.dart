import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/Database/cach_helper.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart' show showError;
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicine_scanner_cubit.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicine_scanner_state';

class MedicineOCRScanner extends StatefulWidget {
  const MedicineOCRScanner({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MedicineOCRScanner> createState() => _MedicineOCRScannerState();
}

class _MedicineOCRScannerState extends State<MedicineOCRScanner> with WidgetsBindingObserver {
  String medicineNameOnly = "";
  final StreamController<String> controller = StreamController<String>();
  bool torchOn = false;
  bool loading = false;
  
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  bool _isCameraInitialized = false;
  bool _isCameraPermissionGranted = false;
  TextRecognizer? _textRecognizer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _textRecognizer = TextRecognizer();
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.close();
    _cameraController?.dispose();
    _textRecognizer?.close();
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _isCameraPermissionGranted = status == PermissionStatus.granted;
    });
  }

  Future<void> _initializeCamera() async {
    await _requestCameraPermission();
    if (!_isCameraPermissionGranted) {
      return;
    }

    cameras = await availableCameras();
    if (cameras == null || cameras!.isEmpty) {
      return;
    }

    _cameraController = CameraController(
      cameras![0],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    
    if (torchOn) {
      await _cameraController!.setFlashMode(FlashMode.torch);
    } else {
      await _cameraController!.setFlashMode(FlashMode.off);
    }
    
    if (!mounted) {
      return;
    }

    setState(() {
      _isCameraInitialized = _cameraController!.value.isInitialized;
    });
  }
  
  Future<void> _toggleTorch() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        if (torchOn) {
          await _cameraController!.setFlashMode(FlashMode.off);
        } else {
          await _cameraController!.setFlashMode(FlashMode.torch);
        }
        
        setState(() {
          torchOn = !torchOn;
        });
      } catch (e) {
        print('Error toggling torch: $e');
      }
    }
  }

  Future<void> _scanImage() async {
    if (loading || _cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final pictureFile = await _cameraController!.takePicture();
      final inputImage = InputImage.fromFilePath(pictureFile.path);
      final recognizedText = await _textRecognizer!.processImage(inputImage);
      final extractedMedicineName = _extractMedicineName(recognizedText.text);
      
      setState(() {
        medicineNameOnly = extractedMedicineName;
        controller.add(medicineNameOnly);
      });
      
      inspect(recognizedText);
    } catch (e) {
      print('Error scanning image: $e');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
  
  String _extractMedicineName(String fullText) {
    if (fullText.isEmpty) return "";
    
    final allLines = fullText.split('\n');
    List<String> allWords = [];
    Map<String, int> wordScores = {};
    
    for (var line in allLines) {
      final words = line.split(' ')
          .where((word) => word.trim().length >= 3 && RegExp(r'[A-Za-z]').hasMatch(word))
          .map((word) => word.trim())
          .toList();
      allWords.addAll(words);
    }
    
    if (allWords.isEmpty) return "";
    
    for (var word in allWords) {
      int score = 0;
      
      if (word == word.toUpperCase() && word.length >= 4) {
        score += 10+word.length;
      } else if (word[0] == word[0].toUpperCase() && word.substring(1) == word.substring(1).toLowerCase() && word.length >= 5) {
        score += 7;
      }
      
      score += (word.length >= 8) ? 5 : (word.length >= 6) ? 3 : 0;
      
      if (RegExp(r'[^aeiouAEIOU]{3,}').hasMatch(word)) {
        score += 2;
      }
      
      final pharmaSuffixes = [
        'cin', 'xin', 'zole', 'pine', 'pril', 'sone', 'zine', 'zide', 'pam',
        'lol', 'tin', 'tide', 'dryl', 'mide', 'zepam', 'caine', 'micin'
      ];
      
      for (var suffix in pharmaSuffixes) {
        if (word.toLowerCase().endsWith(suffix)) {
          score += 5;
          break;
        }
      }
      
      final commonWords = [
        'tablet', 'capsule', 'dose', 'daily', 'take', 'with', 'water', 
        'food', 'before', 'after', 'adult', 'child', 'store', 'keep', 
        'contains', 'ingredients', 'warning', 'caution', 'date'
      ];
      
      if (commonWords.contains(word.toLowerCase())) {
        score -= 5;
      }
      
      final int lineIndex = allLines.indexWhere((line) => line.contains(word));
      if (lineIndex == 0) {
        score += 3;
      } else if (lineIndex == 1) {
        score += 1;
      }
      
      wordScores[word] = score;
    }
    
    String bestCandidate = "";
    int highestScore = -1;
    
    wordScores.forEach((word, score) {
      if (score > highestScore) {
        highestScore = score;
        bestCandidate = word;
      }
    });
    
    if (bestCandidate.isNotEmpty && wordScores[bestCandidate]! > 0) {
      return bestCandidate;
    }
    
    final upperCaseWords = allWords.where((w) => w == w.toUpperCase() && RegExp(r'[A-Z]').hasMatch(w)).toList();
    if (upperCaseWords.isNotEmpty) {
      return upperCaseWords.reduce((a, b) => a.length > b.length ? a : b);
    }
    
    if (allWords.isNotEmpty) {
      return allWords.reduce((a, b) => a.length > b.length ? a : b);
    }
    
    return allLines.first.trim();
  }

  void setText(value) {
    controller.add(value);
    setState(() {
      medicineNameOnly = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 60,
        title: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Text(widget.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(torchOn ? Icons.flash_on : Icons.flash_off,
                color: torchOn ? Colors.yellow : Colors.white),
            onPressed: _toggleTorch,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Camera Preview (1/6 of screen height)
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Stack(
                children: [
                  if (_isCameraInitialized && !loading)
                    SizedBox.expand(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _cameraController!.value.previewSize!.width,
                          height: _cameraController!.value.previewSize!.height,
                          child: CameraPreview(_cameraController!),
                        ),
                      ),
                    )
                  else
                    Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(153, 102, 160, 241),
                        width: 4.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Scan Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: FloatingActionButton(
                onPressed: _scanImage,
                backgroundColor: Colors.white.withOpacity(0.7),
                child: Icon(Icons.camera_alt, color: Colors.black87),
              ),
            ),
            
            // Instruction Text
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
         
            ),
                   child: Text(
                'برجاء توجيه الكاميرا على الاسم الإنجليزي للدواء المطبوع على العبوة ثم التقط صورة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),),
            
            // Medicine Name Preview
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.medication, color: Colors.white),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      medicineNameOnly.isNotEmpty ? medicineNameOnly : 'لم يتم التعرف على اسم الدواء بعد',
                      style: TextStyle(
                        color: medicineNameOnly.isNotEmpty ? Colors.white : Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Confirm Button
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColorsManager.mainDarkBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColorsManager.mainDarkBlue,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  setState(() => loading = true);
                  await context
                      .read<MedicineScannerCubit>()
                      .getMatchedMedicines(
                        query: medicineNameOnly,
                      );
                  setState(() => loading = false);
                },
                child: Text(
                  "تأكيد اسم الدواء",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            // Results List
            BlocConsumer<MedicineScannerCubit, MedicineScannerState>(
              listener: (context, state) async {
                if (state.matchedMedicines.isEmpty &&
                    state.message.isNotEmpty) {
                  await showError(state.message);
                }
              },
              builder: (context, state) {
                if (state.matchedMedicines.isNotEmpty) {
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'الأدوية المتطابقة',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  '${state.matchedMedicines.length} نتيجة',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(height: 1, thickness: 1),
                          Expanded(
                            child: ListView.separated(
                              padding: EdgeInsets.all(16),
                              itemCount: state.matchedMedicines.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final medicine = state.matchedMedicines[index];
                                return Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () async {
                                      await CacheHelper.setData(
                                        "medicineName",
                                        medicine.medicineName,
                                      );
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.grey[200]!,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(0.1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.medication,
                                              color:
                                                  Theme.of(context).primaryColor,
                                              size: 20,
                                            ),
                                          ),
                                          SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  medicine.medicineName,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.chevron_right,
                                            color: Colors.grey[400],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}