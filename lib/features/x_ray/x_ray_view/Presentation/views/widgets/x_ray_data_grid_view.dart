import 'package:flutter/material.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/medical_test_card.dart';

class MedicalItemGridView extends StatelessWidget {
  final List<dynamic> items;
  final void Function(String id) onTap;
  final List<Map<String, String>> Function(dynamic item) infoRowBuilder;
  final String Function(dynamic item) titleBuilder;

  const MedicalItemGridView({
    super.key,
    required this.items,
    required this.onTap,
    required this.infoRowBuilder,
    required this.titleBuilder,
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
            title: titleBuilder(item), // Get the title dynamically
            itemId: item.id,
            infoRows: infoRowBuilder(item), // Get the info rows dynamically
            onTap: onTap,
          );
        },
      ),
    );
  }
}
