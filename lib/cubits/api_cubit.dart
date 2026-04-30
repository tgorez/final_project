import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/api_item_model.dart';
import '../services/api_service.dart';

abstract class ApiState {}

class ApiInitial extends ApiState {}

class ApiLoading extends ApiState {}

class ApiLoaded extends ApiState {
  final List<ApiItemModel> items;

  ApiLoaded(this.items);
}

class ApiError extends ApiState {
  final String message;

  ApiError(this.message);
}

class ApiCubit extends Cubit<ApiState> {
  final ApiService apiService;

  ApiCubit({required this.apiService}) : super(ApiInitial());

  Future<void> fetchItems() async {
    try {
      emit(ApiLoading());

      final items = await apiService.fetchExploreItems();

      emit(ApiLoaded(items));
    } catch (e) {
      emit(ApiError(e.toString()));
    }
  }
}