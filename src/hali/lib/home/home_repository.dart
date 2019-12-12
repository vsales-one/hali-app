import 'dart:async';

import 'package:hali/constants/constants.dart';
import 'package:hali/home/index.dart';
import 'package:hali/models/api_response.dart';
import 'package:hali/models/post_model.dart';
import 'package:hali/repositories/post_repository.dart';
import 'package:meta/meta.dart';

class HomeRepository {
  final AbstractPostRepository postRepository;
  final provider = HomeProvider();

  HomeRepository({@required this.postRepository});

  Future<ApiResponse<List<PostModel>>> fetchPosts(
      int pageNumber, int pageSize) async {
    return kDbProvider == "firestore"
        ? postRepository.fetchPosts(pageNumber, pageSize)
        : provider.fetchPosts(pageNumber, pageSize);
  }
}
