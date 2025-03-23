import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_action_button_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class DetailsViewImageWithTitleTile extends StatelessWidget {
  final String? image;
  final String title;
  final bool isShareEnabled;
  const DetailsViewImageWithTitleTile(
      {super.key,
      required this.image,
      required this.title,
      this.isShareEnabled = false});

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
              Spacer(),
              isShareEnabled
                  ? CustomActionButton(
                      onTap: () {
                        shareImage(image ?? '', title);
                      },
                      title: 'ارسال',
                      icon: 'assets/images/share.png',
                    )
                  : SizedBox.shrink(),
            ],
          ),
          verticalSpacing(8),
          image != ""
              ? Image.network(
                  image!,
                  height: 278.h,
                  width: double.infinity,
                  fit: BoxFit.contain,
                )
              : CustomContainer(
                  value: 'لم يتم رفع صورة',
                  isExpanded: true,
                ),
        ],
      ),
    );
  }
}

Future<void> shareImage(String imageUrl, String title) async {
  final tempDir = await getTemporaryDirectory();
  final filePath = "${tempDir.path}/$title.jpg";

  downloadImage(imageUrl, tempDir, filePath);
  await Share.shareXFiles(
    [XFile(filePath)],
    text: title,
  );
}
