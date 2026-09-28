// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

enum SearchStatus { initial, loading, failure, success, empty }

class SearchState extends Equatable {
  final SearchStatus status;
  final List<Map> data;
  final String? errorText;
  const SearchState({required this.status, this.data = const [], this.errorText});

  SearchState copyWith({
    SearchStatus? status,
    List<Map>? data,
    String? errorText,
  }) {
    return SearchState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorText: errorText ?? this.errorText,
    );
  }

  @override
  List<Object?> get props => [status, data, errorText];
}
