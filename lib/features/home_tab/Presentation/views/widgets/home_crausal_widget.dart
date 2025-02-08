import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class HomeCarouselWidget extends StatefulWidget {
  const HomeCarouselWidget({super.key});

  @override
  HomeCarouselWidgetState createState() => HomeCarouselWidgetState();
}

class HomeCarouselWidgetState extends State<HomeCarouselWidget> {
  int _currentIndex = 0;
  final _carouselController = CarouselSliderController();

  final List<String> messages = [
    """
عزيزى محمد
لديك العديد من عوامل المخاطرة التى يمكن التغلب عليها ويمكننا المساعدة/ لا تستلم وانتبه الى صحتك.
""",
    """
عزيزى محمد
لديك العديد من عوامل المخاطرة التى يمكن التغلب عليها ويمكننا المساعدة/ لا تستلم وانتبه الى صحتك.
""",
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              CarouselSlider(
                items: messages.map(
                  (message) {
                    return Container(
                      width: 271.0, // Fixed width as specified
                      height: 40.h,
                      padding: EdgeInsets.only(
                        top: 3.0,
                        right: 6.0,
                        bottom: 3.0,
                        left: 6.0,
                      ),
                      margin: EdgeInsets.only(
                        bottom: 8.0,
                        left: 7,
                        right: 2,
                      ),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(16.0), // Radius as specified
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFECF5FF),
                            Color(0xFFFBFDFF)
                          ], // Linear gradient colors
                        ),
                        color: Colors
                            .white, // Background color for the container, adjust as necessary
                        border: Border.all(
                          color:
                              Colors.black, // Border color, adjust as necessary
                          width:
                              0.2, // Border width as specified, though very thin and might not be visible
                        ),
                      ),

                      child: Text(
                        message,
                        style: AppTextStyles.font12blackWeight400,
                      ),
                    );
                  },
                ).toList(),
                carouselController: _carouselController,
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  height: 60.h,
                  aspectRatio: 2.0,
                  // padEnds: false,

                  onPageChanged: (index, reason) {
                    setState(
                      () {
                        _currentIndex = index;
                      },
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: messages.asMap().entries.map(
                  (entry) {
                    return GestureDetector(
                      onTap: () => _carouselController.animateToPage(entry.key),
                      child: Container(
                        width: _currentIndex == entry.key
                            ? 14.0.w
                            : 8.0.w, // Change width if it's the current index

                        height: 6.h,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          color: _currentIndex == entry.key
                              ? AppColorsManager.mainDarkBlue
                              : Color(0xff909090),
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ],
          ),
        ),
        Image.asset(
          'assets/images/percent_indicator.png',
          height: 61,
          width: 56,
        ),
      ],
    );
  }
}
