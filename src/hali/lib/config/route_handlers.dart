import 'package:flutter/painting.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:hali/home/views/feed_detail.dart';
import 'package:hali/login/login.dart';
import 'package:hali/register/register.dart';

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