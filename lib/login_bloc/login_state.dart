import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

abstract class LoginState extends Equatable {}

class UsernameEmailInvalidState extends LoginState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class UsernameEmailValidState extends LoginState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class PasswordInvalidState extends LoginState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class PasswordValidState extends LoginState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class LoginValidState extends LoginState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class UserCheckValidState extends LoginState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class UserCheckInvalidState extends LoginState {
  final String errorMessage;
  final String id = Uuid().v1();

  UserCheckInvalidState(this.errorMessage);
  @override
  List<Object> get props => [id];
}

class NoInternetConnectionState extends LoginState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class ProgressIndicatorValidState extends LoginState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class InitialState extends LoginState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}
