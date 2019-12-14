import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/repositories/post_repository.dart';
import 'package:hali/posts/bloc/index.dart';
import 'package:hali/posts/create_post_screen.dart';

class CreatePostPage extends StatelessWidget {
  final AbstractPostRepository _postRepository;

  const CreatePostPage({
    Key key,
    @required AbstractPostRepository postRepository,
  })  : assert(postRepository != null),
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
