import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// شعار WECARE SYS.
/// بيستخدم نسخة مقصوصة من اللوجو خلفيتها شفافة (`wecare_brand_mark.png`)
/// بدل `we_care_logo.png` اللى خلفيتها بيضا وبتبان كمربع أبيض فوق الكروت.
/// `onDarkSurface` بتحوّل الشعار لأبيض عشان يبان فوق البانر الكحلى.
class WeCareBrandMark extends StatelessWidget {
  const WeCareBrandMark({super.key, this.onDarkSurface = false, this.width});

  final bool onDarkSurface;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final logo = Image.asset(
      "assets/images/wecare_brand_mark.png",
      width: width ?? 96.w,
      fit: BoxFit.contain,
    );

    if (!onDarkSurface) return logo;

    return ColorFiltered(
      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      child: logo,
    );
  }
}
