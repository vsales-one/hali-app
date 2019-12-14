import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:hali/di/appModule.dart';
import 'package:hali/models/address_dto.dart';
import 'package:hali/posts/bloc/index.dart';
import 'package:hali/repositories/post_repository.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final AbstractPostRepository postRepository;

  CreatePostBloc({@required this.postRepository});

  @override
  Future<void> close() async {
    // dispose objects
    super.close();
  }

  CreatePostState get initialState => CreatePostState.empty();

  @override
  Stream<CreatePostState> mapEventToState(
    CreatePostEvent event,
  ) async* {
    if (event is AddPostStartEvent) {
      yield* _mapAddPostToState(event);
    } else if (event is UploadPostImageEvent) {
      yield* _mapUploadPostImageEventToState(event);
    } else if(event is ChangePostPickupLocationEvent) {
      yield* _mapChangePostPickupLocationEventToState(event);
    }
  }

  Stream<CreatePostState> _mapAddPostToState(AddPostStartEvent event) async* {
    yield CreatePostState.loading();

    var payload = event.postModel;
    if (payload.imageUrl == null || payload.imageUrl.isEmpty) {
      final taskSnapshot = await this
          .postRepository
          .uploadImage(event.image, "${Uuid().v1()}.jpg");
      final downloadUrl = await taskSnapshot.ref.getDownloadURL();
      payload.imageUrl = downloadUrl;
    }

    final res = await this.postRepository.addNewPost(payload);
    if (res.isSuccess) {
      yield CreatePostState.postCreatedSuccess(res.data);
    } else {
      yield CreatePostState.failure(res.error);
    }
  }

  Stream<CreatePostState> _mapUploadPostImageEventToState(
      UploadPostImageEvent event) async* {
    yield CreatePostState.loading();
    try {
      final taskSnapshot = await this
          .postRepository
          .uploadImage(event.image, "${Uuid().v1()}.jpg");
      final downloadUrl = await taskSnapshot.ref.getDownloadURL();
      var payload = event.postModel;
      payload.imageUrl = downloadUrl;
      yield CreatePostState.postImageUploadedSuccess(payload);
    } catch (e) {
      logger.e(e);
      yield CreatePostState.failureWithMessage(e.toString());
    }
  }

  Stream<CreatePostState> _mapChangePostPickupLocationEventToState(ChangePostPickupLocationEvent event) async* {
    yield CreatePostState.loading();
    final result = event.locationResult;
    assert(result.formattedAddress != null);
    final addressDto = AddressDto.fromFullAddress(result.formattedAddress);
    yield CreatePostState.postLocationChangedSuccess(addressDto, result);
  }
}
