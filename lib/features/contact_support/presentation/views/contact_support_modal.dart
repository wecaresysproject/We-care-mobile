import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/contact_support/data/repos/contact_support_repository.dart';
import 'package:we_care/features/contact_support/logic/contact_support_cubit.dart';
import 'package:we_care/features/contact_support/presentation/views/widgets/chat_input_widget.dart';
import 'package:we_care/features/contact_support/presentation/views/widgets/intro_banner_widget.dart';
import 'package:we_care/features/contact_support/presentation/views/widgets/messages_list_widget.dart';
import 'package:we_care/features/contact_support/presentation/views/widgets/modal_header_widget.dart';

class ContactSupportModal extends StatelessWidget {
  const ContactSupportModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ContactSupportModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContactSupportCubit(ContactSupportRepository())
        ..loadMessages(),
      child: AnimatedPadding(
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFECF5FF), Color(0xFFFBFDFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          child: Column(
            children: [
              // Header with close button
              const ModalHeaderWidget(),
              
              // Intro banner
              const IntroBannerWidget(),
              
              // Messages list
              const Expanded(
                child: MessagesListWidget(),
              ),
              
              // Input field
              BlocBuilder<ContactSupportCubit, ContactSupportState>(
                builder: (context, state) {
                  return ChatInputWidget(
                    isLoading: state.requestStatus == RequestStatus.loading,
                    onSendMessage: (message) {
                      context.read<ContactSupportCubit>().sendMessage(message);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
