// Model for symptom items
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
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
  late TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController = TextEditingController();
    _tabController.addListener(_handleTabChange);
    initializeSyptomsAndProcedures();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      _searchController.clear();
      setState(() {
        _searchQuery = '';
      });
    }
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
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _searchController.dispose();
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

  List<SymptomAndProcedureItem> get filteredSymptoms {
    if (_searchQuery.isEmpty) return symptoms;
    return symptoms
        .where((item) =>
            item.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  List<SymptomAndProcedureItem> get filteredProcedures {
    if (_searchQuery.isEmpty) return procedures;
    return procedures
        .where((item) =>
            item.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
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
          // Search Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "بحث باسم العرض أو الإجراء...",
                hintStyle: AppTextStyles.font16DarkGreyWeight400,
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColorsManager.mainDarkBlue,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                        child: Icon(
                          Icons.clear,
                          color: Colors.grey,
                        ),
                      )
                    : null,
                filled: true,
                fillColor: AppColorsManager.textfieldInsideColor.withAlpha(100),
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
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 14.h,
                ),
              ),
              style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                color: AppColorsManager.textColor,
              ),
            ),
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
                      itemsList: filteredSymptoms,
                      onItemToggled: _toggleSymptomSelection,
                      searchQuery: _searchQuery,
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
                      itemsList: filteredProcedures,
                      onItemToggled: _toggleProceduresSelection,
                      searchQuery: _searchQuery,
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
  final String searchQuery;

  const SymptomsAndProceduresListTabContent({
    super.key,
    required this.itemsList,
    required this.onItemToggled,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    if (itemsList.isEmpty && searchQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 80.sp,
              color: AppColorsManager.placeHolderColor.withOpacity(0.5),
            ),
            verticalSpacing(16),
            Text(
              "لا توجد نتائج تطابق بحثك",
              style: AppTextStyles.font18blackWight500.copyWith(
                color: AppColorsManager.placeHolderColor,
              ),
            ),
          ],
        ),
      );
    }

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
