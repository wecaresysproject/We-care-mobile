import 'package:flutter/material.dart';
import 'package:we_care/features/x_ray_view/Presentation/views/widgets/medical_test_card.dart';

class XRayDataGridView extends StatelessWidget {
  const XRayDataGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        itemCount: 4,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.65,
        ),
        itemBuilder: (context, index) {
          return MedicalTestCard(
            title: "الرنين المغناطيسي",
            date: "25/1/2025",
            region: "العين",
            reason: "صداع مزمن\nاحمرار وحكة مستمرة",
            notes: "هذا النص هو مثال نص يمكن أن يستبدل في نفس المساحة.",
          );
        },
      ),
    );
  }
}
