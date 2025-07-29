import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/medical_illnesses/data/models/mental_illness_model.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_view/Presentation/widgets/medical_illness_footer_row.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_view/Presentation/widgets/mental_illness_card_horizontal_widget.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_view/logic/mental_illness_data_view_cubit.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_view/logic/mental_illness_data_view_state.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_filters_row.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_view_app_bar.dart';

class MentalIllnessRecordsView extends StatelessWidget {
  const MentalIllnessRecordsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MentalIllnessDataViewCubit>(
            create: (_) => getIt<MentalIllnessDataViewCubit>()
            // ..getMentalIllnessRecords()
            // ..getMedicalIllnessDocsAvailableYears(),
            ),
      ],
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body:
            BlocBuilder<MentalIllnessDataViewCubit, MentalIllnessDataViewState>(
          builder: (context, state) {
            final cubit = context.read<MentalIllnessDataViewCubit>();

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      children: [
                        ViewAppBar(),
                        DataViewFiltersRow(
                          filters: [
                            FilterConfig(
                              title: ' السنة ',
                              options: state.yearsFilter,
                              isYearFilter: true,
                            ),
                          ],
                          onApply: (selectedFilters) {
                            cubit.getFilteredMentalIllnessDocuments(
                              year: selectedFilters[' السنة '],
                            );
                          },
                        ),
                        if (state.requestStatus == RequestStatus.loading)
                          const Center(child: CircularProgressIndicator())
                        else if (state.mentalIllnessRecords
                            .isNotEmpty) //! put it isEmpty instead plz
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
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              final doc = MentalIllnessModel(
                                id: '1',
                                mentalIllnessType: 'اضطراب القلق العام',
                                diagnosisDate: '2022-12-12',
                                duration: '2 ساعات',
                                illnessSeverity: 'متوسط',
                              );
                              return MentalIllnessItemCardHorizontal(
                                item: doc,
                                onArrowTap: () async {
                                  await context.pushNamed(
                                    Routes.mentalIllnessDocDetailsView,
                                    arguments: {
                                      'docId': doc.id,
                                    },
                                  );
                                },
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),

                /// Fixed Footer
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: MentalIllnessFooterRow(),
                ),

                verticalSpacing(16),
              ],
            );
          },
        ),
      ),
    );
  }
}
