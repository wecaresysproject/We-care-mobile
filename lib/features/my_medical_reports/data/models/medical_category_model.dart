class MedicalCategoryModel {
  final String title;
  final String image;
  final String selectionType; // 'selection', 'filters', 'selection_and_filters'
  final List<String> radioOptions;
  final List<MedicalFilterModel> filters;

  const MedicalCategoryModel({
    required this.title,
    required this.image,
    this.selectionType = '',
    this.radioOptions = const [],
    this.filters = const [],
  });
}

class MedicalFilterModel {
  final String title;
  final String? displayTitle;
  final String? sectionTitle;
  final List<String> values;

  const MedicalFilterModel({
    required this.title,
    this.displayTitle,
    this.sectionTitle,
    this.values = const [],
  });
}
