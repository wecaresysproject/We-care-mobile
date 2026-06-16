import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/allowed_care_access/presentation/logic/access_management_cubit.dart';
import 'package:we_care/features/allowed_care_access/presentation/logic/access_management_state.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/selected_user_card.dart';

class SearchResultListBlocBuilder extends StatelessWidget {
  const SearchResultListBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccessManagementCubit, AccessManagementState>(
      buildWhen: (previous, current) {
        return previous.searchStatus != current.searchStatus ||
            previous.searchResults != current.searchResults ||
            previous.selectedUser != current.selectedUser;
      },
      builder: (context, state) {
        if (state.searchStatus == RequestStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.searchStatus == RequestStatus.failure) {
          return Center(
            child: Text(
              state.message,
              style: AppTextStyles.font14blackWeight400
                  .copyWith(color: Colors.red),
            ),
          );
        } else if (state.searchStatus == RequestStatus.success &&
            state.searchResults.isNotEmpty) {
          return Column(
            children: state.searchResults.map((user) {
              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: SelectedUserCard(
                  user: user,
                  isSelected: state.selectedUser?.userId == user.userId,
                  onTap: () {
                    context
                        .read<AccessManagementCubit>()
                        .updateSelectedUser(user);
                  },
                ),
              );
            }).toList(),
          );
        } else if (state.searchStatus == RequestStatus.success &&
            state.searchResults.isEmpty) {
          return Center(
            child: Text(
              'لا يوجد مستخدم بهذا الرقم',
              style: AppTextStyles.font14blackWeight400,
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
