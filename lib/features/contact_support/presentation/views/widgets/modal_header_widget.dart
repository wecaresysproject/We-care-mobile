import 'package:flutter/material.dart';

class ModalHeaderWidget extends StatelessWidget {
  const ModalHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.close,
                size: 25,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
