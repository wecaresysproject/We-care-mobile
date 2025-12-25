import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class BannerCrausalWidget extends StatefulWidget {
  const BannerCrausalWidget({super.key});

  @override
  State<BannerCrausalWidget> createState() => _BannerCrausalWidgetState();
}

class _BannerCrausalWidgetState extends State<BannerCrausalWidget> {
  final List<String> _bannerImages = const [
    "assets/images/panner.png",
    "assets/images/panner.png",
    "assets/images/panner.png",
  ];

  @override
  Widget build(BuildContext context) {
    if (_bannerImages.isEmpty) return const SizedBox.shrink();

    return CarouselSlider(
      options: CarouselOptions(
        height: 100,
        autoPlay: true,
        viewportFraction: 1,
        enlargeCenterPage: false,
      ),
      items: _bannerImages.map((imagePath) {
        return Image.asset(
          height: 100,
          imagePath,
          fit: BoxFit.contain,
        );
      }).toList(),
    );
  }
}
