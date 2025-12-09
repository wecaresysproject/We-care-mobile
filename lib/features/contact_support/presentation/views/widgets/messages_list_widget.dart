import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/contact_support/data/models/chat_message_model.dart';
import 'package:we_care/features/contact_support/logic/contact_support_cubit.dart';
import 'package:we_care/features/contact_support/presentation/views/widgets/message_bubble_widget.dart';

class MessagesListWidget extends StatefulWidget {
  const MessagesListWidget({super.key});

  @override
  State<MessagesListWidget> createState() => _MessagesListWidgetState();
}

class _MessagesListWidgetState extends State<MessagesListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactSupportCubit, ContactSupportState>(
      listener: (context, state) {
        if (state.requestStatus == RequestStatus.success) {
          _scrollToBottom();
        }
      },
      builder: (context, state) {
        if (state.requestStatus == RequestStatus.loading &&
            state.messages.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state.messages.isEmpty) {
          return Center(
            child: Text(
              'لا توجد رسائل بعد',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16.sp,
              ),
            ),
          );
        }

        // Group messages by date
        final groupedMessages = _groupMessagesByDate(state.messages);

        return ListView.builder(
          controller: _scrollController,
          padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
          itemCount: groupedMessages.length,
          itemBuilder: (context, index) {
            final entry = groupedMessages[index];

            return Column(
              children: [
                // Date separator
                if (entry['showDate'] as bool)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Color(0xFF6EA1CB), // الأزرق من الأسفل لليمين
                            Color(0xFFEFF5FB), // وسط فاتح
                            Color(0xFFEDF4FF), // أفتح درجة في الأعلى لليسار
                          ],
                          stops: [0.0, 0.45, 1.0],
                        ),
                        // color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        entry['dateLabel'] as String,
                        style: TextStyle(
                          color: AppColorsManager.mainDarkBlue,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                // Message bubble
                MessageBubbleWidget(
                  message: entry['message'] as ChatMessage,
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<Map<String, dynamic>> _groupMessagesByDate(List<ChatMessage> messages) {
    final List<Map<String, dynamic>> result = [];
    String? lastDate;

    for (final message in messages) {
      final messageDate = _getDateLabel(message.timestamp);
      final showDate = messageDate != lastDate;

      result.add({
        'message': message,
        'showDate': showDate,
        'dateLabel': messageDate,
      });

      lastDate = messageDate;
    }

    return result;
  }

  String _getDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return 'اليوم';
    } else if (messageDate == yesterday) {
      return 'أمس';
    } else {
      return DateFormat('الأربعاء yyyy/M/d', 'ar').format(date);
    }
  }
}
