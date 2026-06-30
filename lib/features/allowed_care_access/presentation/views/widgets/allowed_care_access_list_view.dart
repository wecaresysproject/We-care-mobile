import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/networking/models/care_context_manager_model.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/allowed_care_access/data/models/care_profile.dart';
import 'package:we_care/features/allowed_care_access/presentation/logic/access_management_state.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/care_profile_card.dart';

class AllowedCareAccessListView extends StatelessWidget {
  final AccessManagementState state;
  final List<CareProfile> profiles;

  const AllowedCareAccessListView({
    super.key,
    required this.state,
    required this.profiles,
  });

  @override
  Widget build(BuildContext context) {
    switch (state.allowedCareAccessStatus) {
      case RequestStatus.initial:
      case RequestStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case RequestStatus.failure:
        return Center(
          child: Text(
            state.allowedCareAccessMessage,
            style: const TextStyle(color: Colors.red),
          ),
        );

      case RequestStatus.success:
        if (profiles.isEmpty) {
          return const Center(
            child: Text(
              'لا يوجد أشخاص مضافون حالياً',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: profiles.length,
          itemBuilder: (context, index) {
            return CareProfileCard(
              profile: profiles[index],
              onEnterPressed: () {
                final currentProfile = profiles[index];
                CareContextManager.enter(
                  accessId: currentProfile.id,
                  patientId: currentProfile.patientId,
                  patientName: currentProfile.name,
                  modulePermissions: currentProfile.modulePermissions,
                );
                context.pushNamedAndRemoveUntil(
                  Routes.bottomNavBar,
                  predicate: (route) => false,
                );
              },
            );
          },
        );
    }
  }
}
