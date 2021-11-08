import 'package:equatable/equatable.dart';
import 'package:snapchat/model/country_code_class.dart';
import 'package:uuid/uuid.dart';

abstract class EmailNumberEvent extends Equatable {}

class EmailChange extends EmailNumberEvent {
  final String email;
  EmailChange(this.email);
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class EmailCheck extends EmailNumberEvent {
  final String email;
  final String id = Uuid().v1();

  EmailCheck(this.email);
  @override
  List<Object> get props => [id];
}

class NumberChange extends EmailNumberEvent {
  final String number;
  final int phoneNumberLength;
  NumberChange(this.number, this.phoneNumberLength);
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class NumberCheck extends EmailNumberEvent {
  final String number;
  final String id = Uuid().v1();

  NumberCheck(this.number);
  @override
  List<Object> get props => [id];
}

class ChangeToEmailPage extends EmailNumberEvent {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class PhoneNumberPageReload extends EmailNumberEvent {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class SetCountryCode extends EmailNumberEvent {
  final CountryCode? countryCode;
  final String id = Uuid().v1();

  SetCountryCode(this.countryCode);
  @override
  List<Object> get props => [id];
}

class ProgressIndicatorShowEvent extends EmailNumberEvent {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}
