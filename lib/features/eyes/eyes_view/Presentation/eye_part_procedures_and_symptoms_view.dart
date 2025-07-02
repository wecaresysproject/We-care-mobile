import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_app_bar.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/eyes/eyes_view/Presentation/eye_parts_proscedure_and_symptoms_details_view.dart';
import 'package:we_care/features/eyes/eyes_view/Presentation/widgets/eye_documents_footer_row.dart';
import 'package:we_care/features/eyes/eyes_view/Presentation/widgets/medical_card_horizontal_widget.dart';
import 'package:we_care/features/eyes/eyes_view/logic/eye_view_cubit.dart';
import 'package:we_care/features/eyes/eyes_view/logic/eye_view_state.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_filters_row.dart';

class EyePartProceduresAndSymptomsView extends StatelessWidget {
  const EyePartProceduresAndSymptomsView({super.key, required this.eyePart});
  final String eyePart;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EyeViewCubit>(
      create: (_) => getIt<EyeViewCubit>()
        ..getEyePartDocuments()
        ..getAvailableYears(),
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: BlocBuilder<EyeViewCubit, EyeViewState>(
            builder: (context, state) {
              final cubit = context.read<EyeViewCubit>();

              return SingleChildScrollView(
                child: Column(
                  children: [
                    DetailsViewAppBar(
                      title: eyePart,
                      showActionButtons: false,
                    ),
                    DataViewFiltersRow(
                      filters: [
                        FilterConfig(
                          title: ' السنة ',
                          options: state.yearsFilter,
                          isYearFilter: true,
                        ),
                        FilterConfig(
                          title: '  الفئة      ',
                          options: const ['الاعراض', 'الاجراءات', 'الكل'],
                        ),
                      ],
                      onApply: (selectedFilters) {
                        cubit.getFilteredEyePartProceduresAndSymptomsDocuments(
                          year: selectedFilters[' السنة '],
                          category: selectedFilters['  الفئة      '],
                        );
                      },
                    ),
                    if (state.requestStatus == RequestStatus.loading)
                      const Center(child: CircularProgressIndicator())
                    else if (state.eyePartDocuments.isEmpty)
                      Center(
                        child: Text(
                          "لا يوجد بيانات",
                          style: AppTextStyles.font22MainBlueWeight700,
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.eyePartDocuments.length,
                        itemBuilder: (context, index) {
                          final doc = state.eyePartDocuments[index];
                          return MedicalItemCardHorizontal(
                            onArrowTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EyePartsProcedureAndSymptomsDetailsView(
                                    title: eyePart,
                                    documentId: doc.id,
                                  ),
                                ),
                              );
                              await cubit.getEyePartDocuments();
                            },
                            date: doc.date,
                            procedures: doc.procedures,
                            symptoms: doc.symptoms,
                          );
                        },
                      ),
                    const EyeDocumentsFooterRow(),
                    verticalSpacing(16),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
