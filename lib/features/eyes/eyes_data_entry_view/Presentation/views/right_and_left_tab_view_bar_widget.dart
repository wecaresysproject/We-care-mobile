import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/Database/dummy_data.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class RightAndLeftLensTabBarView extends StatelessWidget {
  const RightAndLeftLensTabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(bottom: 52),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            "assets/images/glasses.png",
            // width: 100.w,
            height: 100.h,
          ),
          verticalSpacing(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "العدسة اليمنية",
                style: AppTextStyles.font18blackWight500.copyWith(
                  color: AppColorsManager.mainDarkBlue,
                ),
              ),
              horizontalSpacing(16),
              Text(
                "العدسة اليسارية",
                style: AppTextStyles.font18blackWight500.copyWith(
                  color: AppColorsManager.mainDarkBlue,
                ),
              ),
            ],
          ),
          verticalSpacing(16),
          Row(
            children: [
              // الجزء الايمن
              Expanded(
                child: UserSelectionContainer(
                  // containerBorderColor: state.syptomTypeSelection == null
                  //     ? AppColorsManager.warningColor
                  //     : AppColorsManager.textfieldOutsideBorderColor,
                  categoryLabel: "قصر النظر",
                  // containerHintText: state.syptomTypeSelection ?? "اختر نوع العرض",
                  containerHintText: "اخترالدرجة",
                  options: doctorsList,
                  onOptionSelected: (value) {
                    // log("xxx:Selected: $value");
                    // context.read<DentalDataEntryCubit>().updateTypeOfSyptom(value);
                  },
                  // bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
                  bottomSheetTitle: "اخترالدرجة ",
                  searchHintText: "اخترالدرجة ",
                ),
              ),
              horizontalSpacing(16),
              // الجزء الايسر

              Expanded(
                child: UserSelectionContainer(
                  // containerBorderColor: state.syptomTypeSelection == null
                  //     ? AppColorsManager.warningColor
                  //     : AppColorsManager.textfieldOutsideBorderColor,
                  categoryLabel: "قصر النظر",
                  // containerHintText: state.syptomTypeSelection ?? "اختر نوع العرض",
                  containerHintText: "اخترالدرجة",
                  options: doctorsList,
                  onOptionSelected: (value) {
                    // log("xxx:Selected: $value");
                    // context.read<DentalDataEntryCubit>().updateTypeOfSyptom(value);
                  },
                  // bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
                  bottomSheetTitle: "اخترالدرجة ",
                  searchHintText: "اخترالدرجة ",
                ),
              ),
            ],
          ),
          verticalSpacing(16),
          Row(
            children: [
              // الجزء الايمن
              Expanded(
                child: UserSelectionContainer(
                  // containerBorderColor: state.syptomTypeSelection == null
                  //     ? AppColorsManager.warningColor
                  //     : AppColorsManager.textfieldOutsideBorderColor,
                  categoryLabel: "طول النظر",
                  // containerHintText: state.syptomTypeSelection ?? "اختر نوع العرض",
                  containerHintText: "اخترالدرجة",
                  options: doctorsList,
                  onOptionSelected: (value) {
                    // log("xxx:Selected: $value");
                    // context.read<DentalDataEntryCubit>().updateTypeOfSyptom(value);
                  },
                  // bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
                  bottomSheetTitle: "اخترالدرجة ",
                  searchHintText: "اخترالدرجة ",
                ),
              ),
              horizontalSpacing(16),
              // الجزء الايسر

              Expanded(
                child: UserSelectionContainer(
                  // containerBorderColor: state.syptomTypeSelection == null
                  //     ? AppColorsManager.warningColor
                  //     : AppColorsManager.textfieldOutsideBorderColor,
                  categoryLabel: "طول النظر",
                  // containerHintText: state.syptomTypeSelection ?? "اختر نوع العرض",
                  containerHintText: "اخترالدرجة",
                  options: doctorsList,
                  onOptionSelected: (value) {
                    // log("xxx:Selected: $value");
                    // context.read<DentalDataEntryCubit>().updateTypeOfSyptom(value);
                  },
                  // bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
                  bottomSheetTitle: "اخترالدرجة ",
                  searchHintText: "اخترالدرجة ",
                ),
              ),
            ],
          ),
          verticalSpacing(16),
          Row(
            children: [
              // الجزء الايمن
              Expanded(
                child: UserSelectionContainer(
                  // containerBorderColor: state.syptomTypeSelection == null
                  //     ? AppColorsManager.warningColor
                  //     : AppColorsManager.textfieldOutsideBorderColor,
                  categoryLabel: "الاستجماتزم",
                  // containerHintText: state.syptomTypeSelection ?? "اختر نوع العرض",
                  containerHintText: "اخترالدرجة",
                  options: doctorsList,
                  onOptionSelected: (value) {
                    // log("xxx:Selected: $value");
                    // context.read<DentalDataEntryCubit>().updateTypeOfSyptom(value);
                  },
                  // bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
                  bottomSheetTitle: "اخترالدرجة ",
                  searchHintText: "اخترالدرجة ",
                ),
              ),
              horizontalSpacing(16),
              // الجزء الايسر

              Expanded(
                child: UserSelectionContainer(
                  // containerBorderColor: state.syptomTypeSelection == null
                  //     ? AppColorsManager.warningColor
                  //     : AppColorsManager.textfieldOutsideBorderColor,
                  categoryLabel: "الاستجماتزم",
                  // containerHintText: state.syptomTypeSelection ?? "اختر نوع العرض",
                  containerHintText: "اخترالدرجة",
                  options: doctorsList,
                  onOptionSelected: (value) {
                    // log("xxx:Selected: $value");
                    // context.read<DentalDataEntryCubit>().updateTypeOfSyptom(value);
                  },
                  // bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
                  bottomSheetTitle: "اخترالدرجة ",
                  searchHintText: "اخترالدرجة ",
                ),
              ),
            ],
          ),
          verticalSpacing(16),
          Row(
            children: [
              // الجزء الايمن
              Expanded(
                child: UserSelectionContainer(
                  // containerBorderColor: state.syptomTypeSelection == null
                  //     ? AppColorsManager.warningColor
                  //     : AppColorsManager.textfieldOutsideBorderColor,
                  categoryLabel: "محور الاستجماتزم",
                  // containerHintText: state.syptomTypeSelection ?? "اختر نوع العرض",
                  containerHintText: "اخترالدرجة",
                  options: doctorsList,
                  onOptionSelected: (value) {
                    // log("xxx:Selected: $value");
                    // context.read<DentalDataEntryCubit>().updateTypeOfSyptom(value);
                  },
                  // bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
                  bottomSheetTitle: "اخترالدرجة ",
                  searchHintText: "اخترالدرجة ",
                ),
              ),
              horizontalSpacing(16),
              // الجزء الايسر

              Expanded(
                child: UserSelectionContainer(
                  // containerBorderColor: state.syptomTypeSelection == null
                  //     ? AppColorsManager.warningColor
                  //     : AppColorsManager.textfieldOutsideBorderColor,
                  categoryLabel: "محور الاستجماتزم",
                  // containerHintText: state.syptomTypeSelection ?? "اختر نوع العرض",
                  containerHintText: "اخترالدرجة",
                  options: doctorsList,
                  onOptionSelected: (value) {
                    // log("xxx:Selected: $value");
                    // context.read<DentalDataEntryCubit>().updateTypeOfSyptom(value);
                  },
                  // bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
                  bottomSheetTitle: "اخترالدرجة ",
                  searchHintText: "اخترالدرجة ",
                ),
              ),
            ],
          ),
          verticalSpacing(16),
          Row(
            children: [
              // الجزء الايمن
              Expanded(
                child: UserSelectionContainer(
                  // containerBorderColor: state.syptomTypeSelection == null
                  //     ? AppColorsManager.warningColor
                  //     : AppColorsManager.textfieldOutsideBorderColor,
                  categoryLabel: "الاضافة البؤرية",
                  // containerHintText: state.syptomTypeSelection ?? "اختر نوع العرض",
                  containerHintText: "اخترالدرجة",
                  options: doctorsList,
                  onOptionSelected: (value) {
                    // log("xxx:Selected: $value");
                    // context.read<DentalDataEntryCubit>().updateTypeOfSyptom(value);
                  },
                  // bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
                  bottomSheetTitle: "اخترالدرجة ",
                  searchHintText: "اخترالدرجة ",
                ),
              ),
              horizontalSpacing(16),
              // الجزء الايسر

              Expanded(
                child: UserSelectionContainer(
                  // containerBorderColor: state.syptomTypeSelection == null
                  //     ? AppColorsManager.warningColor
                  //     : AppColorsManager.textfieldOutsideBorderColor,
                  categoryLabel: "الاضافة البؤرية",
                  // containerHintText: state.syptomTypeSelection ?? "اختر نوع العرض",
                  containerHintText: "اخترالدرجة",
                  options: doctorsList,
                  onOptionSelected: (value) {
                    // log("xxx:Selected: $value");
                    // context.read<DentalDataEntryCubit>().updateTypeOfSyptom(value);
                  },
                  // bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
                  bottomSheetTitle: "اخترالدرجة ",
                  searchHintText: "اخترالدرجة ",
                ),
              ),
            ],
          ),
          verticalSpacing(16),
          Row(
            children: [
              // الجزء الايمن
              Expanded(
                child: UserSelectionContainer(
                  // containerBorderColor: state.syptomTypeSelection == null
                  //     ? AppColorsManager.warningColor
                  //     : AppColorsManager.textfieldOutsideBorderColor,
                  categoryLabel: "تباعد الحدقتين",
                  // containerHintText: state.syptomTypeSelection ?? "اختر نوع العرض",
                  containerHintText: "اخترالدرجة",
                  options: doctorsList,
                  onOptionSelected: (value) {
                    // log("xxx:Selected: $value");
                    // context.read<DentalDataEntryCubit>().updateTypeOfSyptom(value);
                  },
                  // bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
                  bottomSheetTitle: "اخترالدرجة ",
                  searchHintText: "اخترالدرجة ",
                ),
              ),
              horizontalSpacing(16),
              // الجزء الايسر

              Expanded(
                child: UserSelectionContainer(
                  // containerBorderColor: state.syptomTypeSelection == null
                  //     ? AppColorsManager.warningColor
                  //     : AppColorsManager.textfieldOutsideBorderColor,
                  categoryLabel: "تباعد الحدقتين",
                  // containerHintText: state.syptomTypeSelection ?? "اختر نوع العرض",
                  containerHintText: "اخترالدرجة",
                  options: doctorsList,
                  onOptionSelected: (value) {
                    // log("xxx:Selected: $value");
                    // context.read<DentalDataEntryCubit>().updateTypeOfSyptom(value);
                  },
                  // bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
                  bottomSheetTitle: "اخترالدرجة ",
                  searchHintText: "اخترالدرجة ",
                ),
              ),
            ],
          ),
          verticalSpacing(16),
          Row(
            children: [
              // الجزء الايمن
              Expanded(
                child: UserSelectionContainer(
                  // containerBorderColor: state.syptomTypeSelection == null
                  //     ? AppColorsManager.warningColor
                  //     : AppColorsManager.textfieldOutsideBorderColor,
                  categoryLabel: "معامل الانكسار",
                  // containerHintText: state.syptomTypeSelection ?? "اختر نوع العرض",
                  containerHintText: "اخترالدرجة",
                  options: doctorsList,
                  onOptionSelected: (value) {
                    // log("xxx:Selected: $value");
                    // context.read<DentalDataEntryCubit>().updateTypeOfSyptom(value);
                  },
                  // bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
                  bottomSheetTitle: "اخترالدرجة ",
                  searchHintText: "اخترالدرجة ",
                ),
              ),
              horizontalSpacing(16),
              // الجزء الايسر

              Expanded(
                child: UserSelectionContainer(
                  // containerBorderColor: state.syptomTypeSelection == null
                  //     ? AppColorsManager.warningColor
                  //     : AppColorsManager.textfieldOutsideBorderColor,
                  categoryLabel: "معامل الانكسار",
                  // containerHintText: state.syptomTypeSelection ?? "اختر نوع العرض",
                  containerHintText: "اخترالدرجة",
                  options: doctorsList,
                  onOptionSelected: (value) {
                    // log("xxx:Selected: $value");
                    // context.read<DentalDataEntryCubit>().updateTypeOfSyptom(value);
                  },
                  // bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
                  bottomSheetTitle: "اخترالدرجة ",
                  searchHintText: "اخترالدرجة ",
                ),
              ),
            ],
          ),
          verticalSpacing(16),
          Row(
            children: [
              // الجزء الايمن
              Expanded(
                child: UserSelectionContainer(
                  // containerBorderColor: state.syptomTypeSelection == null
                  //     ? AppColorsManager.warningColor
                  //     : AppColorsManager.textfieldOutsideBorderColor,
                  categoryLabel: "قطر العدسة",
                  // containerHintText: state.syptomTypeSelection ?? "اختر نوع العرض",
                  containerHintText: "اخترالدرجة",
                  options: doctorsList,
                  onOptionSelected: (value) {
                    // log("xxx:Selected: $value");
                    // context.read<DentalDataEntryCubit>().updateTypeOfSyptom(value);
                  },
                  // bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
                  bottomSheetTitle: "اخترالدرجة ",
                  searchHintText: "اخترالدرجة ",
                ),
              ),
              horizontalSpacing(16),
              // الجزء الايسر

              Expanded(
                child: UserSelectionContainer(
                  // containerBorderColor: state.syptomTypeSelection == null
                  //     ? AppColorsManager.warningColor
                  //     : AppColorsManager.textfieldOutsideBorderColor,
                  categoryLabel: "قطر العدسة",
                  // containerHintText: state.syptomTypeSelection ?? "اختر نوع العرض",
                  containerHintText: "اخترالدرجة",
                  options: doctorsList,
                  onOptionSelected: (value) {
                    // log("xxx:Selected: $value");
                    // context.read<DentalDataEntryCubit>().updateTypeOfSyptom(value);
                  },
                  // bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
                  bottomSheetTitle: "اخترالدرجة ",
                  searchHintText: "اخترالدرجة ",
                ),
              ),
            ],
          ),
          verticalSpacing(16),
          Row(
            children: [
              // الجزء الايمن
              Expanded(
                child: UserSelectionContainer(
                  // containerBorderColor: state.syptomTypeSelection == null
                  //     ? AppColorsManager.warningColor
                  //     : AppColorsManager.textfieldOutsideBorderColor,
                  categoryLabel: "المركز",
                  // containerHintText: state.syptomTypeSelection ?? "اختر نوع العرض",
                  containerHintText: "اخترالدرجة",
                  options: doctorsList,
                  onOptionSelected: (value) {
                    // log("xxx:Selected: $value");
                    // context.read<DentalDataEntryCubit>().updateTypeOfSyptom(value);
                  },
                  // bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
                  bottomSheetTitle: "اخترالدرجة ",
                  searchHintText: "اخترالدرجة ",
                ),
              ),
              horizontalSpacing(16),
              // الجزء الايسر

              Expanded(
                child: UserSelectionContainer(
                  // containerBorderColor: state.syptomTypeSelection == null
                  //     ? AppColorsManager.warningColor
                  //     : AppColorsManager.textfieldOutsideBorderColor,
                  categoryLabel: "المركز",
                  // containerHintText: state.syptomTypeSelection ?? "اختر نوع العرض",
                  containerHintText: "اخترالدرجة",
                  options: doctorsList,
                  onOptionSelected: (value) {
                    // log("xxx:Selected: $value");
                    // context.read<DentalDataEntryCubit>().updateTypeOfSyptom(value);
                  },
                  // bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
                  bottomSheetTitle: "اخترالدرجة ",
                  searchHintText: "اخترالدرجة ",
                ),
              ),
            ],
          ),
          verticalSpacing(16),
          Row(
            children: [
              // الجزء الايمن
              Expanded(
                child: UserSelectionContainer(
                  // containerBorderColor: state.syptomTypeSelection == null
                  //     ? AppColorsManager.warningColor
                  //     : AppColorsManager.textfieldOutsideBorderColor,
                  categoryLabel: "الحواف",
                  // containerHintText: state.syptomTypeSelection ?? "اختر نوع العرض",
                  containerHintText: "اخترالدرجة",
                  options: doctorsList,
                  onOptionSelected: (value) {
                    // log("xxx:Selected: $value");
                    // context.read<DentalDataEntryCubit>().updateTypeOfSyptom(value);
                  },
                  // bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
                  bottomSheetTitle: "اخترالدرجة ",
                  searchHintText: "اخترالدرجة ",
                ),
              ),
              horizontalSpacing(16),
              // الجزء الايسر

              Expanded(
                child: UserSelectionContainer(
                  // containerBorderColor: state.syptomTypeSelection == null
                  //     ? AppColorsManager.warningColor
                  //     : AppColorsManager.textfieldOutsideBorderColor,
                  categoryLabel: "الحواف",
                  // containerHintText: state.syptomTypeSelection ?? "اختر نوع العرض",
                  containerHintText: "اخترالدرجة",
                  options: doctorsList,
                  onOptionSelected: (value) {
                    // log("xxx:Selected: $value");
                    // context.read<DentalDataEntryCubit>().updateTypeOfSyptom(value);
                  },
                  // bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
                  bottomSheetTitle: "اخترالدرجة ",
                  searchHintText: "اخترالدرجة ",
                ),
              ),
            ],
          ),
          verticalSpacing(16),
          Row(
            children: [
              // الجزء الايمن
              Expanded(
                child: UserSelectionContainer(
                  // containerBorderColor: state.syptomTypeSelection == null
                  //     ? AppColorsManager.warningColor
                  //     : AppColorsManager.textfieldOutsideBorderColor,
                  categoryLabel: "سطح العدسة",
                  // containerHintText: state.syptomTypeSelection ?? "اختر نوع العرض",
                  containerHintText: "اخترالدرجة",
                  options: doctorsList,
                  onOptionSelected: (value) {
                    // log("xxx:Selected: $value");
                    // context.read<DentalDataEntryCubit>().updateTypeOfSyptom(value);
                  },
                  // bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
                  bottomSheetTitle: "اخترالدرجة ",
                  searchHintText: "اخترالدرجة ",
                ),
              ),
              horizontalSpacing(16),
              // الجزء الايسر

              Expanded(
                child: UserSelectionContainer(
                  // containerBorderColor: state.syptomTypeSelection == null
                  //     ? AppColorsManager.warningColor
                  //     : AppColorsManager.textfieldOutsideBorderColor,
                  categoryLabel: "سطح العدسة",
                  // containerHintText: state.syptomTypeSelection ?? "اختر نوع العرض",
                  containerHintText: "اخترالدرجة",
                  options: doctorsList,
                  onOptionSelected: (value) {
                    // log("xxx:Selected: $value");
                    // context.read<DentalDataEntryCubit>().updateTypeOfSyptom(value);
                  },
                  // bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
                  bottomSheetTitle: "اخترالدرجة ",
                  searchHintText: "اخترالدرجة ",
                ),
              ),
            ],
          ),
          verticalSpacing(16),
          Row(
            children: [
              // الجزء الايمن
              Expanded(
                child: UserSelectionContainer(
                  // containerBorderColor: state.syptomTypeSelection == null
                  //     ? AppColorsManager.warningColor
                  //     : AppColorsManager.textfieldOutsideBorderColor,
                  categoryLabel: "سُمك العدسة",
                  // containerHintText: state.syptomTypeSelection ?? "اختر نوع العرض",
                  containerHintText: "اخترالدرجة",
                  options: doctorsList,
                  onOptionSelected: (value) {
                    // log("xxx:Selected: $value");
                    // context.read<DentalDataEntryCubit>().updateTypeOfSyptom(value);
                  },
                  // bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
                  bottomSheetTitle: "اخترالدرجة ",
                  searchHintText: "اخترالدرجة ",
                ),
              ),
              horizontalSpacing(16),
              // الجزء الايسر

              Expanded(
                child: UserSelectionContainer(
                  // containerBorderColor: state.syptomTypeSelection == null
                  //     ? AppColorsManager.warningColor
                  //     : AppColorsManager.textfieldOutsideBorderColor,
                  categoryLabel: "سُمك العدسة",
                  // containerHintText: state.syptomTypeSelection ?? "اختر نوع العرض",
                  containerHintText: "اخترالدرجة",
                  options: doctorsList,
                  onOptionSelected: (value) {
                    // log("xxx:Selected: $value");
                    // context.read<DentalDataEntryCubit>().updateTypeOfSyptom(value);
                  },
                  // bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
                  bottomSheetTitle: "اخترالدرجة ",
                  searchHintText: "اخترالدرجة ",
                ),
              ),
            ],
          ),
          verticalSpacing(16),
          Row(
            children: [
              // الجزء الايمن
              Expanded(
                child: UserSelectionContainer(
                  // containerBorderColor: state.syptomTypeSelection == null
                  //     ? AppColorsManager.warningColor
                  //     : AppColorsManager.textfieldOutsideBorderColor,
                  categoryLabel: "نوع العدسة",
                  // containerHintText: state.syptomTypeSelection ?? "اختر نوع العرض",
                  containerHintText: "اخترالدرجة",
                  options: doctorsList,
                  onOptionSelected: (value) {
                    // log("xxx:Selected: $value");
                    // context.read<DentalDataEntryCubit>().updateTypeOfSyptom(value);
                  },
                  // bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
                  bottomSheetTitle: "اخترالدرجة ",
                  searchHintText: "اخترالدرجة ",
                ),
              ),
              horizontalSpacing(16),
              // الجزء الايسر

              Expanded(
                child: UserSelectionContainer(
                  // containerBorderColor: state.syptomTypeSelection == null
                  //     ? AppColorsManager.warningColor
                  //     : AppColorsManager.textfieldOutsideBorderColor,
                  categoryLabel: "نوع العدسة",
                  // containerHintText: state.syptomTypeSelection ?? "اختر نوع العرض",
                  containerHintText: "اخترالدرجة",
                  options: doctorsList,
                  onOptionSelected: (value) {
                    // log("xxx:Selected: $value");
                    // context.read<DentalDataEntryCubit>().updateTypeOfSyptom(value);
                  },
                  // bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
                  bottomSheetTitle: "اخترالدرجة ",
                  searchHintText: "اخترالدرجة ",
                ),
              ),
            ],
          ),
          verticalSpacing(32),
          AppCustomButton(
            isLoading: false,
            title: "ارسال",
            onPressed: () async {},
            isEnabled: true,
          ),
        ],
      ),
    );
  }
}
