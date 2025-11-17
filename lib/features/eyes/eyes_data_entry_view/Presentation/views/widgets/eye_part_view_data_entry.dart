import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/logic/cubit/eyes_data_entry_cubit.dart';

class EyePartsViewDataEntry extends StatefulWidget {
  const EyePartsViewDataEntry(
      {super.key, required this.handleArrowTap, required this.pageTitle});
  final void Function(String partName) handleArrowTap;
  final String pageTitle;

  @override
  State<EyePartsViewDataEntry> createState() => _EyePartsViewStateDataEntry();
}

class _EyePartsViewStateDataEntry extends State<EyePartsViewDataEntry> {
  String selectedImage = 'assets/images/eye_parts.png';
  String selectedDiscription = '';
  String? selectedPartName;

  Future<void> handlePartTap(String partName) async {
    final description = await getIt
        .get<EyesDataEntryCubit>()
        .getEyePartDescribtion(selectedEyePart: partName);

    setState(() {
      selectedImage = selectedPartName = partName;
      selectedDiscription = description;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedPart = selectedPartName ?? 'initial';
    final partData = eyePartsContent[selectedPart];
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Column(
          children: [
            CustomAppBarWidget(haveBackArrow: true)
                .paddingSymmetricHorizontal(16),
            Text(
              widget.pageTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.font20blackWeight600.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            verticalSpacing(20),

            /// 🔍 Eye Detail View
            EyePartDetailView(
              description: selectedDiscription,
              leftImageAsset: partData!.leftImage,
              rightImageAsset: partData.rightImage,
              isLoading: false,
            ).paddingSymmetricHorizontal(16),

            verticalSpacing(24),

            EyeCategoriesGridView(
              categories: [
                'الجفون',
                'القرنية',
                'الملتحمة',
                'بياض العين',
                'الشبكية',
                'العصب البصرى',
                'العدسة',
                'القزحيه',
                'الجسم الزجاجى',
                'السائل المائى',
              ],
              onArrowTapped: widget.handleArrowTap,
              onButtonTapped: handlePartTap,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Divider(
                thickness: 1.5,
                color: AppColorsManager.mainDarkBlue,
              ),
            ),
            EyeCategoriesGridView(
              categories: [
                'أعراض عامة',
                'ضغط العين',
                'الجهاز الدمعى',
                'عضلات العين',
                'الحول',
                'الانكسار البصرى',
                'الاصابة والعدوى',
                'الاجراءات التعويضية والتجميد',
              ],
              onArrowTapped: widget.handleArrowTap,
              onButtonTapped: widget.handleArrowTap,
            ),
          ],
        ),
      ),
    );
  }
}

class MedicalCategoryButton extends StatelessWidget {
  final String title;
  final void Function(String) onButtonTapped;
  final void Function(String) onArrowTapped;

  const MedicalCategoryButton({
    super.key,
    required this.title,
    required this.onButtonTapped,
    required this.onArrowTapped,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onButtonTapped(title),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColorsManager.mainDarkBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
      child: Row(
        children: [
          Text(title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600)),
          Spacer(),
          InkWell(
            onTap: () => onArrowTapped(title),
            child: Image.asset(
              'assets/images/back_icon.png',
              width: 30.w,
              height: 30.h,
            ),
          )
        ],
      ),
    );
  }
}

class EyeCategoriesGridView extends StatelessWidget {
  final List<String> categories;
  final void Function(String) onButtonTapped;
  final void Function(String) onArrowTapped;

  const EyeCategoriesGridView(
      {super.key,
      required this.categories,
      required this.onButtonTapped,
      required this.onArrowTapped});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: categories.map((category) {
        return SizedBox(
          width: category == 'الاجراءات التعويضية والتجميد' ||
                  category == 'أعراض عامة'
              ? MediaQuery.of(context).size.width - 16.w
              : MediaQuery.of(context).size.width / 2 - 16.w,
          child: MedicalCategoryButton(
            title: category,
            onButtonTapped: onButtonTapped,
            onArrowTapped: onArrowTapped,
          ),
        );
      }).toList(),
    );
  }
}

class EyePartDetailView extends StatelessWidget {
  final String leftImageAsset;
  final String rightImageAsset;
  final String description;
  final bool isLoading;

  const EyePartDetailView({
    super.key,
    required this.leftImageAsset,
    required this.rightImageAsset,
    required this.description,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 233.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// Right Image
          Container(
            width: 182.w,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColorsManager.mainDarkBlue,
                width: 1.2,
              ),
              borderRadius: BorderRadius.circular(24.r),
            ),
            padding: EdgeInsets.all(8.w),
            child: Image.asset(
              rightImageAsset,
              fit: BoxFit.contain,
            ),
          ),

          /// Left Image with Text Below
          Container(
            width: 131.w,
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColorsManager.mainDarkBlue,
                width: 1.2,
              ),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Column(
              children: [
                Image.asset(
                  leftImageAsset,
                  height: 100.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 10.h),
                Divider(
                  color: AppColorsManager.mainDarkBlue,
                  thickness: 1.5,
                  height: 0,
                ),
                Expanded(
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Text(
                            description,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.font18blackWight500.copyWith(
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EyePartData {
  final String leftImage;
  final String rightImage;

  EyePartData({
    required this.leftImage,
    required this.rightImage,
  });
}

final Map<String, EyePartData> eyePartsContent = {
  "initial": EyePartData(
    leftImage: 'assets/images/eye_initial_state_left.png',
    rightImage: 'assets/images/eye_initial_state_right.png',
  ),
  'الجفون': EyePartData(
    leftImage: 'assets/images/eye_lid_data_entry_left.png',
    rightImage: 'assets/images/eye_lid_data_entry.png',
  ),
  'القرنية': EyePartData(
    leftImage: 'assets/images/cornea_data_entry_left.png',
    rightImage: 'assets/images/cornea_data_entry.png',
  ),
  'الملتحمة': EyePartData(
    leftImage: 'assets/images/conjunctiva_data_entry_left.png',
    rightImage: 'assets/images/conjunctiva_data_entry.png',
  ),
  'بياض العين': EyePartData(
    leftImage: 'assets/images/sclera_data_entry_left.png',
    rightImage: 'assets/images/sclera_data_entry.png',
  ),
  'الشبكية': EyePartData(
    leftImage: 'assets/images/retina_data_entry_left.png',
    rightImage: 'assets/images/retina_data_entry.png',
  ),
  'العصب البصرى': EyePartData(
    leftImage: 'assets/images/optic_nerve_data_entry_left.png',
    rightImage: 'assets/images/optic_nerve_data_entry.png',
  ),
  'القزحيه': EyePartData(
    leftImage: 'assets/images/pupil_data_entry_left.png',
    rightImage: 'assets/images/pupil_data_entry.png',
  ),
  'العدسة': EyePartData(
    leftImage: 'assets/images/lens_data_entry_left.png',
    rightImage: 'assets/images/lens_data_entry.png',
  ),
  'الجسم الزجاجى': EyePartData(
    leftImage: 'assets/images/vitreous_data_entry_left.png',
    rightImage: 'assets/images/vitreous_data_entry.png',
  ),
  'السائل المائى': EyePartData(
    leftImage: 'assets/images/aqueous_data_entry_left.png',
    rightImage: 'assets/images/aqueous_data_entry.png',
  ),
};
