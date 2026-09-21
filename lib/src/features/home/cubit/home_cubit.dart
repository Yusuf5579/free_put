import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_put/src/features/home/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState(status: HomeStatus.initial));

  Future<void> getFiles() async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final result = await FirebaseFirestore.instance.collection('files').get();
      List<Map> data = result.docs.map((value) => value.data()).toList();
      emit(state.copyWith(status: HomeStatus.success, data: data));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.failure, errorText: e.toString()));
    }
  }
}
