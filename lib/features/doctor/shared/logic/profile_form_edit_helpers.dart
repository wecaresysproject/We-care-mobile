import 'dart:convert';

/// Button title shown when a doctor profile module already has saved data.
const String profileFormSaveChangesTitle = 'حفظ التعديلات';

/// Tracks whether a doctor profile module form differs from the data that was
/// loaded from the server.
///
/// Call [setBaseline] with the form's request JSON right after filling it from
/// the `GET` response, then call [hasChanges] with the current request JSON
/// whenever a field changes. Comparing the JSON the app would send means a
/// value changed and then changed back counts as "no changes".
class ProfileFormChangesTracker {
  String? _baseline;

  /// True once a baseline was set, i.e. the module had saved data.
  bool get hasBaseline => _baseline != null;

  void setBaseline(Object? requestJson) => _baseline = jsonEncode(requestJson);

  /// Without a baseline (first time filling the module) every state counts as
  /// changed, so the submit button keeps its current behavior.
  bool hasChanges(Object? requestJson) =>
      _baseline == null || jsonEncode(requestJson) != _baseline;
}

/// Returns the `data` field of a `{ success, message, data }` response.
Object? profileResponseData(dynamic response) =>
    response is Map ? response['data'] : null;

/// Parses a `yyyy-MM-dd` string loaded from the server, or null.
DateTime? parseProfileDate(String? value) =>
    (value == null || value.isEmpty) ? null : DateTime.tryParse(value);

/// Parses a `yyyy` year string loaded from the server, or null.
DateTime? parseProfileYear(String? value) {
  final year = int.tryParse(value ?? '');
  return year == null ? null : DateTime(year);
}
