
import 'package:dio/dio.dart';
import 'package:hali/di/appModule.dart';
import 'package:hali/models/api_response.dart';
import 'package:hali/models/post_model.dart';

abstract class AbstractPostRepository {
  Future<ApiResponse<PostModel, DioError>> addNewPost(PostModel postModel);
}

class PostRepository implements AbstractPostRepository {

  /*
  *  add new post
  * */
  @override
  Future<ApiResponse<PostModel, DioError>> addNewPost(PostModel postModel) async {
    try {
      final response = await dio.post<PostModel>("/api/posting-items");
      return ApiResponse(data: response.data);
    }
    on DioError catch(e) {
      return ApiResponse(errorMgs: e.message, error: e);
    }
  }


}