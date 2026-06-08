import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/join_care_request_header.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/permission_selection_section.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/relationship_input_field.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/search_person_field.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/selected_user_card.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/submit_care_request_button.dart';

class JoinCareRequestScreen extends StatelessWidget {
  const JoinCareRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                JoinCareRequestHeader(
                  onBack: () {
                    Navigator.of(context).pop();
                  },
                ),

                verticalSpacing(24),

                // 2. Search Section
                const SearchPersonField(),

                verticalSpacing(16),

                // 3. Selected User Card
                const SelectedUserCard(),

                verticalSpacing(24),

                // 4. Relationship Field
                const RelationshipInputField(),

                verticalSpacing(24),

                // 5. Permission Selection Section
                const PermissionSelectionSection(),

                verticalSpacing(24),

                // 6. Information Banner
                // const CareInfoBanner(),

                verticalSpacing(60),

                // 7. Submit Button
                SubmitCareRequestButton(
                  onPressed: () {
                    // Handle submission
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
