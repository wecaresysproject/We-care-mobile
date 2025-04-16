import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_action_button_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class DetailsViewImageWithTitleTile extends StatelessWidget {
  final String? image;
  final String title;
  final bool isShareEnabled;

  const DetailsViewImageWithTitleTile({
    super.key,
    required this.image,
    required this.title,
    this.isShareEnabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
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
              if (isShareEnabled)
                CustomActionButton(
                  onTap: () {
                    shareImage(context,image ?? '', title);
                  },
                  title: 'ارسال',
                  icon: 'assets/images/share.png',
                ),
            ],
          ),
          verticalSpacing(8),
          (image != null && image!.isNotEmpty && image != "لم يتم ادخال بيانات")
              ? GestureDetector(
                  onDoubleTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => FullScreenImageViewer(imageUrl: image!),
                      ),
                    );
                  },
                  child: Image.network(
                    image!,
                    width: double.infinity,
                    height: 278.h,
                    fit: BoxFit.contain,
                  ),
                )
              : const CustomContainer(
                  value: 'لم يتم رفع صورة',
                  isExpanded: true,
                ),
        ],
      ),
    );
  }
}


Future<void> shareImage(
    BuildContext context, String image,String title) async {
  try {
    // 📥 Download images
    final tempDir = await getTemporaryDirectory();
    List<String> imagePaths = [];

    if (image.startsWith("http")) {
      final imagePath = await downloadImage(
          image,
          tempDir,
          'image.png');
      if (imagePath != null) imagePaths.add(imagePath);
    }
    if (imagePaths.isNotEmpty) {
      await Share.shareXFiles([XFile(imagePaths.first)], text: title);
    } else {
      await Share.share(title);
    }
  } catch (e) {
    await showError("❌ حدث خطأ أثناء المشاركة");
  }
}


class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageViewer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
    leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.pop(context), // اضغط مرة للخروج
        ),
      ),
      body: GestureDetector(
        onDoubleTap: () => Navigator.pop(context), // اضغط مرة للخروج
        child: Center(
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 1,
            maxScale: 5,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
