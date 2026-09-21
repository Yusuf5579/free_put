enum HomeStatus { initial, loading, success, failure }

class HomeState {
  final HomeStatus status;
  final String? errorText;
  final List<Map>
      data; 

  const HomeState({
    this.status = HomeStatus.initial,
    this.errorText,
    this.data = const [],
  });

  HomeState copyWith({
    HomeStatus? status,
    String? errorText,
    List<Map>? data,
  }) {
    return HomeState(
      status: status ?? this.status,
      errorText: errorText ?? this.errorText,
      data: data ?? this.data,
    );
  }
}
