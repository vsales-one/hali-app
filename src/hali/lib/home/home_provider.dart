import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hali/di/appModule.dart';
import 'package:hali/models/post_model.dart';

import 'package:hali/models/api_response.dart';
List<PostModel> postModelFromJson(String str) => List<PostModel>.from(json.decode(str).map((x) => PostModel.fromJson(x)));

class HomeProvider {
  Future<ApiResponse<List<PostModel>>> fetchPosts(int pageNumber, int pageSize) async {
    try {
      Response response = await dio.get("/api/posting-items?page=$pageNumber&size=$pageSize");
      List<dynamic> body = response.data;
      List<PostModel> posts = body
          .map(
            (dynamic item) => PostModel.fromJson(item),
          )
          .toList();
      return ApiResponse(data: posts);
    }
    on DioError catch(e) {
      return ApiResponse(errorMgs: e.message, error: e);
    }
  }
}
