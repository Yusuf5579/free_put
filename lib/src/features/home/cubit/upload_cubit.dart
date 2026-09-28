import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_put/src/core/appwrite/appwrite_client.dart';
import 'package:free_put/src/features/home/cubit/upload_state.dart';
import 'package:path/path.dart' as path;

class UploadCubit extends Cubit<UploadState> {
  UploadCubit() : super(UploadState(status: .initial));

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

  Future<void> fileYuborish({required Function onError, required Function onSuccess}) async {
    emit(state.copyWith(status: UploadStatus.loading));
    try {
       final uploadFile =  await AppwriteClient.storage.createFile(
        bucketId: AppwriteClient.bucketId,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: state.file!.path, filename: state.name),
      );

      final String fileUrl = '${AppwriteClient.appwriteEndpoint}/storage/buckets/${AppwriteClient.bucketId}/files/${uploadFile.$id}/view?project=${AppwriteClient.appwriteProjectId}';
      
      final deviceInfo = Platform.isIOS ? await DeviceInfoPlugin().iosInfo : await DeviceInfoPlugin().androidInfo;
      
      await FirebaseFirestore.instance.collection('files').add({
        "name" : path.basename(state.file!.path),
        "url" : fileUrl,
        "fileId" : uploadFile.$id,
        "device" : deviceInfo.data,
        "time" : Timestamp.now()
      });
      onSuccess();
      reset();

    } catch (e) {
      onError();
      print('Error keldi $e');
      emit(UploadState(status: .failure));

    } 
  }

   void reset() {
    emit(UploadState(status: UploadStatus.initial, name: null, file: null));
  }

}
