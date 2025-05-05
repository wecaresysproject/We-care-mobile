import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class UserSelectionContainer extends StatefulWidget {
  const UserSelectionContainer({
    super.key,
    required this.options,
    required this.categoryLabel,
    required this.bottomSheetTitle,
    required this.onOptionSelected,
    required this.containerHintText,
    required this.searchHintText,
    this.allowManualEntry = false,
    this.isDisabled = false,
    this.containerBorderColor = AppColorsManager.textfieldOutsideBorderColor,
    this.iconColor = AppColorsManager.mainDarkBlue,
    this.userEntryLabelText,
    this.isEditMode = false,
    this.initialValue,
  });

  final List<String> options;
  final String categoryLabel;
  final String bottomSheetTitle;
  final String containerHintText;
  final String searchHintText;
  final Function(String) onOptionSelected;
  final bool allowManualEntry;
  final Color containerBorderColor;
  final bool isDisabled;
  final Color? iconColor;
  final String? userEntryLabelText;
  final bool isEditMode;
  final String? initialValue;

  @override
  State<UserSelectionContainer> createState() => _UserSelectionContainerState();
}

class _UserSelectionContainerState extends State<UserSelectionContainer> {
  String? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialValue;
  }

  @override
  void didUpdateWidget(UserSelectionContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _selectedItem = widget.initialValue;
    }
  }

  void _showSelectionSheet() {
    if (widget.isDisabled) return;

    _showSelectionBottomSheet(
      context: context,
      title: widget.bottomSheetTitle,
      options: widget.options,
      initialSelectedItem:
          widget.isEditMode ? widget.containerHintText : _selectedItem,
      onItemSelected: (selected) {
        setState(() {
          _selectedItem = selected;
        });
        widget.onOptionSelected(selected);
      },
      allowManualEntry: widget.allowManualEntry,
      userEntryLabelText: widget.userEntryLabelText ?? "أدخل اسمًا يدويًا",
      searchHintText: widget.searchHintText,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.categoryLabel,
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(10),
        _buildSelectionContainer(),
        if (_shouldShowErrorMessage())
          Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: Text(
              context.translate.required_field,
              style: TextStyle(color: Colors.red, fontSize: 14.sp),
            ),
          ),
      ],
    );
  }

  Widget _buildSelectionContainer() {
    final String displayText = _selectedItem ?? widget.containerHintText;
    final bool hasSelection = _selectedItem != null;

    return GestureDetector(
      onTap: _showSelectionSheet,
      child: Container(
        width: double.infinity,
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.containerBorderColor,
            width: 0.8,
          ),
          color: AppColorsManager.textfieldInsideColor.withAlpha(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                displayText,
                style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                  color: hasSelection ? AppColorsManager.textColor : null,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: true,
              ),
            ),
            Image.asset(
              hasSelection
                  ? "assets/images/arrow_up_icon.png"
                  : "assets/images/arrow_down_icon.png",
              height: 24.h,
              width: 16.w,
              color: widget.iconColor ?? AppColorsManager.mainDarkBlue,
            ),
          ],
        ),
      ),
    );
  }

  bool _shouldShowErrorMessage() {
    return widget.containerBorderColor == AppColorsManager.warningColor;
  }
}

void _showSelectionBottomSheet({
  required BuildContext context,
  required String title,
  required List<String> options,
  required Function(String) onItemSelected,
  required String userEntryLabelText,
  required String searchHintText,
  String? initialSelectedItem,
  bool allowManualEntry = false,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(18.r),
      ),
    ),
    builder: (context) => _SelectionBottomSheet(
      title: title,
      options: options,
      onItemSelected: onItemSelected,
      userEntryLabelText: userEntryLabelText,
      initialSelectedItem: initialSelectedItem,
      allowManualEntry: allowManualEntry,
      searchHintText: searchHintText,
    ),
  );
}

class _SelectionBottomSheet extends StatefulWidget {
  final String title;
  final List<String> options;
  final Function(String) onItemSelected;
  final String userEntryLabelText;
  final String? initialSelectedItem;
  final bool allowManualEntry;
  final String searchHintText;

  const _SelectionBottomSheet({
    required this.title,
    required this.options,
    required this.onItemSelected,
    required this.userEntryLabelText,
    required this.searchHintText,
    this.initialSelectedItem,
    this.allowManualEntry = false,
  });

  @override
  State<_SelectionBottomSheet> createState() => _SelectionBottomSheetState();
}

class _SelectionBottomSheetState extends State<_SelectionBottomSheet> {
  late TextEditingController _searchController;
  late TextEditingController _manualInputController;
  late List<String> _filteredOptions;
  String? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialSelectedItem;
    _filteredOptions = List.from(widget.options);
    _searchController = TextEditingController();
    _manualInputController = TextEditingController();

    _searchController.addListener(_filterOptions);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterOptions);
    _searchController.dispose();
    _manualInputController.dispose();
    super.dispose();
  }

  void _filterOptions() {
    final query = normalizeArabic(_searchController.text.trim());

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

  void _addManualEntry() {
    final text = _manualInputController.text.trim();
    if (text.isNotEmpty) {
      widget.onItemSelected(text);
      Navigator.pop(context);
    }
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
          vertical: widget.allowManualEntry ? 24.h : 8.h,
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
            if (widget.allowManualEntry) _buildManualEntrySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.title,
          style: AppTextStyles.font18blackWight500.copyWith(
            color: AppColorsManager.textfieldOutsideBorderColor,
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

                return _OptionItem(
                  option: option,
                  isSelected: isSelected,
                  onTap: () => _selectItem(option),
                );
              },
            ),
    );
  }

  Widget _buildManualEntrySection() {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _manualInputController,
              decoration: InputDecoration(
                labelText: widget.userEntryLabelText,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                labelStyle: AppTextStyles.font16DarkGreyWeight400.copyWith(
                  color: Color(0xff555555),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _addManualEntry,
            child: Image.asset(
              "assets/images/plus_icon.png",
              height: 28,
              width: 48,
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionItem extends StatelessWidget {
  final String option;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionItem({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    option,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    softWrap: true,
                    style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                      color: isSelected
                          ? AppColorsManager.mainDarkBlue
                          : Color(0xff555555),
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    textAlign: isArabic() ? TextAlign.right : TextAlign.left,
                  ),
                ),
                if (isSelected)
                  Image.asset(
                    "assets/images/check_right.png",
                    height: 15,
                    width: 20,
                  ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 0.3,
            indent: 14,
            color: AppColorsManager.placeHolderColor,
          ),
        ],
      ),
    );
  }
}
