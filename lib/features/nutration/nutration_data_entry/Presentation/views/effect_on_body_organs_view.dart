import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';

class EffectOnBodyOrgansView extends StatelessWidget {
  const EffectOnBodyOrgansView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<OrganItem> organsList = [
      OrganItem(
          name: "الكبد",
          imagePath: "assets/images/liver_icon.png",
          isActive: false),
      OrganItem(
          name: "الكلى",
          imagePath: "assets/images/kidney_icon.png",
          isActive: true),
      OrganItem(
        name: "القلب والأوعية",
        imagePath: "assets/images/heart_organ_icon.png",
        isActive: true,
      ),
      OrganItem(
          name: "العظام والمفاصل",
          imagePath: "assets/images/bones_icon.png",
          isActive: true),
      OrganItem(
          name: "الغدد",
          imagePath: "assets/images/glands_icon.png",
          isActive: true),
      OrganItem(
          name: "البنكرياس",
          imagePath: "assets/images/pancreas_icon.png",
          isActive: true),
      OrganItem(
          name: "العضلات",
          imagePath: "assets/images/muscles_icon.png",
          isActive: true),
      OrganItem(
          name: "العيون",
          imagePath: "assets/images/eye_module_pic.png",
          isActive: true),
      OrganItem(
          name: "الأسنان",
          imagePath: "assets/images/teeth_image_icon.png",
          isActive: false), // example inactive
      OrganItem(
          name: "الأعضاء التناسلية",
          imagePath: "assets/images/reproductive_icon.png",
          isActive: true),
      OrganItem(
        name: "الجهاز الهضمى",
        imagePath: "assets/images/digestive_icon.png",
        isActive: true,
      ),
      OrganItem(
          name: "الدماغ والجهاز العصبى",
          imagePath: "assets/images/brain_icon.png",
          isActive: true),
      OrganItem(
          name: "الجهاز المناعى",
          imagePath: "assets/images/immune_icon.png",
          isActive: true),
      OrganItem(
          name: "الدم",
          imagePath: "assets/images/blood_icon.png",
          isActive: true),
      OrganItem(
          name: "الجنين",
          imagePath: "assets/images/fetus_icon.png",
          isActive: true),
      OrganItem(
          name: "الجلد / الشعر / الأظافر",
          imagePath: "assets/images/skin_icon.png",
          isActive: false),
    ];

    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            AppBarWithCenteredTitle(
              title: "تأثير النمط الغذائى المتناول على أعضائك",
              showActionButtons: false,
              fontSize: 14,
              titleColor: AppColorsManager.textColor,
            ).paddingSymmetricHorizontal(16),
            GridView.builder(
              itemCount: organsList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: 130.h,
                childAspectRatio: .85,
                crossAxisSpacing: 10.w,
              ),
              itemBuilder: (context, index) {
                final organ = organsList[index];
                return GestureDetector(
                  onTap: organ.isActive
                      ? () async {
                          AppLogger.info("Clicked: ${organ.name}");
                          await context.pushNamed(
                            Routes.selectedOrganAffectedDetailsView,
                            arguments: organ.name,
                          );
                        }
                      : null,
                  child: Opacity(
                    opacity: organ.isActive ? 1.0 : 0.4, // dim inactive
                    child: _buildItem(context, organ.imagePath, organ.name),
                  ),
                );
              },
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, String image, String title) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.r),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFCDE1F8),
                Color(0xFFE7E9EB),
              ],
            ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 18.h,
            horizontal: 24.w,
          ),
          child: Center(
            child: Image.asset(
              image,
              fit: BoxFit.contain,
              height: 51.h,
              width: 52.w,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font14whiteWeight600.copyWith(
              color: AppColorsManager.textColor,
            ),
          ),
        )
      ],
    );
  }
}

class OrganItem {
  final String name;
  final String imagePath;
  final bool isActive;

  OrganItem({
    required this.name,
    required this.imagePath,
    this.isActive = true,
  });
}
