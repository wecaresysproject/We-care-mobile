import 'package:flutter/material.dart';
import 'package:we_care/features/x_ray_view/Presentation/views/widgets/medical_test_card.dart';

class MedicalItemGridView extends StatelessWidget {
  final List<dynamic> items;

  final void Function() onTap;

  const MedicalItemGridView({
    super.key,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemBuilder: (context, index) {
          final item = items[index];
          return MedicalItemCard(
            item: item,
            onTap: onTap,
          );
        },
      ),
    );
  }
}
