import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/contact_support/data/models/chat_message_model.dart';

class MessageBubbleWidget extends StatelessWidget {
  final ChatMessage message;

  const MessageBubbleWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUserMessage;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(maxWidth: 0.75.sw),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isUser ? AppColorsManager.mainDarkBlue : const Color(0xeeeeeeee),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isUser ? 16.r : 4.r),
              topRight: Radius.circular(isUser ? 4.r : 16.r),
              bottomLeft: Radius.circular(16.r),
              bottomRight: Radius.circular(16.r),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message.content,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  fontSize: 14.sp,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                _formatTimestamp(message.timestamp),
                style: TextStyle(
                  color: isUser 
                      ? Colors.white.withValues(alpha: 0.7)
                      : Colors.grey.shade600,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (messageDate == today) {
      // Today - show time only
      return DateFormat('hh:mm a', 'ar').format(timestamp);
    } else {
      // Other days - show date and time
      return DateFormat('yyyy/MM/dd hh:mm a', 'ar').format(timestamp);
    }
  }
}
