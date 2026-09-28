import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_put/src/core/appwrite/appwrite_client.dart';
import 'package:free_put/src/features/home/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState(status: HomeStatus.initial));

  Future<void> deleteFile(String id, String fileId) async {
    emit(state.copyWith(status: HomeStatus.loading));
    await Future.delayed(Duration(seconds: 3));
    try {
      await AppwriteClient.storage.deleteFile(
        bucketId: AppwriteClient.bucketId,
        fileId: fileId,
      );
      await FirebaseFirestore.instance.collection('files').doc(id).delete();
      emit(state.copyWith(status: HomeStatus.success));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  Future<void> editFile(String id, String newName) async {
    emit(state.copyWith(status: HomeStatus.loading));
    await Future.delayed(Duration(seconds: 3));
    try {
      await FirebaseFirestore.instance.collection('files').doc(id).update({
        "name": newName,
      });
      emit(state.copyWith(status: HomeStatus.success));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }
}
