import 'package:dio/dio.dart';
import 'package:hali/models/address_dto.dart';
import 'package:hali/models/post_model.dart';
import 'package:meta/meta.dart';
import 'package:place_picker/place_picker.dart';

@immutable
class CreatePostState {
  final PostModel postModel;
  final DioError error;
  final bool isLoading;
  final bool isPostImageUploadedSuccess;
  final bool isPostCreatedSuccess;
  final bool isPostLocationChanged;
  final AddressDto addressDto;
  final LocationResult locationResult;

  bool get isFormValid =>
      postModel.title != null && postModel.description != null;

  CreatePostState(
      {@required this.postModel,
      @required this.error,
      @required this.isLoading,
      this.isPostImageUploadedSuccess,
      this.isPostCreatedSuccess,
      this.isPostLocationChanged,
      this.addressDto,
      this.locationResult});

  factory CreatePostState.empty() {
    return CreatePostState(
      postModel: PostModel(),
      error: null,
      isLoading: false,
      isPostImageUploadedSuccess: false,
      isPostCreatedSuccess: false,
      isPostLocationChanged: false,
    );
  }

  factory CreatePostState.loading() {
    return CreatePostState(
      postModel: null,
      error: null,
      isLoading: true,
      isPostImageUploadedSuccess: false,
      isPostCreatedSuccess: false,
      isPostLocationChanged: false,
    );
  }

  factory CreatePostState.failure(DioError e) {
    return CreatePostState(
      postModel: null,
      error: e,
      isLoading: false,
      isPostImageUploadedSuccess: false,
      isPostCreatedSuccess: false,
      isPostLocationChanged: false,
    );
  }

  factory CreatePostState.failureWithMessage(String message) {
    return CreatePostState(
      postModel: null,
      error: DioError(error: message),
      isLoading: false,
      isPostImageUploadedSuccess: false,
      isPostCreatedSuccess: false,
      isPostLocationChanged: false,
    );
  }

  factory CreatePostState.postImageUploadedSuccess(PostModel model) {
    return CreatePostState(
      postModel: model,
      error: null,
      isLoading: false,
      isPostImageUploadedSuccess: true,
      isPostCreatedSuccess: false,
      isPostLocationChanged: false,
    );
  }

  factory CreatePostState.postLocationChangedSuccess(
      AddressDto addressDto, LocationResult locationResult) {
    return CreatePostState(
      postModel: null,
      error: null,
      isLoading: false,
      isPostImageUploadedSuccess: false,
      isPostCreatedSuccess: false,
      isPostLocationChanged: true,
      addressDto: addressDto,
      locationResult: locationResult,
    );
  }

  factory CreatePostState.postCreatedSuccess(PostModel model) {
    return CreatePostState(
      postModel: model,
      error: null,
      isLoading: false,
      isPostImageUploadedSuccess: false,
      isPostCreatedSuccess: true,
      isPostLocationChanged: false,
    );
  }

  @override
  String toString() {
    return '''CreatePostState {
      postModel: $postModel,
      error: $error,
      isLoading: $isLoading,
      isPostImageUploadedSuccess: $isPostImageUploadedSuccess,
      isPostCreatedSuccess: $isPostCreatedSuccess,
      isPostLocationChanged: $isPostLocationChanged,
    }''';
  }

  CreatePostState update(
      {PostModel postModel,
      DioError error,
      bool isLoading,
      bool isPostImageUploadedSuccess,
      bool isPostCreatedSuccess,
      bool isPostLocationChanged}) {
    return copyWith(
        postModel: postModel,
        error: error,
        isLoading: isLoading,
        isPostImageUploadedSuccess: isPostImageUploadedSuccess,
        isPostCreatedSuccess: isPostCreatedSuccess,
        isPostLocationChanged: isPostLocationChanged);
  }

  CreatePostState copyWith(
      {PostModel postModel,
      DioError error,
      bool isLoading,
      bool isPostImageUploadedSuccess,
      bool isPostCreatedSuccess,
      bool isPostLocationChanged}) {
    return CreatePostState(
        postModel: postModel,
        error: error,
        isLoading: isLoading,
        isPostImageUploadedSuccess: isPostImageUploadedSuccess,
        isPostCreatedSuccess: isPostCreatedSuccess,
        isPostLocationChanged: isPostLocationChanged);
  }
}
