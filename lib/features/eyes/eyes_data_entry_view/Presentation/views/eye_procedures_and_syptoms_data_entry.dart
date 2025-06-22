// Model for symptom items
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/Presentation/views/widgets/eye_syptom_custom_app_bar_widget.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/Presentation/views/widgets/selectable_syptom_card_widget.dart';

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
  List<SymptomItem> symptoms = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeSymptoms();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _initializeSymptoms() {
    symptoms = [
      SymptomItem(
        id: '1',
        title:
            'ادت إلى تغير مفاجئ وتشوش في رؤية الصورة أو ظهور بقع داكنة في مجال الرؤية',
        isSelected: false,
      ),
      SymptomItem(
        id: '2',
        title: 'تغير في رؤية الألوان',
        isSelected: false,
      ),
      SymptomItem(
        id: '3',
        title: 'ألم عند تحريك العين',
        isSelected: false,
      ),
      SymptomItem(
        id: '4',
        title: 'تقديم توصيات بالعادات البصرية الصحية',
        isSelected: false,
      ),
      SymptomItem(
        id: '5',
        title: 'غثيان',
        isSelected: false,
      ),
      SymptomItem(
        id: '6',
        title: 'شحوب في رأس العصب',
        isSelected: false,
      ),
      SymptomItem(
        id: '7',
        title: 'فقدان مفاجئ وغير مؤلم للبصر في عين واحدة',
        isSelected: false,
      ),
      SymptomItem(
        id: '8',
        title: 'ضعف تدريجي في الرؤية',
        isSelected: false,
      ),
      SymptomItem(
        id: '9',
        title: 'صداع مستمر ونوبات صرع',
        isSelected: false,
      ),
    ];
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

  // Get all selected symptoms
  List<SymptomItem> getSelectedSymptoms() {
    return symptoms.where((symptom) => symptom.isSelected).toList();
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
                SymptomsTabContent(
                  symptoms: symptoms,
                  onSymptomToggle: _toggleSymptomSelection,
                ),
                // Procedures Tab
                const Center(
                  child: Text(
                    'الإجراءات',
                    style: TextStyle(fontSize: 18),
                  ),
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
              await context.pushNamed(
                Routes.eyeDataEntry,
                arguments: {
                  'selectedSymptoms': selectedSymptoms,
                },
              );
              log("selectedSymptoms: ${selectedSymptoms.length}");
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
class SymptomsTabContent extends StatelessWidget {
  final List<SymptomItem> symptoms;
  final Function(String) onSymptomToggle;

  const SymptomsTabContent({
    super.key,
    required this.symptoms,
    required this.onSymptomToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: symptoms.length,
      itemBuilder: (context, index) {
        return SelectableSymptomCard(
          symptom: symptoms[index],
          onTap: () => onSymptomToggle(symptoms[index].id),
        );
      },
    );
  }
}

class SymptomItem {
  final String id;
  final String title;
  bool isSelected;

  SymptomItem({
    required this.id,
    required this.title,
    this.isSelected = false,
  });
}
