import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/home/index.dart';
import 'package:hali/repositories/post_repository.dart';
import 'package:hali/posts/bloc/index.dart';

import 'bloc/index.dart';
import 'create_post_screen.dart';

class CreatePostPage extends StatelessWidget {
  final HomeBloc _homeBloc;
  final AbstractPostRepository _postRepository;

  const CreatePostPage({
    Key key,
    @required AbstractPostRepository postRepository,
    HomeBloc homeBloc,
  })  : assert(postRepository != null),
        assert(homeBloc != null),
        _postRepository = postRepository,
        _homeBloc = homeBloc,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreatePostBloc>(
      builder: (context) =>
          CreatePostBloc(postRepository: _postRepository, homeBloc: _homeBloc),
      child: CreatePostScreen(postRepository: _postRepository),
    );
  }
}
