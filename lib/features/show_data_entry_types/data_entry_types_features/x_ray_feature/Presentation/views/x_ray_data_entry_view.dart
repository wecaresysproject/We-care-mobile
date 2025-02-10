import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/date_validator_class.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class XrayCategoryDataEntryView extends StatelessWidget {
  const XrayCategoryDataEntryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBarWidget(
                haveBackArrow: true,
              ),
              verticalSpacing(24),
              XRayDataEntryFormFields(),
            ],
          ),
        ),
      ),
    );
  }
}

class DateFormField extends StatefulWidget {
  const DateFormField({super.key});

  @override
  DateFormFieldState createState() => DateFormFieldState();
}

class DateFormFieldState extends State<DateFormField> {
  final TextEditingController _dateController = TextEditingController();

  /// intialize it in its cubit later to take its input from here to make the request and handle focus node

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      validator: (value) {
        if (value!.isEmptyOrNull) return "من فضلك ادخل التاريخ";
        return DateValidator.getErrorMessage(value);
      },
      controller: _dateController,
      isPassword: false,
      showSuffixIcon: false,
      keyboardType: TextInputType.number,
      hintText: "يوم / شهر / سنة",
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
        DateTextFormatter(),
      ],
    );
  }
}

class XRayDataEntryFormFields extends StatefulWidget {
  const XRayDataEntryFormFields({super.key});

  @override
  State<XRayDataEntryFormFields> createState() =>
      _XRayDataEntryFormFieldsState();
}

class _XRayDataEntryFormFieldsState extends State<XRayDataEntryFormFields> {
  final GlobalKey<CustomDropdownState> _dropdownKey =
      GlobalKey(); // handle it in cubit
  final GlobalKey<CustomDropdownState> _dropdownKey2 =
      GlobalKey(); // handle it in cubit
  bool isValid = false;
  void _submitForm() {
    if (_dropdownKey.currentState!.validate() &&
        _dropdownKey2.currentState!.validate()) {
      // Proceed with form submission
      isValid = true;

      print("Form is valid");
    } else {
      // Show error or handle invalid state
      isValid = false;
      print("Form is invalid");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "تاريخ الأشعة",
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(10),

        // DateFormField(),

        /// size between each categogry
        verticalSpacing(16),
        CustomDropdown(
          key: _dropdownKey,
          categoryLabel: "منطقة الأشعة", // Another Dropdown Example
          hintText: "اختر العضو الخاص بالأشعة",
          isRequired: true,
          options: [
            "أشعة الصدر",
            "أشعة البطن",
            "أشعة اليد",
            "أشعة القدم",
            "أشعة العمود الفقري",
            "أشعة الأسنان",
          ],
          onSelected: (value) {
            log("xxx:Selected: $value");
          },
        ),
        verticalSpacing(16),
        CustomDropdown(
          key: _dropdownKey2,
          categoryLabel: "النوع ", // Another Dropdown Example
          hintText: "اختر نوع الأشعة",
          isRequired: true,
          options: [
            "فحص الدم",
            "فحص البول",
            "فحص القلب",
            "أشعة سينية",
          ],
          onSelected: (value) {
            log("xxx:Selected: $value");
          },
        ),
        verticalSpacing(16),

        CustomDropdown(
          categoryLabel: "نوعية الاحتياج للأشعة", // Another Dropdown Example
          hintText: "اختر نوعية احتياجك للأشعة",
          options: [
            "فحص الدم",
            "فحص البول",
            "فحص القلب",
            "أشعة سينية",
          ],
          onSelected: (value) {
            log("xxx:Selected: $value");
          },
        ),
        verticalSpacing(16),
        Text(
          "الصورة",
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(10),
        CustomContainer(
          imagePath: "assets/images/camera_icon.png",
          label: "التقط الأشعة بالكاميرا",
          onTap: () {},
        ),
        verticalSpacing(8),
        CustomContainer(
          imagePath: "assets/images/photo_icon.png",
          label: "اختر صورة من الجهاز",
          onTap: () {},
        ),
        verticalSpacing(16),
        Text(
          "التقرير الطبي",
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(10),
        CustomContainer(
          imagePath: "assets/images/t_shape_icon.png",
          label: "اكتب التقرير",
          onTap: () {},
        ),

        verticalSpacing(8),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomImageButton(
                imagePath: "assets/images/camera_icon.png",
                title: "التقط بالكاميرا",
                onTap: () {},
              ),
            ),
            horizontalSpacing(15),
            Expanded(
              flex: 3,
              child: CustomImageButton(
                imagePath: "assets/images/photo_icon.png",
                title: "ارفق صورة من الجهاز",
                onTap: () {},
              ),
            ),
          ],
        ),
        verticalSpacing(16),

        /// الأعراض المستدعية للاجراء"

        CustomDropdown(
          hintText: "اختر الأعراض المستدعية",
          categoryLabel: "الأعراض المستدعية للاجراء",
          options: [
            "فحص الدم",
            "فحص البول",
            "فحص القلب",
            "أشعة سينية",
          ],
          onSelected: (value) {
            log("xxx:Selected: $value");
          },
        ),

        verticalSpacing(16),

        /// طبيب الأشعة

        CustomDropdown(
          //! write by ur hand
          categoryLabel: "طبيب الأشعة",
          hintText: "اختر اسم طبيب الأشعة",
          options: [
            "د / محمد محمد",
            "د / كريم محمد",
            "د / رشا محمد",
            "د / رشا مصطفى",
          ],
          onSelected: (value) {
            log("xxx:Selected: $value");
          },
        ),
        verticalSpacing(16),

        /// المركز / المستشفى
        CustomDropdown(
          //! write by ur hand
          categoryLabel: "المركز / المستشفى",
          hintText: "اختر اسم المستشفى/المركز",
          options: [
            "مستشفى القلب",
            "مستشفى العين الدولى",
            "مستشفى 57357",
          ],
          onSelected: (value) {
            log("xxx:Selected: $value");
          },
        ),
        verticalSpacing(16),

        /// الطبيب المعالج
        CustomDropdown(
          //! write by ur hand
          categoryLabel: "الطبيب المعالج",
          hintText: "اختر اسم الطبيب المعالج (جراح/باطنة)",
          options: [
            "د / محمد محمد",
            "د / كريم محمد",
            "د / رشا محمد",
            "د / رشا مصطفى",
          ],
          onSelected: (value) {
            log("xxx:Selected: $value");
          },
        ),
        verticalSpacing(16),

        ///الدولة
        CustomDropdown(
          //! write by ur hand
          categoryLabel: "الدولة",
          hintText: "اختر اسم الدولة",
          options: [
            "مصر",
            "الامارات",
            "السعوديه",
            "الكويت",
            "العراق",
          ],
          onSelected: (value) {
            log("xxx:Selected: $value");
          },
        ),
        verticalSpacing(16),
        Text(
          "ملاحظات شخصية",
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(10),
        CustomTextField(
          validator: (value) {},
          isPassword: false,
          showSuffixIcon: false,
          keyboardType: TextInputType.number,
          hintText: "اكتب باختصار أى معلومات مهمة أخرى",
        ),

        /// final section
        verticalSpacing(32),
        AppCustomButton(
          title: "ارسال",
          onPressed: _submitForm,
          isEnabled: isValid ? true : false,
        ),
        verticalSpacing(71),
      ],
    );
  }
}

class CustomDropdown extends StatefulWidget {
  final String categoryLabel;
  final String hintText;
  final List<String> options;
  final Function(String) onSelected;
  final bool isRequired; // Add this to mark the dropdown as required

  const CustomDropdown({
    super.key,
    required this.categoryLabel,
    required this.hintText,
    required this.options,
    required this.onSelected,
    this.isRequired = false, // Default to false
  });

  @override
  CustomDropdownState createState() => CustomDropdownState();
}

class CustomDropdownState extends State<CustomDropdown> {
  String? selectedValue;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _dropdownKey = GlobalKey();

  bool _isValid = true; // Track validation state

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _showDropdown();
    } else {
      _removeDropdown();
    }
  }

  void _showDropdown() {
    RenderBox renderBox =
        _dropdownKey.currentContext!.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Dismiss when tapping outside
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _removeDropdown,
            ),
          ),

          // Dropdown Menu
          Positioned(
            width: renderBox.size.width,
            left: offset.dx,
            top: offset.dy + renderBox.size.height + 8.h,
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: 250.h, // Ensures list is scrollable
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(
                    color: AppColorsManager.placeHolderColor,
                    width: 1,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.options.map((option) {
                      return RadioListTile<String>(
                        selected: selectedValue == option,
                        shape: RoundedRectangleBorder(
                          // Ensure background applies correctly
                          borderRadius: BorderRadius.circular(
                              12.r), // Add rounded corners
                        ),
                        tileColor: selectedValue == option
                            ? AppColorsManager.mainDarkBlue
                            : Colors.transparent,
                        fillColor: WidgetStateProperty.resolveWith<Color?>(
                          (states) {
                            if (states.contains(WidgetState.selected)) {
                              return AppColorsManager.mainDarkBlue;
                            }
                            return AppColorsManager.placeHolderColor;
                          },
                        ),
                        title: Text(
                          option,
                          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                            color: selectedValue == option
                                ? AppColorsManager.mainDarkBlue
                                : null,
                          ),
                        ),
                        value: option,
                        groupValue: selectedValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue = newValue;
                            _isValid = true; // Reset validation on selection
                          });
                          widget.onSelected(newValue!);
                          _removeDropdown();
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // Method to validate the dropdown
  bool validate() {
    if (widget.isRequired && selectedValue == null) {
      setState(() {
        _isValid = false; // Set validation to false if no value is selected
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.categoryLabel,
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(10),
        GestureDetector(
          onTap: () {
            _toggleDropdown();
            setState(() {});
          },
          child: CompositedTransformTarget(
            link: _layerLink,
            child: Container(
              key: _dropdownKey,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: _isValid
                      ? (_overlayEntry == null
                          ? AppColorsManager.placeHolderColor
                          : AppColorsManager.mainDarkBlue)
                      : Colors.red, // Red border for invalid state
                ),
                color: AppColorsManager.textfieldInsideColor.withAlpha(100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedValue ?? widget.hintText,
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          selectedValue == null ? Colors.black54 : Colors.black,
                    ),
                  ),
                  Image.asset(
                    _overlayEntry == null
                        ? "assets/images/arrow_up_icon.png"
                        : "assets/images/arrow_down_icon.png",
                    height: 24.h,
                    width: 16.w,
                  )
                ],
              ),
            ),
          ),
        ),
        if (!_isValid) // Show validation error message
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text(
              "هذا الحقل مطلوب",
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }
}

class CustomContainer extends StatelessWidget {
  final String imagePath;
  final String label;
  final void Function()? onTap;
  const CustomContainer({
    super.key,
    required this.imagePath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52.h, // Fixed height
        padding: EdgeInsets.symmetric(horizontal: 16), // Padding: Left & Right
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), // Rounded corners
          border: Border.all(
            color: Color(0xFF555555), // Border color from image
            width: 0.8, // Border width
          ),
          // gradient: LinearGradient(
          //   colors: [
          //     Color(0xFFECF5FF),
          //     Color(0xFFFBFDFF),
          //   ],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          color: AppColorsManager.textfieldInsideColor.withAlpha(100),
        ),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              width: 23.3.h,
              height: 21.w,
            ),
            horizontalSpacing(18.3),
            Text(
              label,
              style: AppTextStyles.font16DarkGreyWeight400,
            ),
            Spacer(),
            Image.asset(
              "assets/images/image_arrow.png",
              height: 15.h,
              width: 17.w,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomImageButton extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const CustomImageButton({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56.h,
        padding: EdgeInsets.symmetric(horizontal: 6.w), // Padding from Figma
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r), // Border radius
          border: Border.all(
            color: Color(0xFF555555), // Border color
            width: 0.8, // Border width
          ),
          // gradient: LinearGradient(
          //   colors: [
          //     Color(0xFFECF5FF),
          //     Color(0xFFFBFDFF)
          //   ], // Background gradient
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          color: AppColorsManager.textfieldInsideColor.withAlpha(100),
        ),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              width: 24, // Adjust image size if necessary
              height: 24,
              fit: BoxFit.contain,
            ),
            horizontalSpacing(8),
            Text(
              title,
              style: AppTextStyles.font16DarkGreyWeight400,
              overflow: TextOverflow.ellipsis, // Prevents overflow issues
            ),
          ],
        ),
      ),
    );
  }
}
