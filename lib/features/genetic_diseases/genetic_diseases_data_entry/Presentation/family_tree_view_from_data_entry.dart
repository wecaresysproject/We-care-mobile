import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class FamilyTreeViewFromDataEntry extends StatelessWidget {
  const FamilyTreeViewFromDataEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RelativeCategoryRow(
              names: List.filled(2, "الجد") + List.filled(2, "الجده"),
              icon: Icons.person,
              color: Color(0xff547792),
              onTap: (index) => print("Tapped on sibling #$index"),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RelativeCategoryRow(
              names: List.filled(1, "الاب") + List.filled(1, "الام"),
              icon: Icons.person,
              color: AppColorsManager.mainDarkBlue,
              onTap: (index) => print("Tapped on sibling #$index"),
            ),
          ],
        ),
        const SizedBox(height: 16),
        RelativeCategoryRow(
          names: List.filled(9, "العم"),
          icon: Icons.person_outline,
          color: Color(0xff5A4B8D),
          onTap: (index) => print("Tapped on uncle #$index"),
        ),
        const SizedBox(height: 16),

        RelativeCategoryRow(
          names: List.filled(9, "العمه"),
          icon: Icons.person_outline,
          color: Color.fromARGB(255, 63, 5, 255),
          onTap: (index) => print("Tapped on uncle #$index"),
        ),
        const SizedBox(height: 16),
        // const SizedBox(height: 16),
        // RelativeCategoryRow(
        //   names: List.filled(2, "العمة"),
        //   icon: Icons.person_outline,
        //   color: Colors.deepPurple,
        //   onTap: (index) => print("Tapped on aunt #$index"),
        // ),
      ],
    ));
  }
}

class RelativeCategoryRow extends StatelessWidget {
  final List<String> names; // e.g., ["الأخ", "الأخ", "الأخت"]
  final IconData icon; // Choose appropriate emoji/icon
  final Color color;
  final void Function(int index)? onTap;

  const RelativeCategoryRow({
    required this.names,
    required this.icon,
    required this.color,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: List.generate(names.length, (index) {
        return GestureDetector(
          onTap: () => onTap?.call(index),
          child: Container(
            width: 79.w,
            height: 44.2.h,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(names[index],
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(width: 6),
                Icon(icon, color: Colors.white, size: 16),
              ],
            ),
          ),
        );
      }),
    );
  }
}
