import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'functions.dart';
import '../theming/app_text_styles.dart';
import '../theming/color_manager.dart';

class CustomUnderlinedRichTextWidget extends StatelessWidget {
  final String normalText;
  final String highlightedText;
  final VoidCallback onTap;
  final TextStyle? textStyle;

  const CustomUnderlinedRichTextWidget({
    super.key,
    required this.normalText,
    required this.highlightedText,
    required this.onTap,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Normal (Uncolored) Text
        Text(
          normalText,
          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
            color: Color(0xff000000),
          ),
        ),

        horizontalSpacing(8), // Space between normal and highlighted text

        // Highlighted Text with Border and Underline
        Stack(
          children: [
            // Clickable Colored Text
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.only(bottom: 2.h),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColorsManager.mainDarkBlue,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  highlightedText,
                  style: textStyle ??
                      AppTextStyles.font18blackWight500.copyWith(
                        color: AppColorsManager.mainDarkBlue,
                      ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CustomUnderlinedRichTextWithCounterWidget extends StatefulWidget {
  final String normalText;
  final String highlightedText;
  final VoidCallback onTap;
  final TextStyle? textStyle;

  const CustomUnderlinedRichTextWithCounterWidget({
    super.key,
    required this.normalText,
    required this.highlightedText,
    required this.onTap,
    this.textStyle,
  });

  @override
  _CustomUnderlinedRichTextWithCounterWidgetState createState() =>
      _CustomUnderlinedRichTextWithCounterWidgetState();
}

class _CustomUnderlinedRichTextWithCounterWidgetState
    extends State<CustomUnderlinedRichTextWithCounterWidget> {
  late Timer _timer;
  int _counter = 30;
  bool _isButtonEnabled = false;
  int _attempts = 0;
  final List<int> _delays = [30, 150, 600, 3600];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _counter = _delays[_attempts % _delays.length];
    _isButtonEnabled = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() {
          _counter--;
        });
      } else {
        setState(() {
          _isButtonEnabled = true;
        });
        _timer.cancel();
      }
    });
  }

  String _formattedCounter() {
    if (_counter >= 3600) {
      return 'اعادة الارسال (${_counter ~/ 3600} ساعة)';
    } else if (_counter >= 60) {
      return 'اعادة الارسال (${_counter ~/ 60} دقيقة)';
    } else {
      return 'اعادة الارسال ($_counter ث)';
    }
  }

  void _handleTap() {
    if (_isButtonEnabled) {
      widget.onTap();
      setState(() {
        _attempts++;
      });
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.normalText,
          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
            color: const Color(0xff000000),
          ),
        ),
        horizontalSpacing(8),
        Stack(
          children: [
            GestureDetector(
              onTap: _isButtonEnabled ? _handleTap : null,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 2.h),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: _isButtonEnabled
                              ? AppColorsManager.mainDarkBlue
                              : Colors.grey,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      _isButtonEnabled
                          ? widget.highlightedText
                          : _formattedCounter(),
                      style: widget.textStyle ??
                          AppTextStyles.font18blackWight500.copyWith(
                            color: _isButtonEnabled
                                ? AppColorsManager.mainDarkBlue
                                : Colors.grey,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
