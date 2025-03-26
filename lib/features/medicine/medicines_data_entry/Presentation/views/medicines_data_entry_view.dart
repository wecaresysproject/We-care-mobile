import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/features/medicine/medicines_data_entry/Presentation/views/widgets/medicines_data_entry_form_fields_widget.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_cubit.dart';

class MedicinesDataEntryView extends StatelessWidget {
  const MedicinesDataEntryView({
    super.key,
  });
  // final DetailedComplaintModel? complaint;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MedicinesDataEntryCubit>(
      create: (context) {
        final cubit = getIt<MedicinesDataEntryCubit>();

        /// ✅ Ensures `context` is fully mounted before calling `S.of(context)`
        // WidgetsBinding.instance.addPostFrameCallback(
        //   (_) {
        //     if (complaint != null) {
        //       cubit.loadComplaintForEditing(complaint!, S.of(context));
        //     }
        //   },
        // );
        return cubit;
      },
      child: Scaffold(
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
                MedicinesDataEntryFormFieldsWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
