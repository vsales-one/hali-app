import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hali/models/api_response.dart';
import 'package:hali/models/post_model.dart';
import 'package:hali/repositories/post_repository.dart';

class FirebasePostRepository implements AbstractPostRepository {
  final Firestore _fireStore;
  static const String POST_COLLECTIONS = "posts";

  FirebasePostRepository({Firestore firestore})
      : this._fireStore = firestore ?? Firestore.instance;

  @override
  Future<ApiResponse<PostModel>> addNewPost(PostModel postModel) async {
    final docRef =
        await _fireStore.collection(POST_COLLECTIONS).add(postModel.toJson());
    assert(docRef != null);
    final doc = await docRef.snapshots().first;
    return doc.exists
        ? ApiResponse(
            data: PostModel.fromJson(doc.data),
          )
        : ApiResponse(error: true, errorMgs: "Cannot create post");
  }

  @override
  Future<ApiResponse<PostModel>> getPostById(int id) {
    // TODO: implement getPostById
    return null;
  }

  @override
  Future<StorageTaskSnapshot> uploadImage(File image, String _fileName) {
    // TODO: implement uploadImage
    return null;
  }
}
