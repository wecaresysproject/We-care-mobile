import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/SharedWidgets/error_view_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/notifications/data/models/app_notification_model.dart';
import 'package:we_care/features/notifications/logic/notifications_cubit.dart';
import 'package:we_care/features/notifications/presentation/views/widgets/meeting_invitation_item.dart';
import 'package:we_care/features/notifications/presentation/views/widgets/notification_item.dart';

/// صفحة الرسائل — كل الرسائل اللى وصلت للمستخدم، حتى لو إشعار الموبايل
/// اختفى. الضغط على رسالة بيعلمها مقروءة ويفتح تفاصيلها.
class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// الصفحة اللى بعدها بتتحمل قبل آخر القايمة بشوية.
  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<NotificationsCubit>().loadMore();
    }
  }

  void _onNotificationTap(AppNotificationModel notification) {
    context.read<NotificationsCubit>().markAsRead(notification);
    // الدعوة بتتفتح بحالتها قبل القراية عشان "دعوة جديدة" تظهر.
    if (notification.isMeetingInvitation) {
      Navigator.of(context).pushNamed(
        Routes.meetingInvitationDetailsView,
        arguments: notification,
      );
      return;
    }
    Navigator.of(context).pushNamed(
      Routes.notificationDetailsView,
      arguments: notification.copyWith(isRead: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColorsManager.scaffoldBackGroundColor,
        appBar: AppBar(toolbarHeight: 0.h),
        body: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
          child: Column(
            children: [
              AppBarWithCenteredTitle(
                title: "الرسائل",
                showActionButtons: false,
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: BlocBuilder<NotificationsCubit, NotificationsState>(
                  builder: (context, state) {
                    final cubit = context.read<NotificationsCubit>();
                    switch (state.requestStatus) {
                      case RequestStatus.initial:
                      case RequestStatus.loading:
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColorsManager.mainDarkBlue,
                          ),
                        );
                      case RequestStatus.failure:
                        return ErrorViewWidget(
                          errorMessage: state.errorMessage,
                          onRetry: cubit.loadNotifications,
                        );
                      case RequestStatus.success:
                        return RefreshIndicator(
                          color: AppColorsManager.mainDarkBlue,
                          onRefresh: cubit.loadNotifications,
                          child: state.notifications.isEmpty
                              ? const _EmptyNotifications()
                              : ListView.builder(
                                  controller: _scrollController,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.only(bottom: 16.h),
                                  itemCount: state.notifications.length +
                                      (state.isLoadingMore ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index == state.notifications.length) {
                                      return Padding(
                                        padding: EdgeInsets.all(12.r),
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }
                                    final notification =
                                        state.notifications[index];
                                    final meeting = notification.meeting;
                                    if (notification.isMeetingInvitation &&
                                        meeting != null) {
                                      return MeetingInvitationItem(
                                        notification: notification,
                                        meeting: meeting,
                                        onTap: () =>
                                            _onNotificationTap(notification),
                                      );
                                    }
                                    return NotificationItem(
                                      notification: notification,
                                      onTap: () =>
                                          _onNotificationTap(notification),
                                    );
                                  },
                                ),
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// مفيش رسائل — قابلة للسحب عشان التحديث يشتغل.
class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: 120.h),
        Icon(
          Icons.notifications_off_outlined,
          size: 56.sp,
          color: AppColorsManager.placeHolderColor,
        ),
        SizedBox(height: 12.h),
        Text(
          "لا توجد رسائل حتى الآن",
          textAlign: TextAlign.center,
          style: AppTextStyles.font14blackWeight400.copyWith(
            color: AppColorsManager.placeHolderColor,
          ),
        ),
      ],
    );
  }
}
