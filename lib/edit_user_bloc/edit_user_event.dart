import 'package:equatable/equatable.dart';
import 'package:snapchat/model/country_code_class.dart';
import 'package:uuid/uuid.dart';

import '../validation_type.dart';

abstract class EditUserEvent extends Equatable {}

class EditUserPageLoad extends EditUserEvent {
  final String isoCode;
  final String id = Uuid().v1();

  EditUserPageLoad(this.isoCode);
  @override
  List<Object> get props => [id];
}

class UserValidation extends EditUserEvent {
  final Validation validation;
  final dynamic value;
  final dynamic value2;
  final String id = Uuid().v1();

  UserValidation(this.validation, this.value, this.value2);

  @override
  List<Object> get props => [id];
}

class SetCountryCode extends EditUserEvent {
  final CountryCode countryCode;
  final String id = Uuid().v1();

  SetCountryCode(this.countryCode);

  @override
  List<Object> get props => [id];
}

class EditUser extends EditUserEvent {
  final Object token;
  final String? initalFirstName;
  final String? initalLastName;
  final String? initalEmail;
  final String? initalName;
  final DateTime initalBirthDate;
  final String? initalPassword;
  final String? initalPhone;

  final String? country;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final DateTime? birthDate;
  final String? name;
  final String? password;
  EditUser(
    this.token,
    this.initalFirstName,
    this.initalLastName,
    this.initalEmail,
    this.initalName,
    this.initalBirthDate,
    this.initalPassword,
    this.initalPhone,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.birthDate,
    this.name,
    this.password,
    this.country,
  );
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}

class EditUserValidation extends EditUserEvent {
  final String initalFirstName;
  final String initalLastName;
  final String initalEmail;
  final String initalName;
  final DateTime initalBirthDate;
  final String initalPassword;
  final String initalPhone;
  final String firstName;
  final String lastName;
  final String email;
  final String name;
  final DateTime birthDate;
  final String password;
  final String phone;
  final int phoneLength;
  final String id = Uuid().v1();
  EditUserValidation(
      this.initalFirstName,
      this.initalLastName,
      this.initalEmail,
      this.initalName,
      this.initalBirthDate,
      this.initalPassword,
      this.initalPhone,
      this.firstName,
      this.lastName,
      this.email,
      this.name,
      this.birthDate,
      this.password,
      this.phone,
      this.phoneLength);
  @override
  List<Object> get props => [id];
}

class ProgressIndicatorShowEvent extends EditUserEvent {
  final String id = Uuid().v1();
  @override
  List<Object> get props => [id];
}
