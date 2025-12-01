import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/error_view_widget.dart';
import 'package:we_care/core/global/SharedWidgets/loading_state_view.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/medical_notes/logic/medical_notes_cubit.dart';
import 'package:we_care/features/medical_notes/presentation/views/widgets/medical_note_card_widget.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_view_app_bar.dart';

class MedicalNotesView extends StatelessWidget {
  const MedicalNotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<MedicalNotesCubit, MedicalNotesState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // App Bar
                  _buildAppBar(context, state),

                  // Header
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'ملاحظاتك',
                      style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColorsManager.mainDarkBlue,
                      ),
                    ),
                  ),
                  verticalSpacing(16),

                  // Content
                  Expanded(
                    child: _buildContent(context, state),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: BlocBuilder<MedicalNotesCubit, MedicalNotesState>(
        builder: (context, state) {
          return FloatingActionButton.extended(
            onPressed: () async {
              await context.pushNamed(Routes.createEditMedicalNote);
              if (context.mounted) {
                context.read<MedicalNotesCubit>().loadNotes();
              }
            },
            backgroundColor: AppColorsManager.mainDarkBlue,
            elevation: 4,
            icon: Icon(Icons.add, color: Colors.white, size: 20.sp),
            label: Text(
              'أضف ملاحظة',
              style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, MedicalNotesState state) {
    return BlocBuilder<MedicalNotesCubit, MedicalNotesState>(
      builder: (context, state) {
        if (state.isSelectionMode) {
          return ViewAppBar(
            isItemSelectionMode: true,
            onShare: () {
              context.read<MedicalNotesCubit>().shareSelectedNotes();
            },
            onDelete: () {
              _showDeleteConfirmation(context);
            },
          );
        } else {
          // Normal app bar
          return ViewAppBar();
        }
      },
    );
  }

  Widget _buildContent(BuildContext context, MedicalNotesState state) {
    // Loading
    if (state.requestStatus == RequestStatus.loading && state.notes.isEmpty) {
      return const LoadingStateView();
    }

    // Error
    if (state.requestStatus == RequestStatus.failure && state.notes.isEmpty) {
      return ErrorViewWidget(
        errorMessage: state.errorMessage ?? 'حدث خطأ ما',
        onRetry: () => context.read<MedicalNotesCubit>().loadNotes(),
      );
    }

    // Empty state
    if (state.filteredNotes.isEmpty) {
      return Center(
        child: Text(
          state.searchQuery.isNotEmpty
              ? 'لا توجد ملاحظات مطابقة للبحث'
              : 'لا توجد ملاحظات حتى الآن',
          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
            color: AppColorsManager.textColor,
          ),
        ),
      );
    }

    // Notes list
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 16.w),
      itemCount: state.filteredNotes.length,
      itemBuilder: (context, index) {
        final note = state.filteredNotes[index];
        return MedicalNoteCardWidget(
          note: note,
          isSelectionMode: state.isSelectionMode,
          onTap: () {
            if (state.isSelectionMode) {
              // Toggle selection in selection mode
              context.read<MedicalNotesCubit>().toggleNoteSelection(note.id);
            } else {
              // Enter selection mode on single tap
              context.read<MedicalNotesCubit>().toggleSelectionMode(true);
              context.read<MedicalNotesCubit>().toggleNoteSelection(note.id);
            }
          },
          onDoubleTap: () {
            // Navigate to edit screen on double tap (only when not in selection mode)
            context
                .pushNamed(
              Routes.createEditMedicalNote,
              arguments: note.id,
            )
                .then((_) {
              // Reload notes after returning from edit screen
              if (context.mounted) {
                context.read<MedicalNotesCubit>().loadNotes();
              }
            });
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final cubit = context.read<MedicalNotesCubit>();
    final selectedCount = cubit.state.selectedCount;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'تأكيد الحذف',
          textAlign: TextAlign.right,
          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'هل أنت متأكد من حذف $selectedCount ملاحظة؟',
          textAlign: TextAlign.right,
          style: AppTextStyles.font16DarkGreyWeight400,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'إلغاء',
              style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                color: AppColorsManager.textColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              cubit.deleteSelectedNotes();
            },
            child: Text(
              'حذف',
              style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                color: AppColorsManager.warningColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
