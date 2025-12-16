import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/font_weight_helper.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/essential_info/essential_info_view/logic/%20essential_info_view_cubit.dart';
import 'package:we_care/features/essential_info/essential_info_view/logic/essential_info_view_state.dart';
import 'package:we_care/core/routing/routes.dart';

class HomeCustomAppBarWidget extends StatelessWidget {
  const HomeCustomAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        textBaseline: TextBaseline.alphabetic,
        children: [
          BlocProvider(
            create: (context) =>
                getIt<EssentialInfoViewCubit>()..getUserEssentialInfo(),
            child: BlocBuilder<EssentialInfoViewCubit, EssentialInfoViewState>(
              builder: (context, state) {
                final displayName =
                    (state.userEssentialInfo?.fullName ?? "User Name")
                        .firstAndLastName;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    /// ---------------- 3 Dots ----------------
                    SizedBox(
                      width: 20,
                      height: 24,
                      child: PopupMenuButton(
                        constraints: BoxConstraints(), // مهم جدًا

                        color: AppColorsManager.scaffoldBackGroundColor,
                        padding: EdgeInsets.zero,
                        offset: const Offset(-10, 35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        icon: Icon(
                          Icons.more_vert,
                          size: 30,
                          color: AppColorsManager.mainDarkBlue,
                        ),
                        itemBuilder: (context) => [
                          _popupItem(
                            Icons.person,
                            "الدخول على البيانات الرئيسية",
                            onClick: () async {
                              await context.pushNamed(
                                Routes.essentialInfoView,
                              );
                            },
                          ),
                          _popupItem(Icons.lock, "تغيير كلمة السر"),
                          _popupItem(Icons.admin_panel_settings, "الصلاحيات"),
                          _popupItem(Icons.subscriptions, "الاشتراكات"),
                          _popupItem(Icons.logout, "تسجيل الخروج", isRed: true),
                        ],
                        onSelected: (value) {
                          // TODO: Navigate or perform action
                        },
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// ---------------- Avatar ----------------
                        UserAvatarWidget(
                          height: 30,
                          width: 30,
                          borderRadius: 50,
                          userImageUrl:
                              state.userEssentialInfo?.personalPhotoUrl,
                        ),
                        Text(
                          displayName,
                          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                            fontSize: 10.sp,
                            fontWeight: FontWeightHelper.medium,
                            color: AppColorsManager.textColor,
                          ),
                        )
                      ],
                    ),
                  ],
                );
              },
            ),
          ),

          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, Routes.notificationsScreen);
            },
            child: NotificationIcon(
              count: 2,
            ),
          ),
          SizedBox(width: 8.w),

          /// ---------------- Search Area ----------------
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: isArabic()
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              textBaseline: TextBaseline.alphabetic,
              children: [
                SizedBox(
                  height: 35.h,
                  child: TextField(
                    textAlign: isArabic() ? TextAlign.right : TextAlign.left,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                      hintText: context.translate.search_text,
                      hintStyle: AppTextStyles.font16DarkGreyWeight400.copyWith(
                        color: AppColorsManager.textColor,
                        fontSize: 12.sp,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.r),
                        borderSide: BorderSide(
                          color: AppColorsManager.placeHolderColor,
                        ),
                      ),
                      suffixIcon: buildCustomSearchIcon(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 10.w),

          /// ---------------- Logo ----------------
          CircleAvatar(
            radius: 28.r,
            backgroundImage: const AssetImage("assets/images/we_care_logo.png"),
          ),
        ],
      ),
    );
  }

  PopupMenuItem _popupItem(IconData icon, String title,
      {bool isRed = false, VoidCallback? onClick}) {
    return PopupMenuItem(
      onTap: onClick,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isRed ? Colors.red : AppColorsManager.mainDarkBlue,
          ),
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 13.sp,
              color: isRed ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildCustomSearchIcon() {
  return Container(
    decoration: BoxDecoration(
      color: AppColorsManager.mainDarkBlue,
      borderRadius: BorderRadius.circular(12.r),
    ),
    padding: EdgeInsets.all(8.w),
    child: Image.asset(
      "assets/images/search_icon.png",
      width: 12.w,
      height: 12.h,
    ),
  );
}

class NotificationIcon extends StatelessWidget {
  final int count;

  const NotificationIcon({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main red circle with bell icon
        Container(
          height: 36,
          width: 36,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFD64541), // red like in your photo
          ),
          child: const Center(
            child: Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
              size: 25,
            ),
          ),
        ),

        // Notification badge
        Positioned(
          top: -5,
          right: -5,
          child: Container(
            height: 18,
            width: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffF1F3F6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: FittedBox(
                child: Text(
                  "$count",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font18blackWight500.copyWith(
                    color: AppColorsManager.placeHolderColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
