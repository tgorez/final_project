import 'package:dio/dio.dart';
import '../models/api_item_model.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<ApiItemModel>> fetchExploreItems() async {
    final response = await _dio.get(
      'https://jsonplaceholder.typicode.com/posts',
    );

    final List data = response.data;

    return data.take(20).map((json) {
      return ApiItemModel.fromJson(json);
    }).toList();
  }
}