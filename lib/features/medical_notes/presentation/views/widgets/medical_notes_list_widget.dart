import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/SharedWidgets/error_view_widget.dart';
import 'package:we_care/core/global/SharedWidgets/loading_state_view.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/medical_notes/data/models/medical_note_model.dart';
import 'package:we_care/features/medical_notes/logic/medical_notes_cubit.dart';
import 'package:we_care/features/medical_notes/presentation/views/widgets/medical_note_card_widget.dart';

class MedicalNotesListWidget extends StatelessWidget {
  final MedicalNotesState state;

  const MedicalNotesListWidget({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    // Loading
    if (state.requestStatus == RequestStatus.loading && state.notes.isEmpty) {
      return const LoadingStateView();
    }

    // Error
    if (state.requestStatus == RequestStatus.failure && state.notes.isEmpty) {
      return ErrorViewWidget(
        errorMessage: state.message ?? 'حدث خطأ ما',
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
          onTap: () => _handleNoteTap(context, note.id, state.isSelectionMode),
          onDoubleTap: () => _handleNoteDoubleTap(context, note),
        );
      },
    );
  }

  void _handleNoteTap(
      BuildContext context, String noteId, bool isSelectionMode) {
    if (isSelectionMode) {
      // Toggle selection in selection mode
      context.read<MedicalNotesCubit>().toggleNoteSelection(noteId);
    } else {
      // Enter selection mode on single tap
      context.read<MedicalNotesCubit>().toggleSelectionMode(true);
      context.read<MedicalNotesCubit>().toggleNoteSelection(noteId);
    }
  }

  void _handleNoteDoubleTap(BuildContext context, MedicalNote note) {
    // Navigate to edit screen on double tap
    context
        .pushNamed(
      Routes.createEditMedicalNote,
      arguments: note,
    )
        .then((_) {
      // Reload notes after returning from edit screen
      if (context.mounted) {
        context.read<MedicalNotesCubit>().loadNotes();
      }
    });
  }
}
