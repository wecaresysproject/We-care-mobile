import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/SharedWidgets/error_view_widget.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/bookings/logic/cubit/bookings_cubit.dart';
import 'package:we_care/features/doctor/bookings/presentation/views/widgets/bookings_content_widget.dart';
import 'package:we_care/features/doctor/bookings/presentation/views/widgets/bookings_shimmer_widget.dart';

class BookingsView extends StatelessWidget {
  const BookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BookingsCubit>()..getBookings(),
      child: Scaffold(
        backgroundColor: AppColorsManager.scaffoldBackGroundColor,
        body: SafeArea(
          // Reference design lays this screen out at fixed physical
          // positions, not mirrored for Arabic — see the Home screen's
          // Directionality wrap for the full rationale.
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: BlocBuilder<BookingsCubit, BookingsState>(
              buildWhen: (previous, current) =>
                  previous.status != current.status,
              builder: (context, state) {
                switch (state.status) {
                  case RequestStatus.initial:
                  case RequestStatus.loading:
                    return const BookingsShimmerWidget();
                  case RequestStatus.failure:
                    return ErrorViewWidget(
                      errorMessage: state.message,
                      onRetry: () =>
                          context.read<BookingsCubit>().getBookings(),
                    );
                  case RequestStatus.success:
                    return BookingsContentWidget(bookings: state.bookings!);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
