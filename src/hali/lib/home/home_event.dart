import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadHomeEvent extends HomeEvent {
  @override
  String toString() => 'LoadHomeEvent';
}

class Fetch extends HomeEvent {
  final int currentPage;
  Fetch({this.currentPage});

   @override
  String toString() => 'HomeFetch: $currentPage';
}