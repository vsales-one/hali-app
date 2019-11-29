import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/repositories/post_repository.dart';
import 'package:hali/posts/bloc/index.dart';

import 'bloc/index.dart';
import 'create_post.dart';

class CreatePostPage extends StatelessWidget {

  final PostRepository _postRepository;

  const CreatePostPage({Key key, @required PostRepository postRepository}) 
  : assert(postRepository != null), 
  _postRepository = postRepository,
   super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreatePostBloc>(
      builder: (context) => CreatePostBloc(postRepository: _postRepository),
      child: CreatePostScreen(postRepository: _postRepository),
    );
  }
}
