import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/faq/cubits/faq/faq_cubit.dart';
import 'package:we_care/features/faq/cubits/faq/faq_state.dart';
import 'package:we_care/features/faq/repositories/faq_repository.dart';
import 'package:we_care/features/faq/services/faq_service.dart';

class FAQSectionWidget extends StatefulWidget {
  const FAQSectionWidget({super.key});

  @override
  FAQSectionWidgetState createState() => FAQSectionWidgetState();
}

class FAQSectionWidgetState extends State<FAQSectionWidget> {
  bool _isExpanded = false;
  final Set<int> _expandedQuestions = {};

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FAQCubit(
        FAQRepository(
          FAQService(),
        ),
      )..getFaq(),
      child: Card(
        elevation: 0,
        color: AppColorsManager.backGroundColor,
        surfaceTintColor: Colors.red,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
          side: BorderSide(
            color: _isExpanded
                ? AppColorsManager.mainDarkBlue
                : AppColorsManager.placeHolderColor.withAlpha(150),
            style: BorderStyle.solid,
          ),
        ),
        child: ExpansionTile(
          trailing: Image.asset(
            _isExpanded
                ? "assets/images/arrow_up.png"
                : "assets/images/arrow_down.png",
            height: 8.h,
            width: 17.w,
          ),
          backgroundColor: AppColorsManager.backGroundColor,
          collapsedIconColor: AppColorsManager.placeHolderColor,
          collapsedBackgroundColor: AppColorsManager.backGroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
            side: BorderSide(
              width: _isExpanded ? 1.5 : 1,
              strokeAlign: 70,
              color: AppColorsManager.placeHolderColor.withAlpha(
                150,
              ),
            ),
          ),
          tilePadding: EdgeInsets.symmetric(
            horizontal: 16.w,
          ),
          leading: Image.asset(
            "assets/images/faq_section_icon.png",
            width: 21.6.w,
            height: 19.5.h,
            color: _isExpanded
                ? AppColorsManager.mainDarkBlue
                : AppColorsManager.placeHolderColor,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "الأسئلة الشائعة",
                style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          onExpansionChanged: (expanded) {
            setState(
              () {
                _isExpanded = expanded;
                if (!expanded) {
                  _expandedQuestions.clear();
                }
              },
            );
          },
          children: [
            BlocBuilder<FAQCubit, FAQState>(
              builder: (context, state) {
                if (state is FAQLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is FAQError) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(child: Text(state.message)),
                  );
                } else if (state is FAQLoaded) {
                  return Column(
                    children: List.generate(
                      state.faqList.length,
                      (index) {
                        final faq = state.faqList[index];
                        return Column(
                          children: [
                            if (index > 0)
                              Divider(
                                color: AppColorsManager.placeHolderColor.withAlpha(100),
                                height: 1,
                              ),
                            _buildFAQItem(
                              question: faq.question ?? "",
                              answer: faq.answer ?? "",
                              index: index,
                            ),
                          ],
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
    required int index,
  }) {
    final isExpanded = _expandedQuestions.contains(index);

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        childrenPadding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          bottom: 12.h,
        ),
        trailing: Icon(
          isExpanded ? Icons.remove : Icons.add,
          color: AppColorsManager.mainDarkBlue,
          size: 20.sp,
        ),
        title: Text(
          question,
          style: AppTextStyles.font22MainBlueWeight700.copyWith(
            color: AppColorsManager.textColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        onExpansionChanged: (expanded) {
          setState(() {
            if (expanded) {
              _expandedQuestions.add(index);
            } else {
              _expandedQuestions.remove(index);
            }
          });
        },
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              answer,
              style: AppTextStyles.font12blackWeight400.copyWith(
                fontSize: 12.sp,
                color: AppColorsManager.textColor.withOpacity(0.8),
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
