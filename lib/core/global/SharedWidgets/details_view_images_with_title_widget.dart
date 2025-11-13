import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_action_button_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class DetailsViewImagesWithTitleTile extends StatelessWidget {
  final List<String>? images;
  final String title;
  final bool isShareEnabled;

  const DetailsViewImagesWithTitleTile({
    super.key,
    required this.images,
    required this.title,
    this.isShareEnabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final validImages = images
            ?.where((e) => e.isNotEmpty && e != "لم يتم ادخال بيانات")
            .toList() ??
        [];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Align(
        alignment: Alignment.topRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                    color: AppColorsManager.mainDarkBlue,
                    fontSize: 18.sp,
                  ),
                ),
                const Spacer(),
                if (isShareEnabled && validImages.isNotEmpty)
                  CustomActionButton(
                    onTap: () {
                      shareImages(context, validImages, title);
                    },
                    title: 'ارسال',
                    icon: 'assets/images/share.png',
                  ),
              ],
            ),
            verticalSpacing(8),
            validImages.isNotEmpty
                ? SizedBox(
                    height: 180.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: validImages.length,
                      separatorBuilder: (_, __) => SizedBox(width: 8.w),
                      itemBuilder: (context, index) {
                        final img = validImages[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => FullScreenImageViewer(
                                  images: validImages,
                                  initialIndex: index,
                                ),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              img,
                              width: 180.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : const CustomContainer(
                    value: 'لم يتم رفع صور',
                    isExpanded: true,
                  ),
          ],
        ),
      ),
    );
  }
}

Future<void> shareImages(
    BuildContext context, List<String> images, String title) async {
  try {
    final tempDir = await getTemporaryDirectory();
    List<String> imagePaths = [];

    for (var image in images) {
      if (image.startsWith("http")) {
        final imagePath = await downloadImage(
            image, tempDir, '${DateTime.now().millisecondsSinceEpoch}.png');
        if (imagePath != null) imagePaths.add(imagePath);
      }
    }

    if (imagePaths.isNotEmpty) {
      await Share.shareXFiles(imagePaths.map((path) => XFile(path)).toList(),
          text: title);
    } else {
      await Share.share(title);
    }
  } catch (e) {
    await showError("❌ حدث خطأ أثناء مشاركة الصور");
  }
}

class FullScreenImageViewer extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const FullScreenImageViewer(
      {super.key, required this.images, this.initialIndex = 0});

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late PageController _pageController;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: BackButton(color: Colors.white),
        title: Text(
          '${currentIndex + 1} / ${widget.images.length}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.images.length,
        onPageChanged: (i) => setState(() => currentIndex = i),
        itemBuilder: (context, index) {
          return Center(
            child: PhotoView(
              backgroundDecoration: const BoxDecoration(color: Colors.black),
              imageProvider: NetworkImage(widget.images[index]),
            ),
          );
        },
      ),
    );
  }
}
