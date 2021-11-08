import 'package:uuid/uuid.dart';
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {}

class UserDeletedValidState extends UserState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class UserDeletedInvalidState extends UserState {
  final String errorMessage;
  final String id = Uuid().v1();

  UserDeletedInvalidState(this.errorMessage);
  @override
  List<Object> get props => [id];
}

class UserLogOutValidState extends UserState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class LocalUserValidState extends UserState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class MongoUserValidState extends UserState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class MongoUserInvalidState extends UserState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class UserUpdatedValidState extends UserState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class UserUpdatedInvalidState extends UserState {
  final String errorMessage;
  final String id = Uuid().v1();

  UserUpdatedInvalidState(this.errorMessage);
  @override
  List<Object> get props => [id];
}

class NoInternetConnectionState extends UserState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class InitialState extends UserState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}
