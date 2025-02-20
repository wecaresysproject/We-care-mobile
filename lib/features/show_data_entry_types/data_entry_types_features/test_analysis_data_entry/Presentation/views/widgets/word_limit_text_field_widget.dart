import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class WordLimitTextField extends StatefulWidget {
  const WordLimitTextField({super.key, this.controller});
  final TextEditingController? controller;

  @override
  WordLimitTextFieldState createState() => WordLimitTextFieldState();
}

class WordLimitTextFieldState extends State<WordLimitTextField> {
  final int maxWords = 150;
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          heightFactor: 0,
          alignment: !isArabic() ? Alignment.bottomRight : Alignment.bottomLeft,
          child: Text(
            "${countWords(widget.controller!.text)} / $maxWords ${context.translate.word}",
            textAlign: TextAlign.right,
            style: AppTextStyles.font14whiteWeight600.copyWith(
              color: countWords(widget.controller!.text) > maxWords
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textColor,
            ),
          ),
        ),
        CustomTextField(
          validator: (p0) {
            return _errorText;
          },
          controller: widget.controller,
          keyboardType: TextInputType.multiline,
          hintText: "اكتب باختصار اى معلومات مهمة اخرى",
          onChanged: (text) {
            int wordCount = countWords(text);
            if (wordCount > maxWords) {
              setState(() {
                _errorText = context.translate.word_limit_exceeded;
              });
            } else {
              setState(() {
                _errorText = null; // Clear error if within limit
              });
            }
          },
        ),
      ],
    );
  }
}
