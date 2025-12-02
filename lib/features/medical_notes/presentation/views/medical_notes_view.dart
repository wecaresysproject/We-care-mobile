import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/medical_notes/logic/medical_notes_cubit.dart';
import 'package:we_care/features/medical_notes/presentation/views/widgets/add_note_fab_widget.dart';
import 'package:we_care/features/medical_notes/presentation/views/widgets/delete_confirmation_dialog.dart';
import 'package:we_care/features/medical_notes/presentation/views/widgets/medical_notes_header_widget.dart';
import 'package:we_care/features/medical_notes/presentation/views/widgets/medical_notes_list_widget.dart';
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
                  _buildAppBar(state, context),

                  // Header
                  const MedicalNotesHeaderWidget(),
                  verticalSpacing(16),

                  // Content
                  Expanded(
                    child: MedicalNotesListWidget(state: state),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: const AddNoteFabWidget(),
    );
  }

  Widget _buildAppBar(MedicalNotesState state, BuildContext context) {
    if (state.isSelectionMode) {
      return ViewAppBar(
        isItemSelectionMode: true,
        onShare: () {
          context.read<MedicalNotesCubit>().shareSelectedNotes();
        },
        onDelete: () {
          DeleteConfirmationDialog.show(context);
        },
      );
    } else {
      return const ViewAppBar();
    }
  }
}
