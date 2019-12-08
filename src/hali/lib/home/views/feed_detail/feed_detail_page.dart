import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/home/views/feed_detail.dart';
import 'package:hali/home/views/feed_detail/index.dart';
import 'package:hali/repositories/post_repository.dart';
import 'package:hali/repositories/user_repository.dart';

class FeedDetailPage extends StatelessWidget {
  final UserRepository _userRepository;
  final PostRepository _postRepository;

  final int postId;

  const FeedDetailPage({Key key, this.postId, PostRepository postRepository, UserRepository userRepository}) 
  : assert(postRepository != null),
    assert(userRepository != null),
    _postRepository = postRepository,
    _userRepository = userRepository,
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FeedDetailBloc>(
      builder: (context) => new FeedDetailBloc(postRepository: _postRepository, userRepository: _userRepository),
      child: FeedDetail(postId: this.postId,),
    );
  }
}
