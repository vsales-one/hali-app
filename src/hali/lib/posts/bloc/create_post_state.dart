import 'package:dio/dio.dart';
import 'package:hali/models/post_model.dart';
import 'package:meta/meta.dart';

@immutable
class CreatePostState {
  final PostModel postModel;
  final DioError error;
  final bool isLoading;

  bool get isFormValid => postModel.title != null && postModel.description != null;

  CreatePostState({
    @required this.postModel,
    @required this.error,
    @required this.isLoading
  });

  factory CreatePostState.empty() {
    return CreatePostState(postModel: new PostModel(), error: null, isLoading: false);
  }

  factory CreatePostState.loading() {
    return CreatePostState(
      postModel: null,
      error: null,
      isLoading: true
    );
  }

  factory CreatePostState.failure(DioError e) {
    return CreatePostState(postModel: null, error: e, isLoading: false);
  }

  factory CreatePostState.success(PostModel model) {
    return CreatePostState(postModel: model, error: null, isLoading: false);
  }

  @override
  String toString() {
    return '''CreatePostState {
      postModel: $postModel,
      error: $error
    }''';
  }
  
  CreatePostState update({
    PostModel postModel,
    DioError error,
    bool isLoading,
  }){
    return copyWith(
      postModel: postModel,
      error: error,
      isLoading: isLoading
    );
  }

  CreatePostState copyWith({
    PostModel postModel,
    DioError error,
    bool isLoading
  }) {
    return CreatePostState(
      postModel: postModel,
      error: error,
      isLoading: isLoading
    );
  }

}