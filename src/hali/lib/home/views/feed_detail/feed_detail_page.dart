import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/home/views/feed_detail.dart';
import 'package:hali/home/views/feed_detail/index.dart';
import 'package:hali/repositories/post_repository.dart';

class FeedDetailPage extends StatelessWidget {

  final int postId;

  const FeedDetailPage({Key key, this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FeedDetailBloc>(
      builder: (context) => new FeedDetailBloc(postRepository: RepositoryProvider.of<PostRepository>(context)),
      child: FeedDetail(postId: this.postId,),
    );
  }
}
