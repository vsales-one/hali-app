import 'dart:async';

import 'package:hali/home/index.dart';
import 'package:hali/models/api_response.dart';
import 'package:hali/models/post_model.dart';

class HomeRepository {

  final provider = HomeProvider();

  Future<ApiResponse<List<PostModel>>> fetchPosts(int pageNumber, int pageSize) async {
    return provider.fetchPosts(pageNumber, pageSize);
  }
  
}
