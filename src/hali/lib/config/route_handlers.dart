import 'package:flutter/painting.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hali/home/views/feed_detail.dart';
import 'package:hali/login/login.dart';
import 'package:hali/posts/create_post.dart';
import 'package:hali/posts/create_post_page.dart';
import 'package:hali/posts/pickup_location.dart';
import 'package:hali/register/register.dart';
import 'package:hali/repositories/post_repository.dart';

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
      return FeedDetail();
    });

var showCreatePostScreenHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      final _postRepository = new PostRepository();
      return CreatePostPage(postRepository: _postRepository,);
    });

var showPickupLocationScreenHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return PickupLocationScreen();
    });