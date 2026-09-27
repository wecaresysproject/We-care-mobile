import 'package:flutter/material.dart';
import 'package:we_care/features/doctor/home/presentation/views/doctor_home_view.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/app_bottom_nav_bar.dart';
import 'package:we_care/generated/l10n.dart';

/// Doctor's post-login shell: floating-home curved bottom nav bar (mirrors
/// the patient `CustomBottomNavBar`) over the 5 top-level tabs.
class DoctorAppShell extends StatelessWidget {
  const DoctorAppShell({super.key});

  @override
  Widget build(BuildContext context) {
    // Figma places the floating home button at the physical left, followed
    // left-to-right by file, doctors, medicine, settings — this list is now
    // read in that literal physical order (see the forced-ltr Directionality
    // in AppBottomNavBar), so home comes first.
    return AppBottomNavBar(
      initialIndex: 0,
      tabs: [
        AppBottomNavTab(
          iconAssetPath: 'assets/svgs/doctor_icon_home.svg',
          label: S.of(context).homeTab,
          body: const DoctorHomeView(),
        ),
        AppBottomNavTab(
          iconAssetPath: 'assets/svgs/doctor_icon_file.svg',
          label: S.of(context).medicalFileTab,
          body:
              UnimplementedTabPlaceholder(label: S.of(context).medicalFileTab),
        ),
        AppBottomNavTab(
          iconAssetPath: 'assets/svgs/doctor_icon_doctor.svg',
          label: S.of(context).doctorsTab,
          body: UnimplementedTabPlaceholder(label: S.of(context).doctorsTab),
        ),
        AppBottomNavTab(
          iconAssetPath: 'assets/svgs/doctor_icon_medicine.svg',
          label: S.of(context).medicineInteractionTab,
          body: UnimplementedTabPlaceholder(
            label: S.of(context).medicineInteractionTab,
          ),
        ),
        AppBottomNavTab(
          iconAssetPath: 'assets/svgs/doctor_icon_settings.svg',
          label: S.of(context).settingsTab,
          body: UnimplementedTabPlaceholder(label: S.of(context).settingsTab),
        ),
      ],
    );
  }
}
