import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';

class BottomSheetChildWidget extends StatelessWidget {
  const BottomSheetChildWidget(
      {super.key, required this.title, required this.text});

  final String title;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(10),
                color: Colors.grey.shade100,
                child: Text(
                  text,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    height: 2,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          AppCustomButton(
            title: context.translate.ok,
            isEnabled: true,
            onPressed: () => context.pop(),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
