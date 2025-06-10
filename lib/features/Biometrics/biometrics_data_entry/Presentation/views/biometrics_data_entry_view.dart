import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/features/Biometrics/biometrics_data_entry/logic/cubit/biometrics_data_entry_cubit.dart';
import 'package:we_care/features/medicine/data/models/get_all_user_medicines_responce_model.dart';

class BiometricsDataEntryView extends StatelessWidget {
  const BiometricsDataEntryView({
    super.key,
    this.medicineToEdit,
  });
  final MedicineModel? medicineToEdit;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<BiometricsDataEntryCubit>(
      create: (context) => getIt<BiometricsDataEntryCubit>(),
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
                BiometricBodyDataEntryView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BiometricBodyDataEntryView extends StatelessWidget {
  const BiometricBodyDataEntryView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
