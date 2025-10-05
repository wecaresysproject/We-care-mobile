import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/nutration/nutration_view/logic/nutration_view_cubit.dart';

class FoodAlternativesView extends StatelessWidget {
  const FoodAlternativesView({super.key, required this.elementName});
  final String elementName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NutrationViewCubit>(
      create: (context) => getIt<NutrationViewCubit>()
        ..getFoodAlternatives(
          elementName: elementName,
        ),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.h,
        ),
        body: Column(
          children: [
            AppBarWithCenteredTitle(
              title: 'بدائل غذائية ($elementName)',
              showActionButtons: false,
            ).paddingSymmetricHorizontal(16),
            BlocBuilder<NutrationViewCubit, NutrationViewState>(
              builder: (context, state) {
                // Loading State
                if (state.requestStatus == RequestStatus.loading) {
                  return Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColorsManager.mainDarkBlue,
                      ),
                    ),
                  );
                }

                // Error State
                if (state.requestStatus == RequestStatus.failure) {
                  return Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64.sp,
                            color: Colors.red,
                          ),
                          verticalSpacing(16),
                          Text(
                            'حدث خطأ أثناء تحميل البيانات',
                            style: AppTextStyles.font16DarkGreyWeight400,
                          ),
                          verticalSpacing(8),
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<NutrationViewCubit>()
                                  .getFoodAlternatives(
                                    elementName: elementName,
                                  );
                            },
                            child: Text('إعادة المحاولة'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Empty State
                if (state.requestStatus == RequestStatus.success &&
                    state.foodAlternatives.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 64.sp,
                            color: AppColorsManager.mainDarkBlue,
                          ),
                          verticalSpacing(16),
                          Text(
                            'لا توجد بدائل غذائية متاحة',
                            style: AppTextStyles.font16DarkGreyWeight400,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Success State with Data
                return Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ...state.foodAlternatives.map((category) {
                          return Column(
                            children: [
                              SectionHeaderWidget(
                                title: '${category.type} (الكمية لكل 100 جم)',
                                icon: _getCategoryIcon(category.type),
                              ),
                              verticalSpacing(10),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  childAspectRatio: 1,
                                  crossAxisSpacing: 7,
                                  mainAxisSpacing: 10,
                                ),
                                itemCount: category.detail.length,
                                itemBuilder: (context, index) {
                                  final foodItem = category.detail[index];
                                  return FoodCard(
                                    name: foodItem.food,
                                    percent: foodItem.dailyNeed,
                                    quantity: foodItem.quantityPer100g,
                                  );
                                },
                              ),
                              verticalSpacing(20),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryIcon(String type) {
    // Match icons based on category type
    if (type.contains('خضار') ||
        type.contains('فواكه') ||
        type.contains('حبوب')) {
      return '🥗';
    } else if (type.contains('لحوم') ||
        type.contains('أسماك') ||
        type.contains('مصنعة')) {
      return '🐟';
    } else if (type.contains('ألبان')) {
      return '🥛';
    }
    return '🍽️'; // Default icon
  }
}

class SectionHeaderWidget extends StatelessWidget {
  final String title;
  final String icon;

  const SectionHeaderWidget({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: Color(0xffDAE9FA),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Text(
            icon,
            style: AppTextStyles.font16DarkGreyWeight400.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColorsManager.mainDarkBlue,
            ),
          ),
          horizontalSpacing(6),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColorsManager.mainDarkBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final String name;
  final String percent;
  final String quantity;

  const FoodCard({
    super.key,
    required this.name,
    required this.percent,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
      decoration: BoxDecoration(
        color: Color(0xffF1F3F6),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: Color(0xff555555),
          width: .9,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Food name in blue
          AutoSizeText(
            name,
            style: AppTextStyles.font14blackWeight400.copyWith(
              color: AppColorsManager.mainDarkBlue,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            minFontSize: 10,
            overflow: TextOverflow.ellipsis,
          ),

          verticalSpacing(4),

          // Protein percentage and quantity in same row
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     // Quantity column
          //     Column(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: [
          //         Text(
          //           quantity,
          //           style: AppTextStyles.font12blackWeight400.copyWith(
          //             fontWeight: FontWeight.w700,
          //           ),
          //           textAlign: TextAlign.center,
          //           maxLines: 1,
          //           overflow: TextOverflow.ellipsis,
          //         ),
          //         Text(
          //           'جم',
          //           style: AppTextStyles.font12blackWeight400.copyWith(
          //             fontWeight: FontWeight.w700,
          //             fontSize: 10.sp,
          //           ),
          //           textAlign: TextAlign.center,
          //         ),
          //       ],
          //     ),

          //     // horizontalSpacing(2),

          //     // Percentage column
          //     Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Text(
          //           percent,
          //           style: AppTextStyles.font14BlueWeight700.copyWith(
          //             color: Colors.black,
          //             fontSize: 12.sp,
          //           ),
          //         ),
          //         Text(
          //           'من الاحتياج\nاليومي',
          //           textAlign: TextAlign.center,
          //           style: AppTextStyles.font18blackWight500.copyWith(
          //             fontSize: 8.sp,
          //             fontWeight: FontWeight.w600,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
          // Protein percentage and quantity in same row
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Quantity column
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoSizeText(
                        quantity,
                        style: AppTextStyles.font12blackWeight400.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        minFontSize: 10,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                horizontalSpacing(2),
                // Percentage column
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        percent,
                        style: AppTextStyles.font14BlueWeight700.copyWith(
                          color: Colors.black,
                          fontSize: 12.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'من الاحتياج\nاليومي',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.font18blackWight500.copyWith(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
