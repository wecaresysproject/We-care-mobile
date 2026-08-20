import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_care/core/global/Helpers/font_weight_helper.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/online_doctor/data/models/booking_payment_method.dart';

/// قائمة طرق الدفع — دايرة الاختيار فى أول السطر والأيقونة فى آخره.
class PaymentMethodsSelector extends StatelessWidget {
  const PaymentMethodsSelector({
    super.key,
    required this.selectedMethod,
    required this.onMethodSelected,
  });

  final BookingPaymentMethod? selectedMethod;
  final ValueChanged<BookingPaymentMethod> onMethodSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final method in BookingPaymentMethod.values) ...[
          if (method != BookingPaymentMethod.values.first) verticalSpacing(16),
          _PaymentMethodRow(
            method: method,
            isSelected: selectedMethod == method,
            onTap: () => onMethodSelected(method),
          ),
        ],
      ],
    );
  }
}

class _PaymentMethodRow extends StatelessWidget {
  const _PaymentMethodRow({
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  final BookingPaymentMethod method;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _PaymentRadio(isSelected: isSelected),
              horizontalSpacing(12),
              Text(
                method.label,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeightHelper.medium,
                  fontFamily: AppStrings.cairoFontFamily,
                  color: AppColorsManager.textColor,
                  height: 27 / 18,
                ),
              ),
            ],
          ),
          SvgPicture.asset(
            method.iconAsset,
            width: method.iconSize.w,
            height: method.iconSize.h,
          ),
        ],
      ),
    );
  }
}

class _PaymentRadio extends StatelessWidget {
  const _PaymentRadio({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24.w,
      height: 24.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 3.w, color: AppColorsManager.mainDarkBlue),
      ),
      child: isSelected
          ? Container(
              width: 10.w,
              height: 10.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColorsManager.mainDarkBlue,
              ),
            )
          : null,
    );
  }
}
