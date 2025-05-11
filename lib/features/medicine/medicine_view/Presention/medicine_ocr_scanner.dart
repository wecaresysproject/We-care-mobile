import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      final words = line
          .split(' ')
          .where((word) =>
              word.trim().length >= 3 && RegExp(r'[A-Za-z]').hasMatch(word))
          .map((word) => word.trim())
          .toList();
      allWords.addAll(words);
    }

    if (allWords.isEmpty) return "";

    for (var word in allWords) {
      int score = 0;

      if (word == word.toUpperCase() && word.length >= 4) {
        score += 10 + word.length;
      } else if (word[0] == word[0].toUpperCase() &&
          word.substring(1) == word.substring(1).toLowerCase() &&
          word.length >= 5) {
        score += 7;
      }

      score += (word.length >= 8)
          ? 5
          : (word.length >= 6)
              ? 3
              : 0;

      if (RegExp(r'[^aeiouAEIOU]{3,}').hasMatch(word)) {
        score += 2;
      }

      final pharmaSuffixes = [
        'cin',
        'xin',
        'zole',
        'pine',
        'pril',
        'sone',
        'zine',
        'zide',
        'pam',
        'lol',
        'tin',
        'tide',
        'dryl',
        'mide',
        'zepam',
        'caine',
        'micin'
      ];

      for (var suffix in pharmaSuffixes) {
        if (word.toLowerCase().endsWith(suffix)) {
          score += 5;
          break;
        }
      }

      final commonWords = [
        'tablet',
        'capsule',
        'dose',
        'daily',
        'take',
        'with',
        'water',
        'food',
        'before',
        'after',
        'adult',
        'child',
        'store',
        'keep',
        'contains',
        'ingredients',
        'warning',
        'caution',
        'date'
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

    final upperCaseWords = allWords
        .where((w) => w == w.toUpperCase() && RegExp(r'[A-Z]').hasMatch(w))
        .toList();
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
              height: MediaQuery.of(context).size.height / 7,
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

// Camera Scan Button with enhanced animations
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                            scale: _isFirstLoad ? _pulseAnimation.value : 1.0,
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
                                    color: Color(0xFF1A73E8).withOpacity(0.6),
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
                                  (_pulseAnimationController.value - delay) %
                                      1.0;

                              // Only show when progress is positive
                              if (progress < 0) return SizedBox();

                              return Positioned.fill(
                                child: Center(
                                  child: Container(
                                    width: 70 +
                                        progress * 40, // Larger pulse effect
                                    height: 70 + progress * 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Color(0xFF1A73E8)
                                            .withOpacity(0.7 * (1 - progress)),
                                        width: 3.0 *
                                            (1 - progress), // Thicker border
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
                              angle:
                                  _pulseAnimationController.value * 2 * 3.14159,
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
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                        colors: [Colors.grey.shade700, Colors.grey.shade600],
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

            // Part of the BlocConsumer for displaying matched medicines
            MatchedMedicineResultsList()
          ],
        ),
      ),
    );
  }
}
