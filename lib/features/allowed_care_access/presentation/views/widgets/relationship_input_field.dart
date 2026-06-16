import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/allowed_care_access/presentation/logic/access_management_cubit.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';

class RelationshipInputField extends StatelessWidget {
  const RelationshipInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'صلة القرابة',
          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        verticalSpacing(8),
        SizedBox(
          height: 44.h,
          child: TextField(
            controller:
                context.read<AccessManagementCubit>().relationController,
            decoration: InputDecoration(
              hintText: 'أمي، أبي، زوجتي...',
              hintStyle: AppTextStyles.font14blackWeight400.copyWith(
                color: Colors.grey.shade400,
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
