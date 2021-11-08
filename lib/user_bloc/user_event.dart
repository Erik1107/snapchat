import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

abstract class UserEvent extends Equatable {}

class DeleteUser extends UserEvent {
  final String id = Uuid().v1();

  @override
  List<Object> get props => [id];
}

class GetLocalUser extends UserEvent {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class UpdateUserFromServer extends UserEvent {
  final String id = Uuid().v1();

  @override
  List<Object> get props => [id];
}

class GetUserMongo extends UserEvent {
  final String id = Uuid().v1();

  @override
  List<Object> get props => [id];
}

class LogOutUser extends UserEvent {
  final String id = Uuid().v1();

  @override
  List<Object> get props => [id];
}
