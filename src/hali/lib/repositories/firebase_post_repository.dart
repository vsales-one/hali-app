import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hali/di/appModule.dart';
import 'package:hali/models/api_response.dart';
import 'package:hali/models/create_post_command.dart';
import 'package:hali/models/post_model.dart';
import 'package:hali/repositories/post_repository.dart';

class FirebasePostRepository implements AbstractPostRepository {
  final Firestore _fireStore;
  static const String POST_COLLECTIONS = "itemposts";

  FirebasePostRepository({Firestore firestore})
      : this._fireStore = firestore ?? Firestore.instance;

  @override
  Future<ApiResponse<List<PostModel>>> fetchPosts(
    Map<String, dynamic> params,
    int pageNumber,
    int pageSize,
  ) async {
    final categoryId = params["categoryId.equals"];
    final status = params["status.equals"];
    logger.d(
        ">>>>>>>: fetchPosts from firestore pageSize: $pageSize-pageNumber: $pageNumber-status: $status-categoryId: $categoryId");
    try {
      final query = _fireStore
          .collection(POST_COLLECTIONS)
          .where("status", isEqualTo: status)
          .where("categoryId", isEqualTo: categoryId)
          .orderBy("lastModifiedDate", descending: true)
          .limit(pageSize);
      
      final docs = await query.getDocuments();

      logger.d(">>>>>>>: fetchPosts from firestore ${docs.documents.length}");

      final posts = docs.documents.map((doc) {
        logger.d(">>>>>> fetchPosts map document: ${doc.data}");
        final post = PostModel.fromJson(doc.data);
        post.id = doc.documentID;
        return post;
      }).toList();

      return ApiResponse(data: posts);
    } catch (e) {
      logger.e(e);
      return ApiResponse(errorMgs: e.message, error: e);
    }
  }

  @override
  Future<ApiResponse<PostModel>> addNewPost(CreatePostCommand postModel) async {
    final docRef =
        await _fireStore.collection(POST_COLLECTIONS).add(postModel.toJson());
    assert(docRef != null);
    final doc = await docRef.snapshots().first;
    return doc.exists
        ? ApiResponse(
            data: PostModel.fromJson(doc.data),
          )
        : ApiResponse(error: true, errorMgs: "Lỗi không thể đăng tin");
  }

  @override
  Future<ApiResponse<PostModel>> getPostById(String id) async {
    return getPostByIdString(id);
  }

  @override
  Future<ApiResponse<PostModel>> getPostByIdString(String id) async {
    logger.d(">>>>>>> getPostByIdString: $id");
    final doc = await _fireStore
        .collection(POST_COLLECTIONS)
        .document(id)
        .snapshots()
        .first;
    assert(doc != null);
    return doc.exists
        ? ApiResponse(
            data: PostModel.fromJson(doc.data),
          )
        : ApiResponse(error: true, errorMgs: "Lỗi không thể tìm thấy tin $id");
  }

  @override
  Future<StorageTaskSnapshot> uploadImage(File image, String _fileName) async {
    final StorageReference ref = storage
        .ref()
        .child("public_images")
        .child("itemposts")
        .child(_fileName);
    // upload task
    final StorageUploadTask uploadTask = ref.putFile(
      image,
      StorageMetadata(
        contentLanguage: "en",
        contentType: "image/jpg",
        customMetadata: <String, String>{
          "fileName": _fileName,
        },
      ),
    );
    return await uploadTask.onComplete;
  }
}
