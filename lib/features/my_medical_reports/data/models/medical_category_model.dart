class MedicalCategoryModel {
  final String title;
  final String image;
  final String selectionType; // 'selection', 'filters', 'selection_and_filters'
  final List<String> radioOptions;
  final List<MedicalFilterSectionModel> filterSections;

  const MedicalCategoryModel({
    required this.title,
    required this.image,
    this.selectionType = '',
    this.radioOptions = const [],
    this.filterSections = const [],
  });
}

class MedicalFilterSectionModel {
  final String? title;
  final List<MedicalFilterModel> filters;

  const MedicalFilterSectionModel({
    this.title,
    required this.filters,
  });
}

class MedicalFilterModel {
  final String title;
  final String? displayTitle;
  final List<String> values;

  const MedicalFilterModel({
    required this.title,
    this.displayTitle,
    this.values = const [],
  });
}
