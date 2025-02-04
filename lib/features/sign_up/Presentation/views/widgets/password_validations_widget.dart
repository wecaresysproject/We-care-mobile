import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/generated/l10n.dart';

class PasswordValidations extends StatelessWidget {
  final bool isbetween8and15Character;
  final bool hasSpecialCharacters;
  final bool hasNumber;
  const PasswordValidations({
    super.key,
    required this.isbetween8and15Character,
    required this.hasSpecialCharacters,
    required this.hasNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildValidationRow(
            S.of(context).passwordHint1, isbetween8and15Character),
        verticalSpacing(5),
        buildValidationRow(S.of(context).passwordHint2, hasSpecialCharacters),
        verticalSpacing(5),
        buildValidationRow(S.of(context).passwordHint3, hasNumber),
        verticalSpacing(5),
      ],
    );
  }

  Widget buildValidationRow(String text, bool hasValidated) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Color(0xff909090).withAlpha(100),
          radius: 12,
          child: CircleAvatar(
            radius: 6,
            backgroundColor: hasValidated
                ? AppColorsManager.doneColor
                : AppColorsManager.warningColor,
          ),
        ),
        horizontalSpacing(6),
        Text(
          text,
          style: AppTextStyles.font12blackRegular.copyWith(
            decorationColor: Colors.green,
            decorationThickness: 2,
          ),
        )
      ],
    );
  }
}
