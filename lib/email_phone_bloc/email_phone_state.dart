import 'package:uuid/uuid.dart';
import 'package:equatable/equatable.dart';

abstract class EmailNumberState extends Equatable {}

class EmailInvalidState extends EmailNumberState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class EmailValidState extends EmailNumberState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class EmailCheckValidState extends EmailNumberState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class EmailCheckInvalidState extends EmailNumberState {
  final String errorMessage;
  final String id = Uuid().v1();

  EmailCheckInvalidState(this.errorMessage);
  @override
  List<Object> get props => [id];
}

class NumberInvalidState extends EmailNumberState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class NumberValidState extends EmailNumberState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class NumberCheckValidState extends EmailNumberState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class NumberCheckInvalidState extends EmailNumberState {
  final String errorMessage;
  final String id = Uuid().v1();

  NumberCheckInvalidState(this.errorMessage);
  @override
  List<Object> get props => [id];
}

class PhoneNumberPageLoadedState extends EmailNumberState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class NoInternetConnectionState extends EmailNumberState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class ProgressIndicatorValidState extends EmailNumberState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class InitialState extends EmailNumberState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}
