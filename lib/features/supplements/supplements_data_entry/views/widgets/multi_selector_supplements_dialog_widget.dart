import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class MultiSelectSupplementsDialog extends StatefulWidget {
  final String dateTitle;
  final List<String> items;
  final ValueChanged<List<String>> onSubmit;

  const MultiSelectSupplementsDialog({
    super.key,
    required this.dateTitle,
    required this.items,
    required this.onSubmit,
  });
  static Future<void> show(
    BuildContext context, {
    required String dateTitle,
    required List<String> items,
    required ValueChanged<List<String>> onSubmit,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => MultiSelectSupplementsDialog(
        dateTitle: dateTitle,
        items: items,
        onSubmit: onSubmit,
      ),
    );
  }

  @override
  State<MultiSelectSupplementsDialog> createState() =>
      _MultiSelectSupplementsDialogState();
}

class _MultiSelectSupplementsDialogState
    extends State<MultiSelectSupplementsDialog> {
  final List<String> _selected = [];

  void toggleItem(String item) {
    setState(() {
      if (_selected.contains(item)) {
        _selected.remove(item);
      } else {
        _selected.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "فيتامينات اليوم ${widget.dateTitle}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: ListView.builder(
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  final item = widget.items[index];
                  final bool isSelected = _selected.contains(item);

                  return ListTile(
                    title: Text(
                      item,
                      textDirection: TextDirection.rtl,
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_box,
                            color: AppColorsManager.mainDarkBlue,
                          )
                        : const Icon(
                            Icons.check_box_outline_blank,
                          ),
                    onTap: () => toggleItem(item),
                  );
                },
              ),
            ),
            verticalSpacing(20),
            SizedBox(
              width: double.infinity,
              child: AppCustomButton(
                onPressed: () {
                  widget.onSubmit(_selected);
                  Navigator.pop(context);
                },
                title: "حفظ",
                isEnabled: _selected.isNotEmpty,
              ),
            )
          ],
        ),
      ),
    );
  }
}
