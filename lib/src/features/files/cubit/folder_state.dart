enum FolderStatus { initial, loading, success, failure }

class FolderState {
  final List<dynamic> data;
  final Set fileTypes;
  final FolderStatus status;
  final List? files;

  FolderState({
    this.data = const [],
    required this.status,
    this.fileTypes = const {}, this.files,
  });

  FolderState copyWith({
    List<dynamic>? data,
    FolderStatus? status,
    Set? fileTypes,
   List? files
  }) => FolderState(
    files: files ?? this.files,
    status: status ?? this.status,
    data: data ?? this.data,
    fileTypes: fileTypes ?? this.fileTypes,
  );
}

void dfsfsd() {}
