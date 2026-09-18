import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_put/src/core/appwrite/appwrite_client.dart';
import 'package:free_put/src/features/home/cubit/upload_state.dart';

class UploadCubit extends Cubit<UploadState> {
  UploadCubit() : super(UploadState(status: .loading));

  Future<void> fileTanlash() async {
    try {
      final result = await FilePicker.pickFile();
      if (result != null) {
        print('NUll EMAS');
        print('Image Name ${result.name}');

        emit(
          UploadState(
            status: UploadStatus.success,
            name: result.name,
            file: File(result.path!),
          ),
        );
      }
    } catch (e) {
      emit(UploadState(status: UploadStatus.initial));
    }
  }

  Future<void> fileYuborish() async {
    try {
       await AppwriteClient.storage.createFile(
        bucketId: AppwriteClient.bucketId,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: state.file!.path, filename: state.name),
      );
    } catch (e) {
      emit(UploadState(status: .failure));
    }
  }

   void reset() {
    emit(UploadState(status: UploadStatus.initial, name: null, file: null));
  }

}
