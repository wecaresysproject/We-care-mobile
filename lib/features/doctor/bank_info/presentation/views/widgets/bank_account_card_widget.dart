import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/bank_info/logic/cubit/bank_account_form_entry.dart';
import 'package:we_care/generated/l10n.dart';

/// One bank account's fields, grouped inside a bordered card so each added
/// account reads as its own unit. Field order: country, user name, bank
/// name, branch name, account number, IBAN.
class BankAccountCardWidget extends StatelessWidget {
  const BankAccountCardWidget({
    super.key,
    required this.account,
    required this.countriesNames,
    required this.onCountryChanged,
    this.onRemove,
  });

  final BankAccountFormEntry account;
  final List<String> countriesNames;
  final ValueChanged<String?> onCountryChanged;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColorsManager.basicDataTileBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColorsManager.placeHolderColor.withAlpha(60),
          width: 1.3,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (onRemove != null)
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: GestureDetector(
                onTap: onRemove,
                child: Icon(
                  Icons.close,
                  size: 20.r,
                  color: AppColorsManager.warningColor,
                ),
              ),
            ),

          // 1. Country
          UserSelectionContainer(
            categoryLabel: localization.bankInfoFormCountryLabel,
            containerHintText: account.selectedCountry ??
                localization.bankInfoFormChooseCountry,
            options: countriesNames,
            onOptionSelected: onCountryChanged,
            bottomSheetTitle: localization.bankInfoFormChooseCountry,
            searchHintText: localization.bankInfoFormChooseCountry,
          ),
          verticalSpacing(18),

          // 2. User name
          Text(
            localization.bankInfoFormUserNameLabel,
            style: AppTextStyles.font18blackWight500,
          ),
          verticalSpacing(10),
          CustomTextField(
            controller: account.userNameController,
            hintText: localization.bankInfoFormEnterUserName,
            validator: (val) => (val == null || val.trim().isEmpty)
                ? localization.required_field
                : null,
          ),
          verticalSpacing(18),

          // 3. Bank name
          Text(
            localization.bankInfoFormBankNameLabel,
            style: AppTextStyles.font18blackWight500,
          ),
          verticalSpacing(10),
          CustomTextField(
            controller: account.bankNameController,
            hintText: localization.bankInfoFormEnterBankName,
            validator: (val) => (val == null || val.trim().isEmpty)
                ? localization.required_field
                : null,
          ),
          verticalSpacing(18),

          // 4. Branch name
          Text(
            localization.bankInfoFormBranchNameLabel,
            style: AppTextStyles.font18blackWight500,
          ),
          verticalSpacing(10),
          CustomTextField(
            controller: account.branchNameController,
            hintText: localization.bankInfoFormEnterBranchName,
            validator: (val) => (val == null || val.trim().isEmpty)
                ? localization.required_field
                : null,
          ),
          verticalSpacing(18),

          // 5. Account number
          Text(
            localization.bankInfoFormAccountNumberLabel,
            style: AppTextStyles.font18blackWight500,
          ),
          verticalSpacing(10),
          CustomTextField(
            controller: account.accountNumberController,
            hintText: localization.bankInfoFormEnterAccountNumber,
            keyboardType: TextInputType.number,
            validator: (val) => (val == null || val.trim().isEmpty)
                ? localization.required_field
                : null,
          ),
          verticalSpacing(18),

          // 6. IBAN
          Text(
            localization.bankInfoFormIbanLabel,
            style: AppTextStyles.font18blackWight500,
          ),
          verticalSpacing(10),
          CustomTextField(
            controller: account.ibanController,
            hintText: localization.bankInfoFormEnterIban,
            validator: (val) => (val == null || val.trim().isEmpty)
                ? localization.required_field
                : null,
          ),
        ],
      ),
    );
  }
}
