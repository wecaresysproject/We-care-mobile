import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/module_guidance_alert_dialog.dart';
import 'package:we_care/core/global/SharedWidgets/shared_app_bar_widget.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
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
      return BlocBuilder<MedicalNotesCubit, MedicalNotesState>(
        buildWhen: (previous, current) =>
            previous.moduleGuidanceData != current.moduleGuidanceData,
        builder: (context, state) {
          return AppBarWithImageAndActionButtons(
            haveBackArrow: true,
            trailingActions: [
              CircleIconButton(
                icon: Icons.play_arrow,
                color: state.moduleGuidanceData?.videoLink?.isNotEmpty == true
                    ? AppColorsManager.mainDarkBlue
                    : Colors.grey,
                onTap: state.moduleGuidanceData?.videoLink?.isNotEmpty == true
                    ? () =>
                        launchYouTubeVideo(state.moduleGuidanceData!.videoLink)
                    : null,
              ),
              SizedBox(width: 8.w),
              CircleIconButton(
                icon: Icons.menu_book_outlined,
                color:
                    state.moduleGuidanceData?.moduleGuidanceText?.isNotEmpty ==
                            true
                        ? AppColorsManager.mainDarkBlue
                        : Colors.grey,
                onTap:
                    state.moduleGuidanceData?.moduleGuidanceText?.isNotEmpty ==
                            true
                        ? () {
                            ModuleGuidanceAlertDialog.show(
                              context,
                              title: "ملاحظات طبية",
                              description:
                                  state.moduleGuidanceData!.moduleGuidanceText!,
                            );
                          }
                        : null,
              ),
            ],
          ).paddingBottom(16);
        },
      );
    }
  }
}
