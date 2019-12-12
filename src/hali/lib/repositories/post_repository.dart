
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hali/constants/constants.dart';
import 'package:hali/di/appModule.dart';
import 'package:hali/models/api_response.dart';
import 'package:hali/models/create_post_command.dart';
import 'package:hali/models/post_model.dart';

abstract class AbstractPostRepository {
  Future<ApiResponse<List<PostModel>>> fetchPosts(int pageNumber, int pageSize);

  Future<ApiResponse<PostModel>> addNewPost(CreatePostCommand postModel);

  Future<StorageTaskSnapshot> uploadImage(File image, String _fileName);

  Future<ApiResponse<PostModel>> getPostById(String id);

  Future<ApiResponse<PostModel>> getPostByIdString(String id);

}

class PostRepository implements AbstractPostRepository {

  @override
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
    catch(e) {
      logger.e(e);
      return ApiResponse(errorMgs: e.message, error: e);
    }
  }

  /*
  *  add new post
  * */
  @override
  Future<ApiResponse<PostModel>> addNewPost(CreatePostCommand postModel) async {
    try {
      final response = await dio.post("/api/posting-items", data: postModel.toJson());
      return ApiResponse(data: PostModel.fromJson(response.data));
    }
    on DioError catch(e) {
      return ApiResponse(errorMgs: e.message, error: e);
    }
  }

  @override
  Future<StorageTaskSnapshot> uploadImage(File image, String _fileName) async {
    final StorageReference ref = storage.ref().child('public_images').child("posts").child(_fileName);
    // upload task
    final StorageUploadTask uploadTask = ref.putFile(
      image,
      StorageMetadata(
        contentLanguage: 'en',
        contentType: 'image/jpg',
        customMetadata: <String, String>{
          'fileName': _fileName,
        },
      ),
    );
    return await uploadTask.onComplete;
  }

  @override
  Future<ApiResponse<PostModel>> getPostById(String id) async {
    try {
      final response = await dio.get("/api/posting-items/$id");
      return ApiResponse(data: PostModel.fromJson(response.data));
    }
    on DioError catch(e) {
      return ApiResponse(errorMgs: e.message, error: e);
    }
  }

  @override
  Future<ApiResponse<PostModel>> getPostByIdString(String id) async {
    throw Exception("Database provider $kDbProvider does not support get by id string: $id");
  }

}