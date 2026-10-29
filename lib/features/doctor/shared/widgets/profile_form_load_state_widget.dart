import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/SharedWidgets/error_view_widget.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// Shows a loader while a doctor profile module loads its saved data, an
/// error with retry if loading failed, and the form once it's ready.
///
/// The form is never shown after a failed load: saving replaces the module's
/// data on the server, so saving an empty form would wipe what was there.
class ProfileFormLoadStateWidget extends StatelessWidget {
  const ProfileFormLoadStateWidget({
    super.key,
    required this.loadStatus,
    required this.errorMessage,
    required this.onRetry,
    required this.child,
  });

  final RequestStatus loadStatus;
  final String? errorMessage;
  final VoidCallback onRetry;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    switch (loadStatus) {
      case RequestStatus.initial:
      case RequestStatus.loading:
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 120.h),
          child: Center(
            child: CircularProgressIndicator(
              color: AppColorsManager.mainDarkBlue,
            ),
          ),
        );
      case RequestStatus.failure:
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 80.h),
          child: ErrorViewWidget(
            errorMessage: errorMessage ?? 'حدث خطأ أثناء تحميل البيانات',
            onRetry: onRetry,
          ),
        );
      case RequestStatus.success:
        return child;
    }
  }
}
