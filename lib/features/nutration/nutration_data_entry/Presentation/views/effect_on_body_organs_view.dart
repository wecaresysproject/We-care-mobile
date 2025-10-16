import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/nutration/nutration_view/logic/nutration_view_cubit.dart';

class EffectOnBodyOrgansView extends StatelessWidget {
  const EffectOnBodyOrgansView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<OrganItem> organsList = [
      OrganItem(name: "الكبد", imagePath: "assets/images/liver_icon.png"),
      OrganItem(name: "الكلى", imagePath: "assets/images/kidney_icon.png"),
      OrganItem(
          name: "القلب و الاوعية الدموية",
          imagePath: "assets/images/heart_organ_icon.png"),
      OrganItem(
          name: "العظام و المفاصل", imagePath: "assets/images/bones_icon.png"),
      OrganItem(name: "الغدد", imagePath: "assets/images/glands_icon.png"),
      OrganItem(
          name: "البنكرياس", imagePath: "assets/images/pancreas_icon.png"),
      OrganItem(name: "العضلات", imagePath: "assets/images/muscles_icon.png"),
      OrganItem(name: "العيون", imagePath: "assets/images/eye_module_pic.png"),
      OrganItem(
          name: "الاسنان", imagePath: "assets/images/teeth_image_icon.png"),
      OrganItem(
          name: "الأعضاء التناسلية",
          imagePath: "assets/images/reproductive_icon.png"),
      OrganItem(
          name: "الجهاز الهضمي", imagePath: "assets/images/digestive_icon.png"),
      OrganItem(
          name: "الدماغ والجهاز العصبي",
          imagePath: "assets/images/brain_icon.png"),
      OrganItem(
          name: "الجهاز المناعي و الهرموني",
          imagePath: "assets/images/immune_icon.png"),
      OrganItem(name: "الدم", imagePath: "assets/images/blood_icon.png"),
      OrganItem(name: "الجنين", imagePath: "assets/images/fetus_icon.png"),
      OrganItem(
          name: "الجلد/الشعر/الاظافر",
          imagePath: "assets/images/skin_icon.png"),
    ];

    return BlocProvider.value(
      value: getIt<NutrationViewCubit>()..getAffectedOrgans(),
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: BlocBuilder<NutrationViewCubit, NutrationViewState>(
          builder: (context, state) {
            if (state.requestStatus == RequestStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(
                    color: AppColorsManager.mainDarkBlue),
              );
            }
            final affectedOrgans = state.affectedOrgansList;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: AppBarWithCenteredTitle(
                    title: "تأثير النمط الغذائى المتناول على أعضائك",
                    showActionButtons: false,
                    fontSize: 14,
                    titleColor: AppColorsManager.textColor,
                  ).paddingSymmetricHorizontal(16),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final organ = organsList[index];
                        final isActive = affectedOrgans.contains(organ.name);
                        return GestureDetector(
                          onTap: isActive
                              ? () async {
                                  AppLogger.info("Clicked: ${organ.name}");
                                  await context.pushNamed(
                                    Routes.selectedOrganAffectedDetailsView,
                                    arguments: organ.name,
                                  );
                                }
                              : null,
                          child: Opacity(
                            opacity: isActive ? 1.0 : 0.4,
                            child: _buildItem(
                                context, organ.imagePath, organ.name),
                          ),
                        );
                      },
                      childCount: organsList.length,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisExtent: 130.h,
                      childAspectRatio: .85,
                      crossAxisSpacing: 10.w,
                    ),
                  ),
                ),
              ],
            );
          },
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
  OrganItem({
    required this.name,
    required this.imagePath,
  });
}
