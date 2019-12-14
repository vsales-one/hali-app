import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'HomeEvent';
}

class LoadHomeEvent extends HomeEvent {
  @override
  String toString() => 'LoadHomeEvent';
}

class HomeFetchEvent extends HomeEvent {
  final int categoryId;
  final String lastDocumentOrderFieldRef;

  HomeFetchEvent({@required this.categoryId, @required this.lastDocumentOrderFieldRef});

  @override
  List<Object> get props => [categoryId, lastDocumentOrderFieldRef];

  @override
  String toString() => 'HomeFetchEvent-$categoryId-$lastDocumentOrderFieldRef';
}