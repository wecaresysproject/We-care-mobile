import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/features/medicine/medicines_data_entry/Presentation/views/widgets/matched_medicines_results_list.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicine_scanner_cubit.dart';

class MedicineOCRScanner extends StatefulWidget {
  const MedicineOCRScanner({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MedicineOCRScanner> createState() => _MedicineOCRScannerState();
}

class _MedicineOCRScannerState extends State<MedicineOCRScanner>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  String medicineNameOnly = "";
  final StreamController<String> controller = StreamController<String>();
  final GlobalKey _previewKey = GlobalKey(); // لقياس مساحة عرض الكاميرا
  final GlobalKey _scanBoxKey = GlobalKey(); // لقياس المربع الأزرق

  bool torchOn = false;
  bool loading = false;

  // Animation controllers and variables - only keeping button animation
  late AnimationController _pulseAnimationController;
  late Animation<double> _pulseAnimation;
  bool _isFirstLoad = true;

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
    _setupAnimations();
  }

  void _setupAnimations() {
    // Modern button pulse animation with enhanced visual appeal
    _pulseAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Create a more dramatic pulse effect with better easing curves
    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.25)
            .chain(CurveTween(curve: Curves.easeOutQuint)),
        weight: 35.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.25, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 65.0,
      ),
    ]).animate(_pulseAnimationController);

    _pulseAnimationController.repeat();

    // Keep the animation running longer for better visibility
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        // Fade out animations gradually
        Future.delayed(const Duration(milliseconds: 500), () {
          _pulseAnimationController.stop();
          setState(() {
            _isFirstLoad = false;
          });
        });
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.close();
    _cameraController?.dispose();
    _textRecognizer?.close();
    _pulseAnimationController.dispose();
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
      ResolutionPreset.medium,
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
        AppLogger.error('Error toggling torch: $e');
      }
    }
  }

  Future<File?> _cropToScanBox(String imagePath) async {
    try {
      if (_previewKey.currentContext == null ||
          _scanBoxKey.currentContext == null) {
        return null;
      }

      final RenderBox previewBox =
          _previewKey.currentContext!.findRenderObject() as RenderBox;

      final RenderBox scanBox =
          _scanBoxKey.currentContext!.findRenderObject() as RenderBox;

      final previewPosition = previewBox.localToGlobal(Offset.zero);
      final scanPosition = scanBox.localToGlobal(Offset.zero);

      final previewSize = previewBox.size;
      final scanSize = scanBox.size;

      final double relativeX = scanPosition.dx - previewPosition.dx;
      final double relativeY = scanPosition.dy - previewPosition.dy;

      final bytes = await File(imagePath).readAsBytes();
      final img.Image original = img.decodeImage(bytes)!;

      final double scaleX = original.width / previewSize.width;
      final double scaleY = original.height / previewSize.height;

      int cropX = (relativeX * scaleX).toInt();
      int cropY = (relativeY * scaleY).toInt();
      int cropWidth = (scanSize.width * scaleX).toInt();
      int cropHeight = (scanSize.height * scaleY).toInt();

      // حماية من الحدود
      cropX = math.max(0, cropX);
      cropY = math.max(0, cropY);

      if (cropX + cropWidth > original.width) {
        cropWidth = original.width - cropX;
      }

      if (cropY + cropHeight > original.height) {
        cropHeight = original.height - cropY;
      }

      final img.Image cropped = img.copyCrop(
        original,
        x: cropX,
        y: cropY,
        width: cropWidth,
        height: cropHeight,
      );

      final croppedFile = File("${imagePath}_crop.jpg");
      await croppedFile.writeAsBytes(img.encodeJpg(cropped));

      return croppedFile;
    } catch (e) {
      log("Crop error: $e");
      return null;
    }
  }

  Future<void> _scanImage() async {
    if (loading ||
        _cameraController == null ||
        !_cameraController!.value.isInitialized) {
      return;
    }

    // Stop animations when scan button is pressed
    if (_isFirstLoad) {
      _pulseAnimationController.stop();
      setState(() {
        _isFirstLoad = false;
      });
    }

    setState(() {
      loading = true;
    });

    try {
      final pictureFile = await _cameraController!.takePicture();
      // قص الصورة حسب المربع الأزرق
      final croppedFile = await _cropToScanBox(pictureFile.path);
      final inputImage = InputImage.fromFilePath(
        croppedFile?.path ?? pictureFile.path,
      );
      final recognizedText = await _textRecognizer!.processImage(inputImage);
      final extractedMedicineName = _extractMedicineName(recognizedText.text);

      setState(() {
        medicineNameOnly = extractedMedicineName;
        controller.add(medicineNameOnly);
      });

      inspect(recognizedText);
    } catch (e) {
      AppLogger.error('Error scanning image: $e');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  String _extractMedicineName(String fullText) {
    if (fullText.trim().isEmpty) return "";

    final lines = fullText.split('\n');

    List<String> candidates = [];

    for (var line in lines) {
      String cleaned = line
          .replaceAll(
              RegExp(r'[0-9]+ ?(mg|ml|g|mcg|%)', caseSensitive: false), '')
          .replaceAll(RegExp(r'[^A-Za-z ]'), '')
          .trim();

      if (cleaned.length < 3) continue;

      final words = cleaned.split(' ').where((w) => w.length >= 3).toList();

      if (words.isEmpty) continue;

      // كلمة واحدة
      candidates.add(words.first);

      // كلمتين (اسم مركب)
      if (words.length >= 2) {
        candidates.add("${words[0]} ${words[1]}");
      }
    }

    if (candidates.isEmpty) return "";

    Map<String, int> scores = {};

    final pharmaSuffixes = [
      'cin',
      'zole',
      'pril',
      'zepam',
      'olol',
      'mide',
      'sone',
      'zine',
      'tine',
      'dine',
      'pine',
      'cillin',
      'mycin'
    ];

    final stopWords = [
      'tablet',
      'tablets',
      'capsule',
      'capsules',
      'dose',
      'daily',
      'warning',
      'storage',
      'keep',
      'ingredients',
      'contains'
    ];

    for (var candidate in candidates) {
      int score = 0;

      final lower = candidate.toLowerCase();

      if (stopWords.contains(lower)) continue;

      // الطول
      score += candidate.length;

      // uppercase
      if (candidate == candidate.toUpperCase()) {
        score += 10;
      }

      // capitalized
      if (candidate[0].toUpperCase() == candidate[0]) {
        score += 5;
      }

      // suffix شائع للأدوية
      for (var suffix in pharmaSuffixes) {
        if (lower.endsWith(suffix)) {
          score += 8;
          break;
        }
      }

      // وجود حروف كثيرة بدون حركات (غالباً اسم علمي)
      if (RegExp(r'[^aeiou]{4,}', caseSensitive: false).hasMatch(candidate)) {
        score += 4;
      }

      scores[candidate] = score;
    }

    if (scores.isEmpty) return "";

    final sorted = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.first.key;
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
        child: Stack(
          children: [
            Column(
              children: [
                _isCameraInitialized && _cameraController != null
                    ? AspectRatio(
                        key: _previewKey,
                        aspectRatio: _cameraController!.value.aspectRatio,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CameraPreview(_cameraController!),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                key: _scanBoxKey,
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: 70,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color.fromARGB(153, 102, 160, 241),
                                    width: 4,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),

                // Camera Scan Button with enhanced animations
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.5),
                  child: Center(
                    child: SizedBox(
                      width: 70.0, // Increased size for better visibility
                      height: 70.0, // Increased size for better visibility
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Base button
                          AnimatedBuilder(
                            animation: _pulseAnimationController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale:
                                    _isFirstLoad ? _pulseAnimation.value : 1.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF1A73E8),
                                        Color(0xFF4285F4),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color(0xFF1A73E8).withOpacity(0.6),
                                        blurRadius: _isFirstLoad ? 12.0 : 8.0,
                                        spreadRadius: _isFirstLoad ? 2.0 : 0.0,
                                      ),
                                    ],
                                  ),
                                  child: FloatingActionButton(
                                    onPressed: _scanImage,
                                    elevation:
                                        0, // Removed elevation for modern flat design
                                    backgroundColor: Colors
                                        .transparent, // Transparent to show gradient
                                    child: Icon(
                                      Icons.camera_alt_rounded,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          // Enhanced pulse rings (only shown on first load)
                          if (_isFirstLoad)
                            ...List.generate(3, (index) {
                              // Increased to 3 rings
                              final delay = index * 0.3; // Faster sequence
                              return AnimatedBuilder(
                                animation: _pulseAnimationController,
                                builder: (context, child) {
                                  final progress =
                                      (_pulseAnimationController.value -
                                              delay) %
                                          1.0;

                                  // Only show when progress is positive
                                  if (progress < 0) return SizedBox();

                                  return Positioned.fill(
                                    child: Center(
                                      child: Container(
                                        width: 70 +
                                            progress *
                                                40, // Larger pulse effect
                                        height: 70 + progress * 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Color(0xFF1A73E8)
                                                .withOpacity(
                                                    0.7 * (1 - progress)),
                                            width: 3.0 *
                                                (1 -
                                                    progress), // Thicker border
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),

                          // Optional: Add a subtle rotating glow effect
                          if (_isFirstLoad)
                            AnimatedBuilder(
                              animation: _pulseAnimationController,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: _pulseAnimationController.value *
                                      2 *
                                      3.14159,
                                  child: Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: SweepGradient(
                                        colors: [
                                          Colors.transparent,
                                          Color(0xFF1A73E8).withOpacity(0.3),
                                          Colors.transparent,
                                        ],
                                        stops: [0.0, 0.5, 1.0],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Non-animated Instruction Text
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          'برجاء توجيه الكاميرا على الاسم الإنجليزي للدواء المطبوع على العبوة ثم التقط صورة',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),

                // Non-animated Medicine Name Preview
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: medicineNameOnly.isNotEmpty
                        ? Color(0xFF1A73E8).withOpacity(0.2)
                        : Colors.grey[900],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: medicineNameOnly.isNotEmpty
                          ? Color(0xFF1A73E8).withOpacity(0.5)
                          : Colors.grey[800]!,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: medicineNameOnly.isNotEmpty
                              ? Color(0xFF1A73E8).withOpacity(0.9)
                              : Colors.grey[800],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.medication_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              medicineNameOnly.isNotEmpty
                                  ? 'اسم الدواء'
                                  : 'لم يتم التعرف بعد',
                              style: TextStyle(
                                color: medicineNameOnly.isNotEmpty
                                    ? Color(0xFF1A73E8)
                                    : Colors.grey[400],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              medicineNameOnly.isNotEmpty
                                  ? medicineNameOnly
                                  : 'برجاء التقاط صورة للدواء أولاً',
                              style: TextStyle(
                                color: medicineNameOnly.isNotEmpty
                                    ? Colors.white
                                    : Colors.grey[600],
                                fontSize: 18,
                                fontWeight: medicineNameOnly.isNotEmpty
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Non-animated Confirm Button
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: medicineNameOnly.isEmpty
                        ? LinearGradient(
                            colors: [
                              Colors.grey.shade700,
                              Colors.grey.shade600
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : LinearGradient(
                            colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                  ),
                  child: ElevatedButton(
                    onPressed: medicineNameOnly.isEmpty
                        ? null
                        : () async {
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
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Results list as an overlay at the bottom
            const Align(
              alignment: Alignment.bottomCenter,
              child: MatchedMedicineResultsList(),
            ),
          ],
        ),
      ),
    );
  }
}
