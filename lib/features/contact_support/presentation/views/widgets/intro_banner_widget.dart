import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IntroBannerWidget extends StatelessWidget {
  const IntroBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(children: [
        Image.asset(
          'assets/images/chat_banner_bg.png',
          fit: BoxFit.fitHeight,
          width: MediaQuery.of(context).size.width,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
                  'اكتب ما تريد من مقترح أو مشكلة \n واجهتك أثناء استخدام التطبيق وسيتم الرد عليك.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    height: 1.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
          ),
        ),
      ]),
    );
  }
}

class BannerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF2B2B2B), Color(0xFF03508F), Color(0xFF5998CD)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();

    // Create banner shape with chevron edges
    final chevronSize = 15.0.w;

    // Start from top-left with chevron
    path.moveTo(0, chevronSize);
    path.lineTo(chevronSize, 0);
    path.lineTo(size.width - chevronSize, 0);
    path.lineTo(size.width, chevronSize);

    // Right side
    path.lineTo(size.width, size.height - chevronSize);
    path.lineTo(size.width - chevronSize, size.height);

    // Bottom
    path.lineTo(chevronSize, size.height);
    path.lineTo(0, size.height - chevronSize);

    // Close path
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
