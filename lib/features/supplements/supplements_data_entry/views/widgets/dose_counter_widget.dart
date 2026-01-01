import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class DoseCounter extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onChanged;

  const DoseCounter({
    super.key,
    this.initialValue = 0,
    required this.onChanged,
  });

  @override
  State<DoseCounter> createState() => _DoseCounterState();
}

class _DoseCounterState extends State<DoseCounter> {
  late int count;

  @override
  void initState() {
    super.initState();
    count = widget.initialValue;
  }

  void _increase() {
    setState(() {
      count++;
    });
    widget.onChanged(count);
  }

  void _decrease() {
    if (count == 0) return;
    setState(() {
      count--;
    });
    widget.onChanged(count);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 120,
      decoration: BoxDecoration(
        color: AppColorsManager.mainDarkBlue,
        borderRadius: BorderRadius.circular(17.r),
      ),
      child: Row(
        children: [
          // --- Increase Button ---
          Expanded(
            child: GestureDetector(
              onTap: _increase,
              child: Center(
                child: Text(
                  "+",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // --- Counter Center Box ---
          Container(
            width: 30,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.symmetric(
                horizontal: BorderSide(color: Colors.black12, width: 0.7),
                vertical: BorderSide(color: Colors.black26, width: 0.7),
              ),
            ),
            child: Center(
              child: Text(
                "$count",
                style: AppTextStyles.font20blackWeight600,
              ),
            ),
          ),
          // --- Decrease Button ---
          Expanded(
            child: GestureDetector(
              onTap: _decrease,
              child: Center(
                child: Text(
                  "-",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
