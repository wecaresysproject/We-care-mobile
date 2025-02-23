import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/x_ray_view/Presentation/views/widgets/filter_chip_item.dart';

import '../../../../../core/global/Helpers/functions.dart';
import '../../../../../core/global/theming/color_manager.dart';

class SearchFilterWidget extends StatefulWidget {
  final String filterTitle;
  final bool isYearFilter;
  final List<String> filterList;

  const SearchFilterWidget(
      {super.key,
      required this.filterTitle,
      this.isYearFilter = false,
      required this.filterList});

  @override
  _SearchFilterWidgetState createState() => _SearchFilterWidgetState();
}

class _SearchFilterWidgetState extends State<SearchFilterWidget> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  int _selectedIndex = -1;
  bool _isDropdownOpen = false;

  void _toggleOverlay() {
    if (_isDropdownOpen) {
      _closeOverlay();
    } else {
      _openOverlay();
    }
  }

  void _openOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isDropdownOpen = true;
    });
  }

  void _closeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isDropdownOpen = false;
    });
  }

  void _onChipSelected(int index) {
    _closeOverlay();
    setState(() {
      _selectedIndex = index;
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    double screenWidth = MediaQuery.of(context).size.width;

    return OverlayEntry(
      builder: (context) => Positioned(
        left: 16,
        right: 16,
        top: offset.dy + renderBox.size.height + 5.h,
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(12.0),
          child: Container(
            width: screenWidth,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFECF5FF), Color(0xFFFBFDFF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: GridView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.isYearFilter ? 5 : 3,
                crossAxisSpacing: widget.isYearFilter ? 15.w : 8.w,
                mainAxisSpacing: widget.isYearFilter ? 16.h : 16.h,
                childAspectRatio: widget.isYearFilter ? 2 : 3,
              ),
              itemCount: widget.filterList.length,
              itemBuilder: (context, index) {
                return FilterChipItem(
                  label: widget.filterList[index],
                  isSelected: index == _selectedIndex,
                  onTap: () => _onChipSelected(index),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleOverlay,
      child: CompositedTransformTarget(
        link: _layerLink,
        child: Container(
          padding: EdgeInsets.fromLTRB(12.w, 8.h, 6.w, 10.h),
          decoration: BoxDecoration(
            color: AppColorsManager.secondaryColor,
            borderRadius: BorderRadius.circular(12.r),
            border: _selectedIndex != -1
                ? Border.all(
                    color: AppColorsManager.mainDarkBlue,
                    width: 1,
                  )
                : null,
          ),
          child: Row(
            children: [
              Text(
                widget.filterTitle,
                style: AppTextStyles.font12blackWeight400,
              ),
              horizontalSpacing(6),
              Icon(
                _selectedIndex != -1 ? Icons.expand_less : Icons.expand_more,
                color: AppColorsManager.mainDarkBlue,
                size: 22.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
