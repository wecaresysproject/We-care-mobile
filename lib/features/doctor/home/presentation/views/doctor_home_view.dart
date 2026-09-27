import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/SharedWidgets/error_view_widget.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/doctor/home/logic/cubit/doctor_home_cubit.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/doctor_home_content_widget.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/doctor_home_shimmer_widget.dart';

class DoctorHomeView extends StatelessWidget {
  const DoctorHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DoctorHomeCubit>()..getDoctorHome(),
      child: BlocListener<DoctorHomeCubit, DoctorHomeState>(
        listenWhen: (previous, current) =>
            previous.logoutStatus != current.logoutStatus,
        listener: (context, state) async {
          if (state.logoutStatus == RequestStatus.success) {
            await context.pushNamedAndRemoveUntil(
              Routes.userTypesView,
              predicate: (Route<dynamic> route) => false,
            );
          } else if (state.logoutStatus == RequestStatus.failure) {
            await showError(state.message);
          }
        },
        child: Scaffold(
          backgroundColor: AppColorsManager.homeScaffoldBackground,
          body: SafeArea(
            // The Figma design lays out this screen with fixed left-to-right
            // positions (Arabic appears only in text content, not layout
            // direction) — forcing ltr here keeps every Row's child order
            // matching Figma instead of auto-mirroring under the app's
            // ambient Arabic/RTL locale. Text still renders RTL-correct per
            // paragraph regardless of this ambient direction.
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: BlocBuilder<DoctorHomeCubit, DoctorHomeState>(
                buildWhen: (previous, current) =>
                    previous.status != current.status,
                builder: (context, state) {
                  switch (state.status) {
                    case RequestStatus.initial:
                    case RequestStatus.loading:
                      return const DoctorHomeShimmerWidget();
                    case RequestStatus.failure:
                      return ErrorViewWidget(
                        errorMessage: state.message,
                        onRetry: () =>
                            context.read<DoctorHomeCubit>().getDoctorHome(),
                      );
                    case RequestStatus.success:
                      return DoctorHomeContentWidget(
                          doctorHome: state.doctorHome!);
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
