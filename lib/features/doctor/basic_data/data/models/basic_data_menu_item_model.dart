import 'package:we_care/features/doctor/basic_data/data/models/basic_data_menu_item_type.dart';

class BasicDataMenuItemModel {
  const BasicDataMenuItemModel({
    required this.type,
    required this.iconAssetPath,
  });

  final BasicDataMenuItemType type;
  final String iconAssetPath;
}
