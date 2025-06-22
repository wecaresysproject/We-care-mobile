import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_back_arrow.dart';

class EyeSyptomAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;

  const EyeSyptomAppBarWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: preferredSize.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Centered Title
          Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: 'Cairo',
              ),
              textDirection: TextDirection.rtl,
            ),
          ),

          // Positioned Icon (right side)
          Positioned(
            right: 16,
            child: CustomBackArrow(
              onTap: () {
                context.pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
