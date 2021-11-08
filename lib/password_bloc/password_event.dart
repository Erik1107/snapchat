import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

abstract class PasswordEvent extends Equatable {}

class PasswordChange extends PasswordEvent {
  final String password;
  PasswordChange(this.password);
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class SubmitUser extends PasswordEvent {
  final String? firstName;
  final String? lastName;
  final String? name;
  final String? email;
  final String? phone;
  final String? birthDate;
  final String? password;
  final String? counrty;
  SubmitUser(this.firstName, this.lastName, this.name, this.email, this.phone,
      this.birthDate, this.password, this.counrty);
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class ProgressIndicatorShowEvent extends PasswordEvent {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}
