/*
 * fluro
 * Created by Yakka
 * https://theyakka.com
 * 
 * Copyright (c) 2019 Yakka, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:hali/di/appModule.dart';
import './route_handlers.dart';

class Routes {
  static String root = "/";
  static String loginInfo = "/login-info";
  static String login = "/login";
  static String signUp = "/sign-up";
  static String feedDetail = "/feed-detail";
  static String createPost = "create-post-screen";
  static String locationScreen = "pickup-location-screen";

  static void configureRoutes(Router router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      logger.d("ROUTE WAS NOT FOUND !!!");
    });
    router.define(root, handler: rootHandler);
    router.define(login, handler: loginHandler);
    router.define(signUp, handler: signUpHandler);
    router.define(feedDetail, handler: showFeedDetailHandler);
    router.define(createPost, handler: showCreatePostScreenHandler);
    router.define(locationScreen, handler: showPickupLocationScreenHandler);
  }
}
