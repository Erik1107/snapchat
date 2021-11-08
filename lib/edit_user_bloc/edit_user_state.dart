import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../validation_type.dart';

abstract class EditUserState extends Equatable {}

class InfoInvalidState extends EditUserState {
  final Validation validation;
  final String id = Uuid().v1();

  InfoInvalidState(this.validation);
  @override
  List<Object> get props => [id];
}

class InfoValidState extends EditUserState {
  final Validation validation;
  final String id = Uuid().v1();

  InfoValidState(this.validation);
  @override
  List<Object> get props => [id];
}

class LastNameInvalidState extends EditUserState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class BirthDateInvalidState extends EditUserState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class EmailInvalidState extends EditUserState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class PhoneInvalidState extends EditUserState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class UserNameInvalidState extends EditUserState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class PasswordInvalidState extends EditUserState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class UserEditedInvalidState extends EditUserState {
  final String errorMessage;
  final String id = Uuid().v1();

  UserEditedInvalidState(this.errorMessage);
  @override
  List<Object> get props => [id];
}

class UserEditedValidState extends EditUserState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class UserInfoValidState extends EditUserState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class UserInfoInvalidState extends EditUserState {
  final List<String> errors;
  final String id = Uuid().v1();

  UserInfoInvalidState(this.errors);
  @override
  List<Object> get props => [id];
}

class EditUserPageLoadedValidState extends EditUserState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class NoInternetConnectionState extends EditUserState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class EditUserLoadedState extends EditUserState {
  final String id = Uuid().v1();

  @override
  List<Object> get props => [id];
}

class UserCountryChangedState extends EditUserState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class ProgressIndicatorValidState extends EditUserState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class InitialState extends EditUserState {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}
