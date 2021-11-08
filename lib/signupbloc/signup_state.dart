import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

abstract class SignupState extends Equatable {}

class FirstNameInvalidState extends SignupState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class FirstNameValidState extends SignupState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class LastNameInvalidState extends SignupState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class LastNameValidState extends SignupState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class LastFirstValidState extends SignupState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class NoInternetConnectionState extends SignupState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class ValidState extends SignupState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class InitialState extends SignupState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}
