// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:we_care/core/global/Helpers/extensions.dart';
// import 'package:we_care/core/global/Helpers/font_weight_helper.dart';
// import 'package:we_care/core/global/Helpers/functions.dart';
// import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
// import 'package:we_care/core/global/theming/app_text_styles.dart';
// import 'package:we_care/core/global/theming/color_manager.dart';
// import 'package:we_care/core/routing/routes.dart';
// import 'package:we_care/features/home_tab/Presentation/views/widgets/custom_text_with_image_button.dart';

// class HomeTabView extends StatelessWidget {
//   const HomeTabView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: DecoratedBox(
//         decoration: ShapeDecoration(
//           color: Theme.of(context).scaffoldBackgroundColor,
//           shape: RoundedRectangleBorder(),
//         ),
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 16.w),
//           child: Center(
//             child: Column(
//               children: [
//                 CustomAppBarWidget(
//                   haveBackArrow: true,
//                 ),
//                 verticalSpacing(32),
//                 Text(
//                   context.translate.medicalRecordManagement,
//                   textAlign: TextAlign.center,
//                   maxLines: 2,
//                   style: AppTextStyles.font22MainBlueRegular.copyWith(
//                     color: AppColorsManager.textColor,
//                     fontFamily: "Rubik",
//                     fontWeight: FontWeightHelper.medium,
//                   ),
//                 ),
//                 verticalSpacing(60),
//                 CustomImageWithTextButtonHomeWidget(
//                   onTap: () {
//                     context.pushNamed(Routes.dateEntryTypesView);
//                   },
//                   imagePath: "assets/images/edit_icon.png",
//                   text: isArabic()
//                       ? "ادخال بيانات\nسجلك الطبي"
//                       : "Enter medical\n record data",
//                   textStyle: AppTextStyles.font22WhiteSemiBold.copyWith(
//                     fontSize: 24.sp,
//                   ),
//                 ),
//                 verticalSpacing(80),
//                 CustomImageWithTextButtonHomeWidget(
//                   onTap: () {},
//                   imagePath: "assets/images/show_medical_history.png",
//                   text: isArabic() ? "عرض سجلك\nالطبي" : "View medical\nrecord",
//                   textStyle: AppTextStyles.font22WhiteSemiBold.copyWith(
//                     fontSize: 24.sp,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/font_weight_helper.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Center(
            child: Column(
              children: [
                HomeCustomAppBarWidget(),
                verticalSpacing(32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeCustomAppBarWidget extends StatelessWidget {
  const HomeCustomAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UserAvatarWidget(
              height: 47,
              width: 46,
              borderRadius: 48,
            ),
            Text(
              context.translate.dummyUserName,
              textAlign: TextAlign.center,
              style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                color: AppColorsManager.textColor,
                fontWeight: FontWeightHelper.medium,
                fontSize: 11.sp,
              ),
            )
          ],
        ),
        horizontalSpacing(8),
        Expanded(
          child: TextField(
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
              hintText: "بحث",
              hintStyle: TextStyle(fontSize: 16, color: Colors.black54),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(
                  color: AppColorsManager.placeHolderColor.withAlpha(150),
                  width: 1.3, // Same thickness
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(
                  color: AppColorsManager.placeHolderColor.withAlpha(150),
                  width: 1.3, // Same thickness
                ),
              ),
              suffixIcon: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16.r),
                    topLeft: Radius.circular(16.r),
                  ),
                  color: AppColorsManager.mainDarkBlue,
                ),
                child: Icon(Icons.search, color: Colors.white),
              ),
            ),
          ),
        )
        // TextField(
        //   textAlign: TextAlign.right,
        //   decoration: InputDecoration(
        //     contentPadding: EdgeInsets.symmetric(vertical: 12),
        //     hintText: "بحث",
        //     hintStyle: TextStyle(fontSize: 16, color: Colors.black54),
        //     border: InputBorder.none,
        //     prefixIcon: Container(
        //       padding: EdgeInsets.all(10),
        //       child: Icon(Icons.search, color: Colors.white),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
