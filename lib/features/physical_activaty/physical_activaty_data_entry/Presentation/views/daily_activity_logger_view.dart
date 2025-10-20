import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class DailyActivityLogger extends StatefulWidget {
  const DailyActivityLogger({super.key});

  @override
  State<DailyActivityLogger> createState() => _DailyActivityLoggerState();
}

class _DailyActivityLoggerState extends State<DailyActivityLogger> {
  final List<Map<String, String>> activityList = [
    {
      'title': 'جيم خفيف',
      'subtitle': '(أوزان خفيفة)',
      'image': 'assets/images/gym.png',
    },
    {
      'title': 'جيم متوسط',
      'subtitle': '(أوزان متوسطة)',
      'image': 'assets/images/gym.png',
    },
    {
      'title': 'جيم ثقيل',
      'subtitle': '(أوزان حرة)',
      'image': 'assets/images/gym.png',
    },
    {
      'title': 'كاليستنكس',
      'subtitle': '(وزن الجسم)',
      'image': 'assets/images/calthtinces.png',
    },
    {
      'title': 'مشاية جري منزلية',
      'subtitle': '(سرعة خفيفة)',
      'image': 'assets/images/trade_mil.png',
    },
    {
      'title': 'مشاية جري منزلية',
      'subtitle': '(سرعة متوسطة)',
      'image': 'assets/images/trade_mil.png',
    },
    {
      'title': 'مشاية جري منزلية',
      'subtitle': '(سرعة عالية)',
      'image': 'assets/images/trade_mil.png',
    },
    {
      'title': 'أوربتراك',
      'subtitle': '(جهد خفيف)',
      'image': 'assets/images/aurbtrack.png',
    },
    {
      'title': 'أوربتراك',
      'subtitle': '(جهد متوسط)',
      'image': 'assets/images/aurbtrack.png',
    },
    {
      'title': 'أوربتراك',
      'subtitle': '(جهد عالٍ)',
      'image': 'assets/images/aurbtrack.png',
    },
    {
      'title': 'عجلة منزلية ثابتة',
      'subtitle': '(جهد خفيف)',
      'image': 'assets/images/bycle.png',
    },
    {
      'title': 'عجلة منزلية ثابتة',
      'subtitle': '(جهد متوسط)',
      'image': 'assets/images/bycle.png',
    },
    {
      'title': 'عجلة منزلية ثابتة',
      'subtitle': '(جهد قوي)',
      'image': 'assets/images/bycle.png',
    },
    {
      'title': 'مشي',
      'subtitle': '(عادي)',
      'image': 'assets/images/man.png',
    },
    {
      'title': 'مشي',
      'subtitle': '(متوسط السرعة)',
      'image': 'assets/images/man.png',
    },
    {
      'title': 'جري',
      'subtitle': '(خفيف)',
      'image': 'assets/images/harry_up.png',
    },
    {
      'title': 'جري',
      'subtitle': '(متوسط السرعة)',
      'image': 'assets/images/harry_up.png',
    },
    {
      'title': 'جري',
      'subtitle': '(متوسط عالي السرعة)',
      'image': 'assets/images/harry_up.png',
    },
    {
      'title': 'نط الحبل',
      'subtitle': '',
      'image': 'assets/images/jump_rope.png',
    },
    {
      'title': 'ركوب دراجات خارجية',
      'subtitle': '(منخفض السرعة)',
      'image': 'assets/images/bycle_2.png',
    },
    {
      'title': 'ركوب دراجات خارجية',
      'subtitle': '(متوسط السرعة)',
      'image': 'assets/images/bycle_2.png',
    },
    {
      'title': 'ركوب دراجات خارجية',
      'subtitle': '(مرتفع السرعة)',
      'image': 'assets/images/bycle_2.png',
    },
    {
      'title': 'سباحة',
      'subtitle': '(حرة ترفيهية)',
      'image': 'assets/images/swimming.png',
    },
    {
      'title': 'سباحة',
      'subtitle': '(جهد متوسط)',
      'image': 'assets/images/swimming.png',
    },
    {
      'title': 'سباحة',
      'subtitle': '(جهد قوي)',
      'image': 'assets/images/swimming.png',
    },
    {
      'title': 'تنس الطاولة',
      'subtitle': '(بينج بونج)',
      'image': 'assets/images/pingpong.png',
    },
    {
      'title': 'تنس الأرضي',
      'subtitle': '',
      'image': 'assets/images/tennis.png',
    },
    {
      'title': 'اسكواش',
      'subtitle': '',
      'image': 'assets/images/squash.png',
    },
    {
      'title': 'ملاكمة',
      'subtitle': '(ملاكمة على كيس)',
      'image': 'assets/images/boxing.png',
    },
    {
      'title': 'ملاكمة',
      'subtitle': '(ملاكمة متوسطة في حلبة)',
      'image': 'assets/images/boxing.png',
    },
    {
      'title': 'ملاكمة',
      'subtitle': '(ملاكمة في حلبة قوية)',
      'image': 'assets/images/boxing.png',
    },

    // ⬇️ الأنشطة الجديدة من الصورة
    {
      'title': 'جودو / كاراتيه',
      'subtitle': '',
      'image': 'assets/images/judo.png',
    },
    {
      'title': 'مصارعة',
      'subtitle': '(متوسطة)',
      'image': 'assets/images/wrestling.png',
    },
    {
      'title': 'مصارعة',
      'subtitle': '(عنيفة)',
      'image': 'assets/images/wrestling.png',
    },
    {
      'title': 'كرة القدم',
      'subtitle': '',
      'image': 'assets/images/football.png',
    },
    {
      'title': 'كرة السلة',
      'subtitle': '(تمرين بسيط)',
      'image': 'assets/images/basketball.png',
    },
    {
      'title': 'كرة السلة',
      'subtitle': '(تمرين متوسط)',
      'image': 'assets/images/basketball.png',
    },
    {
      'title': 'كرة السلة',
      'subtitle': '(مباراة)',
      'image': 'assets/images/basketball.png',
    },
    {
      'title': 'كرة اليد',
      'subtitle': '(تمرين بسيط)',
      'image': 'assets/images/handball.png',
    },
    {
      'title': 'كرة اليد',
      'subtitle': '(تمرين متوسط)',
      'image': 'assets/images/handball.png',
    },
    {
      'title': 'كرة الطائرة',
      'subtitle': '(تمرين بسيط)',
      'image': 'assets/images/handball.png',
    },
    {
      'title': 'كرة الطائرة',
      'subtitle': '(مباراة)',
      'image': 'assets/images/volleyball.png',
    },
    {
      'title': 'يوجا',
      'subtitle': '(هاتا)',
      'image': 'assets/images/yoga.png',
    },
    {
      'title': 'يوجا',
      'subtitle': '(فينياسا / أشتانجا)',
      'image': 'assets/images/yoga_vinyasa.png',
    },
    {
      'title': 'تمارين سويدي',
      'subtitle': '(جهاز / إطالة)',
      'image': 'assets/images/swedish_stretch.png',
    },
    {
      'title': 'تمارين سويدي',
      'subtitle': '(جهاز / متوسط)',
      'image': 'assets/images/swedish_stretch.png',
    },
    {
      'title': 'تمارين سويدي',
      'subtitle': '(جهاز / قوي عام)',
      'image': 'assets/images/swedish_stretch.png',
    },
    {
      'title': 'تسلق الصخور',
      'subtitle': '(صعود حوائط هادئ)',
      'image': 'assets/images/climbing.png',
    },
    {
      'title': 'تسلق الصخور',
      'subtitle': '(صعود حوائط متوسط)',
      'image': 'assets/images/climbing.png',
    },
    {
      'title': 'تسلق الصخور',
      'subtitle': '(صعود حوائط شديد)',
      'image': 'assets/images/climbing.png',
    },
  ];

  void _submitActivities() {
    // Here you would send the data to your backend

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حفظ البيانات بنجاح!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const AppBarWithCenteredTitle(
              title: 'النشاط البدنى لليوم',
              showActionButtons: false,
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: activityList.length,
              itemBuilder: (context, index) {
                final activity = activityList[index];

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  textBaseline: TextBaseline.alphabetic,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Image.asset(
                      activity['image']!,
                      width: 44.w,
                      height: 50.h,
                    ),
                    horizontalSpacing(2),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColorsManager.mainDarkBlue, width: 1),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 4.h,
                            ),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      activity['title']!,
                                      style: AppTextStyles.font18blackWight500
                                          .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColorsManager.mainDarkBlue,
                                      ),
                                    ),
                                    Text(
                                      activity['subtitle']!,
                                      style: AppTextStyles.font18blackWight500
                                          .copyWith(
                                        fontSize: 12.sp,
                                        color: AppColorsManager.mainDarkBlue,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                SizedBox(
                                  width: 90,
                                  height: 50,
                                  child: CustomTextField(
                                    hintText: 'دقيقة',
                                    validator: (value) {},
                                    controller: TextEditingController(),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            AppCustomButton(
              title: "حفظ",
              onPressed: _submitActivities,
              isEnabled: true,
            ),
          ],
        ),
      ),
    );
  }
}
