// Model for symptom items
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/Presentation/views/widgets/eye_syptom_custom_app_bar_widget.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/Presentation/views/widgets/selectable_syptom_card_widget.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/logic/cubit/eyes_data_entry_cubit.dart';

// Main page widget
class EyeProceduresAndSyptomsDataEntry extends StatefulWidget {
  const EyeProceduresAndSyptomsDataEntry(
      {super.key, required this.selectedEyePart});
  final String selectedEyePart;
  @override
  State<EyeProceduresAndSyptomsDataEntry> createState() =>
      _EyeProceduresAndSyptomsDataEntryState();
}

class _EyeProceduresAndSyptomsDataEntryState
    extends State<EyeProceduresAndSyptomsDataEntry>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<SymptomAndProcedureItem> symptoms = [];
  List<SymptomAndProcedureItem> procedures = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    initializeSyptomsAndProcedures();
  }

  initializeSyptomsAndProcedures() async {
    await context.read<EyesDataEntryCubit>().getEyePartSyptomsAndProcedures(
          selectedEyePart: widget.selectedEyePart,
        );

    if (!mounted) return;

    final data =
        context.read<EyesDataEntryCubit>().state.eyePartSyptomsAndProcedures;

    if (data == null) return; // ✅ Prevent null error

    symptoms = data.symptoms
        .map((symptom) => SymptomAndProcedureItem(
              id: symptom,
              title: symptom,
              isSelected: false,
            ))
        .toList();

    procedures = data.procedures
        .map((procedure) => SymptomAndProcedureItem(
              id: procedure,
              title: procedure,
              isSelected: false,
            ))
        .toList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleSymptomSelection(String id) {
    setState(
      () {
        final index = symptoms.indexWhere((symptom) => symptom.id == id);
        if (index != -1) {
          symptoms[index].isSelected = !symptoms[index].isSelected;
        }
      },
    );
  }

  void _toggleProceduresSelection(String id) {
    setState(
      () {
        final index = procedures.indexWhere((procedure) => procedure.id == id);
        if (index != -1) {
          procedures[index].isSelected = !procedures[index].isSelected;
        }
      },
    );
  }

  // Get all selected symptoms
  List<SymptomAndProcedureItem> getSelectedSymptoms() {
    return symptoms.where((symptom) => symptom.isSelected).toList();
  }

  List<SymptomAndProcedureItem> getSelectedProcedures() {
    return procedures.where((procedure) => procedure.isSelected).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Column(
        children: [
          EyeSyptomAppBarWidget(
            title: 'امراض ${widget.selectedEyePart}',
          ),
          // Tab Bar
          TabBar(
            dividerColor: Color(0xff555555),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 16),
            automaticIndicatorColorAdjustment: false,
            indicatorWeight: 2.5,
            tabs: const [
              Tab(
                text: "الأعراض",
              ),
              Tab(
                text: "الاجراءات",
              ),
            ],
            controller: _tabController,
            labelStyle: AppTextStyles.font18blackWight500.copyWith(
              fontSize: 16.sp,
              fontFamily: "Cairo",
              color: AppColorsManager.mainDarkBlue,
            ),
            unselectedLabelStyle: AppTextStyles.font18blackWight500.copyWith(
              fontSize: 16.sp,
              fontFamily: "Cairo",
              color: Color(0xff555555),
            ),
            indicatorColor: AppColorsManager.mainDarkBlue,
          ),
          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Symptoms Tab
                BlocBuilder<EyesDataEntryCubit, EyesDataEntryState>(
                  builder: (context, state) {
                    if (state.eyePartSyptomsAndProcedures == null ||
                        symptoms.isEmpty) {
                      return Center(
                        child: Text(
                          "لا يوجد اعراض مضافه لهذا الجزء",
                          style: AppTextStyles.font22MainBlueWeight700,
                        ),
                      );
                    }

                    return SymptomsAndProceduresListTabContent(
                      itemsList: symptoms,
                      onItemToggled: _toggleSymptomSelection,
                    );
                  },
                ),
                // Procedures Tab
                BlocBuilder<EyesDataEntryCubit, EyesDataEntryState>(
                  builder: (context, state) {
                    if (state.eyePartSyptomsAndProcedures == null ||
                        procedures.isEmpty) {
                      return Center(
                        child: Text(
                          "لا يوجد اجرائات مضافه لهذا الجزء",
                          style: AppTextStyles.font22MainBlueWeight700,
                        ),
                      );
                    }

                    return SymptomsAndProceduresListTabContent(
                      itemsList: procedures,
                      onItemToggled: _toggleProceduresSelection,
                    );
                  },
                ),
              ],
            ),
          ),

          AppCustomButton(
            isLoading: false,
            title: "أكمل الادخال",
            isEnabled: true,
            onPressed: () async {
              final selectedSymptoms = getSelectedSymptoms();
              final selectedProcedures = getSelectedProcedures();
              await context.pushReplacementNamed(
                Routes.eyeDataEntry,
                arguments: {
                  'selectedSymptoms': selectedSymptoms,
                  'selectedProcedures': selectedProcedures,
                  'affectedEyePart': widget.selectedEyePart,
                },
              );
            },
          ).paddingFrom(
            left: 16,
            right: 16,
            bottom: 16,
          ),
        ],
      ),
    );
  }
}

// Symptoms tab content widget
class SymptomsAndProceduresListTabContent extends StatelessWidget {
  final List<SymptomAndProcedureItem> itemsList;
  final Function(String) onItemToggled;

  const SymptomsAndProceduresListTabContent({
    super.key,
    required this.itemsList,
    required this.onItemToggled,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: itemsList.length,
      itemBuilder: (context, index) {
        return SelectableCard(
          symptom: itemsList[index],
          onTap: () => onItemToggled(itemsList[index].id),
        );
      },
    );
  }
}

class SymptomAndProcedureItem {
  final String id;
  final String title;
  bool isSelected;

  SymptomAndProcedureItem({
    required this.id,
    required this.title,
    this.isSelected = false,
  });
}
