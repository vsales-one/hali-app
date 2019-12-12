import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:hali/models/create_post_command.dart';
import 'package:hali/models/post_model.dart';
import 'package:meta/meta.dart';
import 'package:place_picker/place_picker.dart';

@immutable
abstract class CreatePostEvent extends Equatable {
  const CreatePostEvent();

  @override
  List<Object> get props => [];

}

class AddPostStartEvent extends CreatePostEvent {
  final File image;
  final CreatePostCommand postModel;

  AddPostStartEvent({ this.image, this.postModel});

  @override
  String toString() => 'AddPostEvent { todo: $postModel }';
}

class CreatePostError extends CreatePostEvent {

  final DioError error;

  CreatePostError({this.error});

  @override
  String toString() => 'CreatePostError { todo: $error }';
}

class UploadPostImageEvent extends CreatePostEvent {
  final File image;
  final PostModel postModel;

  UploadPostImageEvent({this.image, this.postModel});

  @override
  List<Object> get props => [image];
}

class ChangePostPickupLocationEvent extends CreatePostEvent {
  final LocationResult locationResult;

  ChangePostPickupLocationEvent({this.locationResult});

  @override
  List<Object> get props => [locationResult];

}
