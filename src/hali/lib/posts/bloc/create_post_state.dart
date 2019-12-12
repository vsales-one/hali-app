import 'package:dio/dio.dart';
import 'package:hali/models/post_model.dart';
import 'package:meta/meta.dart';

@immutable
class CreatePostState {
  final PostModel postModel;
  final DioError error;
  final bool isLoading;
  final bool isPostImageUploadedSuccess;
  final bool isPostCreatedSuccess;

  bool get isFormValid =>
      postModel.title != null && postModel.description != null;

  CreatePostState(
      {@required this.postModel,
      @required this.error,
      @required this.isLoading,
      this.isPostImageUploadedSuccess,
      this.isPostCreatedSuccess});

  factory CreatePostState.empty() {
    return CreatePostState(
      postModel: PostModel(),
      error: null,
      isLoading: false,
      isPostImageUploadedSuccess: false,
      isPostCreatedSuccess: false,
    );
  }

  factory CreatePostState.loading() {
    return CreatePostState(
      postModel: null,
      error: null,
      isLoading: true,
      isPostImageUploadedSuccess: false,
      isPostCreatedSuccess: false,
    );
  }

  factory CreatePostState.failure(DioError e) {
    return CreatePostState(
      postModel: null,
      error: e,
      isLoading: false,
      isPostImageUploadedSuccess: false,
      isPostCreatedSuccess: false,
    );
  }

  factory CreatePostState.failureWithMessage(String message) {
    return CreatePostState(
      postModel: null,
      error: DioError(error: message),
      isLoading: false,
      isPostImageUploadedSuccess: false,
      isPostCreatedSuccess: false,
    );
  }

  factory CreatePostState.postImageUploadedSuccess(PostModel model) {
    return CreatePostState(
        postModel: model,
        error: null,
        isLoading: false,
        isPostImageUploadedSuccess: true,
        isPostCreatedSuccess: false);
  }

  factory CreatePostState.postCreatedSuccess(PostModel model) {
    return CreatePostState(
        postModel: model,
        error: null,
        isLoading: false,
        isPostImageUploadedSuccess: false,
        isPostCreatedSuccess: true);
  }

  @override
  String toString() {
    return '''CreatePostState {
      postModel: $postModel,
      error: $error,
      isLoading: $isLoading,
      isPostImageUploadedSuccess: $isPostImageUploadedSuccess,
      isPostCreatedSuccess: $isPostCreatedSuccess
    }''';
  }

  CreatePostState update(
      {PostModel postModel,
      DioError error,
      bool isLoading,
      bool isPostImageUploadedSuccess,
      bool isPostCreatedSuccess}) {
    return copyWith(
        postModel: postModel,
        error: error,
        isLoading: isLoading,
        isPostImageUploadedSuccess: isPostImageUploadedSuccess,
        isPostCreatedSuccess: isPostCreatedSuccess);
  }

  CreatePostState copyWith(
      {PostModel postModel,
      DioError error,
      bool isLoading,
      bool isPostImageUploadedSuccess,
      bool isPostCreatedSuccess}) {
    return CreatePostState(
        postModel: postModel,
        error: error,
        isLoading: isLoading,
        isPostImageUploadedSuccess: isPostImageUploadedSuccess,
        isPostCreatedSuccess: isPostCreatedSuccess);
  }
}
