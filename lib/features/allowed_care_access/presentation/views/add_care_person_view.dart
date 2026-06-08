import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/add_care_person_header.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/join_request_card.dart';

class AddCarePersonScreen extends StatelessWidget {
  const AddCarePersonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                AddCarePersonHeader(
                  onClose: () {
                    Navigator.of(context).pop();
                  },
                ),

                verticalSpacing(12),
                // Divider
                const Divider(height: 1, color: Color(0xFFEEEEEE)),

                verticalSpacing(12),

                // Content Cards - Currently only JoinRequestCard as requested
                JoinRequestCard(
                  onTap: () {
                    context.pushNamedWithSettingRootNavigator(
                      Routes.joinCareRequestView,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
