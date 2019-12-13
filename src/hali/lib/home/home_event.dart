import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadHomeEvent extends HomeEvent {
  @override
  String toString() => 'LoadHomeEvent';
}

class HomeFetchEvent extends HomeEvent {
  final int categoryId;

  HomeFetchEvent({this.categoryId});

  @override
  List<Object> get props => [categoryId];

  String toString() => 'HomeFetch';
}