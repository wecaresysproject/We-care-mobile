import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';

class SupplementsDataEntryView extends StatelessWidget {
  const SupplementsDataEntryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.h,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 24.h),
        child: Column(
          children: [
            AppBarWithCenteredTitle(
              title: "مكملاتك الغذائية",
              showActionButtons: false,
            ),
            verticalSpacing(24),
            Text(
              'ابدأ قرص فيتامينات او مكملات غذائيه \n'
              'هنتابع معك كيف جسمك سيستفيد.',
              style: AppTextStyles.font20blackWeight600.copyWith(
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                fontFamily: "Rubik",
              ),
            ),
            verticalSpacing(24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const LabeledIcon(
                  icon: Icons.medication,
                  text: "الفيتامين أو المكمل",
                ),
                const LabeledIcon(
                  icon: Icons.rule,
                  text: "الجرعة/اليوم",
                ),
              ],
            ),
            verticalSpacing(24),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: UserSelectionContainer(
                    bottomSheetTitle: "ابحث عن الإسم ....",
                    onOptionSelected: (value) {
                      // context
                      //     .read<DentalDataEntryCubit>()
                      //     .updateSelectedCountry(value);
                    },
                    containerHintText: "ابحث عن الإسم ....",
                    searchHintText: "ابحث عن الإسم ....",
                    options: [
                      "Omega 3",
                      "Vitamin c",
                      "Vitamin D",
                      "Vitamin E",
                      "Vitamin B12",
                    ],
                  ),
                ),
                horizontalSpacing(12),
                Expanded(
                  flex: 2,
                  child: DoseCounter(
                    onChanged: (value) {
                      print("New count = $value");
                    },
                  ),
                ),
              ],
            ),
            verticalSpacing(24),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: UserSelectionContainer(
                    bottomSheetTitle: "ابحث عن الإسم ....",
                    onOptionSelected: (value) {
                      // context
                      //     .read<DentalDataEntryCubit>()
                      //     .updateSelectedCountry(value);
                    },
                    containerHintText: "ابحث عن الإسم ....",
                    searchHintText: "ابحث عن الإسم ....",
                    options: [
                      "Omega 3",
                      "Vitamin c",
                      "Vitamin D",
                      "Vitamin E",
                      "Vitamin B12",
                    ],
                  ),
                ),
                horizontalSpacing(12),
                Expanded(
                  flex: 2,
                  child: DoseCounter(
                    onChanged: (value) {
                      print("New count = $value");
                    },
                  ),
                ),
              ],
            ),
            verticalSpacing(24),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: UserSelectionContainer(
                    bottomSheetTitle: "ابحث عن الإسم ....",
                    onOptionSelected: (value) {
                      // context
                      //     .read<DentalDataEntryCubit>()
                      //     .updateSelectedCountry(value);
                    },
                    containerHintText: "ابحث عن الإسم ....",
                    searchHintText: "ابحث عن الإسم ....",
                    options: [
                      "Omega 3",
                      "Vitamin c",
                      "Vitamin D",
                      "Vitamin E",
                      "Vitamin B12",
                    ],
                  ),
                ),
                horizontalSpacing(12),
                Expanded(
                  flex: 2,
                  child: DoseCounter(
                    onChanged: (value) {
                      print("New count = $value");
                    },
                  ),
                ),
              ],
            ),
            verticalSpacing(24),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: UserSelectionContainer(
                    bottomSheetTitle: "ابحث عن الإسم ....",
                    onOptionSelected: (value) {
                      // context
                      //     .read<DentalDataEntryCubit>()
                      //     .updateSelectedCountry(value);
                    },
                    containerHintText: "ابحث عن الإسم ....",
                    searchHintText: "ابحث عن الإسم ....",
                    options: [
                      "Omega 3",
                      "Vitamin c",
                      "Vitamin D",
                      "Vitamin E",
                      "Vitamin B12",
                    ],
                  ),
                ),
                horizontalSpacing(12),
                Expanded(
                  flex: 2,
                  child: DoseCounter(
                    onChanged: (value) {
                      print("New count = $value");
                    },
                  ),
                ),
              ],
            ),
            verticalSpacing(24),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: UserSelectionContainer(
                    bottomSheetTitle: "ابحث عن الإسم ....",
                    onOptionSelected: (value) {
                      // context
                      //     .read<DentalDataEntryCubit>()
                      //     .updateSelectedCountry(value);
                    },
                    containerHintText: "ابحث عن الإسم ....",
                    searchHintText: "ابحث عن الإسم ....",
                    options: [
                      "Omega 3",
                      "Vitamin c",
                      "Vitamin D",
                      "Vitamin E",
                      "Vitamin B12",
                    ],
                  ),
                ),
                horizontalSpacing(12),
                Expanded(
                  flex: 2,
                  child: DoseCounter(
                    onChanged: (value) {
                      print("New count = $value");
                    },
                  ),
                ),
              ],
            ),
            verticalSpacing(24),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: UserSelectionContainer(
                    bottomSheetTitle: "ابحث عن الإسم ....",
                    onOptionSelected: (value) {
                      // context
                      //     .read<DentalDataEntryCubit>()
                      //     .updateSelectedCountry(value);
                    },
                    containerHintText: "ابحث عن الإسم ....",
                    searchHintText: "ابحث عن الإسم ....",
                    options: [
                      "Omega 3",
                      "Vitamin c",
                      "Vitamin D",
                      "Vitamin E",
                      "Vitamin B12",
                    ],
                  ),
                ),
                horizontalSpacing(12),
                Expanded(
                  flex: 2,
                  child: DoseCounter(
                    onChanged: (value) {
                      print("New count = $value");
                    },
                  ),
                ),
              ],
            ),
            verticalSpacing(30),
            AppCustomButton(
              title: "التالي",
              onPressed: () async {
                await context.pushNamed(
                  Routes.supplementsView,
                );
              },
              isEnabled: true,
            ),
          ],
        ),
      ),
    );
  }
}

class LabeledIcon extends StatelessWidget {
  final IconData icon;
  final String text;

  const LabeledIcon({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColorsManager.mainDarkBlue,
          size: 24,
        ),
        horizontalSpacing(4),
        Text(
          text,
          style: AppTextStyles.font18blackWight500.copyWith(
            color: AppColorsManager.mainDarkBlue,
          ),
        ),
      ],
    );
  }
}

class DoseCounter extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onChanged;

  const DoseCounter({
    super.key,
    this.initialValue = 0,
    required this.onChanged,
  });

  @override
  State<DoseCounter> createState() => _DoseCounterState();
}

class _DoseCounterState extends State<DoseCounter> {
  late int count;

  @override
  void initState() {
    super.initState();
    count = widget.initialValue;
  }

  void _increase() {
    setState(() {
      count++;
    });
    widget.onChanged(count);
  }

  void _decrease() {
    if (count == 0) return;
    setState(() {
      count--;
    });
    widget.onChanged(count);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 120,
      decoration: BoxDecoration(
        color: AppColorsManager.mainDarkBlue,
        borderRadius: BorderRadius.circular(17.r),
      ),
      child: Row(
        children: [
          // --- Increase Button ---
          Expanded(
            child: GestureDetector(
              onTap: _increase,
              child: Center(
                child: Text(
                  "+",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // --- Counter Center Box ---
          Container(
            width: 30,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.symmetric(
                horizontal: BorderSide(color: Colors.black12, width: 0.7),
                vertical: BorderSide(color: Colors.black26, width: 0.7),
              ),
            ),
            child: Center(
              child: Text(
                "$count",
                style: AppTextStyles.font20blackWeight600,
              ),
            ),
          ),
          // --- Decrease Button ---
          Expanded(
            child: GestureDetector(
              onTap: _decrease,
              child: Center(
                child: Text(
                  "-",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
