import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

abstract class LoginEvent extends Equatable {}

class ValidateChanges extends LoginEvent {
  final String userNameOrEmail;
  final String password;
  final bool? userNameOrEmailChanged;
  ValidateChanges(this.userNameOrEmailChanged,
      {this.userNameOrEmail = '', this.password = ''});

  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class LogInEvent extends LoginEvent {
  final String login;
  final String password;

  final String id = Uuid().v1();

  LogInEvent(this.login, this.password);
  @override
  List<Object> get props => [id];
}

class ProgressIndicatorShowEvent extends LoginEvent {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}
