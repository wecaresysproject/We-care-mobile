import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medicine/scheduled_medicines/logic/scheduled_medicines_list_cubit.dart';
import 'package:we_care/features/medicine/scheduled_medicines/logic/scheduled_medicines_list_state.dart';
import 'package:we_care/features/medicine/scheduled_medicines/presentation/widgets/medicine_alarm_card.dart';

class ScheduledMedicinesListView extends StatelessWidget {
  const ScheduledMedicinesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ScheduledMedicinesListCubit()..loadScheduledMedicines(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.h,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              AppBarWithCenteredTitle(
                title: 'الأدوية المجدولة',
                showActionButtons: false,
              ),
              Expanded(
                child: BlocBuilder<ScheduledMedicinesListCubit,
                    ScheduledMedicinesListState>(
                  builder: (context, state) {
                    if (state.loadingStatus == RequestStatus.loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (state.loadingStatus == RequestStatus.failure) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.errorMessage,
                              style: AppTextStyles.font16DarkGreyWeight400,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<ScheduledMedicinesListCubit>()
                                    .loadScheduledMedicines();
                              },
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state.scheduledMedicines.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_off_outlined,
                              size: 64,
                              color: AppColorsManager.placeHolderColor,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'لا توجد أدوية مجدولة حالياً',
                              style: AppTextStyles.font16DarkGreyWeight400
                                  .copyWith(
                                color: AppColorsManager.placeHolderColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        await context
                            .read<ScheduledMedicinesListCubit>()
                            .loadScheduledMedicines();
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        itemCount: state.scheduledMedicines.length,
                        itemBuilder: (context, index) {
                          final medicineAlarm = state.scheduledMedicines[index];
                          return MedicineAlarmCard(
                            medicineAlarm: medicineAlarm,
                            onStop: () async {
                              // Show confirmation dialog
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('تأكيد الإيقاف'),
                                  content: Text(
                                    'هل أنت متأكد من إيقاف تنبيهات "${medicineAlarm.medicineName}"؟',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('إلغاء'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('إيقاف'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmed == true && context.mounted) {
                                await context
                                    .read<ScheduledMedicinesListCubit>()
                                    .cancelMedicineAlarms(
                                        medicineAlarm.medicineName);
                              }
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
