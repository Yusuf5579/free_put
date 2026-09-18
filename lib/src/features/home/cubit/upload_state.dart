import 'dart:io';

enum UploadStatus { loading, initial, success, failure }

class UploadState {
  final UploadStatus status;
  final String? name;
  final File? file;

  UploadState({required this.status, this.name, this.file});
}