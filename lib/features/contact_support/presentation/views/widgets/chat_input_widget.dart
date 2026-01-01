import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/contact_support/logic/contact_support_cubit.dart';

class ChatInputWidget extends StatefulWidget {
  const ChatInputWidget({
    super.key,
  });

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  void _sendMessage() {
    final cubit = context.read<ContactSupportCubit>();
    final isLoading = cubit.state.requestStatus == RequestStatus.loading;

    if (_hasText && !isLoading) {
      cubit.sendMessage(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactSupportCubit, ContactSupportState>(
      builder: (context, state) {
        final isLoading = state.requestStatus == RequestStatus.loading;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: Row(
                children: [
                  // Text field
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: AppColorsManager.mainDarkBlue.withAlpha(40),
                            offset: const Offset(5, 4),
                            blurRadius: 20,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _controller,
                        enabled: !isLoading,
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                        textDirection: TextDirection.rtl,
                        decoration: InputDecoration(
                          hintText: "اكتب رسالتك .......",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14.sp,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28.r),
                            borderSide: BorderSide(
                              color: const Color(0xFFB8D0EB),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28.r),
                            borderSide: BorderSide(
                              color: const Color(0xFFB8D0EB),
                              width: 2,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28.r),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 18.h,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Send button
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        color: (_hasText && !isLoading)
                            ? AppColorsManager.mainDarkBlue
                            : Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      child: isLoading
                          ? Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Image.asset(
                              'assets/images/send.png',
                              width: 24.w,
                              height: 24.h,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
