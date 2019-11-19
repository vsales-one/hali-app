import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadHomeEvent extends HomeEvent {
  @override
  String toString() => 'LoadHomeEvent';
}


class VerifyToken extends HomeEvent {
  @override
  String toString() => 'VerifyToken';
}

class UploadInProgressAvatarHomeEvent extends HomeEvent {
  @override
  String toString() => 'UploadInProgressAvatarHomeEvent';
}