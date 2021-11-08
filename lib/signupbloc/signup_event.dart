import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

abstract class SignupEvent extends Equatable {}

class ValidateChanges extends SignupEvent {
  final String firstName;
  final String lastName;
  final bool? firstNameChanged;
  ValidateChanges(this.firstNameChanged,
      {this.firstName = '', this.lastName = ''});

  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class CheckInternetConnection extends SignupEvent {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}
