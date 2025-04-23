import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

import 'filter_chip_item.dart';

class SearchFilterWidget extends StatefulWidget {
  final String filterTitle;
  final bool isYearFilter;
  final List<dynamic> filterList;
  final Function(String, dynamic) onFilterSelected;
  final bool isMedicineFilter;

  const SearchFilterWidget({
    super.key,
    required this.filterTitle,
    this.isYearFilter = false,
    required this.filterList,
    required this.onFilterSelected,
    this.isMedicineFilter = false,
  });

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
      if (_selectedIndex == index) {
        _selectedIndex = -1;
      } else {
        _selectedIndex = index;
      }
    });

    widget.onFilterSelected(
      widget.filterTitle,
      _selectedIndex != -1 ? widget.filterList[_selectedIndex] : null,
    );
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _closeOverlay, // This closes the overlay on outside tap
        child: Stack(
          children: [
            Positioned(
              left:widget.filterTitle=="اسم العملية"? offset.dx-150: offset.dx,
              top: offset.dy + renderBox.size.height + 5.h,
              width: !widget.isYearFilter? widget.filterTitle=="اسم العملية"?renderBox.size.width*3.5:renderBox.size.width*1.45:renderBox.size.width,
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(12.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFECF5FF), Color(0xFFFBFDFF)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: GestureDetector(
                    onTap: () {}, // Prevent taps inside from bubbling up
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.filterList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: FilterChipItem(
                            label: widget.filterList[index] == 0
                                ? "الكل"
                                : widget.isMedicineFilter? widget.filterList[index].toString().split(' ').first: widget.filterList[index].toString(),
                            isSelected: index == _selectedIndex,
                            onTap: () => _onChipSelected(index),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
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
          padding: EdgeInsets.fromLTRB(4.w, 8.h, 4.w, 8.h),
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
                style: AppTextStyles.font12blackWeight400.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
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
