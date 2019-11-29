import 'dart:async';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:hali/models/post_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CreatePostEvent extends Equatable {
  const CreatePostEvent();

  @override
  List<Object> get props => [];

}

class AddPostStartEvent extends CreatePostEvent {

  final PostModel postModel;

  AddPostStartEvent({this.postModel});

  @override
  String toString() => 'AddPostEvent { todo: $postModel }';
}

class CreatePostError extends CreatePostEvent {

  final DioError error;

  CreatePostError({this.error});

  @override
  String toString() => 'CreatePostError { todo: $error }';
}

