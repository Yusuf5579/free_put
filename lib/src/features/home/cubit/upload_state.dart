// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

enum UploadStatus { loading, initial, success, failure }

class UploadState {
  final UploadStatus status;
  final String? name;
  final File? file;

  UploadState({required this.status, this.name, this.file});

  UploadState copyWith({
    UploadStatus? status,
    String? name,
    File? file,
  }) {
    return UploadState(
      status: status ?? this.status,
      name: name ?? this.name,
      file: file ?? this.file,
    );
  }
}
