import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class TestSelectionBottomSheet extends StatefulWidget {
  final String title;
  final List<String> options;
  final Function(String) onItemSelected;
  final String userEntryLabelText;
  final String? initialSelectedItem;
  final String searchHintText;

  const TestSelectionBottomSheet({
    super.key,
    required this.title,
    required this.options,
    required this.onItemSelected,
    required this.userEntryLabelText,
    required this.searchHintText,
    this.initialSelectedItem,
  });

  @override
  State<TestSelectionBottomSheet> createState() =>
      _TestSelectionBottomSheetState();
}

class _TestSelectionBottomSheetState extends State<TestSelectionBottomSheet> {
  late TextEditingController _searchController;
  late List<String> _filteredOptions;
  String? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialSelectedItem;
    _filteredOptions = List.from(widget.options);
    _searchController = TextEditingController();

    _searchController.addListener(_filterOptions);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterOptions);
    _searchController.dispose();
    super.dispose();
  }

  void _filterOptions() {
    final query = normalizeArabic(_searchController.text);

    if (query.isEmpty) {
      setState(() {
        _filteredOptions = List.from(widget.options);
      });
    } else {
      setState(() {
        _filteredOptions = widget.options
            .where((item) => normalizeArabic(item).contains(query))
            .toList();
      });
    }
  }

  void _selectItem(String option) {
    setState(() {
      _selectedItem = option;
    });
    widget.onItemSelected(option);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5, // Allow smaller size for better UX
      maxChildSize: 0.95, // Allow slightly larger for more content
      builder: (context, scrollController) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          // vertical: widget.allowManualEntry ? 24.h : 8.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            verticalSpacing(12),
            _buildHeader(),
            verticalSpacing(12),
            _buildSearchField(),
            verticalSpacing(16),
            _buildOptionsList(scrollController),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            widget.title,
            style: AppTextStyles.font18blackWight500.copyWith(
              color: AppColorsManager.textfieldOutsideBorderColor,
              fontSize: 16.sp,
            ),
            // textAlign: TextAlign.center,
            maxLines: 3,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Image.asset(
            "assets/images/close_icon.png",
            height: 20,
            width: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search, color: Colors.grey),
        hintText: widget.searchHintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
      ),
    );
  }

  Widget _buildOptionsList(ScrollController scrollController) {
    return Expanded(
      child: _filteredOptions.isEmpty
          ? Center(
              child: Text(
                "لا توجد نتائج",
                style: AppTextStyles.font16DarkGreyWeight400,
              ),
            )
          : ListView.builder(
              controller: scrollController,
              itemCount: _filteredOptions.length,
              itemBuilder: (context, index) {
                final option = _filteredOptions[index];
                final isSelected = _selectedItem == option;

                return OptionItem(
                  option: option,
                  isSelected: isSelected,
                  onTap: () => _selectItem(option),
                );
              },
            ),
    );
  }
}
