// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:we_care/core/global/Helpers/extensions.dart';
// import 'package:we_care/core/global/theming/app_text_styles.dart';
// import 'package:we_care/core/global/theming/color_manager.dart';
// import 'package:we_care/features/home_tab/Presentation/views/home_tab_view.dart';

// class CustomBottomNavBar extends StatefulWidget {
//   const CustomBottomNavBar({super.key});

//   @override
//   State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
// }

// class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
//   int _selectedIndex = 4; // Default selected index (Medical Record)

//   final List<Widget> _screens = [
//     Center(child: Text('Medical Record settingsTab')),
//     Center(child: Text('More Options pharmaInteractionTab ')),
//     Center(child: Text('More Options doctors screen ')),
//     Center(child: Text('More Options medical_recordTab')),
//     HomeTabView(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_selectedIndex], // Display selected screen
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: (index) {
//           setState(
//             () {
//               _selectedIndex = index;
//             },
//           );
//         },
//         type: BottomNavigationBarType.fixed, // Ensures icons don't shift
//         backgroundColor: Colors.white,
//         selectedItemColor:
//             AppColorsManager.mainDarkBlue, // Active item text color
//         unselectedItemColor:
//             AppColorsManager.unselectedNavIconColor, // Inactive item text color
//         showSelectedLabels: true, // Show text labels
//         showUnselectedLabels: true,
//         unselectedLabelStyle: AppTextStyles.font12blackRegular,
//         selectedLabelStyle: AppTextStyles.font12blackRegular.copyWith(
//           color: AppColorsManager.mainDarkBlue,
//           fontSize: 13.5.sp,
//         ),
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings_outlined),
//             label: context.translate.settingsTab,
//           ),
//           BottomNavigationBarItem(
//             icon: Image.asset(
//               "assets/images/unselected_medication_interaction_icon.png",
//               width: 22,
//               height: 22,
//             ),
//             label: context.translate.pharmaInteractionTab,
//             activeIcon: Image.asset(
//               "assets/images/unselected_medication_interaction_icon.png",
//               width: 22,
//               height: 22,
//               color: AppColorsManager.mainDarkBlue,
//             ),
//           ),
//           BottomNavigationBarItem(
//             icon: Image.asset(
//               "assets/images/unselected_doctors_tab_icon.png",
//               width: 22,
//               height: 22,
//               color: AppColorsManager.unselectedNavIconColor,
//             ),
//             label: context.translate.doctorsTab,
//             activeIcon: Image.asset(
//               "assets/images/unselected_doctors_tab_icon.png",
//               width: 22,
//               height: 22,
//               color: AppColorsManager.mainDarkBlue,
//             ),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.description_outlined,
//             ),
//             label: context.translate.medical_recordTab,
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.home,
//             ),
//             label: context.translate.homeTab,
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/home_tab/Presentation/views/home_tab_view.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _page = 4; // Default selected index (Home Tab)
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        buttonBackgroundColor: AppColorsManager.mainDarkBlue,
        color: Color(0xffF1F3F6),
        backgroundColor: Colors.transparent,
        index: _page,
        items: [
          CurvedNavigationBarItem(
            child: Icon(
              Icons.settings_outlined,
              color: _page == 0
                  ? Colors.white
                  : AppColorsManager.unselectedNavIconColor,
            ),
            label: _buildLabel(context.translate.settingsTab, 0),
          ),
          CurvedNavigationBarItem(
            child: Image.asset(
              "assets/images/unselected_medication_interaction_icon.png",
              width: 22,
              height: 22,
              color: _page == 1
                  ? Colors.white
                  : AppColorsManager.unselectedNavIconColor,
            ),
            label: _buildLabel(context.translate.pharmaInteractionTab, 1),
          ),
          CurvedNavigationBarItem(
            child: Image.asset(
              "assets/images/unselected_doctors_tab_icon.png",
              width: 22,
              height: 22,
              color: _page == 2
                  ? Colors.white
                  : AppColorsManager.unselectedNavIconColor,
            ),
            label: _buildLabel(context.translate.doctorsTab, 2),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.description_outlined,
              color: _page == 3
                  ? Colors.white
                  : AppColorsManager.unselectedNavIconColor,
            ),
            label: _buildLabel(context.translate.medical_recordTab, 3),
          ),
          CurvedNavigationBarItem(
            child: Image.asset(
              "assets/images/unselected_home_tab_icon.png",
              width: 22,
              height: 22,
              color: _page == 4
                  ? Colors.white
                  : AppColorsManager.unselectedNavIconColor,
            ),
            label: _buildLabel(context.translate.homeTab, 4),
          ),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      body: _screens[_page],
    );
  }

  /// 🎯 Screens corresponding to each tab
  final List<Widget> _screens = [
    Center(child: Text('Settings Screen')),
    Center(child: Text('Medication Interaction Screen')),
    Center(child: Text('Doctors Screen')),
    Center(child: Text('Medical Record Screen')),
    const HomeTabView(),
  ];

  /// 🏷 Method to dynamically build labels
  String _buildLabel(String label, int index) {
    return _page == index ? "" : label;
  }
}
