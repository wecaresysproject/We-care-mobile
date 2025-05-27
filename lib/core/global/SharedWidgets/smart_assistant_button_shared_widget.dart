import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';

class SmartAssistantButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const SmartAssistantButton({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 181.w,
      height: 65.h,
      padding: const EdgeInsets.fromLTRB(0, 0, 14, 9),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF014C8A),
            Color(0xFF014C8A),
          ],
        ),
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x80000000),
            offset: Offset(4, 38),
            blurRadius: 62,
          ),
          BoxShadow(
            color: Color(0x26FFFFFF),
            offset: Offset(-3, -4),
            blurRadius: 7,
          ),
        ],
      ),
      child: Stack(
        children: [
          // White radial gradient overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(30.r),
              ),
              gradient: RadialGradient(
                center: Alignment(-0.18, -0.58),
                radius: 2,
                colors: [
                  Color.fromARGB(108, 255, 255, 255), // 59% opacity
                  Colors.transparent,
                ],
                stops: [0, 200],
              ),
            ),
          ),
          // Existing content row
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.asset(
                  imagePath,
                  width: 48.w,
                  height: 48.h,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.font14whiteWeight600.copyWith(
                        fontSize: 16.sp,
                      ),
                    ),
                    verticalSpacing(4),
                    Text(
                      subtitle,
                      style: AppTextStyles.font14whiteWeight600.copyWith(
                        fontSize: 14.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
