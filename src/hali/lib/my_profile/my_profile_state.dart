import 'package:equatable/equatable.dart';

abstract class MyProfileState extends Equatable {
  /// notify change state without deep clone state
  final int version;
  
  final List propss;
  MyProfileState(this.version,[this.propss]);

  /// Copy object for use in action
  /// if need use deep clone
  MyProfileState getStateCopy();

  MyProfileState getNewVersion();

  @override
  List<Object> get props => (propss);
}

/// UnInitialized
class UnMyProfileState extends MyProfileState {

  UnMyProfileState(int version) : super(version);

  @override
  String toString() => 'UnMyProfileState';

  @override
  UnMyProfileState getStateCopy() {
    return UnMyProfileState(0);
  }

  @override
  UnMyProfileState getNewVersion() {
    return UnMyProfileState(version+1);
  }
}

/// Initialized
class InMyProfileState extends MyProfileState {
  final String hello;

  InMyProfileState(int version, this.hello) : super(version, [hello]);

  @override
  String toString() => 'InMyProfileState $hello';

  @override
  InMyProfileState getStateCopy() {
    return InMyProfileState(this.version, this.hello);
  }

  @override
  InMyProfileState getNewVersion() {
    return InMyProfileState(version+1, this.hello);
  }
}

class ErrorMyProfileState extends MyProfileState {
  final String errorMessage;

  ErrorMyProfileState(int version, this.errorMessage): super(version, [errorMessage]);
  
  @override
  String toString() => 'ErrorMyProfileState';

  @override
  ErrorMyProfileState getStateCopy() {
    return ErrorMyProfileState(this.version, this.errorMessage);
  }

  @override
  ErrorMyProfileState getNewVersion() {
    return ErrorMyProfileState(version+1, this.errorMessage);
  }
}
