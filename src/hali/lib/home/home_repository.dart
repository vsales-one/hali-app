import 'dart:async';
import 'package:hali/models/api_response.dart';
import 'package:hali/models/post_model.dart';
import 'package:hali/repositories/post_repository.dart';
import 'package:meta/meta.dart';

class HomeRepository {
  final AbstractPostRepository postRepository;

  HomeRepository({@required this.postRepository});

  Future<ApiResponse<List<PostModel>>> fetchPosts(
    Map<String, dynamic> params,
    int pageNumber,
    int pageSize,
  ) async {
    return await postRepository.fetchPosts(params, pageNumber, pageSize);
  }
}
