import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_back_arrow.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medical_notes/data/models/medical_note_model.dart';
import 'package:we_care/features/medical_notes/logic/medical_notes_cubit.dart';

class CreateEditMedicalNoteView extends StatefulWidget {
  final MedicalNote? note;

  const CreateEditMedicalNoteView({
    super.key,
    this.note,
  });

  @override
  State<CreateEditMedicalNoteView> createState() =>
      _CreateEditMedicalNoteViewState();
}

class _CreateEditMedicalNoteViewState extends State<CreateEditMedicalNoteView> {
  final TextEditingController _contentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    if (widget.note != null) {
      _contentController.text = widget.note!.note;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    final content = _contentController.text.trim();

    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'الرجاء كتابة محتوى الملاحظة',
            textAlign: TextAlign.right,
            style: AppTextStyles.font16DarkGreyWeight400.copyWith(
              color: Colors.white,
            ),
          ),
          backgroundColor: AppColorsManager.warningColor,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final cubit = context.read<MedicalNotesCubit>();
    bool success;

    if (widget.note != null) {
      // Update existing note
      success = await cubit.updateNote(widget.note!.id, content);
    } else {
      // Create new note
      success = await cubit.createNote(content);
    }

    setState(() {
      _isSaving = false;
    });

    if (success && mounted) {
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'فشل في حفظ الملاحظة',
            textAlign: TextAlign.right,
            style: AppTextStyles.font16DarkGreyWeight400.copyWith(
              color: Colors.white,
            ),
          ),
          backgroundColor: AppColorsManager.warningColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar with save button
            _buildAppBar(context),
            verticalSpacing(16),

            // Content area
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: TextField(
                  controller: _contentController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText:
                        'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى زيادة عدد الحروف التى يولدها التطبيق',
                    hintStyle: AppTextStyles.font16DarkGreyWeight400,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: AppColorsManager.placeHolderColor.withAlpha(150),
                        width: 1.3,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: AppColorsManager.placeHolderColor.withAlpha(150),
                        width: 1.3,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(
                        color: AppColorsManager.mainDarkBlue,
                        width: 1.3,
                      ),
                    ),
                    fillColor:
                        AppColorsManager.textfieldInsideColor.withAlpha(100),
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                    color: AppColorsManager.textColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          CustomBackArrow(),

          const Spacer(),

          // Save button (checkmark icon on the left for RTL)
          GestureDetector(
            onTap: _isSaving ? null : _saveNote,
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: _isSaving
                    ? AppColorsManager.mainDarkBlue.withOpacity(0.5)
                    : AppColorsManager.mainDarkBlue,
                shape: BoxShape.circle,
              ),
              child: _isSaving
                  ? Center(
                      child: SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    )
                  : Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 20.sp,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
