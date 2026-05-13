import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/risky_behaviors/data/models/risky_behavior_models.dart';
import 'package:we_care/features/risky_behaviors/risky_behaviors_data_entry_view/Presentation/views/widgets/risky_behaviors_data_entry_app_bar.dart';
import 'package:we_care/features/risky_behaviors/risky_behaviors_data_entry_view/Presentation/views/widgets/risky_behaviors_form_fields_widget.dart';
import 'package:we_care/features/risky_behaviors/risky_behaviors_data_entry_view/logic/cubit/risky_behaviors_data_entry_cubit.dart';

class RiskyBehaviorsDataEntryView extends StatelessWidget {
  const RiskyBehaviorsDataEntryView({
    super.key,
    this.existingData,
  });

  final RiskyBehaviorDetailsModel? existingData;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RiskyBehaviorsDataEntryCubit>(
      create: (context) {
        final cubit = getIt<RiskyBehaviorsDataEntryCubit>()
          ..getInitalRequests();
        if (existingData != null) {
          cubit.loadExistingData(existingData!);
        }
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.h,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const RiskyBehaviorsDataEntryAppBar(),
              verticalSpacing(24),
              const RiskyBehaviorsFormFieldsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
