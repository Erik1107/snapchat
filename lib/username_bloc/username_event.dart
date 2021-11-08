import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

abstract class UsernameEvent extends Equatable {}

class UsernameChange extends UsernameEvent {
  final String username;
  UsernameChange(this.username);
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class ProgressIndicatorShowEvent extends UsernameEvent {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class UsernameCheck extends UsernameEvent {
  final String username;
  UsernameCheck(this.username);
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}
