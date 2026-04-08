import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/risky_behaviors/data/models/risky_behavior_models.dart';
import 'package:we_care/features/risky_behaviors/risky_behaviors_view/logic/cubit/risky_behaviors_view_cubit.dart';
import 'package:we_care/features/risky_behaviors/risky_behaviors_view/logic/cubit/risky_behaviors_view_state.dart';
import 'package:we_care/features/risky_behaviors/risky_behaviors_view/presentation/widgets/risky_behaviors_view_app_bar.dart';

class RiskyBehaviorsDataView extends StatelessWidget {
  const RiskyBehaviorsDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: BlocBuilder<RiskyBehaviorsViewCubit, RiskyBehaviorsViewState>(
        builder: (context, state) {
          if (state.getBehaviorsStatus == RequestStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.getBehaviorsStatus == RequestStatus.failure) {
            return Center(child: Text(state.message));
          }

          final groupedBehaviors = _groupBehaviors(state.allBehaviors);

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const RiskyBehaviorsViewAppBar(),
                verticalSpacing(24),
                ...groupedBehaviors.entries.map((entry) {
                  return _SectionCard(
                    sectionTitle: entry.key,
                    behaviors: entry.value,
                  );
                }),
                verticalSpacing(40),
              ],
            ),
          );
        },
      ),
    );
  }

  Map<String, List<RiskyBehaviorDetailsModel>> _groupBehaviors(
      List<RiskyBehaviorDetailsModel> behaviors) {
    final Map<String, List<RiskyBehaviorDetailsModel>> grouped = {
      "التدخين": [],
      "الكحول": [],
      "المخدرات": [],
    };

    for (var behavior in behaviors) {
      if (grouped.containsKey(behavior.section)) {
        grouped[behavior.section]!.add(behavior);
      }
    }

    grouped.removeWhere((key, value) => value.isEmpty);

    return grouped;
  }
}

class _SectionCard extends StatelessWidget {
  final String sectionTitle;
  final List<RiskyBehaviorDetailsModel> behaviors;

  const _SectionCard({
    required this.sectionTitle,
    required this.behaviors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppColorsManager.mainDarkBlue.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionTitle,
                style:
                    AppTextStyles.font14BlueWeight700.copyWith(fontSize: 16.sp),
              ),
              IconButton(
                onPressed: () => _shareSection(sectionTitle, behaviors),
                icon: Icon(
                  Icons.share_outlined,
                  color: AppColorsManager.mainDarkBlue,
                  size: 20.sp,
                ),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          verticalSpacing(16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: behaviors.length,
            separatorBuilder: (context, index) => Divider(
              color: AppColorsManager.mainDarkBlue.withOpacity(0.1),
              height: 24.h,
            ),
            itemBuilder: (context, index) {
              return _BehaviorItem(behavior: behaviors[index]);
            },
          ),
        ],
      ),
    );
  }

  void _shareSection(
      String section, List<RiskyBehaviorDetailsModel> behaviors) {
    String text = "$section:\n\n";
    for (var b in behaviors) {
      text += "- ${b.type}:\n";
      for (var r in b.records) {
        text +=
            "  * ${r.option}: [${r.period.fromDate} إلى ${r.period.toDate ?? "الحالي"}]\n";
      }
      text += "\n";
    }
    Share.share(text);
  }
}

class _BehaviorItem extends StatelessWidget {
  final RiskyBehaviorDetailsModel behavior;

  const _BehaviorItem({required this.behavior});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              behavior.type,
              style: AppTextStyles.font14blackWeight400.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  Routes.riskyBehaviorsDataEntryView,
                  arguments: behavior,
                );
              },
              icon: Icon(
                Icons.edit,
                color: AppColorsManager.mainDarkBlue,
                size: 18.sp,
              ),
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
        verticalSpacing(8),
        ...behavior.records.map((record) {
          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColorsManager.mainDarkBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    record.option,
                    style: AppTextStyles.font14BlueWeight700
                        .copyWith(fontSize: 10.sp),
                  ),
                ),
                const Spacer(),
                Text(
                  "${record.period.fromDate} ${record.period.toDate != null ? "إلى ${record.period.toDate}" : "(مستمر)"}",
                  style: AppTextStyles.font14blackWeight400.copyWith(
                    color: Colors.grey[600],
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
