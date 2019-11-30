import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:hali/posts/bloc/index.dart';
import 'package:hali/repositories/post_repository.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final PostRepository postRepository;

  CreatePostBloc({@required this.postRepository});
  
  @override
  Future<void> close() async{
    // dispose objects
    super.close();
  }

  CreatePostState get initialState => CreatePostState.empty();

  @override
  Stream<CreatePostState> mapEventToState(
    CreatePostEvent event,
  ) async* {
      if(event is AddPostStartEvent) {
        yield* _mapAddPostToState(event);
      }
  }

  Stream<CreatePostState> _mapAddPostToState(AddPostStartEvent event) async* {
    yield CreatePostState.loading();
    final taskSnapshot = await this.postRepository.uploadImage(event.image, "${Uuid().v1()}.jpg");
    final downloadUrl = await taskSnapshot.ref.getDownloadURL();  
    var payload = event.postModel;
    payload.imageUrl = downloadUrl;
    final res = await this.postRepository.addNewPost(payload);
      if (res.isSuccess) {
        yield CreatePostState.success(res.data);
      } else {
        yield CreatePostState.failure(res.error);
      }
  }
}
