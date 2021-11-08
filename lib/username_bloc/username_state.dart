import 'package:uuid/uuid.dart';
import 'package:equatable/equatable.dart';

abstract class UsernameState extends Equatable {}

class UsernameInvalidState extends UsernameState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class UsernameValidState extends UsernameState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class UsernameCheckValidState extends UsernameState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class UsernameCheckInvalidState extends UsernameState {
  final String errorMessage;
  final String id = Uuid().v1();

  UsernameCheckInvalidState(this.errorMessage);
  @override
  List<Object> get props => [id];
}

class NoInternetConnectionState extends UsernameState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class ProgressIndicatorValidState extends UsernameState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class InitialState extends UsernameState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}
