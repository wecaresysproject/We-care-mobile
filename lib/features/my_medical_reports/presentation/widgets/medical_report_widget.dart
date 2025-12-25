import 'package:flutter/material.dart';
import '../../../../core/global/theming/color_manager.dart';

class MedicalReportWidget extends StatelessWidget {
  const MedicalReportWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: 1200, // Fixed width for landscape layout
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildBasicInfoSection(),
                  const SizedBox(height: 24),
                  _buildVitalSignsSection(),
                  const SizedBox(height: 24),
                  _buildComplaintsSection(),
                  const SizedBox(height: 24),
                  _buildMedicationsSection(),
                  const SizedBox(height: 24),
                  _buildAllergiesSection(),
                  const SizedBox(height: 24),
                  _buildSurgeriesSection(),
                  const SizedBox(height: 24),
                  _buildLabResultsSection(),
                  const SizedBox(height: 24),
                  _buildVaccinationsSection(),
                  const SizedBox(height: 24),
                  _buildFamilyHistorySection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppColorsManager.mainDarkBlue,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Right Side: Patient Info
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/ai_image.png'), // Placeholder
                    fit: BoxFit.cover,
                  ),
                ),
                // Fallback if asset not found
                child: const Icon(Icons.person, color: Colors.white, size: 40),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'تاريخ الانشاء: 25/10/2025',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  Text(
                    'الاسم: أحمد محمد',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          
          // Center: Title
          Row(
            children: const [
              Icon(Icons.medical_services_outlined, color: Colors.white, size: 40),
              SizedBox(width: 10),
              Text(
                'تقرير طبي شخصي',
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          // Left Side: Logo
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: const [
                 Icon(Icons.local_hospital, color: AppColorsManager.mainDarkBlue, size: 30),
                 Text('WE CARE SYS', style: TextStyle(color: AppColorsManager.mainDarkBlue, fontWeight: FontWeight.bold, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColorsManager.babyBlueColor, width: 2)),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColorsManager.mainDarkBlue,
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColorsManager.scaffoldBackGroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('البيانات الأساسية'),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoItem('النوع:', 'ذكر'),
              _buildInfoItem('السن:', '35 عام'),
              _buildInfoItem('المحافظة:', 'القاهرة'),
              _buildInfoItem('البلد:', 'مصر'), // Added country as placeholder
              _buildInfoItem('فصيلة الدم:', 'B+'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Row(
      children: [
        Text(label, style: const TextStyle(color: AppColorsManager.mainDarkBlue, fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(width: 8),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildVitalSignsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColorsManager.scaffoldBackGroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('القياسات الحيوية'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildVitalCard('سكر عشوائي', '180', '20/12/2024', Icons.bloodtype),
              _buildVitalCard('الضغط', '120/80', '20/12/2024', Icons.speed),
              _buildVitalCard('مستوى الأكسجين', '95 %', '23/6/2024', Icons.air),
              _buildVitalCard('نبضات القلب', '60', '20/12/2024', Icons.monitor_heart),
              _buildVitalCard('درجة الحرارة', '37.4', '23/12/2024', Icons.thermostat),
              _buildVitalCard('مؤشر كتلة الجسم', '22.9', '23/12/2024', Icons.accessibility_new),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVitalCard(String title, String value, String date, IconData icon) {
    return Container(
      width: 350, // Fixed width for grid items
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColorsManager.mainDarkBlue),
            ),
            child: Icon(icon, color: AppColorsManager.mainDarkBlue, size: 30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(color: AppColorsManager.mainDarkBlue, fontWeight: FontWeight.bold)),
                    Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColorsManager.scaffoldBackGroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('الشكاوى المرضية'),
          const SizedBox(height: 16),
          _buildTableHeader(['المنطقة', 'الشكوى', 'طبيعة الشكوى', 'حدة الشكوى', 'تاريخ الشكوى']),
          const Divider(),
          _buildTableRow(['اليد', 'هذا النص مثال لنص اخر يمكن استبداله', 'مستمرة', 'خفيف', '22/7/2024']),
          const Divider(),
          _buildTableRow(['الرأس', 'هذا النص مثال لنص اخر يمكن استبداله', 'مستمرة', 'خفيف', '22/7/2024']),
          const Divider(),
          _buildTableRow(['الرأس', 'صداع نصفي هذا النص مثال', 'مستمرة', 'خفيف', '22/7/2024']),
        ],
      ),
    );
  }

  Widget _buildMedicationsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColorsManager.scaffoldBackGroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('الأدوية الحالية المستمرة'),
          const SizedBox(height: 16),
          _buildTableHeader(['اسم الدواء', 'الجرعة', 'عدد مرات الجرعة اليومية', 'مدة الاستخدام']),
          const Divider(),
          _buildTableRow(['الكلورديازيبوكسيد', 'قرصين', 'بعد العشاء', '3 أسابيع']),
          const Divider(),
          _buildTableRow(['نوردازيام', 'قرص', '3 مرات باليوم', '4 أسابيع']),
        ],
      ),
    );
  }

  Widget _buildAllergiesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColorsManager.scaffoldBackGroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('الحساسية'),
          const SizedBox(height: 16),
          _buildTableHeader(['المادة', 'رد الفعل', 'الشدة']),
          const Divider(),
          _buildTableRow(['البنسلين', 'طفح جلدي', 'متوسطة']),
          const Divider(),
          _buildTableRow(['الفول السوداني', 'ضيق تنفس', 'شديدة']),
        ],
      ),
    );
  }

  Widget _buildSurgeriesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColorsManager.scaffoldBackGroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('العمليات الجراحية'),
          const SizedBox(height: 16),
          _buildTableHeader(['العملية', 'التاريخ', 'المستشفى', 'ملاحظات']),
          const Divider(),
          _buildTableRow(['استئصال الزائدة', '15/03/2018', 'مستشفى السلام', 'ناجحة']),
          const Divider(),
          _buildTableRow(['تصحيح نظر', '10/11/2020', 'مستشفى العيون', 'ليزر']),
        ],
      ),
    );
  }

  Widget _buildLabResultsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColorsManager.scaffoldBackGroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('نتائج التحاليل'),
          const SizedBox(height: 16),
          _buildTableHeader(['اسم التحليل', 'النتيجة', 'المعدل الطبيعي', 'التاريخ']),
          const Divider(),
          _buildTableRow(['Hemoglobin', '13.5 g/dL', '13.0 - 17.0', '20/12/2024']),
          const Divider(),
          _buildTableRow(['Cholesterol', '190 mg/dL', '< 200', '20/12/2024']),
        ],
      ),
    );
  }

  Widget _buildVaccinationsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColorsManager.scaffoldBackGroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('التطعيمات'),
          const SizedBox(height: 16),
          _buildTableHeader(['اللقاح', 'التاريخ', 'الجرعة']),
          const Divider(),
          _buildTableRow(['Influenza', '01/10/2024', '0.5 ml']),
          const Divider(),
          _buildTableRow(['COVID-19', '15/05/2021', 'الجرعة الأولى']),
        ],
      ),
    );
  }

  Widget _buildFamilyHistorySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColorsManager.scaffoldBackGroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('التاريخ العائلي'),
          const SizedBox(height: 16),
          _buildTableHeader(['الحالة', 'صلة القرابة', 'ملاحظات']),
          const Divider(),
          _buildTableRow(['السكري', 'الأب', 'النوع الثاني']),
          const Divider(),
          _buildTableRow(['ارتفاع ضغط الدم', 'الأم', '-']),
        ],
      ),
    );
  }

  Widget _buildTableHeader(List<String> cells) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: cells.map((cell) => Expanded(
          child: Text(
            cell,
            style: const TextStyle(color: AppColorsManager.mainDarkBlue, fontWeight: FontWeight.bold, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildTableRow(List<String> cells) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: cells.map((cell) => Expanded(
          child: Text(
            cell,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        )).toList(),
      ),
    );
  }
}
