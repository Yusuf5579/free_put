import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_put/src/features/files/cubit/folder_state.dart';

class FolderCubit extends Cubit<FolderState> {
  FolderCubit() : super(FolderState(status: FolderStatus.initial));

  Future<void> getAllFiles() async {
    emit(state.copyWith(status: FolderStatus.loading));
    await Future.delayed(Duration(seconds: 3));
    try {
      final result = await FirebaseFirestore.instance.collection('files').get();

      Set data = {};

      for (var i = 0; i < result.docs.length; i++) {
        if (result.docs[i]
            .data()['name']
            .toString()
            .toLowerCase()
            .endsWith('.mp3')) {
          data.add("Music");
        } else if (result.docs[i]
            .data()['name']
            .toString()
            .toLowerCase()
            .endsWith('.mp4')) {
          data.add("Videos");
        } else if (result.docs[i]
                .data()['name']
                .toString()
                .toLowerCase()
                .endsWith('.png') ||
            result.docs[i]
                .data()['name']
                .toString()
                .toLowerCase()
                .endsWith('.jpeg') || result.docs[i]
                .data()['name']
                .toString()
                .toLowerCase()
                .endsWith('.jpg')) {
          data.add("Images");
        } else if (result.docs[i]
            .data()['name']
            .toString()
            .toLowerCase()
            .endsWith('.pdf')) {
          data.add("Docs");
        } else {
          data.add("Others");
        }
      }

      emit(state.copyWith(
          status: FolderStatus.success, data: result.docs, fileTypes: data));
    } catch (e) {
      emit(state.copyWith(status: FolderStatus.failure));
    }
  }
}
