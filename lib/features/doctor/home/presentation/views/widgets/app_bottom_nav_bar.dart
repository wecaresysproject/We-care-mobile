import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// Doctor bottom navigation shell — mirrors the patient `CustomBottomNavBar`
/// (same `curved_labeled_navigation_bar` package) so the floating home button
/// + curved bar look identical for both user types.
class AppBottomNavBar extends StatefulWidget {
  const AppBottomNavBar({super.key, required this.tabs, this.initialIndex = 0});

  final List<AppBottomNavTab> tabs;
  final int initialIndex;

  @override
  State<AppBottomNavBar> createState() => _AppBottomNavBarState();
}

class _AppBottomNavBarState extends State<AppBottomNavBar> {
  late int _page = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsManager.scaffoldBackGroundColor,
      // Figma lays these tabs out at fixed physical positions (the floating
      // home button always sits at the physical left) — forcing ltr here
      // keeps that order instead of mirroring it under the app's ambient
      // Arabic/RTL locale.
      bottomNavigationBar: Directionality(
        textDirection: TextDirection.ltr,
        child: CurvedNavigationBar(
          buttonBackgroundColor: AppColorsManager.mainDarkBlue,
          color: AppColorsManager.homeNavBarBackground,
          backgroundColor: Colors.transparent,
          index: _page,
          items: [
            for (var i = 0; i < widget.tabs.length; i++)
              CurvedNavigationBarItem(
                child: SvgPicture.asset(
                  widget.tabs[i].iconAssetPath,
                  width: 22,
                  height: 22,
                  colorFilter: ColorFilter.mode(
                    _page == i
                        ? AppColorsManager.selectedNavIconColor
                        : AppColorsManager.unselectedNavIconColor,
                    BlendMode.srcIn,
                  ),
                ),
                label: _page == i ? '' : widget.tabs[i].label,
              ),
          ],
          onTap: (index) => setState(() => _page = index),
        ),
      ),
      body: widget.tabs[_page].body,
    );
  }
}

class AppBottomNavTab {
  const AppBottomNavTab({
    required this.iconAssetPath,
    required this.label,
    required this.body,
  });

  final String iconAssetPath;
  final String label;
  final Widget body;
}

/// Placeholder body for a tab whose screen hasn't been implemented yet.
class UnimplementedTabPlaceholder extends StatelessWidget {
  const UnimplementedTabPlaceholder({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(label));
  }
}
