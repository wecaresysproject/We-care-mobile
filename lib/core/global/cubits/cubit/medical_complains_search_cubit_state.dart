enum SearchResultState {
  initial,
  loading,
  loaded,
  error,
  empty,
}

class SearchState {
  final SearchResultState state;
  final List<String> results;
  final String? errorMessage;

  SearchState._({
    required this.state,
    this.results = const [],
    this.errorMessage,
  });

  factory SearchState.initial() =>
      SearchState._(state: SearchResultState.initial, results: []);
  factory SearchState.loading() =>
      SearchState._(state: SearchResultState.loading);
  factory SearchState.loaded(List<String> results) =>
      SearchState._(state: SearchResultState.loaded, results: results);
  factory SearchState.empty() => SearchState._(state: SearchResultState.empty);
  factory SearchState.error(String message) =>
      SearchState._(state: SearchResultState.error, errorMessage: message);
}
