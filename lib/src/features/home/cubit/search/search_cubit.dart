import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_put/src/features/home/cubit/search/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchState(status: SearchStatus.initial));

  Future<void> search({required String name}) async {
    print('Ishladi keldi ku $name');
    if (name.isEmpty) {
      emit(state.copyWith(status: SearchStatus.initial));
      return;
    } else {
      emit(state.copyWith(status: SearchStatus.loading));
    }
    print('[SearchCubit] emitted loading');
    try {
      print('[SearchCubit] querying Firestore: name >= "$name"');
      final result = await FirebaseFirestore.instance
          .collection('files')
          .where("name", isGreaterThanOrEqualTo: name).where('name', isLessThan: '$name\uf8ff')
          .get();
      print('[SearchCubit] query returned ${result.docs.length} docs');

      if (result.docs.isEmpty) {
        emit(state.copyWith(status: SearchStatus.empty));
        print('[SearchCubit] emitted empty');
      } else {
        print(
          '[SearchCubit] matches: ${result.docs.map((d) => d['name']).toList()}',
        );
        emit(state.copyWith(
            status: SearchStatus.success,
            data: result.docs.map((e) => e.data()).toList()));
        print('[SearchCubit] emitted success');
      }
    } on FirebaseException catch (e) {
      print('Firebase xato keldi $e');
      emit(state.copyWith(status: SearchStatus.failure, errorText: e.message));
      print('[SearchCubit] emitted failure (code: ${e.code})');
    } catch (error) {
      print("Nimaddir xato $error");
      emit(state.copyWith(
          status: SearchStatus.failure, errorText: error.toString()));
      print('[SearchCubit] emitted failure');
    }
  }
}
