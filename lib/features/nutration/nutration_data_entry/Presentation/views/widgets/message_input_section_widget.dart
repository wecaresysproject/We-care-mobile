import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/nutration/nutration_data_entry/logic/cubit/nutration_data_entry_cubit.dart';

class MessageInputSection extends StatelessWidget {
  final TextEditingController controller;

  const MessageInputSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NutrationDataEntryCubit, NutrationDataEntryState>(
      builder: (context, state) {
        return Row(
          children: [
            GestureDetector(
              onTap: () {
                // Handle voice input tap
                context.read<NutrationDataEntryCubit>().toggleListening();
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColorsManager.mainDarkBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColorsManager.mainDarkBlue.withOpacity(0.3),
                  ),
                ),
                child: Icon(
                  state.isListening ? Icons.stop : Icons.mic,
                  color: state.isListening
                      ? Colors.red
                      : AppColorsManager.mainDarkBlue,
                  size: 24,
                ),
              ),
            ),
            horizontalSpacing(12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey[300]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.right,
                  maxLines: 3,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: state.isListening
                        ? 'جاري الاستماع...'
                        : (state.selectedPlanDate.isEmpty
                            ? 'اكتب او سجل غذائك'
                            : 'اكتب او سجل غذائك ليوم ${state.selectedPlanDate}'),
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
