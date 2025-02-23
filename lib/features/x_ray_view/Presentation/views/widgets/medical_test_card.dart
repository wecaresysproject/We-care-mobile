import 'package:flutter/material.dart';
import 'package:we_care/features/x_ray_view/Presentation/views/widgets/medical_test_card.dart';

class MedicalItemCard extends StatelessWidget {
  final dynamic item;

  const MedicalItemCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueAccent),
        gradient: LinearGradient(
          colors: [Color(0xFFECF5FF), Color(0xFFFBFDFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              item is PrescriptionData ? item.doctorName : item.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 4),
          _infoRow("التخصص:", item is PrescriptionData ? item.specialty : "-")
              .visible(item is PrescriptionData),
          _infoRow("التاريخ:", item.date),
          _infoRow("منطقة الأشعة:", item is MedicalTestData ? item.region : "-")
              .visible(item is MedicalTestData),
          _infoRow("دواعي الفحص:", item is MedicalTestData ? item.reason : "-")
              .visible(item is MedicalTestData),
          _infoRow("ملاحظات:", item is MedicalTestData ? item.notes : "-")
              .visible(item is MedicalTestData),
          _infoRow("المرض:", item is PrescriptionData ? item.condition : "-")
              .visible(item is PrescriptionData),
          const Spacer(),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              side: const BorderSide(color: Colors.blueAccent, width: 1.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "عرض المحتوى",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_back_ios, size: 14, color: Colors.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: RichText(
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        text: TextSpan(
          children: [
            TextSpan(
              text: "$label ",
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

extension WidgetVisibility on Widget {
  Widget visible(bool isVisible) {
    return isVisible ? this : const SizedBox.shrink();
  }
}

class MedicalTestData {
  final String title;
  final String date;
  final String region;
  final String reason;
  final String notes;

  MedicalTestData({
    required this.title,
    required this.date,
    required this.region,
    required this.reason,
    required this.notes,
  });
}

class PrescriptionData {
  final String doctorName;
  final String specialty;
  final String date;
  final String condition;

  PrescriptionData({
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.condition,
  });
}
