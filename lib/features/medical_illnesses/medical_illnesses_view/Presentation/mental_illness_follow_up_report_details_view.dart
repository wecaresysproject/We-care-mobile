import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medical_illnesses/data/models/mental_illness_follow_up_report_model.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_view/Presentation/widgets/section_info_details_widget.dart';

// Main screen implementation
class MentalIllnessFollowUpReportDetailsView extends StatelessWidget {
  const MentalIllnessFollowUpReportDetailsView(
      {super.key, required this.detailsModel});
  final MentalIllnessFollowUpReportModel detailsModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.h,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        child: Column(
          spacing: 16,
          children: [
            AppBarWithCenteredTitle(
              title: detailsModel.title,
              titleColor: AppColorsManager.mainDarkBlue,
              shareFunction: () {},
              showShareButtonOnly: true,
            ),
            // Depression Level Section
            CustomInfoSection(
              headerIcon: Icons.trending_down,
              headerTitle: 'المستوى الإكتئابي',
              content:
                  'الخطر مرتفع - يشير إلى وجود أفكار خطيرة تتطلب تدخل نفسي عاجل وقيما متضمنها لتجديد مستوى الخطورة والدعم المناسب.',
            ),

            // Positive Responses Count Section
            CustomInfoSection(
              headerIcon: Icons.check_circle,
              headerTitle: 'عدد الإجابات الإيجابية',
              content:
                  'عدد كبير نسبيا هنا يشير إلى نمط تفكيري سلبي عميق قد يتداخل مع أفكار إيذاء الذات أو الانسحاب من الحياة.',
            ),

            // Notes Section
            CustomInfoSection(
              headerIcon: Icons.question_mark,
              headerTitle: 'ملاحظة',
              content:
                  'هذا التحليل يعكس النمط الإكتئابي، وقد لا تنطبق جميع النقاط على حالتك نحن ندعوك لتأمل ما يناسب تجربتك تحديدا.',
            ),

            // Current Status Section
            CustomInfoSection(
              headerIcon: Icons.psychology,
              headerTitle: 'ملخص الحالة',
              content:
                  '''تشير حاجاتك إلى وجود مستوى مرتفع من التفكير السلبي المزمن المتزايد بعدم القيمة والرغبة في الانسحاب.

مؤشرات أخذك متتالية تعاني بالتأثير أو القلق من تجارب يومية. يعتبر هذه الأفكار تكون مجرد تحليلات حزين لل ذات الشكل نحو الموت أو رغبة اكتئاب الذات أو الرغبة تحديدا.

الأمر يا رفيق وفقا رغبة في الانتحار، قد يكون تعامل الهروب من ألم داخلي لم تقم بمعالجته بشكل آمن وصحيح.''',
            ),
            CustomInfoSection(
              headerIcon: Icons.edit_note,
              headerTitle: 'ما الذي نلاحظه في إجابتك ؟',
              content: '''
• وجود أفكار انتحارية مباشرة أو غير مباشرة، مثل تمني عدم الاستيقاظ، أو الرغبة في الهروب، أو التفكير بشكل متكرر في شكل العالم بدونك.

• شعور عميق بانعدام القيمة الذاتية، مثل: "أنا عبء"، أو "لن يلاحظ أحد غيابي"، مما يدل على فراغ داخلي واحتياج غير مشبع للاحتواء أو التقدير.

• ظهور أفكار مزمنة تتعلق بالهروب، كأنك تبحث عن طريقة غير مؤذية للاختفاء من الضغوط. بعض الإجابات قد تدل على تاريخ سابق لمحاولات إيذاء النفس أو تفكير جاد في ذلك، مما يستدعي المراقبة والمتابعة دون تأجيل. رؤية قاتمة للمستقبل، وغياب الأمل في تحسن الأمور، وهي إحدى علامات الاكتئاب التسلي المرتبط بالخمول العاطفي واليأس الصامت.

• غياب شبكة دعم نفسية كافية، أو على الأقل شعورك الداخلي بأن لا أحد سيفهمك، أو يخفف عنك.
''',
            ),
          ],
        ),
      ),
    );
  }
}
