import 'package:uuid/uuid.dart';
import 'package:equatable/equatable.dart';

abstract class PasswordState extends Equatable {}

class PasswordInvalidState extends PasswordState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class PasswordValidState extends PasswordState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class UserCreatedValidState extends PasswordState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class UserCreatedInvalidState extends PasswordState {
  final String errorMessage;
  final String id = Uuid().v1();

  UserCreatedInvalidState(this.errorMessage);
  @override
  List<Object> get props => [id];
}

class NoInternetConnectionState extends PasswordState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class ProgressIndicatorValidState extends PasswordState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class InitialState extends PasswordState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}
