import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/home/views/feed_detail/index.dart';
import 'package:hali/login/login.dart';
import 'package:hali/posts/create_post_page.dart';
import 'package:hali/posts/pickup_location.dart';
import 'package:hali/register/register.dart';
import 'package:hali/repositories/post_repository.dart';
import 'package:hali/repositories/user_repository.dart';

var rootHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return LoginScreen();
});


var loginHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return LoginScreen();
});

var signUpHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return RegisterScreen();
    });

var showFeedDetailHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      final _postRepository = RepositoryProvider.of<PostRepository>(context);
      final _userRepository = RepositoryProvider.of<UserRepository>(context);
      String postId = params["postId"]?.first;
      return FeedDetailPage(postId: int.parse(postId), postRepository: _postRepository, userRepository: _userRepository,);
    });

var showCreatePostScreenHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      final _postRepository = RepositoryProvider.of<PostRepository>(context);
      return CreatePostPage(postRepository: _postRepository,);
    });

var showPickupLocationScreenHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return PickupLocationScreen();
    });