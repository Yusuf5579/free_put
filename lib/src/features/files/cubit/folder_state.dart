enum FolderStatus { initial, loading, success, failure }

class FolderState {
  final List<dynamic> data;
  final Set fileTypes;
  final FolderStatus status;

  FolderState({this.data = const [], required this.status, this.fileTypes = const {}});

  FolderState copyWith({
    List<dynamic>? data,
    FolderStatus? status,
    Set? fileTypes,
  }) =>
      FolderState(status: status ?? this.status, data: data ?? this.data, fileTypes: fileTypes ?? this.fileTypes);
}

void dfsfsd() {}
