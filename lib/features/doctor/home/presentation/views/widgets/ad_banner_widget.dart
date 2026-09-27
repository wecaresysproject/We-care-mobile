import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({super.key, required this.imageUrls});

  final List<String> imageUrls;

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          height: 173.h,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColorsManager.adBannerOverlay,
            borderRadius: BorderRadius.circular(8.r),
            border:
                Border.all(color: AppColorsManager.mainDarkBlue, width: 1.5),
          ),
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (page) => setState(() => _currentPage = page),
            itemBuilder: (context, index) {
              return Image.asset(widget.imageUrls[index], fit: BoxFit.cover);
            },
          ),
        ),
        SizedBox(height: 4.h),
        SizedBox(
          height: 8.h,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < widget.imageUrls.length; i++) ...[
                if (i != 0) SizedBox(width: 8.w),
                _Dot(
                  width: i == _currentPage ? 14.w : 8.w,
                  color: i == _currentPage
                      ? AppColorsManager.mainDarkBlue
                      : AppColorsManager.unselectedNavIconColor,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.width, required this.color});

  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      height: 8.h,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(5.r)),
    );
  }
}
