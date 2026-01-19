import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:we_care/core/global/Helpers/app_dialogs.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/supplements/data/models/daily_supplement_submission_model.dart';
import 'package:we_care/features/supplements/supplements_data_entry/logic/supplements_data_entry_cubit.dart';
import 'package:we_care/features/supplements/supplements_data_entry/logic/supplements_data_entry_state.dart';
import 'package:we_care/features/supplements/supplements_data_entry/views/widgets/day_card_widget.dart';
import 'package:we_care/features/supplements/supplements_data_entry/views/widgets/multi_selector_supplements_dialog_widget.dart';

class MonthlySupplementsPlanGridViewWidget extends StatefulWidget {
  const MonthlySupplementsPlanGridViewWidget({super.key});

  @override
  State<MonthlySupplementsPlanGridViewWidget> createState() =>
      _MonthlySupplementsPlanGridViewWidgetState();
}

class _MonthlySupplementsPlanGridViewWidgetState
    extends State<MonthlySupplementsPlanGridViewWidget> {
  String? selectedDate;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupplementsDataEntryCubit, SupplementsDataEntryState>(
      builder: (context, state) {
        if (state.requestStatus == RequestStatus.loading) {
          return Skeletonizer(
            enabled: true,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: 15,
              itemBuilder: (context, index) {
                return DayCard(
                  day: 'اليوم',
                  date: '--/--/----',
                  onTap: () {},
                );
              },
            ),
          );
        }

        final days = state.days; // البيانات الراجعة من API

        // Add debug information
        if (days.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_month, size: 48, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  state.monthlyActivationStatus
                      ? 'لا توجد أيام متاحة في الخطة'
                      : 'يجب تفعيل الخطة أولاً',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemCount: days.length,
          itemBuilder: (context, index) {
            final day = days[index];
            final isFuture = isFutureDay(day.date);
            final isSelected = selectedDate == day.date;

            // اختر الـ constructor المناسب
            if (!state.monthlyActivationStatus) {
              // لو الخطة مش مفعلة خالص
              return DayCard.planNotActivated(
                day: day.dayOfWeek,
                date: day.date,
                onTap: () async {
                  await showWarningDialog(
                    context,
                    message: 'يجب تفعيل الخطة أولاً',
                  );
                },
                backgroundColor: isSelected
                    ? const Color(0xffDAE9FA)
                    : const Color(0xffF1F3F6),
              );
            } else if (isFuture) {
              return DayCard.futureDay(
                day: day.dayOfWeek,
                date: day.date,
                onTap: () async {
                  await showWarningDialog(
                    context,
                    message: "هذا اليوم لم يبدأ بعد، يرجى الانتظار حتى موعده.",
                  );
                },
              );
            } else if (state.monthlyActivationStatus && day.hasDocument) {
              // لو اليوم له تقرير
              return DayCard.planActivatedandHaveDocument(
                day: day.dayOfWeek,
                date: day.date,
                dietPlan: day.userDietPlan,
                onTap: () {
                  setState(() {
                    selectedDate = day.date;
                  });
                },
                backgroundColor: isSelected
                    ? const Color(0xffDAE9FA)
                    : const Color(0xffF1F3F6),
              );
            } else {
              // لو اليوم مفعل بس مفيش تقرير
              return DayCard.planActivatedandHaveNoDocument(
                day: day.dayOfWeek,
                date: day.date,
                onTap: () {
                  setState(
                    () {
                      selectedDate = day.date;
                    },
                  );

                  MultiSelectSupplementsDialog.show(
                    context,
                    dateTitle: selectedDate!, // Example: 15/01/2025
                    items: state.trackedSupplementsAndVitamins,
                    onSubmit: (selectedItems) {
                      AppLogger.debug("Selected: $selectedItems");
                      context
                          .read<SupplementsDataEntryCubit>()
                          .submitDailyUserTakenSupplement(
                            dailyTakenSupplements:
                                DailySupplementSubmissionModel(
                              date: selectedDate!,
                              hasDocument: true,
                              vitaminsTaken: selectedItems,
                            ),
                          );
                    },
                  );
                },
                backgroundColor: isSelected
                    ? const Color(0xffDAE9FA)
                    : const Color(0xffF1F3F6),
              );
            }
          },
        );
      },
    );
  }
}
