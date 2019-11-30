
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hali/di/appModule.dart';
import 'package:hali/models/api_response.dart';
import 'package:hali/models/post_model.dart';

abstract class AbstractPostRepository {
  Future<ApiResponse<PostModel>> addNewPost(PostModel postModel);

  Future<StorageTaskSnapshot> uploadImage(File image, String _fileName);
}

class PostRepository implements AbstractPostRepository {

  /*
  *  add new post
  * */
  @override
  Future<ApiResponse<PostModel>> addNewPost(PostModel postModel) async {
    try {
      final response = await dio.post<PostModel>("/api/posting-items", data: postModel.toJson());
      return ApiResponse(data: response.data);
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


}