import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/home_tab/Presentation/views/widgets/notification_item.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColorsManager.scaffoldBackGroundColor,
        appBar: AppBar(
         toolbarHeight: 0.h,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: SingleChildScrollView(
            child: Column(
              spacing: 16.h,
              children: [
                AppBarWithCenteredTitle(
                  title: "الإشعارات",
                  showActionButtons: false,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return NotificationItem(
                      title: "تذكير بموعد الدواء",
                      body: "حان موعد أخذ دواء الضغط الخاص بك، يرجى الالتزام بالموعد المحدد للحفاظ على صحتك.",
                      time: "منذ ${index + 1} ساعة",
                      isRead: index > 2,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
