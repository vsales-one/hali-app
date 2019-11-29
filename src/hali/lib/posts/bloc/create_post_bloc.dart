import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:hali/posts/bloc/index.dart';
import 'package:hali/repositories/post_repository.dart';
import 'package:meta/meta.dart';

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
    final res = await this.postRepository.addNewPost(event.postModel);
      if (res.isSuccess) {
        yield CreatePostState.success(res.data);
      } else {
        yield CreatePostState.failure(res.error);
      }
  }
}
