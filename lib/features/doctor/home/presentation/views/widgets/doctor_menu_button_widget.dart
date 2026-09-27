import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/doctor/home/logic/cubit/doctor_home_cubit.dart';
import 'package:we_care/generated/l10n.dart';

enum _DoctorMenuAction {
  basicData,
  accountStatements,
  onlineExamStats,
  changePassword,
  logout,
}

/// Three-dot overflow menu shown next to the doctor photo on Home.
/// `accountStatements` and `onlineExamStats` have no destination screen yet,
/// so those two items are no-ops on tap until that work lands — rendered at
/// full color (not Material's disabled/dimmed style) per design. `logout`
/// goes through [DoctorHomeCubit], provided by the home view.
class DoctorMenuButtonWidget extends StatelessWidget {
  const DoctorMenuButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    //* Sized/spaced exactly like the patient home's overflow menu
    //* (HomeCustomAppBarWidget): a tight 20x24 slot the 30px icon overflows,
    //* so the dots sit flush against the photo without IconButton padding.
    return SizedBox(
      width: 20,
      height: 24,
      child: PopupMenuButton<_DoctorMenuAction>(
        icon: Icon(
          Icons.more_vert,
          size: 30,
          color: AppColorsManager.mainDarkBlue,
        ),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        color: AppColorsManager.scaffoldBackGroundColor,
        offset: const Offset(-10, 35),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        onSelected: (action) {
          switch (action) {
            case _DoctorMenuAction.basicData:
              Navigator.pushNamed(context, Routes.doctorBasicDataView);
            case _DoctorMenuAction.changePassword:
              Navigator.pushNamed(context, Routes.changePasswordView);
            case _DoctorMenuAction.logout:
              context.read<DoctorHomeCubit>().logout();
            case _DoctorMenuAction.accountStatements:
            case _DoctorMenuAction.onlineExamStats:
              break;
          }
        },
        itemBuilder: (context) => [
          _popupItem(
            icon: Icons.description_outlined,
            label: S.of(context).basicDataAction,
            value: _DoctorMenuAction.basicData,
          ),
          _popupItem(
            icon: Icons.receipt_long_outlined,
            label: S.of(context).accountStatementsAction,
            value: _DoctorMenuAction.accountStatements,
          ),
          _popupItem(
            icon: Icons.bar_chart_outlined,
            label: S.of(context).onlineExamStatsAction,
            value: _DoctorMenuAction.onlineExamStats,
          ),
          _popupItem(
            icon: Icons.lock_outline,
            label: S.of(context).changePassword,
            value: _DoctorMenuAction.changePassword,
          ),
          _popupItem(
            icon: Icons.logout,
            label: S.of(context).logoutAction,
            value: _DoctorMenuAction.logout,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  PopupMenuItem<_DoctorMenuAction> _popupItem({
    required IconData icon,
    required String label,
    required _DoctorMenuAction value,
    bool isDestructive = false,
  }) {
    final color = isDestructive
        ? AppColorsManager.warningColor
        : AppColorsManager.mainDarkBlue;
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              color: isDestructive ? color : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
