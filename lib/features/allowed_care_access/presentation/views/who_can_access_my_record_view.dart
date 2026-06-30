import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/allowed_care_access/data/models/care_profile.dart';
import 'package:we_care/features/allowed_care_access/presentation/logic/who_care_access/who_care_access_cubit.dart';
import 'package:we_care/features/allowed_care_access/presentation/logic/who_care_access/who_care_access_state.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/allowed_care_access_header.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/who_can_access_card.dart';

class WhoCanAccessMyRecordView extends StatelessWidget {
  const WhoCanAccessMyRecordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 16.0, left: 24.0, right: 24.0),
              child: const AllowedCareAccessHeader(
                title: 'الأشخاص المسموح لهم بالوصول',
                subtitle: 'قائمة بالأشخاص الذين لديهم صلاحية للوصول',
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            Expanded(
              child: BlocBuilder<WhoCareAccessCubit, WhoCareAccessState>(
                builder: (context, state) {
                  if (state.getWhoCanAccessStatus == RequestStatus.loading) {
                    return const Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFF0075FF)));
                  }
                  if (state.getWhoCanAccessStatus == RequestStatus.failure) {
                    return Center(
                      child: Text(
                        state.getWhoCanAccessMessage,
                        style: TextStyle(color: Colors.red, fontSize: 16.sp),
                      ),
                    );
                  }

                  final profiles = state.whoCanAccessList
                      .map((data) => CareProfile(
                            id: data.accessId ?? "",
                            patientId: data.patientId ?? "",
                            name: data.patientName ?? "",
                            personalPhotoUrl: data.personalPhotoUrl ?? "",
                            relation: data.relation ?? "",
                            addedAtLabel: data.joinedAt ?? "",
                            modulePermissions: data.modulePermissions ?? [],
                          ))
                      .toList();

                  if (profiles.isEmpty) {
                    return Center(
                      child: Text(
                        'لا يوجد أشخاص مسموح لهم بالوصول حالياً',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.sp,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 16.0),
                    itemCount: profiles.length,
                    itemBuilder: (context, index) {
                      return WhoCanAccessCard(
                        profile: profiles[index],
                        onManagePermissionsPressed: () async {
                          final shouldRefresh =
                              await Navigator.of(context).pushNamed(
                            Routes.whoCanAccessModulePermissionsView,
                            arguments: {
                              'requestId': profiles[index].id,
                              'modulePermissions':
                                  profiles[index].modulePermissions,
                            },
                          );

                          if (!context.mounted) return;

                          if (shouldRefresh == true) {
                            context
                                .read<WhoCareAccessCubit>()
                                .getWhoCanAccess();
                          }
                        },
                        onRevokeAccessPressed: () {
                          context.read<WhoCareAccessCubit>().revokeAccess(profiles[index].id);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
