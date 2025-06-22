import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class EyePartsView extends StatefulWidget {
  const EyePartsView({super.key, required this.handleArrowTap, required this.eyePartsImages,required this.pageTitle});
final void Function(String partName) handleArrowTap;
final Map<String, String> eyePartsImages ;
final String pageTitle;

  @override
  State<EyePartsView> createState() => _EyePartsViewState();
}

class _EyePartsViewState extends State<EyePartsView> {
  String selectedImage = 'assets/images/eye_parts.png';

  void handlePartTap(String partName) {
    setState(() {
      selectedImage = widget.eyePartsImages[partName] ?? 'assets/images/eye_parts.png';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Column(
          spacing: 16.h,
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
            Image.asset(
              selectedImage,
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width - 32.w,
            ),
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
              onButtonTapped:widget.handleArrowTap,
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
